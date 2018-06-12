/**
 @file      NWUtils.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "NWInternetMediaMimeType.h"
#import "NWHTTPContentType.h"

static bool isUrlCharUnreserved( unsigned char in );

@implementation NWUtils

static bool isUrlCharUnreserved(unsigned char c) {
	switch ( c ) {
		case '0': case '1': case '2': case '3': case '4':
		case '5': case '6': case '7': case '8': case '9':
		case 'a': case 'b': case 'c': case 'd': case 'e':
		case 'f': case 'g': case 'h': case 'i': case 'j':
		case 'k': case 'l': case 'm': case 'n': case 'o':
		case 'p': case 'q': case 'r': case 's': case 't':
		case 'u': case 'v': case 'w': case 'x': case 'y': case 'z':
		case 'A': case 'B': case 'C': case 'D': case 'E':
		case 'F': case 'G': case 'H': case 'I': case 'J':
		case 'K': case 'L': case 'M': case 'N': case 'O':
		case 'P': case 'Q': case 'R': case 'S': case 'T':
		case 'U': case 'V': case 'W': case 'X': case 'Y': case 'Z':
		case '-': case '.': case '_': case '~':
			return TRUE;
		default:
			break;
	}
	return FALSE;
}

+( NSString* )urlencode:( NSString* )urlString {
	NSMutableString *res = [[ NSMutableString alloc ] init ];
	// Convert to bytes using UTF-8 encoding
	const char *buffer = [ urlString cStringUsingEncoding:NSUTF8StringEncoding ];
	size_t l = [ urlString lengthOfBytesUsingEncoding:NSUTF8StringEncoding ];
	for ( int i = 0; i < l; i++ ) {
		Byte b = buffer[i]; // get a byte
        // Encode
		if ( isUrlCharUnreserved( b )) {
			[ res appendFormat:@"%c", b ];
		} else {
			[ res appendFormat:@"%%%02X", b ];
		}
	}
    return res;
}

+( NSString* )urldecode:( NSString* )urlString {
    NSMutableData *dat = [[ NSMutableData alloc ] init ];
    const char *buffer = [ urlString cStringUsingEncoding:NSUTF8StringEncoding ];
    size_t l = [ urlString lengthOfBytesUsingEncoding:NSUTF8StringEncoding ];
    for ( int i = 0; i < l; i++ ) {
		Byte b = buffer[i]; // get a byte
		if ( b == '%' && isxdigit( buffer[i+1] ) && isxdigit( buffer[i+2] )) {
            char hexStr[3];
            hexStr[0] = buffer[i+1];
            hexStr[1] = buffer[i+2];
            hexStr[2] = 0;
            unsigned long l = strtoul( hexStr, NULL, 16 );
            Byte bl = ( Byte )l;
            [ dat appendBytes:&bl length:1 ];
            i += 2;
        } else {
            [ dat appendBytes:&b length:1 ];
        }
	}
    return [[ NSString alloc ] initWithData:dat encoding:NSUTF8StringEncoding ];
}

+( NSMutableString* )joinParameters:( NSArray* )params
							  forKey:( NSString* )key
					   intoURLString:( NSMutableString* )s {
	if ( s == nil )
		s = [ NSMutableString string ];
    for ( id obj in params ) {
        if ([ obj isKindOfClass:[ NSNull class ]]) continue;
        if ([[ obj class ] isSubclassOfClass:[ NSString class ]] || [[ obj class ] isSubclassOfClass:[ NSNumber class ]]) {
            [ s appendFormat:@"%@[]=%@&", key, obj ];
        } else if ([[ obj class ] isSubclassOfClass:[ NSArray class ]]) {
			[ NWUtils joinParameters:obj
							   forKey:[ NSString stringWithFormat:@"%@[]", key ]
						intoURLString:s ];
		} else if ([[ obj class ] isSubclassOfClass:[ NSDictionary class ]]) {
			[ NWUtils joinParametersDictionary:obj
							   forKey:[ NSString stringWithFormat:@"%@[]", key ]
						intoURLString:s ];
        } else {
            [ NSException raise:@"Join ARRAY to url string"
						 format:@"Unsupport data. The array must contain the NSString, NSArray or NSDictionary" ];
        }
    }
	if ( s.length > 1 )
        [ s deleteCharactersInRange:NSMakeRange( s.length - 1, 1 )];
	return s;
}

+( NSMutableString* )joinParametersDictionary:( NSDictionary* )params
										forKey:( NSString* )key
								 intoURLString:( NSMutableString* )s {
	if ( s == nil )
		s = [ NSMutableString string ];
    for ( NSString *k in params.allKeys ) {
        id obj = [ params objectForKey:k ];
        if ([ obj isKindOfClass:[ NSNull class ]]) continue;
        if ([[ obj class ] isSubclassOfClass:[ NSString class ]] || [[ obj class ] isSubclassOfClass:[ NSNumber class ]]) {
            [ s appendFormat:@"%@[%@]=%@&", key, k, obj ];
        } else if ([[ obj class ] isSubclassOfClass:[ NSDictionary class ]]) {
			[ NWUtils joinParametersDictionary:obj
                                        forKey:[ NSString stringWithFormat:@"%@[%@]", key, k ]
                                 intoURLString:s ];
		} else if ([[ obj class ] isSubclassOfClass:[ NSArray class ]]) {
			[ NWUtils joinParameters:obj
                              forKey:[ NSString stringWithFormat:@"%@[%@]", key, k ]
                       intoURLString:s ];
        } else {
            [ NSException raise:@"Join DICTIONARY to url string"
						 format:@"Unsupport data. The array must contain the NSString, NSArray or NSDictionary" ];
        }
    }
	if ( s.length > 1 )
        [ s deleteCharactersInRange:NSMakeRange( s.length - 1, 1 )];
	return s;
}

+( NSMutableString* )joinParametersFromDictionary:( NSDictionary* )params
                                    intoURLString:( NSMutableString* )s {
	if ( s == nil )
		s = [ NSMutableString string ];
    for ( NSString *k in params.allKeys ) {
        id obj = [ params objectForKey:k ];
        if ([ obj isKindOfClass:[ NSNull class ]]) continue;
        if ([[ obj class ] isSubclassOfClass:[ NSString class ]] || [[ obj class ] isSubclassOfClass:[ NSNumber class ]]) {
            [ s appendFormat:@"%@=%@&", k, obj ];
        } else if ([[ obj class ] isSubclassOfClass:[ NSDictionary class ]]) {
			[ NWUtils joinParametersDictionary:obj
                                        forKey:k
                                 intoURLString:s ];
		} else if ([[ obj class ] isSubclassOfClass:[ NSArray class ]]) {
			[ NWUtils joinParameters:obj
                              forKey:k
                       intoURLString:s ];
        } else {
            [ NSException raise:@"Join DICTIONARY to url string"
						 format:@"Unsupport data %@ for key %@\nThe array must contain the NSString, NSArray or NSDictionary", [ obj class ], k ];
        }
    }
	if ( s.length > 1 )
        [ s deleteCharactersInRange:NSMakeRange( s.length - 1, 1 )];
    return s;
}

+( NSString* )completeURL:( NSString* )url {
    NSString *urlScheme = nil;
    NSRange range = [ url rangeOfString:@"://" ];
    if ( range.location != NSNotFound ) {
        urlScheme = [ url substringToIndex:range.location + 3 ];
        url = [ url substringFromIndex:range.location + 3 ];
    } else {
        urlScheme = @"http://";
    }
    
    NSArray *urlParts = [ url componentsSeparatedByString:@"/" ];
    if ( urlParts.count == 0 ) return [ NSString stringWithFormat:@"%@%@", urlScheme, url ];
    
    NSMutableString *lastUrl = [ NSMutableString stringWithString:urlScheme ];
    [ lastUrl appendString:[ urlParts objectAtIndex:0 ]];
    for ( int i = 1; i < urlParts.count - 1; i++ ) {
        NSString *s = [ urlParts objectAtIndex:i ];
        [ lastUrl appendFormat:@"/%@", [ NWUtils urlencode:s ]];
    }
    if ( urlParts.count > 1 ) {
        NSString *lastPart = [ urlParts lastObject ];
        range = [ lastPart rangeOfString:@"?" ];
        if ( range.location != NSNotFound ) {
            NSString *script = [ lastPart substringToIndex:range.location ];
            [ lastUrl appendFormat:@"/%@?", [ NWUtils urlencode:script ]];
            NSString *paramsS = [ lastPart substringFromIndex:range.location + 1 ];
            NSArray *params = [ paramsS componentsSeparatedByString:@"&" ];
            if ( params.count ) {
                for ( NSString *param in params ) {
                    range = [ param rangeOfString:@"=" ];
                    if ( range.location != NSNotFound ) {
                        NSString *paramKey = [ param substringToIndex:range.location ];
                        NSString *paramValue = [ param substringFromIndex:range.location + 1 ];
                        [ lastUrl appendFormat:@"%@=%@&", [ NWUtils urlencode:paramKey ], [ NWUtils urlencode:paramValue ]];
                    } else {
                        [ lastUrl appendFormat:@"%@&", [ NWUtils urlencode:param ]];
                    }
                }
                [ lastUrl deleteCharactersInRange:NSMakeRange( lastUrl.length - 1, 1 )];
            } else {
                [ lastUrl appendString:[ NWUtils urlencode:paramsS ]];
            }
        } else {
            [ lastUrl appendFormat:@"/%@", [ NWUtils urlencode:lastPart ]];
        }
    }
    return lastUrl;
}

+( NSStringEncoding )stringEncodingFromCharsetName:( NSString* )charsetName {
    if ( charsetName && charsetName.length ) {
        CFStringEncoding cfEndcoding = CFStringConvertIANACharSetNameToEncoding(( CFStringRef )charsetName );
        return CFStringConvertEncodingToNSStringEncoding( cfEndcoding );
    }
    return 0;
}

+( NSString* )charsetNameFromStringEncoding:( NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding( encoding );
    return ( NSString* )CFStringConvertEncodingToIANACharSetName( cfEncoding );
}

+( NSMutableDictionary* )parametersListFromUrlEncodedQuery:( NSString* )query {
    NSArray *arrParams = [ query componentsSeparatedByCharactersInSet:[ NSCharacterSet characterSetWithCharactersInString:@"&=" ]];
    if ( arrParams && arrParams.count ) {
        @try {
            NSMutableDictionary *dicParams = [ NSMutableDictionary dictionary ];
            for ( int i = 0; i < arrParams.count; i += 2 ) {
                [ dicParams setObject:[ NWUtils urldecode:arrParams[ i + 1 ]] forKey:arrParams[ i ]];
            }
            return dicParams;
        }
        @catch (NSException *exception) {
            return nil;
        }
    }
    return nil;
}

@end

@implementation NSURL (params)

-( NSMutableDictionary* )parametersList {
    if ( self.query != nil && self.query.length > 0 ) {
        return [ NWUtils parametersListFromUrlEncodedQuery:self.query ];
    }
    return nil;
}

@end
