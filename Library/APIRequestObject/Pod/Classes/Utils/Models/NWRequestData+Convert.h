/**
 @file      NWRequestData+Convert.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestData.h"
#import "NWHTTPContentType.h"

@interface NWRequestData (Convert)

/**
 Make data with utf-8 string

 @param text Text to convert
 @return New data with mimetype "text/plain"
 */
+( nullable instancetype )dataWithString:( nonnull NSString* )text;
/**
 Create Request Data with given file and mime type (data is stored in temp file)

 @param filePath Path to file
 @param type Mime type
 @return New request data
 */
+( nullable instancetype )dataFromFile:( nonnull NSString* )filePath
                              mimeType:( nonnull NWHTTPContentType* )type;
/**
 Create Request Data with given file, mime as 'video/quicktime` (data store in temp file)

 @param filePath Path to move file
 @return New request data
 */
+( nullable instancetype )dataWithMovieFileFromIOS:( nonnull NSString* )filePath;
/**
 Create Request data from JPEG data with given image & compress rate, mime as 'image/jpeg' (data store in buffer)

 @param image Image
 @param rate Compress rate to make JPEG data
 @return New request data
 */
+( nonnull instancetype )jpegDataWithImage:( nonnull UIImage* )image
                           compressionRate:( CGFloat )rate;
/**
 Create JPEG Request data using compress rate 1.0

 @param image Image
 @return New request data
 */
+( nonnull instancetype )jpegDataWithImage:( nonnull UIImage* )image;
/**
 Create Request data from JPEG data with given image, mime as 'image/png' (data store in buffer)

 @param image Image
 @return New request data
 */
+( nonnull instancetype )pngDataWithImage:( nonnull UIImage* )image;

@end
