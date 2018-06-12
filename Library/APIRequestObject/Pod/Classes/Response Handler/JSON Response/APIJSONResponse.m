/**
 @file      APIJSONResponse.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIJSONResponse.h"
#import "NWHTTPConstant.h"
#import "NSError+APIRequest.h"
#import "NWHTTPContentType.h"
#import "NSDictionary+HTTPResponse.h"
@import CommonLog;
@import ObjCRuntimeWrapper;

NSString *const kAPIResponseErrorJSONParserDomain               = @"ErrorDomain.Response.JSON";
NSInteger const kAPIResponseErrorJSONParserEmptyRawData         = 1;
NSInteger const kAPIResponseErrorJSONParserNotJSON              = 2;
NSInteger const kAPIResponseErrorJSONParserFailToCreateObject   = 3;

@implementation APIJSONResponse

-( nullable id )makeObjectFromClass:( nonnull Class )cls andParsedData:( nonnull id )parsedData {
    if ([ parsedData isKindOfClass:[ NSDictionary class ]]) {
        return [ OBJProperty objectFromClass:cls fromDictionary:parsedData ];
    } else if ([ parsedData isKindOfClass:[ NSArray class ]]) {
        BOOL isValidArray = YES;
        for ( id item in parsedData ) {
            if (![ item isKindOfClass:[ NSDictionary class ]]) {
                isValidArray = NO;
                break;
            }
        }
        if ( isValidArray ) {
            NSMutableArray *resArray = [ NSMutableArray array ];
            for ( NSDictionary *dic in parsedData ) {
                id resObj = [ OBJProperty objectFromClass:cls fromDictionary:dic ];
                if ( resObj != nil && ![ resArray containsObject:resObj ]) {
                    [ resArray addObject:resObj ];
                }
            }
            return resArray;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-( id )processParsedFailData:( id )parsedData {
    id result = nil;
    if ( self.failClass != nil ) {
        result = [ self makeObjectFromClass:self.failClass andParsedData:parsedData ];
    }
    if ( result == nil ) result = parsedData;
    return result;
}

-( id )processFailResponseData:( NSData* )data {
    if ( data!= nil && data.length >  0 ) {
        id parsedObject = [ NSJSONSerialization JSONObjectWithData:data options:0 error:nil ];
        if ( parsedObject != nil ) {
            return [ self processParsedFailData:parsedObject ];
        } else {
            NSString *dataStr = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding ];
            if ( dataStr != nil ) {
                return dataStr;
            } else {
                return data;
            }
        }
    }
    return nil;
}

-( id )processParsedSuccessData:( id )parsedData error:( NSError** )error {
    if ([ parsedData isKindOfClass:[ NSDictionary class ]] && self.defaultSuccessObject != nil ) {
        [ OBJProperty fillDataIntoObject:self.defaultSuccessObject fromDictionary:parsedData ];
        return self.defaultSuccessObject;
    } else if ( self.successClass != nil ) {
        id object = [ self makeObjectFromClass:self.successClass andParsedData:parsedData ];
        if ( object == nil && error != nil && *error == nil ) {
            *error = [ NSError errorWithDomain:kAPIResponseErrorJSONParserDomain
                                          code:kAPIResponseErrorJSONParserFailToCreateObject
                                   description:[ NSString stringWithFormat:@"API Parser Error: Can not make object with class %@ from response data.", self.successClass ]];
        }
        return object;
    } else {
        return parsedData;
    }
}

-( id )processSuccessResponseData:( NSData* )data error:( NSError** )error {
    NSError *err = nil;
    id result = nil;
    if ( data!= nil && data.length >  0 ) {
        id parsedObject = [ NSJSONSerialization JSONObjectWithData:data options:0 error:&err ];
        if ( parsedObject != nil ) {
            result = [ self processParsedSuccessData:parsedObject error:&err ];
        } else {
            err = [ NSError errorWithDomain:kAPIResponseErrorJSONParserDomain
                                       code:kAPIResponseErrorJSONParserNotJSON
                                description:@"API Parser Error: Response data is not JSON." ];
        }
    } else {
        err = [ NSError errorWithDomain:kAPIResponseErrorJSONParserDomain
                                   code:kAPIResponseErrorJSONParserEmptyRawData
                            description:@"API Parser Error: Empty response data." ];
    }
    if ( error != nil && *error == nil ) *error = err;
    return result;
}

-( void )parseResponseData:( id )data responseInfo:( NSHTTPURLResponse* )httpResponse error:( NSError* )error
                andRequest:( APIRequest* )request onComplete:( APIReponseHandlerCompletion )completion {
    NSError *err = error;
    id object = nil;
    if ( httpResponse.statusCode == HTTP_STATUS_CODE_OK && err == nil ) {
        object = [ self processSuccessResponseData:data error:&err ];
    } else if ( err == nil ) {
        err = [ NSError httpErrorWithCode:httpResponse.statusCode ];
    }
    if( err != nil ){
        object = [ self processFailResponseData:data ];
    }
    completion( err, object, httpResponse, data );
}

@end
