/**
 @file      NWBinaryBodyRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIUploadRequest.h"
#import "NWRequest.h"

/// HTTP Body type for `NWBinaryBodyRequest`
typedef NS_ENUM( NSUInteger, NWBinaryBodyType ) {
    /// Data will be set to `NSURLRequest.httpBody`.
    kNWBinaryBody,
    /// Data will be store in temp file & set to `NSURLRequest.httpBodyStream`.
    kNWBinaryBodyStream,
    /// Data will be store in temp file. Use this with `APIUploadRequest`.
    kNWBinaryBodyFile
};

/**
 Make NSURLRequest with HTTP body from `parameter` of `APIRequest`.
 `parameter` of `APIRequest` should be:
   - `NSData`: will set HTTP request header `Content-Type` as `application/octet-stream` & `Content-Length`.
   - `NWRequestData`: use `NWRequestData.mimetype` to set HTTP Request header `Content-Type`. Also set `Content-Length`.
 */
@interface NWBinaryBodyRequest : NWRequestMakerBase <APIUploadRequestMaker>

@property ( nonatomic, assign ) NWBinaryBodyType bodyType;

@end
