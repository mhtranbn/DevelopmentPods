/**
 @file      NWUrlEncodedRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWUrlEncodedRequest.h"
@import ObjCRuntimeWrapper;
@import RSUtils;
#import "NWUtils.h"
#import "NWHTTPContentType.h"
#import "NWHTTPConstant.h"
#import "NWInternetMediaMimeType.h"
#import "NSMutableURLRequest+HTTPRequest.h"
#import "OBJProperty+Request.h"
#import "NWRequestData.h"

@implementation NWUrlEncodedRequest

-( NSString* )queryFromEncodedDictionary:( NSDictionary* )encodedDic {
    NSMutableString *result = [ NSMutableString new ];
    for ( NSString *key in encodedDic.allKeys ) {
        id value = [ encodedDic objectForKey:key ];
        if ([ value isKindOfClass:[ NSArray class ]]) {
            for ( NSString *item in value ) {
                [ result appendFormat:@"%@[]=%@&", key, item ];
            }
        } else if ([ value isKindOfClass:[ NSDictionary class ]]) {
            for ( NSString *itemKey in [ value allKeys ]) {
                NSString *itemValue = [ value objectForKey:itemKey ];
                [ result appendFormat:@"%@[%@]=%@&", key, itemKey, itemValue ];
            }
        } else {
            [ result appendFormat:@"%@=%@&", key, value ];
        }
    }
    if ( encodedDic.count > 0 ) {
        [ result deleteLastCharacter ];
    }
    return [ result copy ];
}

-( void )encodeParamArray:( NSArray* )params withKey:( NSString* )key intoEncodedStore:( NSMutableDictionary* )encodedParams {
    NSMutableArray *subEncodedArray = [ NSMutableArray new ];
    for ( id item in params ) {
        if ([ NWUrlEncodedRequest validateValueObject:item ]) {
            [ subEncodedArray addObject:[ NWUtils urlencode:[ NSString stringWithFormat:@"%@", item ]]];
        }
    }
    if ( subEncodedArray.count > 0 ) {
        [ encodedParams setObject:subEncodedArray forKey:[ NWUtils urlencode:key ]];
    }
}

-( void )encodeParamDictionary:( NSDictionary* )params withKey:( NSString* )key intoEncodedStore:( NSMutableDictionary* )encodedParams {
    NSMutableDictionary *subEncodedDic = [ NSMutableDictionary new ];
    for ( NSString *itemKey in [ params allKeys ]) {
        id itemValue = [ params objectForKey:itemKey ];
        if ([ itemKey isKindOfClass:[ NSString class ]] && itemKey.length > 0 &&
            [ NWUrlEncodedRequest validateValueObject:itemValue ]) {
            [ subEncodedDic setObject:[ NWUtils urlencode:[ NSString stringWithFormat:@"%@", itemValue ]]
                               forKey:[ NWUtils urlencode:itemKey ]];
        }
    }
    if ( subEncodedDic.count > 0 ) {
        [ encodedParams setObject:subEncodedDic forKey:[ NWUtils urlencode:key ]];
    }
}

-( NSDictionary* )encodeParametersFromDictonary:( NSDictionary* )paramsDic {
    NSMutableDictionary *encodedParams = [ NSMutableDictionary new ];
    for ( NSString *key in paramsDic.allKeys ) {
        id value = [ paramsDic objectForKey:key ];
        if ([ key isKindOfClass:[ NSString class ]] && key.length > 0 ) {
            if ([ NWUrlEncodedRequest validateValueObject:value ]) {
                [ encodedParams setObject:[ NWUtils urlencode:[ NSString stringWithFormat:@"%@", value ]]
                                   forKey:[ NWUtils urlencode:key ]];
            } else if ([ value isKindOfClass:[ NSArray class ]]) {
                [ self encodeParamArray:value withKey:key intoEncodedStore:encodedParams ];
            } else if ([ value isKindOfClass:[ NSDictionary class ]]) {
                [ self encodeParamDictionary:value withKey:key intoEncodedStore:encodedParams ];
            }
        }
    }
    return encodedParams;
}

-( NSString* )queryFromDictionary:( NSDictionary* )paramsDic {
    return [ self queryFromEncodedDictionary:[ self encodeParametersFromDictonary:paramsDic ]];
}

-( NSString* )queryFromObject:( NSObject* )paramsObj {
    NSMutableDictionary *encodedParams = [ NSMutableDictionary new ];
    [ OBJProperty enumeratePropertyOfClass:[ paramsObj class ] withBlock:^BOOL( NSString* propertyName,
                                                                               NSMutableDictionary* propertyAttributes,
                                                                               Class ownerClass ) {
        if ( propertyAttributes.isReadOnly ||
            propertyAttributes.isPropertyExcludeAPIParameter ) return NO;
        // Value
        id value = nil;
        NWRequestParameterTransformType transformType = kRawValueOrNotTransform;
        if ([ paramsObj.class conformsToProtocol:@protocol( NWRequestTransformParameter )] &&
            [ paramsObj respondsToSelector:@selector( shouldTransfromValueOfRequestParameter:encoder: )]) {
            transformType = [( id<NWRequestTransformParameter> )paramsObj shouldTransfromValueOfRequestParameter:propertyName encoder:self ];
            value = [ NWUrlEncodedRequest transformRequestParameter:propertyName
                                                           ofObject:( id<NWRequestTransformParameter> )paramsObj
                                                           withType:transformType encoder:self ];
        } else {
            value = [ paramsObj valueForKey:propertyName ];
        }
        if ( value == nil ) return NO;
        // Key
        NSString *key = propertyAttributes.propertyAliasName;
        if ( key == nil ) key = propertyName;
        
        if ([ NWUrlEncodedRequest validateValueObject:value ]) {
            [ encodedParams setObject:[ NWUtils urlencode:[ NSString stringWithFormat:@"%@", value ]]
                               forKey:[ NWUtils urlencode:key ]];
        } else if ([ value isKindOfClass:[ NSArray class ]]) {
            [ self encodeParamArray:value withKey:key intoEncodedStore:encodedParams ];
        } else if ([ value isKindOfClass:[ NSDictionary class ]]) {
            if ( transformType == kCustomWithKey ) {
                NSDictionary *encodeSubDic = [ self encodeParametersFromDictonary:value ];
                [ encodedParams addEntriesFromDictionary:encodeSubDic ];
            } else {
                [ self encodeParamDictionary:value withKey:key intoEncodedStore:encodedParams ];
            }
        }
        return NO;
    }];
    return [ self queryFromEncodedDictionary:encodedParams ];
}

-( void )generateRequestBodyWithRequestObject:( APIRequest* )request
                                   onComplete:( APIRequestMakerCompletion )completion {
    id params = request.parameters;
    NSString *query = nil;
    if ( params != nil ) {
        if ([ params isKindOfClass:[ NSDictionary class ]]) {
            query = [ self queryFromDictionary:params ];
        } else if ([ params isKindOfClass:[ NSObject class ]]) {
            query = [ self queryFromObject:params ];
        } else {
            [ NSException raise:[ NSString stringWithFormat:@"%@ Error", self.class ]
                         format:@"Parameter object of type \"%@\" is not supported.", [ params class ]];
        }
    }
    
    NWUrlEncodedType type = self.encodeType;
    if ( type == kNWUrlEncodedFromHTTPMethod ) {
        if ([ request.httpMethod isEqualToString:HTTP_METHOD_GET ] ||
            [ request.httpMethod isEqualToString:HTTP_METHOD_DELETE ]) {
            type = kNWUrlEncodedIntoURLQuery;
        } else {
            type = kNWUrlEncodedIntoHTTPBody;
        }
    }
    NSMutableString *urlStr = [ NSMutableString stringWithString:request.path ];
    if ( type == kNWUrlEncodedIntoURLQuery && query != nil && query.length > 0 ) {
        if ([ urlStr containsString:@"?" ]) {
            NSString *lastChar = [ urlStr substringFromIndex:urlStr.length - 1 ];
            if (![ lastChar isEqualToString:@"?" ] && ![ lastChar isEqualToString:@"&" ]) {
                [ urlStr appendString:@"&" ];
            }
        } else {
            [ urlStr appendString:@"?" ];
        }
        [ urlStr appendString:query ];
    }
    NSMutableURLRequest *result = [ self makeUrlRequestWithUrl:urlStr ];
    [ result setHTTPMethod:request.httpMethod ];
    if ( type == kNWUrlEncodedIntoHTTPBody && query != nil && query.length > 0 ) {
        NSData *data = [ query dataUsingEncoding:NSUTF8StringEncoding ];
        NWHTTPContentType *contentType = [ NWHTTPContentType new ];
        contentType.type = MIME_MAIN_TYPE_APP;
        contentType.subtype = @"x-www-form-urlencoded";
        contentType.parameters = @{ MIME_PARAMETER_CHARSET: @"utf-8" };
        [ result setHTTPBodyData:data withContentType:contentType ];
    }
    if ( request.httpHeader != nil ) {
        [ result importHTTPHeader:request.httpHeader ];
    }
    completion( result, nil );
}

@end
