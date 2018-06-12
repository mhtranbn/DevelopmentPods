/**
 @file      NWRequestData.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestData.h"
#import "NWInternetMediaMimeType.h"
@import RSUtils;

@interface NWRequestData ()

@property ( nonatomic, strong, nullable ) NSString *logDesc;
@property ( nonatomic, strong, nullable ) NSString *tempPath;
@property ( nonatomic, strong, nullable ) NSData *buffer;
@property ( nonatomic, readwrite ) NSUInteger size;

-( void )createTempFileIfNeeded;

@end

@implementation NWRequestData

-( instancetype )initWithData:( NSData* )data mimeType:( NWHTTPContentType* )type storeInTempFile:(BOOL)isFileStorage {
    if ( self = [ super init ]) {
        _buffer = [ data copy ];
        _mimeType = type;
        _size = _buffer.length;
        NSString *ext = [ type pathExtension ];
        if ( ext == nil || ext.length == 0 ) ext = @"dat";
        _fileName = [ NSString stringWithFormat:@"%p.%@", self, ext ];
        if ( isFileStorage )[ self createTempFileIfNeeded ];
    }
    return self;
}

-( instancetype )initWithData:( NSData* )data {
    if ( self = [ super init ]) {
        self = [ self initWithData:data
                          mimeType:[[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_APP_OCTET_STREAM ]
                   storeInTempFile:NO ];
    }
    return self;
}

-( NSString* )tempFile {
    [ self createTempFileIfNeeded ];
    return _tempPath;
}

-( NSData* )contentData {
    if ( self.tempPath != nil ) {
        return [ NSData dataWithContentsOfFile:self.tempPath ];
    } else {
        return self.buffer;
    }
}

-( NSString* )description {
    NSMutableString *result = [ NSMutableString stringWithFormat:@"%@ <%p>: %@ %@ bytes",
                               NSStringFromClass( self.class ),
                               self,
                               self.mimeType.toString,
                               @( self.size )];
    if ( self.logDesc != nil )[ result appendFormat:@"\n%@", self.logDesc ];
    NSString *content = [[ NSString alloc ] initWithData:self.contentData encoding:NSUTF8StringEncoding ];
    if ( content != nil && content.length > 0 )[ result appendFormat:@"\n%@", content ];
    return result;
}

-( void )createTempFileIfNeeded {
    if ( self.tempPath != nil ) return;
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    NSString *tempFolder = [ fileMan cachesPath ];
    NSString *fileName = [ NSString stringWithFormat:@"%@%p%@", self.class, self, [[ NSDate date ] stringWithFormat:@"yMMddHHmmssSSS" ]];
    NSString *tmpPath = [ tempFolder stringByAppendingPathComponent:fileName ];
    NSInteger i = 0;
    while ([ fileMan fileExistsAtPath:tmpPath ]) {
        tmpPath = [ tempFolder stringByAppendingPathComponent:[ fileName stringByAppendingFormat:@"%@", @( i )]];
        i += 1;
    }
    [ self.buffer writeToFile:tmpPath atomically:NO ];
    self.buffer = nil;
    self.tempPath = tmpPath;
}

-( void )dealloc {
    if ( self.tempPath != nil ) {
        [[ NSFileManager defaultManager ] removeItemAtPath:self.tempPath error:nil ];
        self.tempPath = nil;
    }
}

@end
