/**
 @file      NWRequestData+Convert.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestData+Convert.h"
#import "NWInternetMediaMimeType.h"
@import RSUtils;

@interface NWRequestData ()

@property ( nonatomic, strong, nullable ) NSString *logDesc;

@end

@implementation NWRequestData (Convert)

+( instancetype )dataWithString:( NSString* )text {
    NWHTTPContentType *type = [[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_TEXT_PLAIN ];
    type.parameters = @{ MIME_PARAMETER_CHARSET: @"utf-8" };
    return [[ NWRequestData alloc ] initWithData:[ text dataUsingEncoding:NSUTF8StringEncoding ]
                                        mimeType:type storeInTempFile:false ];
}

+( instancetype )dataFromFile:( NSString* )filePath mimeType:( NWHTTPContentType* )type {
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    NWRequestData *rqData = [[ NWRequestData alloc ] initWithData:[ NSData new ] mimeType:type storeInTempFile:YES ];
    if ([ fileMan copyItemAtPath:filePath overwritePath:rqData.tempFile error:nil ]) {
        rqData.logDesc = [ NSString stringWithFormat:@"Original path: %@", filePath ];
        rqData.fileName = [ filePath lastPathComponent ];
        return rqData;
    }
    return nil;
}

+( instancetype )dataWithMovieFileFromIOS:( NSString* )filePath {
    NWHTTPContentType *contentType = [[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_VIDEO_QUICKTIME ];
    NWRequestData *result = [ self dataFromFile:filePath mimeType:contentType ];
    result.fileName = [ NSString stringWithFormat:@"%p.mp4", result ];
    return result;
}

+( instancetype )jpegDataWithImage:( UIImage* )image compressionRate:( CGFloat )rate {
    NWHTTPContentType *contentType = [[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_IMAGE_JPEG ];
    NWRequestData *rqData = [[ self alloc ] initWithData:UIImageJPEGRepresentation( image, rate )
                                                mimeType:contentType storeInTempFile:NO ];
    rqData.logDesc = [ NSString stringWithFormat:@"CompressionRate=%@ WxH=%@x%@",
                      @( rate ), @( image.size.width ), @( image.size.height )];
    rqData.fileName = [ NSString stringWithFormat:@"%p.jpg", rqData ];
    return rqData;
}

+( instancetype )jpegDataWithImage:( UIImage* )image {
    return [ self jpegDataWithImage:image compressionRate:1.0f ];
}

+( instancetype )pngDataWithImage:( UIImage* )image {
    NWHTTPContentType *contentType = [[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_IMAGE_PNG ];
    NWRequestData *rqData = [[ self alloc ] initWithData:UIImagePNGRepresentation( image )
                                                mimeType:contentType storeInTempFile:NO ];
    rqData.logDesc = [ NSString stringWithFormat:@"WxH=%@x%@",
                      @( image.size.width ), @( image.size.height )];
    rqData.fileName = [ NSString stringWithFormat:@"%p.png", rqData ];
    return rqData;
}

@end
