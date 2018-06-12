/**
 @file      NSData+Split.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSData+Split.h"

@implementation NSData (Split)

-( NSArray<NSData*>* )componentsSeparatedByData:( NSData* )separator {
    if ( self.length == 0 || separator.length == 0 || self.length <= separator.length ) return @[[ self copy ]];
    NSMutableArray *result = [ NSMutableArray new ];
    NSData *buffer = [ self copy ];
    NSRange range = [ buffer rangeOfData:separator options:0 range:NSMakeRange( 0, buffer.length )];
    while ( range.location != NSNotFound ) {
        NSData *subData = [ buffer subdataWithRange:NSMakeRange(0, range.location)];
        [ result addObject:subData ];
        NSUInteger loc = range.location + separator.length;
        if ( loc <= buffer.length ) {
            buffer = [ buffer subdataWithRange:NSMakeRange( loc, buffer.length - loc )];
            range = [ buffer rangeOfData:separator options:0 range:NSMakeRange( 0, buffer.length )];
        } else {
            break;
        }
    }
    if ( buffer.length > 0 ) {
        [ result addObject:buffer ];
    }
    return result;
}

@end
