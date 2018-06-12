/**
 @file      APIURLSession.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import Foundation;
#import "APIManager.h"

extern NSString *const _Nonnull kAPIURLSessionRqErrorDomain;

#pragma mark - Request pattern

/**
 API Request object class must conform this protocol to be used with `APIURLSession`.
 */
@protocol APIURLSessionRequestPattern <APIRequestPattern>
@optional
/**
 Upload progress
 
 @param chunkBytes Bytes of data just sent
 @param uploadedBytes Total bytes of data sent.
 @param totalBytes Total bytes of data to upload.
 */
-( void )didURLSessionUpload:( int64_t )chunkBytes withUploaded:( int64_t )uploadedBytes onTotal:( int64_t )totalBytes;

@end

#pragma mark - Download pattern

/**
 API Request object class can conform this protocol to make download request into file.
 */
@protocol APIURLSessionDownloadPattern <APIURLSessionRequestPattern>
@required

-( nullable NSString* )pathToDownloadFromURLSession;

@optional
/// Resumable data to make request
-( nullable NSData* )dataToResumeURLSessionRequest;
/// Resumable data when CANCEL request
-( void )saveResumableURLSessionRequestData:( nullable NSData* )resumableData;
/**
 Download progress

 @param chunkBytes Bytes of data just received.
 @param downloadedBytes Total bytes of data downloaded.
 @param totalBytes Expected data bytes.
 */
-( void )didURLSessionDownload:( int64_t )chunkBytes withDownloaded:( int64_t )downloadedBytes onTotal:( int64_t )totalBytes;

@end

#pragma mark - Upload pattern

/**
 API Request object class can conform this protocol to make upload request with HTTP body from given file.
 */
@protocol APIURLSessionUploadPattern <APIURLSessionRequestPattern>
@required

/// File to make upload body file
-( nullable NSString* )bodyFileOfURLSessionUploadRequest;

@end

#pragma mark - URS Session engine

/**
 API Network Connection engine using URS Session framework
 
 API Request object class must conform protocol `APIURLSessionRequestPattern`.
 
 API Request object class can conform protocol `APIURLSessionDownloadPattern` or `APIURLSessionUploadPattern`,
 but can not conform both.
 */
@interface APIURLSession : NSObject <APIConnectionEngine>

/// Default trust all hosts called from API. Set this to YES to not allowed untrusted server (invalid certificates).
@property ( nonatomic, assign ) BOOL doNotTrustUntrustedServer;

-( nonnull instancetype )initWithConfiguration:( nonnull NSURLSessionConfiguration* )config;
-( nonnull instancetype )initWithConfiguration:( nonnull NSURLSessionConfiguration* )config
                                operationQueue:( nonnull NSOperationQueue* )queue;
/** Make new instance with default URS Session Configuration */
-( nonnull instancetype )init;

@end
