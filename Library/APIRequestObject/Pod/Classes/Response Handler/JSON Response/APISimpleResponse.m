/**
 @file      APISimpleResponse.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APISimpleResponse.h"
#import "NWHTTPConstant.h"
#import "NSError+APIRequest.h"

@implementation APISimpleResponse

-( void )parseResponseData:( id )data responseInfo:( NSHTTPURLResponse* )httpResponse error:( NSError* )error
                andRequest:( APIRequest* )request onComplete:( APIReponseHandlerCompletion )completion {
    NSError *err = error;
    if ( httpResponse.statusCode != HTTP_STATUS_CODE_OK ) {
        if ( err == nil ) err = [ NSError httpErrorWithCode:httpResponse.statusCode ];
    }
    completion( err, nil, httpResponse, data );
}

@end
