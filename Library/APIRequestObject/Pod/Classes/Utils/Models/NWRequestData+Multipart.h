/**
 @file      NWRequestData+Multipart.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestData.h"

@interface NWRequestData (Multipart)

/**
 Make request data with multipart format

 @param object Dictionary<String, id>, Array<NWRequestData>, or class object.
 Dictionary item/class property should have type of raw number (NSInterger, CGFloat, ...),
 NSString, NSNumber, NSURL, UIImage, NSData, NWRequestData.
 Class object can implement `NWRequestTransformParameter` to transform value.
 @return New request data
 */
+( nonnull instancetype )multipartDataWithObject:( nonnull id )object;

@end
