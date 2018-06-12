/**
 @file      NWUrlEncodedRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIRequest.h"
#import "NWRequest.h"

/// Type to encode data for NSURLRequest
typedef NS_ENUM( NSUInteger, NWUrlEncodedType ) {
    /// Use HTTP method to decide: GET, DELETE: put data into URL; POST, PUT ...: put data into HTTP body.
    kNWUrlEncodedFromHTTPMethod = 0,
    /// Put data into URL query
    kNWUrlEncodedIntoURLQuery = 1,
    /// Put data into HTTP body, also set HTTP request header `Content-Type` & `Content-Length`
    kNWUrlEncodedIntoHTTPBody = 2
};

/**
 Make NSURLRequest with parameters percent-encoded.
 Input (`parameter` of `APIRequest`) should be dictionary or NSObject.
 
 With input dictionary:
   - Keys should be NSString.
   - Items should be NSString, NSNumber, NSURL; array of NSString, NSNumber, NSURL; dictionary with key NSString & value NSString, NSNumber, NSURL.
 With input NSObject:
   - Support property alias name for paramter name.
   - Item value (after transformed) must have native datatype (int, float...), NSString, NSNumber, NSURL.
   - Item value can be Array/Dictionary of NSString, NSNumber, NSURL and will be encoded for PHP server.
 */
@interface NWUrlEncodedRequest : NWRequestMakerBase <APIRequestMaker>

/**
 How to make NSURLRequest object
*/
@property ( nonatomic, assign ) NWUrlEncodedType encodeType;

@end
