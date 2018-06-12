/**
 @file      NWRequestMultiFormData.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestMultiFormData.h"
@import RSUtils;

@implementation NWRequestMultiFormData

-( instancetype )initWithBoundary:( NSString* )boundary andFormDataParts:( NSArray<NWRequestMultiFormDataPart*>* )parts {
    if ( self = [ super init ]) {
        _boundary = [ boundary copy ];
        _parts = [ parts copy ];
    }
    return self;
}

-( instancetype )initWithEncodedData:( NSData* )data {
    NSRange range = [ data rangeOfData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding ]
                               options:0 range:NSMakeRange( 0, data.length )];
    if ( range.location == NSNotFound ) return nil;
    NSData *subData = [ data subdataWithRange:NSMakeRange( 0, range.location )];
    NSString *str = [[ NSString alloc ] initWithData:subData encoding:NSUTF8StringEncoding ];
    if ( str == nil || str.length < 3 || [ str rangeOfString:@"--" ].location != 0 ) return nil;
    if ( self = [ super init ]) {
        _boundary = [ str substringFromIndex:2 ];
        NSArray<NSData*> *array = [ data componentsSeparatedByData:subData ];
        if ( array.count < 2 ) return nil;
        NSData *first = array.firstObject;
        if ( first.length != 0 ) return nil;
        NSData *last = array.lastObject;
        if (![ last isEqualToData:[ @"--" dataUsingEncoding:NSUTF8StringEncoding ]]) return nil;
        NSMutableArray<NWRequestMultiFormDataPart*> *result = [ NSMutableArray new ];
        for ( NSUInteger i = 1; i < array.count - 1; i++ ) {
            NWRequestMultiFormDataPart *part = [[ NWRequestMultiFormDataPart alloc ] initWithEncodedData:array[i] ];
            if ( part != nil )[ result addObject:part ];
        }
        if ( result.count > 0 ) _parts = result;
    }
    return self;
}

-( NSData* )toData {
    NSAssert( self.boundary != nil && self.boundary.length > 0, @"%@<%p> does not have boundary!", self.class, self );
    NSData *crlfData = [ CRLF dataUsingEncoding:NSUTF8StringEncoding ];
    NSData *boundaryData = [[ NSString stringWithFormat:@"--%@", self.boundary ] dataUsingEncoding:NSUTF8StringEncoding ];
    NSMutableData *result = [ NSMutableData new ];
    for ( NWRequestMultiFormDataPart *part in self.parts ) {
        [ result appendData:boundaryData ];
        [ result appendData:crlfData ];
        [ result appendData:[ part toData ]];
        [ result appendData:crlfData ];
    }
    [ result appendData:boundaryData ];
    [ result appendData:[ @"--" dataUsingEncoding:NSUTF8StringEncoding ]];
    return result;
}

-( void )writeData:( NSFileHandle* )writter {
    NSAssert( self.boundary != nil && self.boundary.length > 0, @"%@<%p> does not have boundary!", self.class, self );
    NSData *crlfData = [ CRLF dataUsingEncoding:NSUTF8StringEncoding ];
    NSData *boundaryData = [[ NSString stringWithFormat:@"--%@", self.boundary ] dataUsingEncoding:NSUTF8StringEncoding ];
    for ( NWRequestMultiFormDataPart *part in self.parts ) {
        [ writter writeData:boundaryData ];
        [ writter writeData:crlfData ];
        [ writter writeData:[ part toData ]];
        [ writter writeData:crlfData ];
    }
    [ writter writeData:boundaryData ];
    [ writter writeData:[ @"--" dataUsingEncoding:NSUTF8StringEncoding ]];
}

-( BOOL )saveToFile:( NSString* )path {
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    if (![ fileMan fileExistsAtPath:path ]) {
        [ fileMan removeItemAtPath:path error:nil ];
    }
    [[ NSData new ] writeToFile:path atomically:YES ];
    NSFileHandle *writter = [ NSFileHandle fileHandleForWritingAtPath:path ];
    if ( writter != nil ) {
        [ self writeData:writter ];
        [ writter synchronizeFile ];
        [ writter closeFile ];
        return YES;
    }
    return NO;
}

-( NSString* )logDescription {
    NSMutableString *result = [ NSMutableString new ];
    for ( NWRequestMultiFormDataPart *part in self.parts ) {
        [ result appendFormat:@"--%@\n", self.boundary ];
        [ result appendFormat:@"%@\n", [ part logDescription ]];
    }
    [ result appendFormat:@"--%@--", self.boundary ];
    return result;
}

@end
