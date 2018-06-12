/**
 @file      APIJSONStatusResponse.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIJSONResponse.h"

/**
 *  Response data structure is not valid
 */
extern NSInteger const kAPIResponseErrorJSONParserInvalidData;

/**
 *  Base class to check & parse response data with format
 *  { code = 1, message = "message", data = { data }}
 *  Request success if code == 1
 */
@interface APIJSONStatusResponse : APIJSONResponse

// FUNC TO SUBCLASS

/**
 *  @return Check api code is ok. Default code == 1.
 */
-( BOOL )isApiCodeSuccess:( nonnull NSNumber* )code;
/**
 *  Extract api code from data
 *
 *  @param dataDic Response data
 *
 *  @return Default is value from key "code". Nil if response data does not contain key "code".
 */
-( nullable NSNumber* )apiCodeFromData:( nonnull NSDictionary* )dataDic;
/**
 *  Extract message from response data
 *
 *  @param dataDic Response data
 *
 *  @return Default is value of key "message".
 */
-( nullable NSString* )apiMessageFromData:( nonnull NSDictionary* )dataDic;
/**
 *  Extract data to fill into object
 *
 *  @param dataDic Response data
 *
 *  @return Default is value of key "data"
 */
-( nullable id )dataToFillToObject:( nonnull NSDictionary* )dataDic;

@end
