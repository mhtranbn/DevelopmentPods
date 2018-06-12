/**
 @file      NSMutableURLRequest+HTTPRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

#define NW_REQUEST_TIME_OUT_COMMON	60.0

@class NWHTTPContentType;
/**
 *	@brief	Some additional functions help setting the request
 */
@interface NSMutableURLRequest (HTTPRequest)

/**
 *	@brief	Import a dictionary to HTTP request header
 *
 *	@param 	customHeader 	Custom HTTP request header
 */
- ( void )importHTTPHeader:( nonnull NSDictionary* )customHeader;

/**
 *	@brief	Add Basic Authentication into HTTP header
 *
 *	@param 	userName 	Username
 *	@param 	pass 	Password
 */
- ( void )setBasicAuthenticationWithUserName:( nonnull NSString* )userName
								 andPassword:( nonnull NSString* )pass;
/**
 *	@brief	Add Range entry to HTTP request header
 *
 *	@param 	range 	The range in byte of file to be downloaded, which the size of
	range is length to be download, not the total length
 */
- ( void )setRange:( NSRange )range;

/**
 *  Set HTTP body and Content-Type, Content-Length header
 *
 *  @param body     Data of body
 *  @param mimeType Content-Type
 */
-( void )setHTTPBodyData:( nonnull NSData* )body withContentType:( nonnull NWHTTPContentType* )mimeType;

@end
