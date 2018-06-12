/**
 @file      NSMutableURLRequest+HTTPRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSMutableURLRequest+HTTPRequest.h"
#import "NWHTTPConstant.h"
#import "NWUtils.h"
#import "NWHTTPContentType.h"
@import RSUtils;

@implementation NSMutableURLRequest (HTTPRequest)

- ( void )setBasicAuthenticationWithUserName:( NSString* )userName
								 andPassword:( NSString* )pass {
	NSString *basicAuth = [ NSString stringWithFormat:@"%@:%@", userName, pass ];
	NSData *authData = [ basicAuth dataUsingEncoding:NSASCIIStringEncoding ];
	NSString *authValue = [ NSString stringWithFormat:@"Basic %@", [ authData base64EncodedStringWithOptions:0 ]];
	[ self setValue:authValue forHTTPHeaderField:HTTP_HEADER_REQUEST_AUTHORIZATION ];
}

- ( void )importHTTPHeader:( NSDictionary* )customHeader {
	for ( NSString *s in customHeader.allKeys ) {
		[ self setValue:[ customHeader objectForKey:s ] forHTTPHeaderField:s ];
	}
}

- ( void )setRange:( NSRange )range {
	if ( range.length > 0 )
		[ self setValue:[ NSString stringWithFormat:@"bytes="FM_NSUInteger"-"FM_NSUInteger,
						 range.location,
						 range.location + range.length - 1 ]
	 forHTTPHeaderField:HTTP_HEADER_REQUEST_RANGE ];
	else
		[ self setValue:[ NSString stringWithFormat:@"bytes="FM_NSUInteger,
						 range.location ]
	 forHTTPHeaderField:HTTP_HEADER_REQUEST_RANGE ];
}

-( void )setHTTPBodyData:( NSData* )body withContentType:( NWHTTPContentType* )mimeType {
    [ self setValue:[ mimeType toShortString ]
           forHTTPHeaderField:HTTP_HEADER_REQUEST_CONTENT_TYPE ];
    [ self setValue:[ NSString stringWithFormat:FM_NSUInteger, body.length ]
           forHTTPHeaderField:HTTP_HEADER_REQUEST_CONTENT_LENGTH ];
    [ self setHTTPBody:body ];
}

@end
