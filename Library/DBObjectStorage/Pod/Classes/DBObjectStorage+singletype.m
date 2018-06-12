/**
 @file      DBObjectStorage+singletype.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBObjectStorage_Private.h"
#import "DBObjectStorageHelper.h"

@implementation DBObjectStorage (singletype)

#pragma mark - Select

-( NSArray* )objectsFromResultOfQuery:( NSString* )sql fromTable:( DBTableInfo* )table error:( NSError** )error {
    FMResultSet *resultSet = [ self.database executeQuery:sql ];
    if ( resultSet != nil ) {
        NSMutableArray *result = [ NSMutableArray array ];
        while ([ resultSet next ]) {
            id object = [ self objectFromTable:table andData:resultSet ];
            if ( object != nil )[ result addObject:object ];
        }
        [ resultSet close ];
        DBLog( @"SQL: %@\nResult count: %@", sql, @( result.count ));
        return result;
    } else {
        if ( error != nil ) *error = self.database.lastError;
        DBLog( @"SQL: %@\nDB SELECT ERROR: %@", sql, self.database.lastError );
    }
    return nil;
}

-( NSArray* )getAllObjectsOfClass:( Class )objClass error:( NSError** )error {
    DB_CHECK_OPENED2
    NSString *tableName = NSStringFromClass( objClass );
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        return [ self objectsFromResultOfQuery:[ NSString stringWithFormat:@"SELECT %@* FROM %@;",
                                                [ tableInfo selectAlternativePrimaryKey:NO ],
                                                [ tableInfo.name dbIdentifierQuoted ]]
                                     fromTable:tableInfo error:error ];
    } else {
        NSError *err = DB_ERR_UNK_CLASS;
        if ( error != nil ) *error = err;
        DBLog( @"DB SELECT ALL ERROR: %@", err );
    }
    return nil;
}

-( NSArray* )getObjectsOfClass:( Class )objClass withWhereStatement:( NSString* )whereStatement error:( NSError** )error{
    DB_CHECK_OPENED2
    NSString *tableName = NSStringFromClass( objClass );
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        return [ self objectsFromResultOfQuery:[ NSString stringWithFormat:@"SELECT %@* FROM %@ WHERE %@;",
                                                [ tableInfo selectAlternativePrimaryKey:NO ],
                                                [ tableInfo.name dbIdentifierQuoted ], whereStatement ]
                                     fromTable:tableInfo error:error ];
    } else {
        NSError *err = DB_ERR_UNK_CLASS;
        if ( error != nil ) *error = err;
        DBLog( @"DB SELECT ERROR: %@", err );
    }
    return nil;
}

-( NSArray* )getObjectsOfClass:( Class )objClass withFromStatement:( NSString* )fromStatement error:( NSError** )error {
    DB_CHECK_OPENED2
    NSString *tableName = NSStringFromClass( objClass );
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSMutableString *sql = [ NSMutableString stringWithFormat:@"SELECT %@", [ tableInfo selectAlternativePrimaryKey:YES ]];
        for ( DBColumnInfo *column in tableInfo.columns.allValues ) {
            [ sql appendFormat:@"%@, ", [ NSString dbTableQuoted:tableInfo.name column:column.name ]];
        }
        [ sql deleteTailCharacters:2 ];
        [ sql appendFormat:@" %@;", fromStatement ];
        return [ self objectsFromResultOfQuery:sql fromTable:tableInfo error:error ];
    } else {
        NSError *err = DB_ERR_UNK_CLASS;
        if ( error != nil ) *error = err;
        DBLog( @"DB SELECT ERROR: %@", err );
    }
    return nil;
}

-( NSArray* )getObjectsOfClass:( Class )objClass withSQLStatement:( NSString* )sql error:( NSError** )error {
    DB_CHECK_OPENED2
    NSString *tableName = NSStringFromClass( objClass );
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        return [ self objectsFromResultOfQuery:sql fromTable:tableInfo error:error ];
    } else {
        NSError *err = DB_ERR_UNK_CLASS;
        if ( error != nil ) *error = err;
        DBLog( @"DB SELECT ERROR: %@", err );
    }
    return nil;
}

#pragma mark - DELETE

-( NSError* )executeUpdate:( NSString* )sql{
    DB_CHECK_OPENED
    DBLogSQL( sql );
    NSError *error = nil;
    if (![ self.database executeUpdate:sql ])
        error = self.database.lastError;
    if ( error != nil )
        DBLog( @"DB ERROR: %@", error );
    return error;
}

-( NSError* )deleteAllObjectsOfClass:( Class )objClass{
    DB_CHECK_OPENED
    NSError *error = nil;
    NSString *tableName = NSStringFromClass( objClass );
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSString *sql = [ NSString stringWithFormat:@"DELETE FROM \"%@\";", tableInfo.name ];
        DBLogSQL( sql );
        if (![ self.database executeUpdate:sql ])
            error = self.database.lastError;
    } else {
        error = DB_ERR_UNK_CLASS;
    }
    if ( error != nil )
        DBLog( @"DB DELETE ERROR: %@", error );
    return error;
}

-( NSError* )deleteObjectsOfClass:( Class )objClass withWhereStatement:( NSString* )whereStatement{
    NSError *error = nil;
    NSString *tableName = NSStringFromClass( objClass );
    DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
    if ( tableInfo != nil ) {
        NSString *sql = [ NSString stringWithFormat:@"DELETE FROM \"%@\" WHERE %@;", tableInfo.name, whereStatement ];
        DBLogSQL( sql );
        if (![ self.database executeUpdate:sql ])
            error = self.database.lastError;
    } else {
        error = DB_ERR_UNK_CLASS;
    }
    if ( error != nil )
        DBLog( @"DB DELETE ERROR: %@", error );
    return error;
}

@end
