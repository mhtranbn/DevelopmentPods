/**
 @file      NSDictionary+HTTPResponse.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

/**
 *	@brief	Additional functions to get some HTTP header values
 */
@interface NSDictionary (HttpResponseHeader)

/**
 *	@return	String value of HTTP header field "Last-Modified"
 */
- ( nullable NSString* )httpLastModification;

/**
 *	@return	String value of HTTP header field "Content-Length"
 */
- ( NSUInteger )httpContentLength;

/**
 *	@return	String value of HTTP header field "Content-Type"
 */
- ( nullable NSString* )httpContentType;

/**
 *	@return	if HTTP header field "Accept-Ranges" existing and equal "bytes"
 */
- ( BOOL )httpResumable;

/**
 *	@return	String value of HTTP header field "Allow"
 */
- ( nullable NSString* )httpMethodsSupported;

@end
