/**
 @file      APIRequest+Utils.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIRequest.h"

/// Request type configuration
typedef NS_ENUM( NSUInteger, APIRequestType ) {
    /// Request with HTTP Method `GET`, `requestMaker` `NWUrlEncodedRequest`
    kAPIRequestTypeGet,
    /// Request with HTTP Method `POST`, `requestMaker` `NWUrlEncodedRequest`
    kAPIRequestTypePost,
    /// Request with HTTP Method `POST`, `requestMaker` `NWBinaryBodyRequest`, convert `parameters` to `NWRequestData` with JSON format.
    kAPIRequestTypePostJson,
    /// Request with HTTP Method `POST`, `requestMaker` `NWBinaryBodyRequest`, convert `parameters` to `NWRequestData` with form/multipart format.
    kAPIRequestTypePostMultiPart
};

@interface APIRequest (utils)

/**
 Configure to request with method GET & NWUrlEncodedRequest maker.

 @param urlPath URL path
 @param paramenters Request parameters
 */
-( void )configureToGET:( nonnull NSString* )urlPath withParameter:( nullable id )paramenters;
/**
 Configure to request with method POST & NWUrlEncodedRequest maker.

 @param urlPath URL path
 @param paramenters Request parameters
 */
-( void )configureToPOST:( nonnull NSString* )urlPath withParameter:( nullable id )paramenters;
/**
 Configure to request with method POST & NWBinaryBodyRequest maker with plain text body.

 @param urlPath URL path
 @param bodyText Text to request
 */
-( void )configureToPOST:( nonnull NSString* )urlPath withPlainText:( nonnull NSString* )bodyText;
/**
 Configure to request with method POST & NWBinaryBodyRequest maker with JSON data body.

 @param urlPath URL path
 @param object Object to convert to JSON data.
 @return Error if convert from object to JSON fails.
 */
-( nullable NSError* )configureToPOST:( nonnull NSString* )urlPath withJSONObject:( nullable id )object;

-( void )configureRequestWithType:( APIRequestType )type url:( nonnull NSString* )path andParameter:( nullable id )parameter;

@end
