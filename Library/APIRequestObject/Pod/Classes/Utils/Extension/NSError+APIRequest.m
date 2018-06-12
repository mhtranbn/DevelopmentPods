/**
 @file      NSError+APIRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSError+APIRequest.h"
#import "NWUtils.h"

NSString *const kAPIResponseErrorAPIDomain = @"ErrorDomain.Response.API";
NSString *const kAPIResponseErrorHTTPDomain = @"ErrorDomain.Response.HTTP";

@implementation NSError (APIRequest)

+( NSError* )errorWithDomain:( NSString* )domain code:( NSInteger )code description:( NSString* )description {
    return [ self errorWithDomain:domain
                             code:code
                         userInfo:@{ NSLocalizedDescriptionKey: description ? description : @"" }];
}

+( NSError* )apiErrorWithCode:( NSInteger )code description:( NSString* )description {
    return [ self errorWithDomain:kAPIResponseErrorAPIDomain code:code description:description ];
}

+( NSError* )httpErrorWithCode:( NSInteger )code {
    return [ self errorWithDomain:kAPIResponseErrorHTTPDomain code:code
                      description:[ NSHTTPURLResponse localizedStringForStatusCode:code ]];
}

-( BOOL )isAPIError {
    return [ self.domain isEqualToString:kAPIResponseErrorAPIDomain ];
}

-( BOOL )isHTTPError {
    return [ self.domain isEqualToString:kAPIResponseErrorHTTPDomain ];
}

@end
