/**
 @file      NSData+Split.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

@interface NSData (Split)

-( nonnull NSArray<NSData*>* )componentsSeparatedByData:( nonnull NSData* )separator;

@end
