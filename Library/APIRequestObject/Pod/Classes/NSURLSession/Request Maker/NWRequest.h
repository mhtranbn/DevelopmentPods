/**
 @file      NWRequest.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import Foundation;
#import "APIRequest.h"

/** How to transform request parameter */
typedef NS_ENUM( NSUInteger, NWRequestParameterTransformType ) {
    /** Don't transform */
    kRawValueOrNotTransform = 0,
    /** Transfrom UIImage, NSData, NSString to Base 64 string */
    kBase64String,
    /** Transfrom UIImage, NSData, NSString to Base 64 string with mimetype magic string */
    kBase64StringWithMime,
    /** Transfrom object or array of objects to JSON String */
    kJSONString,
    /** Manual transform, must returns a dictionary to transform also the key name */
    kCustomWithKey,
    /** Manual transfrom */
    kCustom
};

/// Protocol to request object to format the parameters
@protocol NWRequestTransformParameter <NSObject>
@optional

/**
 *  The encoder asks the request object if the property of the request object should be changed before use in request
 *
 *  @param propName Property name of request object
 *  @param encoder  The encoder calls the func
 *
 *  @return How to transform
 */
-( NWRequestParameterTransformType )shouldTransfromValueOfRequestParameter:( nonnull NSString* )propName
                                                                   encoder:( nonnull id )encoder;
/**
 *  The changed value to use in request
 *
 *  @param propName Property name of request object
 *  @param encoder  The encoder calls the func
 *
 *  @return Value
 */
-( nullable id )transformedValueForRequestParameter:( nonnull NSString* )propName
                                            encoder:( nonnull id )encoder;

@end

@interface NWRequestMakerBase : NSObject

/// Cache policy to make NSURLRequest, ignored if timeout <= 0
@property ( nonatomic, assign ) NSURLRequestCachePolicy cachePolicy;
/// Timeout to make NSURLRequest, ignored if timeout <= 0
@property ( nonatomic, assign ) NSTimeInterval timeout;

/// Reserved for subclass
-( nonnull NSMutableURLRequest* )makeUrlRequestWithUrl:( nullable NSString* )path;

/**
 *  Check that type of object is supported to use as request parameter value
 *
 *  @param object Object to check
 *
 *  @return YES if object is NSNumber, NSString or NSURL
 */
+( BOOL )validateValueObject:( nonnull id )object;
/**
 Get transformed value for property of object to use in request
 
 @param property Property name
 @param object Object to use as request parameters
 @param type Transform type
 @return Value for given property
 */
+( nullable id )transformRequestParameter:( nonnull NSString* )property
                                 ofObject:( nonnull NSObject<NWRequestTransformParameter>* )object
                                 withType:( NWRequestParameterTransformType )type
                                  encoder:( nonnull id )encoder;
@end
