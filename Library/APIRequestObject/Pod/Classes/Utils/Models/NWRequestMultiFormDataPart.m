/**
 @file      NWRequestMultiFormDataPart.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestMultiFormDataPart.h"
#import "NSData+Split.h"
#import "NWHTTPConstant.h"
#import "NWInternetMediaMimeType.h"
#import "NWUtils.h"

@implementation NWRequestMultiFormDataPart

-( instancetype )initWithEncodedData:( NSData* )data {
    NSData *separator = [ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding ];
    NSArray *array = [ data componentsSeparatedByData:separator ];
    if ( array.count < 4 ) return nil;
    if ( self = [ super init ]) {
        NSUInteger emptyCount = 1;
        // First item must be empty
        NSData *first = array.firstObject;
        if ( first.length != 0 ) return nil;
        NSMutableArray *attrs = [ NSMutableArray new ];
        for ( NSUInteger i = 1; i < array.count; i++ ) {
            NSData *dat = [ array objectAtIndex:i ];
            if ( dat.length == 0 ) {
                emptyCount += 1;
            } else {
                if ( emptyCount == 1) {
                    NSString *s = [[ NSString alloc ] initWithData:dat encoding:NSUTF8StringEncoding ];
                    if ( s != nil ) {
                        NWRequestHeaderAttribute *attr = [[ NWRequestHeaderAttribute alloc ] initWithString:s ];
                        if ( attr != nil )[ attrs addObject:attr ];
                    }
                } else {
                    _data = dat;
                }
            }
        }
        if ( attrs.count == 0 || _data == nil ) return nil;
        _attributes = attrs;
    }
    return self;
}

-( instancetype )initWithAttributes:( NSArray<NWRequestHeaderAttribute*>* )attributes andData:( NSData* )data {
    if ( self = [ super init ]) {
        _attributes = [ attributes copy ];
        _data = [ data copy ];
    }
    return self;
}

-( NSData* )toData {
    NWRequestHeaderAttribute *firstAttr = self.attributes.firstObject;
    NSAssert( firstAttr != nil , @"%@<%p> has no attribute!", self.class, self );
    NSAssert([ firstAttr.key isEqualToString:HTTP_HEADER_REQUEST_CONTENT_DISPOSITION ],
             @"First attribute of %@<%p> is not %@!", self.class, self, HTTP_HEADER_REQUEST_CONTENT_DISPOSITION );
    NSMutableString *bufferStr = [ NSMutableString new ];
    for ( NWRequestHeaderAttribute *attr in self.attributes ) {
        [ bufferStr appendFormat:@"%@"CRLF, [ attr toString ]];
    }
    [ bufferStr appendString:CRLF ];
    NSMutableData *result = [ NSMutableData dataWithData:[ bufferStr dataUsingEncoding:NSUTF8StringEncoding ]];
    [ result appendData:self.data ];
    return result;
}

-( NSString* )logDescription {
    NSMutableString *result = [ NSMutableString string ];
    NSStringEncoding encoding = NSUTF8StringEncoding;
    for ( NWRequestHeaderAttribute *attr in self.attributes ) {
        NSString *attrStr = [ attr toString ];
        [ result appendFormat:@"%@\n", attrStr ];
        if ([ attr.key isEqualToString:HTTP_HEADER_REQUEST_CONTENT_TYPE ]) {
            NSString *charset = nil;
            if ( attr.parameters != nil ) charset = [ attr.parameters objectForKey:MIME_PARAMETER_CHARSET ];
            if ( charset && charset.length ) encoding = [ NWUtils stringEncodingFromCharsetName:charset ];
        }
    }
    [ result appendString:@"\n" ];
    NSString *dataDesc = [[ NSString alloc ] initWithData:self.data encoding:encoding ];
    if ( dataDesc != nil ) {
        [ result appendString:dataDesc ];
    } else {
        [ result appendFormat:@"BINARY: %@", @( self.data.length )];
    }
    return result;
}

@end
