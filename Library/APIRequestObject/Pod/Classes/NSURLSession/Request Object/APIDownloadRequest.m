/**
 @file      APIDownloadRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIDownloadRequest.h"
#import "NWHTTPConstant.h"
#import "NWUrlEncodedRequest.h"
@import RSUtils;

@interface APIDownloadRequest()

@property ( nonatomic, copy ) NSString *destinationFile;
@property ( nonatomic, copy ) NSString *resumeIdentifier;

@end

@implementation APIDownloadRequest

-( instancetype )initWithDestinationFile:( NSString* )path resumeId:( NSString* )resumeID {
    if ( self = [ super init ]) {
        _destinationFile = [ path copy ];
        _resumeIdentifier = [ resumeID copy ];
        [ self configureForDownload ];
    }
    return self;
}

-( void )configureForDownload {
    self.httpMethod = HTTP_METHOD_GET;
    self.requestMaker = [ NWUrlEncodedRequest new ];
}

#pragma mark - Resume data

+( NSString* )resumeDataContainingFolder {
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    NSString *path = [ fileMan cachesPath ];
    path = [ path stringByAppendingPathComponent:@".resume_data" ];
    if (![ fileMan fileExistsAtPath:path ]) {
        [ fileMan createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil ];
    }
    return path;
}

+( void )saveResumeData:( NSData* )data withIdentifier:( NSString* )key {
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    NSString *path = [[ self resumeDataContainingFolder ] stringByAppendingPathComponent:key ];
    if ([ fileMan fileExistsAtPath:path ])[ fileMan removeItemAtPath:path error:nil ];
    [ data writeToFile:path atomically:YES ];
}

-( void )cleanResumeData {
    if ( self.resumeIdentifier == nil || self.resumeIdentifier.length == 0 ) return;
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    NSString *path = [[ APIDownloadRequest resumeDataContainingFolder ] stringByAppendingPathComponent:self.resumeIdentifier ];
    if ([ fileMan fileExistsAtPath:path ])[ fileMan removeItemAtPath:path error:nil ];
}

-( NSData* )resumableData {
    if ( self.resumeIdentifier == nil || self.resumeIdentifier.length == 0 ) return nil;
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    NSString *path = [[ APIDownloadRequest resumeDataContainingFolder ] stringByAppendingPathComponent:self.resumeIdentifier ];
    if ([ fileMan fileExistsAtPath:path ]) return [ NSData dataWithContentsOfFile:path ];
    return nil;
}

#pragma mark - Request

-( NSString* )pathToDownloadFromURLSession {
    return self.destinationFile;
}

-( void )saveResumableURLSessionRequestData:( NSData* )resumableData {
    if ( self.resumeIdentifier != nil && self.resumeIdentifier.length > 0 ){
        [ APIDownloadRequest saveResumeData:resumableData withIdentifier:self.resumeIdentifier ];
    }
}

-( NSData* )dataToResumeURLSessionRequest {
    return [ self resumableData ];
}

-( void )requestDidFinish:( NSHTTPURLResponse* )response data:( id )data error:( NSError* )error {
    NSError *err = error;
    if ( err == nil && ![[ NSFileManager defaultManager ] fileExistsAtPath:self.destinationFile ]) {
        err = [ NSError errorWithDomain:kAPIURLSessionRqErrorDomain code:404 userInfo:@{ NSLocalizedDescriptionKey: [ NSString stringWithFormat:@"File not downloaded at \"%@\"", self.destinationFile ]}];
    }
    [ super requestDidFinish:response data:data error:err ];
    [ self cleanResumeData ];
}

@end
