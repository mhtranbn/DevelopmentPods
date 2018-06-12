/**
 @file      DBObjectStorage+Debug.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBObjectStorage_Private.h"
#import "DBObjectStorageHelper.h"
@import RSUtils;
@import ObjCRuntimeWrapper;

#define DB_DUMMY_ROW_COUNT  100

#define DB_DEBUG_COL_NAME   @"N"
#define DB_DEBUG_COL_LEN    @"L"
#define DB_DEBUG_COL_ITEMS  @"I"

@implementation DBObjectStorage (Debug)

#if DEBUG

#pragma mark - Dummy data

-( NSString* )makeRandomString {
    NSInteger strLen = NSIntegerRandomNumberBetween( 1, 100 );
    char *buffer = malloc( strLen * sizeof( char ));
    for ( int i = 0; i < strLen; i++ ) {
        buffer[i] = NSIntegerRandomNumberBetween( 32, 126 );
        if ( buffer[i] == '\'' || buffer[i] == '"' )
            buffer[i] = ' ';
    }
    NSString *result = [[ NSString alloc ] initWithBytes:buffer length:strLen encoding:NSASCIIStringEncoding ];
    free( buffer );
    return result;
}

-( NSNumber* )makeRealNumber {
    return @( NSIntegerRandomNumberBetween( 0, 10000 ) + NSIntegerRandomNumberBetween( 0, 100 ) / 100.0f );
}

#pragma mark - Utility

+( NSMutableString* )stringWithString:( NSString* )aString withMaxLength:( NSInteger )len {
    NSMutableString *result = [ NSMutableString stringWithString:aString ];
    while ( result.length < len ) {
        [ result appendString:@" " ];
    }
    return result;
}

+( NSMutableString* )separatorStringWithLength:( NSInteger )len {
    NSMutableString *result = [ NSMutableString string ];
    while ( result.length < len - 1 ) {
        [ result appendString:@"-" ];
    }
    [ result appendString:@"+" ];
    return result;
}

+( NSMutableString* )buildDislay:( NSArray* )infoColumns {
    NSMutableString *result = [ NSMutableString string ];
    for ( NSDictionary *infoDic in infoColumns ) {
        [ result appendString:[ self stringWithString:infoDic[ DB_DEBUG_COL_NAME ]
                                        withMaxLength:[ infoDic[ DB_DEBUG_COL_LEN ] integerValue ] + 1 ]];
    }
    [ result appendString:@"\n" ];
    for ( NSDictionary *infoDic in infoColumns ) {
        [ result appendString:[ self separatorStringWithLength:[ infoDic[ DB_DEBUG_COL_LEN ] integerValue ] + 1 ]];
    }
    [ result appendString:@"\n" ];
    NSInteger count = [ infoColumns[0][DB_DEBUG_COL_ITEMS] count ];
    for ( NSInteger i = 0; i < count; i++ ) {
        for ( NSDictionary *infoDic in infoColumns ) {
            [ result appendString:[ self stringWithString:infoDic[ DB_DEBUG_COL_ITEMS ][i]
                                            withMaxLength:[ infoDic[ DB_DEBUG_COL_LEN ] integerValue ] + 1 ]];
        }
        [ result appendString:@"\n" ];
    }
    return result;
}

+( void )addDisplayItem:( NSString* )item intoDisplayInfo:( NSMutableDictionary* )infoDic {
    NSMutableArray *items = [ infoDic objectForKey:DB_DEBUG_COL_ITEMS ];
    [ items addObject:item ];
    NSInteger l = [[ infoDic objectForKey:DB_DEBUG_COL_LEN ] integerValue ];
    if ( l < item.length ) [ infoDic setObject:@( item.length )
                                        forKey:DB_DEBUG_COL_LEN ];
}
#endif

-( void )generateDummyData {
#if DEBUG
    for ( DBTableInfo *tableInfo in self.tablesInfo.allValues ) {
        for ( int i = 1; i <= DB_DUMMY_ROW_COUNT; i++ ) {
            NSMutableString *listColumns = [ NSMutableString string ];
            NSMutableString *listValues = [ NSMutableString string ];
            [ OBJProperty enumeratePropertyOfClass:tableInfo.objectClass superClassDeep:tableInfo.classTreeDeep withBlock:
             ^BOOL( NSString* propertyName, NSMutableDictionary* propertyAttributes, Class ownerClass ) {
                NSString *colName = [ propertyAttributes propertyAliasName ];
                if ( colName == nil ) colName = propertyName;
                DBColumnInfo *columnInfo = [ tableInfo.columns objectForKey:colName ];
                if ( columnInfo ) {
                    id val = nil;
                    if ( tableInfo.autoIncColumn != nil && [ colName isEqualToString:tableInfo.autoIncColumn ]) {
                        return NO;
                    }
                    [ listColumns appendFormat:@"\"%@\", ", colName ];
                    switch ([ propertyAttributes type ]) {
                        case kObjDataTypeObject:
                        {
                            Class propClass = [ propertyAttributes typeClass ];
                            if ([ propClass isSubclassOfClass:[ NSString class ]])
                                val = [[ DBObjectStorage sharedStorage ] makeRandomString ];
                            else if ([ propClass isSubclassOfClass:[ NSURL class ]])
                                val = @"http://www.google.com.vn";
                            else if ([ propClass isSubclassOfClass:[ NSNumber class ]])
                                val = @( NSIntegerRandomNumberBetween( 1, DB_DUMMY_ROW_COUNT ));
                        }
                            break;
                        case kObjDataTypeCppBool:
                            val = @( NSIntegerRandomNumberBetween( 0, 1 ));
                            break;
                        case kObjDataTypeChar:
                        case kObjDataTypeInt:
                        case kObjDataTypeLong:
                        case kObjDataTypeLongLong:
                        case kObjDataTypeUnsignedChar:
                        case kObjDataTypeUnsignedInt:
                        case kObjDataTypeUnsignedLong:
                        case kObjDataTypeUnsignedLongLong:
                            if ( val == nil )
                                val = @( NSIntegerRandomNumberBetween( 1, DB_DUMMY_ROW_COUNT ));
                            break;
                        case kObjDataTypeDouble:
                        case kObjDataTypeFloat:
                            val = [[ DBObjectStorage sharedStorage ] makeRealNumber ];
                        default:
                            break;
                    }
                    if ( columnInfo.typeId == kDBDataTypeText )
                        [ listValues appendFormat:@"'%@', ", val ];
                    else
                        [ listValues appendFormat:@"%@, ", val ];
                }
                return NO;
            }];
            if ( listColumns.length && listValues.length ) {
                [ listColumns deleteTailCharacters:2 ];
                [ listValues deleteTailCharacters:2 ];
                NSString *sql = [ NSString stringWithFormat:@"INSERT INTO \"%@\" (%@) VALUES (%@);",
                                 tableInfo.name, listColumns, listValues ];
                DBLogSQL( sql );
                if (![ self.database executeUpdate:sql ]) {
                    DBLog( @"DUMMY FAILED: %@", self.database.lastError );
                }
            } else {
                DBLog( @"DUMMY NO FIELD: %@", tableInfo.name );
            }
        }
    }
#endif
}

+( NSString* )printStatus {
#if DEBUG
    DBObjectStorage *db = [ self sharedStorage ];
    if ( db.database ) {
        return [ NSString stringWithFormat:@"DB is opened: %@", db.database.databasePath ];
    } else {
        return @"DB closed.";
    }
#else
    return nil;
#endif
}

+( NSString* )printTables {
#if DEBUG
    DBObjectStorage *db = [ self sharedStorage ];
    if ( db.database ) {
        return [ db.tablesInfo.allKeys serializeToStringWithSeparator:@", " ];
    } else {
        return @"DB closed.";
    }
#else
    return nil;
#endif
}

+( NSString* )printTableStructure:( NSString* )tableName {
#if DEBUG
    DBObjectStorage *db = [ self sharedStorage ];
    if ( db.database ) {
        DBTableInfo *tableInfo = [ db.tablesInfo objectForKey:tableName ];
        if ( tableInfo ) {
            NSMutableArray *infoColumns = [ NSMutableArray array ];
            [ infoColumns addObject:[ NSMutableDictionary dictionaryWithDictionary:@{ DB_DEBUG_COL_NAME: @"Column",
                                                                                      DB_DEBUG_COL_LEN: @6,
                                                                                      DB_DEBUG_COL_ITEMS:[ NSMutableArray array ]}]];
            [ infoColumns addObject:[ NSMutableDictionary dictionaryWithDictionary:@{ DB_DEBUG_COL_NAME: @"Primary",
                                                                                      DB_DEBUG_COL_LEN: @7,
                                                                                      DB_DEBUG_COL_ITEMS:[ NSMutableArray array ]}]];
            [ infoColumns addObject:[ NSMutableDictionary dictionaryWithDictionary:@{ DB_DEBUG_COL_NAME: @"Type",
                                                                                      DB_DEBUG_COL_LEN: @4,
                                                                                      DB_DEBUG_COL_ITEMS:[ NSMutableArray array ]}]];
            for ( DBColumnInfo *colInfo in tableInfo.columns.allValues ) {
                [ self addDisplayItem:colInfo.name intoDisplayInfo:[ infoColumns objectAtIndex:0 ]];
                [ self addDisplayItem:colInfo.isPrimaryKey ? @"*" : @"" intoDisplayInfo:[ infoColumns objectAtIndex:1 ]];
                [ self addDisplayItem:colInfo.type intoDisplayInfo:[ infoColumns objectAtIndex:2 ]];
            }
            return [ self buildDislay:infoColumns ];
        } else {
            return [ NSString stringWithFormat:@"There's no '%@' table in DB.", tableName ];
        }
    } else {
        return @"DB closed.";
    }
#else
    return nil;
#endif
}

+( NSString* )dumpTable:( NSString* )tableName {
#if DEBUG
    DBObjectStorage *db = [ self sharedStorage ];
    if ( db.database ) {
        DBTableInfo *tableInfo = [ db.tablesInfo objectForKey:tableName ];
        if ( tableInfo ) {
            return [ self printQuery:[ NSString stringWithFormat:@"SELECT rowid as \"rowid\", * FROM \"%@\"", tableName ]];
        } else {
            return [ NSString stringWithFormat:@"There's no '%@' table in DB.", tableName ];
        }
    } else {
        return @"DB closed.";
    }
#else
    return nil;
#endif
}

+( NSString* )printQuery:( NSString* )sql {
#if DEBUG
    DBObjectStorage *db = [ self sharedStorage ];
    if ( db.database ) {
        FMResultSet *resultSet = [ db.database executeQuery:sql ];
        if ( resultSet ) {
            NSMutableArray *infoColumns = [ NSMutableArray array ];
            for ( int i = 0; i < resultSet.columnCount; i++ ) {
                NSString *colName = [ resultSet columnNameForIndex:i ];
                [ infoColumns addObject:[ NSMutableDictionary dictionaryWithDictionary:@{ DB_DEBUG_COL_NAME: colName,
                                                                                          DB_DEBUG_COL_LEN: @( colName.length ),
                                                                                          DB_DEBUG_COL_ITEMS:[ NSMutableArray array ]}]];
            }
            NSInteger rowCount = 0;
            while ([ resultSet next ]) {
                rowCount += 1;
                for ( int i = 0; i < resultSet.columnCount; i++ ) {
                    NSString *value = [ NSString stringWithFormat:@"%@", [ resultSet objectForColumnIndex:i ]];
                    [ self addDisplayItem:value intoDisplayInfo:infoColumns[i] ];
                }
            }
            [ resultSet close ];
            NSMutableString *result = [ self buildDislay:infoColumns ];
            [ result appendFormat:@"\n\nTOTAL: %@", @( rowCount )];
            return result;
        } else {
            return [ db.database.lastError localizedDescription ];
        }
    } else {
        return @"DB closed.";
    }
#else
    return nil;
#endif
}

@end
