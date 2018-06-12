/**
 @file      OBJProperty+Request.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import ObjCRuntimeWrapper;

// This key used in APIRequest to exclude property not request param
extern NSString *const _Nonnull kOBJPropertyExcludeParam;

@interface NSDictionary (NWRequest)

-( BOOL )isPropertyExcludeAPIParameter;

@end

@interface NSMutableDictionary (NWRequest)

-( void )setPropertyExcludeAPIParameter:( BOOL )excluded;

@end

@interface NSMutableDictionary (RequestCustomAttributesMap)

-( void )setExcludeAPIParameterEncodingWithProperties:( nonnull NSArray<NSString*>* )propNames;

@end
