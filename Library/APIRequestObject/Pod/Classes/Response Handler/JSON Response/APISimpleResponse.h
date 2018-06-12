/**
 @file      APISimpleResponse.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIRequest.h"

/**
 *  Simple API Response, just check HTTP status without process response data.
 */
@interface APISimpleResponse : NSObject <APIResponseHandler>

@end
