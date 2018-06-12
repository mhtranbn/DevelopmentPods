/**
 @file      NSFileManager+appFolder.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSFileManager+appFolder.h"

@implementation NSFileManager (appFolder)

-( NSString* )pathOfUserFolder:( NSSearchPathDirectory )folder {
    NSArray *array = [ self URLsForDirectory:folder inDomains:NSUserDomainMask ];
    if ( array && array.count ){
        NSURL *url = [ array objectAtIndex:0 ];
        return [ NSString stringWithUTF8String:[ url fileSystemRepresentation ]];
    }
    return nil;
}

-( NSString* )documentPath {
    return [ self pathOfUserFolder:NSDocumentDirectory ];
}

-( NSString* )librayPath {
    return [ self pathOfUserFolder:NSLibraryDirectory ];
}

-( NSString* )cachesPath {
    return [ self pathOfUserFolder:NSCachesDirectory ];
}

-( BOOL )copyItemAtPath:( NSString* )srcPath overwritePath:( NSString* )dstPath error:( NSError** )error {
    if ([ self removeItemAtPath:dstPath error:error ]) {
        return [ self copyItemAtPath:srcPath toPath:dstPath error:error ];
    }
    return NO;
}

-( BOOL )moveItemAtPath:( NSString* )srcPath overwritePath:( NSString* )dstPath error:( NSError** )error {
    if ([ self removeItemAtPath:dstPath error:error ]) {
        return [ self moveItemAtPath:srcPath toPath:dstPath error:error ];
    }
    return NO;
}

-( BOOL )copyItemAtURL:( NSURL* )srcURL overwriteURL:( NSURL* )dstURL error:( NSError** )error {
    if ([ self removeItemAtURL:dstURL error:error ]) {
        return [ self copyItemAtURL:srcURL toURL:dstURL error:error ];
    }
    return NO;
}

-( BOOL )moveItemAtURL:( NSURL* )srcURL overwriteURL:( NSURL* )dstURL error:( NSError** )error {
    if ([ self removeItemAtURL:dstURL error:error ]) {
        return [ self moveItemAtURL:srcURL toURL:dstURL error:error ];
    }
    return NO;
}

@end
