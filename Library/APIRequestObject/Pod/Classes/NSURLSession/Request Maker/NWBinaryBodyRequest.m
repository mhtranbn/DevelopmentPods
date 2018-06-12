/**
 @file      NWBinaryBodyRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWBinaryBodyRequest.h"
#import "NWRequestData.h"
#import "NWInternetMediaMimeType.h"
#import "NWHTTPContentType.h"
#import "NSMutableURLRequest+HTTPRequest.h"
#import "NWHTTPConstant.h"

@interface NWBinaryBodyRequest()

@property ( nonatomic, strong, nullable ) NWRequestData *requestData;

@end

@implementation NWBinaryBodyRequest

-( NSString* )fileToUploadWithURLSession {
    if ( self.requestData != nil && self.bodyType == kNWBinaryBodyFile ) return self.requestData.tempFile;
    return nil;
}

-( void )apiRequestDidFinish:( APIRequest* )request {
    self.requestData = nil;
}

-( void )generateRequestBodyWithRequestObject:( APIRequest* )request onComplete:( APIRequestMakerCompletion )completion {
    NWRequestData *bodyData = nil;
    if ( request.parameters != nil ) {
        if ([ request.parameters isKindOfClass:[ NSData class ]]) {
            bodyData = [[ NWRequestData alloc ] initWithData:request.parameters ];
        } else if ([ request.parameters isKindOfClass:[ NWRequestData class ]]) {
            bodyData = request.parameters;
        } else {
            [ NSException raise:[ NSString stringWithFormat:@"%@ Error", self.class ]
                         format:@"Parameter object of type \"%@\" is not supported.", [ request.parameters class ]];
        }
    }
    NSMutableURLRequest *resutl = [ self makeUrlRequestWithUrl:request.path ];
    [ resutl setHTTPMethod:request.httpMethod ];
    [ resutl setValue:[ NSString stringWithFormat:@"%@", @( bodyData.size )] forHTTPHeaderField:HTTP_HEADER_REQUEST_CONTENT_LENGTH ];
    [ resutl setValue:[ bodyData.mimeType toShortString ] forHTTPHeaderField:HTTP_HEADER_REQUEST_CONTENT_TYPE ];
    [ resutl importHTTPHeader:request.httpHeader ];
    switch ( self.bodyType ) {
        case kNWBinaryBody:
            [ resutl setHTTPBody:bodyData.contentData ];
            break;
        case kNWBinaryBodyStream:
            [ resutl setHTTPBodyStream:[ NSInputStream inputStreamWithFileAtPath:bodyData.tempFile ]];
            self.requestData = bodyData;
            break;
        case kNWBinaryBodyFile:
            self.requestData = bodyData;
            break;
    }
    completion( resutl, nil );
}

@end
