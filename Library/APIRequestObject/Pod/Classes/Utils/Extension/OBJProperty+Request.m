/**
 @file      OBJProperty+Request.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+Request.h"
@import ObjCRuntimeWrapper;

NSString *const kOBJPropertyExcludeParam = @"XPr";

@implementation NSDictionary (NWRequest)

-( BOOL )isPropertyExcludeAPIParameter {
    return [ self.allKeys containsObject:kOBJPropertyExcludeParam ];
}

@end

@implementation NSMutableDictionary (NWRequest)

-( void )setPropertyExcludeAPIParameter:( BOOL )excluded {
    if ( excluded )[ self setObject:@"" forKey:kOBJPropertyExcludeParam ];
    else [ self removeObjectForKey:kOBJPropertyExcludeParam ];
}

@end

@implementation NSMutableDictionary (RequestCustomAttributesMap)

-( void )setExcludeAPIParameterEncodingWithProperties:( NSArray<NSString*>* )propNames {
    for ( NSString *prop in propNames ) {
        NSMutableDictionary *dic = [ self getAttributesMapForPropertyName:prop ];
        [ dic setPropertyExcludeAPIParameter:YES ];
    }
}

@end
