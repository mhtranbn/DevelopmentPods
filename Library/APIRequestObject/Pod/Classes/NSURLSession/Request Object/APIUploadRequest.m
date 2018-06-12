/**
 @file      APIUploadRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIUploadRequest.h"
#import "NWRequestData+Convert.h"
#import "NWRequestData+Multipart.h"
#import "NWBinaryBodyRequest.h"
#import "NWHTTPConstant.h"

@implementation APIUploadRequest

-( NSString* )bodyFileOfURLSessionUploadRequest {
    if ([ self.requestMaker respondsToSelector:@selector( fileToUploadWithURLSession )]) {
        return [( id<APIUploadRequestMaker> )self.requestMaker fileToUploadWithURLSession ];
    }
    return nil;
}

-( void )configureForMultipartRequest:( id )parameter {
    [ self configureForUploadData:[ NWRequestData multipartDataWithObject:parameter ]];
}

-( void )configureForUploadImage:( UIImage* )image {
    [ self configureForUploadData:[ NWRequestData pngDataWithImage:image ]];
}

-( void )configureForUploadBinaryData:( NSData* )data {
    [ self configureForUploadData:[[ NWRequestData alloc ] initWithData:data ]];
}

-( void )configureForUploadData:( NWRequestData* )data {
    self.httpMethod = HTTP_METHOD_POST;
    self.requestMaker = [ NWBinaryBodyRequest new ];
    self.parameters = data;
}

@end
