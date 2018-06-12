/**
 @file      APIUploadRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIRequest.h"
#import "APIURLSession.h"

@class NWRequestData;

@protocol APIUploadRequestMaker <APIRequestMaker>
@optional

-( nullable NSString* )fileToUploadWithURLSession;

@end

/**
 Request object to upload file with URL Session engine,
 requestMaker must return @[ NSURLRequest, NWRequestData ].
 */
@interface APIUploadRequest : APIRequest <APIURLSessionUploadPattern>

/**
 Configure to upload with multipart format

 @param parameter Parameter for request, can be NSObject subclass instance or dictionary.
 */
-( void )configureForMultipartRequest:( nonnull id )parameter;
/**
 Configure to upload a single image

 @param image Image to upload. This image will be convert to JPEG data with compression 1.
 */
-( void )configureForUploadImage:( nonnull UIImage* )image;
/**
 Configure to upload binary data with type as Octet stream

 @param data Data to upload.
 */
-( void )configureForUploadBinaryData:( nonnull NSData* )data;
/**
 Configure to upload with given data

 @param data A NWRequestData instance with data & meta info.
 */
-( void )configureForUploadData:( nonnull NWRequestData* )data;

@end
