/**
 @file      APIManager.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import Foundation;
@import CommonLog;

#define APILog(fmt, ...) CMLogCatS( @"API", (fmt), ##__VA_ARGS__ )

extern NSString *const _Nonnull kAPIEngineDefault;

#pragma mark - APIRequest pattern

@protocol APIRequestPattern <NSObject>
@required

@property ( nonatomic, nullable, strong ) NSMutableDictionary<NSString*, id> *requestInfo;

// These functions will be called by Engine
-( nullable id )getRequestData;
-( void )requestDidFinish:( nullable NSHTTPURLResponse* )response
                     data:( nullable id )data error:( nullable NSError* )error;

@end

#pragma mark - Connection engine

@protocol APIConnectionEngine
@required

-( BOOL )startRequest:( nonnull id<APIRequestPattern> )request;
-( void )cancelRequest:( nonnull id<APIRequestPattern> )request;

@end

#pragma mark - APIManager

@interface APIManager : NSObject

/// Do not check Internet connection before start request
@property ( nonatomic, assign ) BOOL disableInternetCheck;

@property ( nonatomic, readonly, strong, nonnull ) NSOperationQueue *apiQueue;

/**
 *  @return Shared manager
 */
+( nonnull APIManager* )sharedManager;
/**
 Add a connection engine

 @param engine Connection engine
 @param name Name of engine
 */
-( void )addEngine:( nonnull id<APIConnectionEngine> )engine forName:( nonnull NSString* )name;
/**
 Send request to given engine to start

 @param request Request to start
 @param name Name of connection engine
 @return YES if success
 */
-( BOOL )startRequest:( nonnull id<APIRequestPattern> )request withEngine:( nonnull NSString* )name;
/**
 Cancel request of 

 @param request Request object
 */
-( void )cancelRequest:( nonnull id<APIRequestPattern> )request;

@end
