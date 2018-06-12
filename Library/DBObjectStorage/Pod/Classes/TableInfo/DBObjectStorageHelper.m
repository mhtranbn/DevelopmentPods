/**
 @file      DBObjectStorageHelper.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBObjectStorage_Private.h"
@import ObjCRuntimeWrapper;

@implementation DBObjectStorage (DBHelper)

-( void )fillValue:( id )value forObject:( id )object withColumn:( DBColumnInfo* )colInfo {
    if ( value != nil || [ value isKindOfClass:[ NSNull class ]]) value = [ colInfo autoConvertFromDBValue:value ];
    if ( value == nil ) value = [ colInfo.propertyAttributes defaultValueForCommonDataType ];
    @try {
        [ object setValue:value forKey:colInfo.propertyName ];
    }
    @catch (NSException *exception) {
        DBLog( @"Failed to fill value from SQL query result: %@", exception );
    }
}

-( id )getValueForColumn:( DBColumnInfo* )column ofObject:( id )object {
    NSString *propName = column.propertyName;
    return [ column autoConvertToDBValue:[ object valueForKey:propName ]];
}

-( void )fillData:( FMResultSet* )dbResult intoObject:( id )object tableInfo:( DBTableInfo* )table {
    NSArray <NSString*>* dbColumns = [ dbResult allColumnNames ];
    for ( int colIndex = 0; colIndex < dbColumns.count; colIndex++ ) {
        NSString *colName = [ dbColumns objectAtIndex:colIndex ];
        DBColumnInfo *colInfo = [ table.columns objectForKey:[ table unmaskColumnName:colName ]];
        if ( colInfo == nil ) continue;
        id value = nil;
        switch ( colInfo.typeId ) {
            case kDBDataTypeText:
                value = [ dbResult stringForColumnIndex:colIndex ];
                break;
            case kDBDataTypeInteger:
            case kDBDataTypeReal:
                value = [ dbResult objectForColumnIndex:colIndex ];
            default:
                break;
        }
        [ self fillValue:value forObject:object withColumn:colInfo ];
    }
    if ( table.alternativePrimaryKey != nil ) {
        id value = [ dbResult objectForColumn:table.alternativePrimaryKey ];
        @try {
            [ object setValue:value forKey:table.alternativePrimaryKey ];
        }
        @catch (NSException *exception) {
            DBLog( @"Failed to fill value from SQL query result: %@", exception );
        }
    }
}

-( id )objectFromTable:( DBTableInfo* )table andData:( FMResultSet* )dbResult {
    id result = [ table.objectClass new ];
    [ self fillData:dbResult intoObject:result tableInfo:table ];
    return result;
}

@end
