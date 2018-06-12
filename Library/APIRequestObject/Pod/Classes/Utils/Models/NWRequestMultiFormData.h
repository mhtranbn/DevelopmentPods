/**
 @file      NWRequestMultiFormData.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import "NWRequestMultiFormDataPart.h"

@interface NWRequestMultiFormData : NSObject

@property ( nonatomic, copy, nonnull ) NSString *boundary;
@property ( nonatomic, copy, nonnull ) NSArray<NWRequestMultiFormDataPart*> *parts;

/// Init with programmable objects to make encoded data.
-( nonnull instancetype )initWithBoundary:( nonnull NSString* )boundary
                         andFormDataParts:( nonnull NSArray<NWRequestMultiFormDataPart*>* )parts;

/// Init with encoded data to make decoded objects.
-( nullable instancetype )initWithEncodedData:( nonnull NSData* )data;

/// Make encoded data
-( nonnull NSData* )toData;

/// Make encoded data writting to file (this function does not call `synchronize` or `closeFile` to `writter`)
-( void )writeData:( nonnull NSFileHandle* )writter;

/// Write encoded data to given file (overwrite if file exists).
-( BOOL )saveToFile:( nonnull NSString* )path;

/// String descripes data to print out log
-( nonnull NSString* )logDescription;

@end
