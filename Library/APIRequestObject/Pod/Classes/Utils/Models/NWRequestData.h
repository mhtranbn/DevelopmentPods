/**
 @file      NWRequestData.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NWHTTPContentType.h"

@interface NWRequestData : NSObject

/// MIME type identifier for Data
@property ( nonatomic, strong, nonnull ) NWHTTPContentType *mimeType;
/// Data content
@property ( nonatomic, readonly, nonnull ) NSData *contentData;
/// Call this to switch NWRequestData to file mode (store data in temp file instead in buffer).
@property ( nonatomic, readonly, nonnull ) NSString *tempFile;
/// Number of data bytes
@property ( nonatomic, readonly ) NSUInteger size;
/// String for key fileName in MultiPart request
@property ( nonatomic, copy, nullable ) NSString *fileName;
/// Key for Multipart request
@property ( nonatomic, copy, nullable ) NSString *keyName;

/**
 Create new Request Data object

 @param data Content Data
 @param type Mimetype description object
 @param isFileStorage Store data to file instead in buffer (memory)
 @return New object
 */
-( nonnull instancetype )initWithData:( nonnull NSData* )data
                             mimeType:( nonnull NWHTTPContentType* )type
                      storeInTempFile:( BOOL )isFileStorage;

/**
 Create new Request Data object with mimetype 'applicaton/octet-stream' & store data in buffer

 @param data Content data
 @return New object
 */
-( nonnull instancetype )initWithData:( nonnull NSData* )data;


@end
