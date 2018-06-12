/**
 @file      DBObjectStorage+multitype.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBObjectStorage_Private.h"
#import "DBObjectStorageHelper.h"
@import RSUtils;

@implementation DBObjectStorage (multitype)

-( NSDictionary* )validateTableClasses:( NSArray* )classes error:( NSError** )error {
    NSMutableDictionary *tableInfos = [ NSMutableDictionary dictionary ];
    for ( Class aClass in classes ) {
        NSString *tableName = NSStringFromClass( aClass );
        DBTableInfo *tableInfo = [ self.tablesInfo objectForKey:tableName ];
        if ( tableInfo != nil ) {
            [ tableInfos setObject:tableInfo forKey:tableName ];
        } else {
            NSError *err = DB_ERR_UNK_CLASS;
            if ( error != nil ) *error = err;
            DBLog( @"DB SELECT ERROR: %@", err );
            return nil;
        }
    }
    return tableInfos;
}

-( NSMutableString* )sqlSelectFromTables:( NSDictionary* )tableInfos {
    NSMutableString *sql = [ NSMutableString stringWithString:@"SELECT " ];
    for ( DBTableInfo *tableInfo in tableInfos.allValues ) {
        [ sql appendString:[ tableInfo selectAlternativePrimaryKey:YES ]];
        for ( DBColumnInfo *column in tableInfo.columns.allValues ) {
            [ sql appendFormat:@"%@ AS %@, ", [ NSString dbTableQuoted:tableInfo.name column:column.name ],
             [[ tableInfo columnMaskedNameForMultiTablesSelect:column.name ] dbIdentifierQuoted ]];
        }
    }
    [ sql deleteTailCharacters:2 ];
    return sql;
}

-( NSDictionary* )objectsFromTables:( NSDictionary* )tableInfos withQuery:( NSString* )sql error:( NSError** )error {
    FMResultSet *resultSet = [ self.database executeQuery:sql ];
    if ( resultSet != nil ) {
        // Place holder
        NSMutableDictionary *resultDic = [ NSMutableDictionary dictionary ];
        for ( DBTableInfo *tableInfo in tableInfos.allValues ) {
            [ resultDic setObject:[ NSMutableArray array ] forKey:tableInfo.name ];
        }
        // Parse FMResultSet to objects
        NSUInteger cnt = 0;
        while ([ resultSet next ]) {
            for ( DBTableInfo *tableInfo in tableInfos.allValues ) {
                NSMutableArray *resultRows = [ resultDic objectForKey:tableInfo.name ];
                id object = [ self objectFromTable:tableInfo andData:resultSet ];
                if ( object != nil )[ resultRows addObject:object ];
            }
            cnt += 1;
        }
        [ resultSet close ];
        DBLog( @"SQL: %@\nResult count: %@", sql, @( cnt ));
        return resultDic;
    } else {
        if ( error != nil ) *error = self.database.lastError;
        DBLog( @"SQL: %@\nDB ERROR: %@", sql, self.database.lastError );
    }
    return nil;
}

-( NSDictionary* )objectsFromClasses:( NSArray* )classes withWhereStatement:( NSString* )whereStatement error:( NSError** )error {
    DB_CHECK_OPENED2
    NSDictionary *tableInfos = [ self validateTableClasses:classes error:error ];
    if ( tableInfos == nil ) return nil;
    NSMutableString *sql = [ self sqlSelectFromTables:tableInfos ];
    [ sql appendString:@" FROM " ];
    for ( DBTableInfo *tableInfo in tableInfos.allValues ) {
        [ sql appendFormat:@"%@, ", [ tableInfo.name dbIdentifierQuoted ]];
    }
    [ sql deleteTailCharacters:2 ];
    if ( whereStatement && whereStatement.length )
        [ sql appendFormat:@" WHERE %@", whereStatement ];
    [ sql appendString:@";" ];
    return [ self objectsFromTables:tableInfos withQuery:sql error:error ];
}

-( NSDictionary* )objectsFromClasses:( NSArray* )classes withFromStatement:( NSString* )sqlFilter error:( NSError** )error {
    DB_CHECK_OPENED2
    NSDictionary *tableInfos = [ self validateTableClasses:classes error:error ];
    if ( tableInfos == nil ) return nil;
    NSMutableString *sql = [ self sqlSelectFromTables:tableInfos ];
    [ sql appendFormat:@" %@;", sqlFilter ];
    return [ self objectsFromTables:tableInfos withQuery:sql error:error ];
}

-( NSDictionary* )objectsFromClasses:( NSArray* )classes withSQLStatement:( NSString* )sql error:( NSError** )error {
    DB_CHECK_OPENED2
    NSDictionary *tableInfos = [ self validateTableClasses:classes error:error ];
    if ( tableInfos == nil ) return nil;
    return [ self objectsFromTables:tableInfos withQuery:sql error:error ];
}

-( NSArray* )resultOfQuery:( NSString* )sql error:( NSError** )error {
    DB_CHECK_OPENED2
    DBLogSQL( sql );
    FMResultSet *resultSet = [ self.database executeQuery:sql ];
    if ( resultSet != nil ) {
        NSMutableArray *result = [ NSMutableArray array ];
        while ([ resultSet next ]) {
            [ result addObject:resultSet.resultDictionary ];
        }
        [ resultSet close ];
        return result;
    } else {
        if ( error != nil ) *error = self.database.lastError;
        DBLog( @"DB ERROR: %@", self.database.lastError );
    }
    return nil;
}

@end
