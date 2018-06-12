/**
 @file      APIDownloadRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIRequest.h"
#import "APIURLSession.h"

/// Request object to download to file with URL Session engine
@interface APIDownloadRequest : APIRequest <APIURLSessionDownloadPattern>

/**
 Make new request

 @param path Path (with file name) to save file.
 @param resumeID If specified: request will use cached data by given ID to make an resume URS Session request.
 And when cancel, request will save resumable data with given ID.
 @return New request instance
 */
-( nonnull instancetype )initWithDestinationFile:( nonnull NSString* )path
                                        resumeId:( nullable NSString* )resumeID;

/// Destination file path
@property ( nonatomic, readonly, copy, nonnull ) NSString *destinationFile;
@property ( nonatomic, readonly, copy, nullable ) NSString *resumeIdentifier;

/// Set method to GET & requestMaker to NWUrlEncodedRequest
-( void )configureForDownload;

@end
