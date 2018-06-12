/**
 @file      APIRequest+Utils.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIRequest+Utils.h"
#import "NWUrlEncodedRequest.h"
#import "NWBinaryBodyRequest.h"
#import "NWHTTPConstant.h"
#import "NWRequestData+Convert.h"
#import "NWRequestData+JSON.h"
#import "NWRequestData+Multipart.h"

@implementation APIRequest (utils)

-( void )configureToGET:( NSString* )urlPath withParameter:( id )paramenters {
    self.path = urlPath;
    self.parameters = paramenters;
    self.httpMethod = HTTP_METHOD_GET;
    self.requestMaker = [ NWUrlEncodedRequest new ];
}

-( void )configureToPOST:( NSString* )urlPath withParameter:( id )paramenters {
    self.path = urlPath;
    self.parameters = paramenters;
    self.httpMethod = HTTP_METHOD_POST;
    self.requestMaker = [ NWUrlEncodedRequest new ];
}

-( void )configureToPOST:( NSString* )urlPath withPlainText:( NSString* )bodyText {
    self.path = urlPath;
    self.parameters = [ NWRequestData dataWithString:bodyText ];
    self.httpMethod = HTTP_METHOD_POST;
    self.requestMaker = [ NWBinaryBodyRequest new ];
}

-( void )configureToPOSTBinary:(NSString *)urlPath withParameter:( NWRequestData* )paramenters {
    self.path = urlPath;
    self.parameters = paramenters;
    self.httpMethod = HTTP_METHOD_POST;
    self.requestMaker = [ NWBinaryBodyRequest new ];
}

-( NSError* )configureToPOST:( NSString* )urlPath withJSONObject:( id )object {
    NSError *error;
    NWRequestData *data = nil;
    if ( object != nil ) data = [ NWRequestData jsonDataWithObject:object error:&error ];
    [ self configureToPOSTBinary:urlPath withParameter:data ];
    return error;
}

-( void )configureRequestWithType:( APIRequestType )type url:( NSString* )path andParameter:( id )parameter {
    switch ( type ) {
        case kAPIRequestTypeGet:
            [ self configureToGET:path withParameter:parameter ];
            break;
        case kAPIRequestTypePost:
            [ self configureToPOST:path withParameter:parameter ];
            break;
        case kAPIRequestTypePostJson:
            [ self configureToPOST:path withJSONObject:parameter ];
            break;
        case kAPIRequestTypePostMultiPart:
        {
            NWRequestData *data = nil;
            if ( parameter != nil ) data = [ NWRequestData multipartDataWithObject:parameter ];
            [ self configureToPOSTBinary:path withParameter:data ];
        }
            break;
    }
}

@end
