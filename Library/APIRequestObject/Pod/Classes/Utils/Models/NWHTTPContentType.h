/**
 @file      NWHTTPContentType.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import "NWRequestHeaderAttribute.h"

@interface NWHTTPContentType : NWRequestHeaderAttribute

// Type should be MIME_MAIN_TYPE_* => see NWInternetMimeType.h
@property ( nonatomic, strong, nullable ) NSString *type;
@property ( nonatomic, strong, nullable ) NSString *subtype;

/// Init with description string without header name
-( nullable instancetype )initFromShortString:( nonnull NSString* )attrString;
/// Make description string without header name
-( nonnull NSString* )toShortString;
/* Convert between file extension & mime type - just some common cases, not all. */
-( nonnull instancetype )initFromPathExtension:( nonnull NSString* )extension;
-( nullable NSString* )pathExtension;

/**
 *  Try to read the parameter 'charset' & convert to charset number of NSString
 *
 *  @return 0 if failed
 */
-( NSStringEncoding )stringEncoding;

@end
