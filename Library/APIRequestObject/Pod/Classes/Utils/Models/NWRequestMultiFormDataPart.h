/**
 @file      NWRequestMultiFormDataPart.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import "NWRequestHeaderAttribute.h"

@interface NWRequestMultiFormDataPart : NSObject

/// Attribute of form-data part, must begin with "Content-Disposition"
@property ( nonatomic, copy, nonnull ) NSArray<NWRequestHeaderAttribute*> *attributes;
@property ( nonatomic, copy, nonnull ) NSData *data;

/// Init with programmable objects to make encoded data
-( nonnull instancetype )initWithAttributes:( nonnull NSArray<NWRequestHeaderAttribute*>* )attributes
                                    andData:( nonnull NSData* )data;

/// Init with encodedData to make decoded objects.
-( nullable instancetype )initWithEncodedData:( nonnull NSData* )data;

/// Make encoded data (without ending CRLF) 
-( nonnull NSData*  )toData;

/// String descripes data to print out log
-( nonnull NSString* )logDescription;

@end
