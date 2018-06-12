/**
 @file      NSError+APIRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

extern NSString *const _Nonnull kAPIResponseErrorAPIDomain;
extern NSString *const _Nonnull kAPIResponseErrorHTTPDomain;

@interface NSError (APIRequest)

+( nonnull NSError* )errorWithDomain:( nonnull NSString* )domain
                                code:( NSInteger )code
                         description:( nullable NSString* )description;
+( nonnull NSError* )apiErrorWithCode:( NSInteger )code
                          description:( nullable NSString* )description;
+( nonnull NSError* )httpErrorWithCode:( NSInteger )code;

-( BOOL )isAPIError;
-( BOOL )isHTTPError;

@end
