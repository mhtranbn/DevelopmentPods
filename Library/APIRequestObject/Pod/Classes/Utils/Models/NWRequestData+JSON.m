/**
 @file      NWRequestData+JSON.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestData+JSON.h"
#import "NWHTTPContentType.h"
#import "NWInternetMediaMimeType.h"
@import ObjCRuntimeWrapper;

@implementation NWRequestData (JSON)

+( instancetype )jsonDataWithObject:( id )object rootClass:( Class )objRootClass error:( NSError** )error {
    id objectToSerialize = nil;
    if ([ object isKindOfClass:[ NSDictionary class ]]) objectToSerialize = object;
    if ([ object isKindOfClass:[ NSArray class ]]) {
        BOOL isValid = true;
        for ( id item in object ) {
            if (![ item isKindOfClass:[ NSDictionary class ]]) {
                isValid = false;
                break;
            }
        }
        if ( isValid ) objectToSerialize = object;
    }
    if ( objectToSerialize == nil ) {
        objectToSerialize = [ OBJProperty dictionaryFromObject:object rootClass:objRootClass ];
    }
    NSError *err = nil;
    NSData *data = [ NSJSONSerialization dataWithJSONObject:objectToSerialize
                                                    options:0 error:&err ];
    NWRequestData *result = nil;
    if ( data != nil ) {
        result = [[ self alloc ] initWithData:data
                                     mimeType:[[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_APP_JSON ]
                              storeInTempFile:NO ];
        result.fileName = [ NSString stringWithFormat:@"%p.json", result ];
    }
    if ( error != nil ) *error = err;
    return result;
}

+( instancetype )jsonDataWithObject:( id )object error:( NSError** )error {
    return [ self jsonDataWithObject:object rootClass:nil error:error ];
}

@end
