/**
 @file      APIRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import "APIManager.h"

@protocol APIRequestMaker;

typedef void ( ^APIRequestMakerCompletion )( id _Nullable requestData, NSError* _Nullable error );

@protocol APIResponseHandler;

typedef void ( ^APIReponseHandlerCompletion )( NSError* _Nullable error, id _Nullable parsedObject, NSHTTPURLResponse* _Nullable httpResponse, id _Nullable rawData );

/**
 API Request success handler

 @param responseObject Processed object from `responseHandler`
 @param response HTTP header, status ...
 @param responseData Raw response data
 */
typedef void ( ^APIRequestSuccessHandler )( id _Nullable responseObject, NSHTTPURLResponse * _Nonnull response, id _Nullable responseData );
/**
 API Request failure handler

 @param error Error
 @param responseObject Processed object from `responseHandler`
 @param response HTTP header, status ...
 @param responseData Raw response data
 */
typedef void ( ^APIRequestFailureHandler )( NSError * _Nonnull error,  id _Nullable responseObject, NSHTTPURLResponse * _Nullable response, id _Nullable responseData );

//// API Request object
@interface APIRequest : NSObject <APIRequestPattern>

/// URL path of request
@property ( nonatomic, copy, nonnull ) NSString *path;
/// Object/dicitonary ... used as request query parameter, depends on `requestMaker`
@property ( nonatomic, strong, nullable ) id parameters;
/// HTTP method
@property ( nonatomic, copy, nonnull ) NSString *httpMethod;

@property ( nonatomic, readonly, nullable ) NSDictionary<NSString*, id>* httpHeader;
/// Object to encode request
@property ( nonatomic, strong, nonnull ) id<APIRequestMaker> requestMaker;
/// Object to process response data.
@property ( nonatomic, strong, nonnull ) id<APIResponseHandler> responseHandler;
/// Status of request
@property ( nonatomic, readonly ) BOOL isLoading;
/// Common action to do before call onSuccess or error handle
@property ( nonatomic, copy ) void (^ _Nullable onFinish)(void);
/// Block handler when request success
@property ( nonatomic, copy, nullable ) APIRequestSuccessHandler onSuccess;
// RESERVED property for APIRequestPattern protocol
@property ( nonatomic, nullable, strong ) NSMutableDictionary<NSString*, id> *requestInfo;
/**
 Add a handler to execute if request fails with similar to given error.
 One error can be used with 1 handler by the order of handler adding.
 
 @param error User error domain, code (ignore if 0) & localizedDescription (ignore if nil) to filter.
 Pass nill to filter all errors.
 @param handler Block to execute.
 
 @discussion If request fails with an error, request looks up from last to first of pattern errors,
 if error matches (by compare error domain, code, localizedDescription), request executes the equivalent handler & break the looking up.
 */
-( void )processError:( nullable NSError* )error withHandler:( nonnull APIRequestFailureHandler )handler;
/**
 Remove all error hadlers.
 */
-( void )removeAllErrorHandlers;

/**
 Set HTTP header for a key. This can overwrite header made by `requestClass`.

 @param value Value
 @param key Key of header
 */
-( void )setValue:( nullable id )value forHTTPHeader:( nonnull NSString* )key;
/**
 Add key/value into HTTP header. This can overwrite header made by `requestClass`.

 @param headers List of header & value
 */
-( void )addHTTPHeaders:( nonnull NSDictionary<NSString*, id>* )headers;
/**
 Remove all items in HTTP header and add the new ones. This can overwrite header made by `requestClass`.
 
 @param headers List of header & value. Can be `nil`.
 */
-( void )setHTTPHeaders:( nullable NSDictionary<NSString*, id>* )headers;

/**
 Start request with default Network connection engine.
 */
-( void )startRequest;
/**
 Start request with given Network connection engine
 
 @param engineId Engine Identifier
 */
-( void )startRequestWithEngine:( nonnull NSString* )engineId;
/**
 *  Cancel the request
 */
-( void )cancelRequest;

@end

#pragma mark - Request handler

@protocol APIRequestMaker <NSObject>
@required

/**
 Generate request body from request object

 @param request Request object
 @param completion Block to call on finish
 */
-( void )generateRequestBodyWithRequestObject:( nonnull APIRequest* )request
                                   onComplete:( nonnull APIRequestMakerCompletion )completion;

@optional
/// To allow request maker clean temp file.
-( void )apiRequestDidFinish:( nonnull APIRequest* )request;

@end

#pragma mark - Response handler

/**
 The parser of response data prototype. The parser should implement 1 method to initialize with response data & methods to get the result.
 */
@protocol APIResponseHandler <NSObject>
@required
/**
 Start parse Response data

 @param data         Raw data to parse, returned from Connection Engine
 @param httpResponse HTTP response header
 @param error        Error (eg. timeout, no network ...)
 @param request      Call `responseParserDidFinishWithError:...` whern parsing finishes
 */
-( void )parseResponseData:( nullable id )data
              responseInfo:( nullable NSHTTPURLResponse* )httpResponse
                     error:( nullable NSError* )error
                andRequest:( nonnull APIRequest* )request
                onComplete:( nonnull APIReponseHandlerCompletion )completion;

@end
