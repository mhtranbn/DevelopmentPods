/**
 @file      NWRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequest.h"
#import "APIRequest.h"
#import "NWInternetMediaMimeType.h"
#import "NWHTTPContentType.h"
#import "NWRequestData.h"
@import ObjCRuntimeWrapper;

@implementation NWRequestMakerBase

#pragma mark - Transform value & validation

+( BOOL )validateValueObject:( nonnull id )object {
    return [ object isKindOfClass:[ NSString class ]] ||
    [ object isKindOfClass:[ NSNumber class ]] ||
    [ object isKindOfClass:[ NSURL class ]];
}

+( NSData* )dataToEncodeBase64FromValue:( id )value mime:( NSString** )mime {
    if ( value == nil ) return nil;
    NSData *result = nil;
    if ([ value isKindOfClass:[ UIImage class ]]) {
        result = UIImageJPEGRepresentation( value, 1.0 );
        *mime = MIME_TYPE_IMAGE_JPEG;
    } else if ([ value isKindOfClass:[ NSData class ]]) {
        result = value;
        *mime = MIME_TYPE_APP_OCTET_STREAM;
    } else if ([ value isKindOfClass:[ NSString class ]]) {
        result = [ value dataUsingEncoding:NSUTF8StringEncoding ];
        *mime = MIME_TYPE_TEXT_PLAIN;
    }
    return result;
}

+( id )transformToBase64StringValue:( id )value {
    NSString *mime = nil;
    NSData *data = [ self dataToEncodeBase64FromValue:value mime:&mime ];
    if ( data != nil ){
        return [ data base64EncodedStringWithOptions:0 ];
    }
    return value;
}

+( id )transformToBase64StringMimeValue:( id )value {
    NSString *mime = nil;
    NSData *data = [ self dataToEncodeBase64FromValue:value mime:&mime ];
    if ( data != nil ){
        NSString *result = [ data base64EncodedStringWithOptions:0 ];
        if ( mime != nil ) {
            return [ NSString stringWithFormat:@"data:%@;base64,%@", mime, result ];
        }
        return result;
    }
    return value;
}

+( id )transformToJSONStringValue:( id )value {
    if ( value != nil ){
        NSString *result = nil;
        if ([ value isKindOfClass:[ NSArray class ]]) {
            NSArray *array = [ OBJProperty dictionariesFromArray:value rootClass:nil ];
            NSData *jsonData = [ NSJSONSerialization dataWithJSONObject:array options:0 error:nil ];
            if ( jsonData != nil ){
                result = [[ NSString alloc ] initWithData:jsonData encoding:NSUTF8StringEncoding ];
            }
        } else {
            NSDictionary *dic = [ OBJProperty dictionaryFromObject:value ];
            NSData *jsonData = [ NSJSONSerialization dataWithJSONObject:dic options:0 error:nil ];
            if ( jsonData != nil ){
                result = [[ NSString alloc ] initWithData:jsonData encoding:NSUTF8StringEncoding ];
            }
        }
        if ( result != nil ) return result;
    }
    return value;
}

+( id )transformToJSONDataValue:( id )value {
    if ( value != nil ){
        NSData *data = nil;
        if ([ value isKindOfClass:[ NSArray class ]]) {
            NSArray *array = [ OBJProperty dictionariesFromArray:value rootClass:nil ];
            data = [ NSJSONSerialization dataWithJSONObject:array options:0 error:nil ];
        } else {
            NSDictionary *dic = [ OBJProperty dictionaryFromObject:value ];
            data = [ NSJSONSerialization dataWithJSONObject:dic options:0 error:nil ];
        }
        if ( data != nil ){
            NWHTTPContentType *mime = [[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_APP_JSON ];
            return [[ NWRequestData alloc ] initWithData:data mimeType:mime storeInTempFile:NO ];
        }
    }
    return value;
}

+( id )transformValueForProperty:( NSString* )propName ofObject:( NSObject<NWRequestTransformParameter>* )object
                         encoder:( id<APIRequestMaker> )encoder {
    if ([ object respondsToSelector:@selector( transformedValueForRequestParameter:encoder: )]) {
        return [ object transformedValueForRequestParameter:propName encoder:encoder ];
    }
    return nil;
}

+( id )transformRequestParameter:( NSString* )property ofObject:( NSObject<NWRequestTransformParameter>* )object
                        withType:( NWRequestParameterTransformType )type encoder:( id )encoder {
    id value = [ object valueForKey:property ];
    switch ( type ) {
        case kBase64String:
            return [ self transformToBase64StringValue:value ];
            break;
        case kBase64StringWithMime:
            return [ self transformToBase64StringMimeValue:value ];
            break;
        case kJSONString:
            return [ self transformToJSONStringValue:value ];
            break;
        case kCustomWithKey:
        case kCustom:
        {
            id result = [ self transformValueForProperty:property ofObject:object encoder:encoder ];
            if ( result != nil ) return result;
        }
            break;
        case kRawValueOrNotTransform:
            break;
    }
    return value;
}

-( NSMutableURLRequest* )makeUrlRequestWithUrl:( NSString* )path {
    NSURL *url = [ NSURL URLWithString:path ];
    if ( url == nil ) {
        [ NSException raise:[ NSString stringWithFormat:@"%@ Error", self.class ]
                     format:@"Fail to make url from \"%@\".", path ];
    }
    NSMutableURLRequest *result = nil;
    if ( self.timeout > 0 ) {
        result = [[ NSMutableURLRequest alloc ] initWithURL:url cachePolicy:self.cachePolicy
                                            timeoutInterval:self.timeout ];
    } else {
        result = [[ NSMutableURLRequest alloc ] initWithURL:url ];
    }
    return result;
}

@end
