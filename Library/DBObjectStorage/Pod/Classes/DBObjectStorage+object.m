/**
 @file      DBObjectStorage+object.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBObjectStorage_Private.h"
#import "DBObjectStorageHelper.h"
@import RSUtils;
@import ObjCRuntimeWrapper;

NSInteger const kDBObjectStorageErrorUnknownObjectClass         = 1;
NSInteger const kDBObjectStorageErrorNoField                    = 2;
NSInteger const kDBObjectStorageErrorNoPrimaryValueForFilter    = 3;
NSInteger const kDBObjectStorageErrorObjectNotFound             = 4;
NSInteger const kDBObjectStorageErrorDBClosed                   = 5;

@implementation DBObjectStorage (object)

#pragma mark - INSERT

-( NSError* )insertObject:( id )object {
    DB_CHECK_OPENED
    if ( object == nil ) return nil;
    NSError *error = nil;
    NSString *tableName = NSStringFromClass([ object class ]);
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSMutableString *listColumns = [ NSMutableString string ];
        NSMutableString *listValues = [ NSMutableString string ];
        for ( DBColumnInfo *columnInfo in tableInfo.columns.allValues ) {
            id val = [ self getValueForColumn:columnInfo ofObject:object ];
            if ( tableInfo.autoIncColumn != nil && [ tableInfo.autoIncColumn isEqualToString:columnInfo.name ]
                && [ val isKindOfClass:[ NSNumber class ]] && [ columnInfo.propertyAttributes type ] != kObjDataTypeObject
                && [( NSNumber* )val integerValue ] == 0 ) {
                // Ignore the primary key which data type is NSInteger and value default (0)
                continue;
            }
            [ listColumns appendFormat:@"%@, ", [ columnInfo.name dbIdentifierQuoted ]];
            [ listValues appendFormat:@"%@, ", [ NSString dbValueQuoted:val isTextType:columnInfo.typeId == kDBDataTypeText ]];
        }
        if ( listColumns.length > 0 && listValues.length > 0 ) {
            [ listColumns deleteTailCharacters:2 ];
            [ listValues deleteTailCharacters:2 ];
            NSString *sql = [ NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",
                             [ tableInfo.name dbIdentifierQuoted ], listColumns, listValues ];
            DBLogSQL( sql );
            if ([ self.database executeUpdate:sql ]) {
                NSNumber *lastUpdateId = @([ self.database lastInsertRowId ]);
                if ( tableInfo.alternativePrimaryKey != nil ) {
                    @try {
                        [ object setValue:lastUpdateId forKey:tableInfo.alternativePrimaryKey ];
                    }
                    @catch (NSException *exception) {
                        DBLog( @"ERROR INSERT: fail to update new inserted item ID %@", tableInfo.alternativePrimaryKey );
                    }
                } else if ( tableInfo.autoIncColumn != nil ) {
                    DBColumnInfo *column = [ tableInfo.columns objectForKey:tableInfo.autoIncColumn ];
                    if ( column != nil ) {
                        [ self fillValue:lastUpdateId forObject:object withColumn:column ];
                    }
                }
            } else {
                error = self.database.lastError;
            }
        } else {
            error = [ NSError errorWithDomain:DBObjectStorageErrorDomain
                                         code:kDBObjectStorageErrorNoField
                                     userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_NO_FIELD( tableInfo.name )}];
        }
    } else {
        error = DB_ERR_UNK_CLASS;
    }
    if ( error != nil ) DBLog( @"DB ERROR INSERT: %@", error );
    return error;
}

#pragma mark - UPDATE

-( NSString* )filterForSQLForObject:( id )object {
    NSString *tableName = NSStringFromClass([ object class ]);
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSArray *primaryCols = tableInfo.primaryColumns;
        if (( primaryCols == nil ) && tableInfo.alternativePrimaryKey != nil ){
            primaryCols = @[ tableInfo.alternativePrimaryKey ];
        }
        if ( primaryCols == nil ) return nil;

        NSMutableString *result = [ NSMutableString stringWithString:@"WHERE " ];
        for ( NSString *pColName in primaryCols ) {
            DBColumnInfo *pCol = [ tableInfo.columns objectForKey:pColName ];
            id pVal = nil;
            if ( pCol != nil ) {
                pVal = [ self getValueForColumn:pCol ofObject:object ];
            } else {
                pVal = [ object valueForKey:pColName ]; // Alternative primary key
            }
            if ( pVal != nil ) {
                [ result appendFormat:@"%@=%@ AND ", [ pColName dbIdentifierQuoted ],
                 [ NSString dbValueQuoted:pVal isTextType:pCol.typeId == kDBDataTypeText ]];
            }
        }
        if ([ result hasSuffix:@" AND " ]) {
            [ result deleteTailCharacters:5 ];
            return result;
        }
    }
    return nil;
}

-( NSError* )saveObject:( id )object {
    DB_CHECK_OPENED
    NSError *error = nil;
    NSString *tableName = NSStringFromClass([ object class ]);
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSString *whereStatement = [ self filterForSQLForObject:object ];
        if ( whereStatement != nil ) {
            // Update all columns except primary columns (primary columns are used to filter)
            NSMutableString *sql = [ NSMutableString stringWithFormat:@"UPDATE %@ SET ", [ tableInfo.name dbIdentifierQuoted ]];
            for ( DBColumnInfo *columnInfo in tableInfo.columns.allValues ) {
                if (( tableInfo.primaryColumns == nil || ![ tableInfo.primaryColumns containsObject:columnInfo.name ]) &&
                    ( tableInfo.alternativePrimaryKey == nil || ![ columnInfo.name isEqualToString:tableInfo.alternativePrimaryKey ])) {
                    id val = [ self getValueForColumn:columnInfo ofObject:object ];
                    [ sql appendFormat:@"%@=%@, ", [ columnInfo.name dbIdentifierQuoted ],
                     [ NSString dbValueQuoted:val isTextType:columnInfo.typeId == kDBDataTypeText ]];
                }
            }
            [ sql deleteTailCharacters:2 ];
            [ sql appendFormat:@" %@;", whereStatement ];
            DBLogSQL( sql );
            if (![ self.database executeUpdate:sql ]) {
                error = self.database.lastError;
            }
        } else {
            error = [ NSError errorWithDomain:DBObjectStorageErrorDomain
                                         code:kDBObjectStorageErrorNoPrimaryValueForFilter
                                     userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_NO_PRIMARY( tableInfo.name )}];
        }
    } else {
        error = DB_ERR_UNK_CLASS;
    }
    if ( error != nil ) DBLog( @"DB ERROR UPDATE: %@", error );
    return error;
}

-( NSError* )storeObject:( id )object {
    DB_CHECK_OPENED
    NSError *error = nil;
    NSString *tableName = NSStringFromClass([ object class ]);
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSString *whereStatement = [ self filterForSQLForObject:object ];
        if ( whereStatement != nil ) {
            NSString *sql = [ NSString stringWithFormat:@"SELECT %@ FROM %@ %@", [ tableInfo.columns.allKeys.firstObject dbIdentifierQuoted ],
                             [ tableInfo.name dbIdentifierQuoted ], whereStatement ];
            DBLogSQL( sql );
            FMResultSet *resultSet = [ self.database executeQuery:sql ];
            if ( resultSet != nil ) {
                if ([ resultSet next ]) {
                    [ resultSet close ];
                    error = [ self saveObject:object ];
                } else {
                    [ resultSet close ];
                    error = [ self insertObject:object ];
                }
            } else {
                error = self.database.lastError;
            }
        } else {
            error = [ NSError errorWithDomain:DBObjectStorageErrorDomain
                                         code:kDBObjectStorageErrorNoPrimaryValueForFilter
                                     userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_NO_PRIMARY( tableInfo.name )}];
        }
    } else {
        error = DB_ERR_UNK_CLASS;
    }
    if ( error != nil ) DBLog( @"DB ERROR UPDATE: %@", error );
    return error;
}

-( NSError* )loadObject:( id )object {
    DB_CHECK_OPENED
    NSError *error = nil;
    NSString *tableName = NSStringFromClass([ object class ]);
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSString *whereStatement = [ self filterForSQLForObject:object ];
        if ( whereStatement != nil ) {
            NSString *sql = [ NSString stringWithFormat:@"SELECT %@* FROM %@ %@;",
                             [ tableInfo selectAlternativePrimaryKey:NO ], [ tableInfo.name dbIdentifierQuoted ], whereStatement ];
            DBLogSQL( sql );
            FMResultSet *resultSet = [ self.database executeQuery:sql ];
            if ( resultSet != nil ) {
                if ([ resultSet next ]) {
                    [ self fillData:resultSet intoObject:object tableInfo:tableInfo ];
                } else {
                    error = [ NSError errorWithDomain:DBObjectStorageErrorDomain
                                                 code:kDBObjectStorageErrorObjectNotFound
                                             userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_OBJ_NOT_FOUND( tableInfo.name, whereStatement )}];
                }
                [ resultSet close ];
            } else {
                error = self.database.lastError;
            }
        } else {
            error = [ NSError errorWithDomain:DBObjectStorageErrorDomain
                                         code:kDBObjectStorageErrorNoPrimaryValueForFilter
                                     userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_NO_PRIMARY( tableInfo.name )}];
        }
    } else {
        error = DB_ERR_UNK_CLASS;
    }
    if ( error != nil ) DBLog( @"DB ERROR SELECT: %@", error );
    return error;
}

-( NSError* )removeObject:( id )object {
    DB_CHECK_OPENED
    NSError *error = nil;
    NSString *tableName = NSStringFromClass([ object class ]);
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSString *whereStatment = [ self filterForSQLForObject:object ];
        if ( whereStatment != nil ) {
            NSString *sql = [ NSString stringWithFormat:@"DELETE FROM %@ %@;", [ tableInfo.name dbIdentifierQuoted ], whereStatment ];
            DBLogSQL( sql );
            if (![ self.database executeUpdate:sql ]) {
                error = self.database.lastError;
            }
        } else {
            error = [ NSError errorWithDomain:DBObjectStorageErrorDomain
                                         code:kDBObjectStorageErrorNoPrimaryValueForFilter
                                     userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_NO_PRIMARY( tableInfo.name )}];
        }
    } else {
        error = DB_ERR_UNK_CLASS;
    }
    if ( error != nil ) DBLog( @"DB ERROR DELETE: %@", error );
    return error;
}

@end
