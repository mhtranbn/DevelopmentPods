/**
 @file      DBObjectStorageHelper.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
@import FMDB;
#import "DBObjectStorage.h"

@class DBTableInfo;
@class DBColumnInfo;

@interface DBObjectStorage()

@property ( nonatomic, strong, nonnull ) FMDatabase *database;
@property ( nonatomic, assign ) int dbVersion;
@property ( nonatomic, strong, nonnull ) NSDictionary *tablesInfo;

@end

@interface DBObjectStorage (DBHelper)

/// Get value for column of object, including data transformation
-( nullable id )getValueForColumn:( nonnull DBColumnInfo* )column ofObject:( nonnull id )object;
/// Fill FMResutlSet data into object, including data transformation
-( void )fillData:( nonnull FMResultSet* )dbResult intoObject:( nonnull id )object tableInfo:( nonnull DBTableInfo* )table;
/// Create new object to store FMResultSet data, including data transformation
-( nullable id )objectFromTable:( nonnull DBTableInfo* )table andData:( nonnull FMResultSet* )dbResult;

-( void )fillValue:( nullable id )value forObject:( nonnull id )object withColumn:( nonnull DBColumnInfo* )colInfo;

@end
