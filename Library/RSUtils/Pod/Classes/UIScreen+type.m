/**
 @file      UIScreen+type.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "UIScreen+type.h"

const CGSize kCMScreenSize35inch   = { 320.0f,  480.0f};
const CGSize kCMScreenSize35inch2x = { 640.0f,  960.0f};
const CGSize kCMScreenSize4inch    = { 640.0f, 1136.0f};
const CGSize kCMScreenSize47inch   = { 750.0f, 1334.0f};
const CGSize kCMScreenSize55inch   = {1080.0f, 1920.0f};
const CGSize kCMScreenSize58inch   = {1125.0f, 2436.0f};
const CGSize kCMScreenSize97inch   = { 768.0f, 1024.0f};
const CGSize kCMScreenSize97inch2x = {1536.0f, 2048.0f};
const CGSize kCMScreenSize105inch  = {1668.0f, 2224.0f};
const CGSize kCMScreenSize129inch  = {2048.0f, 2732.0f};
const CGSize kCMScreenSize38inch   = { 272.0f,  340.0f};
const CGSize kCMScreenSize42inch   = { 312.0f,  390.0f};

@implementation UIScreen (type)

-( CMScreenSizeType )screenType {
    CGSize nativeSize = self.nativeBounds.size;
    CMScreenSizeType type = kCMScreenUnknown;
    UIUserInterfaceIdiom idiom = [[ UIDevice currentDevice ] userInterfaceIdiom ];
    switch ( idiom ){
        case UIUserInterfaceIdiomPhone:
            if ( self.scale == 3.0f ){
                if ( nativeSize.width == kCMScreenSize55inch.width ) {
                    type = kCMScreeniPhone55Inch;
                } else if ( nativeSize.width == kCMScreenSize58inch.width ) {
                    type = kCMScreeniPhone58Inch;
                }
            } else if ( self.scale == 2.0f ){
                if ( nativeSize.width == kCMScreenSize35inch2x.width ){
                    type = kCMScreeniPhone35InchRetina;
                } else if ( nativeSize.width == kCMScreenSize4inch.width ){
                    type = kCMScreeniPhone4Inch;
                } else if ( nativeSize.width == kCMScreenSize47inch.width ){
                    type = kCMScreeniPhone47Inch;
                }
            } else {
                type = kCMScreeniPhone35Inch;
            }
            break;
        case UIUserInterfaceIdiomPad:
            if ( self.scale > 1 ){
                if ( nativeSize.width == kCMScreenSize129inch.width )
                    type = kCMScreeniPadPro129;
                else if ( nativeSize.width == kCMScreenSize105inch.width)
                    type = kCMScreeniPadPro105;
                else
                    type = kCMScreeniPadRetina;
            } else {
                type = kCMScreeniPad;
            }
            break;
        default:
            if ( @available(iOS 9.0, *) ) {
                if ( idiom == UIUserInterfaceIdiomTV ) { type = kCMScreenTv; }
            }
            break;
    }
    return type;
}

@end

NSString *const kCMImageNameSuffixRetina3_5  = @"@2x";
NSString *const kCMImageNameSuffixRetina4    = @"-568h@2x";
NSString *const kCMImageNameSuffixRetina4_7  = @"-667h@2x";
NSString *const kCMImageNameSuffixRetina5_5  = @"@3x";
NSString *const kCMImageNameSuffixIpad       = @"~ipad";
NSString *const kCMImageNameSuffixIpadRetina = @"~ipad@2x";

@implementation NSBundle (screen)

-( NSString* )searchForResourceName:( NSString* )name type:( NSString* )ext
                           inFolder:( NSString* )subDir suffix:( NSArray* )suffix {
    NSString *path = nil;
    for ( NSString *sf in suffix ){
        path = [ self pathForResource:[ name stringByAppendingString:sf ]
                               ofType:ext inDirectory:subDir ];
        if ( path ) break;
    }
    if ( path == nil ) path = [ self pathForResource:name ofType:ext inDirectory:subDir ];
    return path;
}

-( NSString* )pathForCurrentScreenOfResourceName:( NSString* )name
                                         andType:( NSString* )extension inFolder:( NSString* )subDir {
    CMScreenSizeType screenType = [[ UIScreen mainScreen ] screenType ];
    switch ( screenType ){
        case kCMScreeniPhone35Inch:
            return [ self pathForResource:name ofType:extension inDirectory:subDir ];
            break;
        case kCMScreeniPhone35InchRetina:
            return [ self searchForResourceName:name type:extension inFolder:subDir
                                         suffix:@[ kCMImageNameSuffixRetina3_5 ]];
            break;
        case kCMScreeniPhone4Inch:
            return [ self searchForResourceName:name type:extension inFolder:subDir
                                         suffix:@[ kCMImageNameSuffixRetina4,
                                                   kCMImageNameSuffixRetina3_5 ]];
            break;
        case kCMScreeniPhone47Inch:
            return [ self searchForResourceName:name type:extension inFolder:subDir
                                         suffix:@[ kCMImageNameSuffixRetina4_7,
                                                   kCMImageNameSuffixRetina4,
                                                   kCMImageNameSuffixRetina3_5 ]];
            break;
        case kCMScreeniPhone55Inch:
        case kCMScreeniPhone58Inch:
            return [ self searchForResourceName:name type:extension inFolder:subDir
                                         suffix:@[ kCMImageNameSuffixRetina5_5,
                                                   kCMImageNameSuffixRetina4_7,
                                                   kCMImageNameSuffixRetina4,
                                                   kCMImageNameSuffixRetina3_5 ]];
            break;
        case kCMScreeniPad:
            return [ self searchForResourceName:name type:extension inFolder:subDir
                                         suffix:@[ kCMImageNameSuffixIpad ]];
            break;
        case kCMScreeniPadRetina:
        case kCMScreeniPadPro129:
        case kCMScreeniPadPro105:
            return [ self searchForResourceName:name type:extension inFolder:subDir
                                         suffix:@[ kCMImageNameSuffixIpadRetina,
                                                   kCMImageNameSuffixIpad,
                                                   kCMImageNameSuffixRetina3_5 ]];
            break;
        default:
            break;
    }
    return nil;
}

@end

@implementation UIImage (screen)

+( UIImage* )pngImageFromName:( NSString* )name {
    return [ self imageWithName:name andType:@"png" inFolder:nil ];
}

+( UIImage* )imageWithName:( NSString* )name andType:( NSString* )extension inFolder:( NSString* )subDir {
    NSString *path = [[ NSBundle mainBundle ] pathForCurrentScreenOfResourceName:name
                                                                         andType:extension
                                                                        inFolder:subDir ];
    if ( path ) return [ self imageWithContentsOfFile:path ];
    return nil;
}

@end
