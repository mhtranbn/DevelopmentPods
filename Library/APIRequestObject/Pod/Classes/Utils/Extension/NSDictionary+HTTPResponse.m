/**
 @file      NSDictionary+HTTPResponse.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSDictionary+HTTPResponse.h"
#import "NWHTTPConstant.h"

@implementation NSDictionary (HttpResponseHeader)

- ( NSString* )httpLastModification {
    return  [ self objectForKey:HTTP_HEADER_RESPONSE_LAST_MODIFIED ];
}

- ( NSUInteger )httpContentLength {
    return [[ self objectForKey:HTTP_HEADER_RESPONSE_CONTENT_LENGTH ] integerValue ];
}

- ( NSString* )httpContentType {
    return [ self objectForKey:HTTP_HEADER_RESPONSE_CONTENT_TYPE ];
}

- ( BOOL )httpResumable {
    return [ self.allKeys containsObject:HTTP_HEADER_RESPONSE_CONTENT_RANGE ];
}

- ( NSString* )httpMethodsSupported {
    return [ self objectForKey:HTTP_HEADER_RESPONSE_ALLOW ];
}

@end
