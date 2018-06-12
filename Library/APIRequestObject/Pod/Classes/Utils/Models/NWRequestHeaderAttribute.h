/**
 @file      NWRequestHeaderAttribute.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

#define CRLF    @"\r\n"

@interface NWRequestHeaderAttribute : NSObject

@property ( nonatomic, copy, nonnull ) NSString *key;
@property ( nonatomic, copy, nonnull ) NSString *value;
@property ( nonatomic, copy, nullable ) NSDictionary<NSString*, NSString*> *parameters;

-( nullable instancetype )initWithString:( nonnull NSString* )attrString;
-( nonnull NSString* )toString;

@end
