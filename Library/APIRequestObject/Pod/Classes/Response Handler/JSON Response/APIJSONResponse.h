/**
 @file      APIJSONResponse.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APISimpleResponse.h"

/**
 *  Domain of APIJSONResponse error
 */
extern NSString *const _Nonnull kAPIResponseErrorJSONParserDomain;
/**
 *  Response data is nil
 */
extern NSInteger const kAPIResponseErrorJSONParserEmptyRawData;
/**
 *  Response data is not JSON
 */
extern NSInteger const kAPIResponseErrorJSONParserNotJSON;
/**
 *  JSON parsed successfully but can not make object (eg. parsed data is not NSDictionary or NSArray)
 */
extern NSInteger const kAPIResponseErrorJSONParserFailToCreateObject;

/**
 *  Base class to parse JSON data from API response to object.
 
 *  Subclass should override 'handleParsedObject:' to store the response object (parsed & filled values).
 *  Subclass also can override other funcs to add features.
 
 *  Fill data from Dic using ObjCRuntimerWrapper.
 
 *  This class works with steps:
 - APIRequest object calls func 'parseResponseData:responseInfo:error:' when it received all response data.
 - If response status is OK, exec func 'processSuccessResponseData:' try to check & parsed response raw data:
    - Data is JSON & parsed into raw objects (NSDictionary, NSArray...), exec func 'processParsedSuccessData:'
      to fill values form parsed data into successObject (if data is Dictionary & defautlSuccessObject != nil,
      fill data into defaultSuccessObject). Subclass can override 'processParsedSuccessData:' to
      validate data. Return NO makes reponse status to fail as can not parsed.
    - Data is nil or can not parsed: exec func 'processFailedResponseData'. Request is failed.
 - If Response status is not OK, request is failed, also exec func 'processFailedResponseData'.
    - Try parsed response data as JSON. If success parsed, run 'processParsedFailData:' to fill into failObject
    - If response data is not JSON, assign dirent faillObject
 */
@interface APIJSONResponse : NSObject <APIResponseHandler>

/**
 Class to create new object to parse raw data into in case request success. If null, not parse data to object.
 */
@property ( nonatomic, assign, nullable ) Class successClass;
/**
 *  Object to fill success data. You must maintain it (weak).
 */
@property ( nonatomic, weak, nullable ) id defaultSuccessObject;

/**
 Class to create new object to parse raw data into in case request failure.
 */
@property ( nonatomic, assign, nullable ) Class failClass;

/**
 *  Process JSON parsed data in case failed (eg HTTP status != OK). Default is fill value into fail object.
 *
 *  @param parsedData JSON parsed data
 */
-( nonnull id )processParsedFailData:( nonnull id )parsedData;
/**
 *  Handle data in case of failure (response status not OK, can not parse JSON or response data nil)
 *
 *  @param data Response data
 */
-( nullable id )processFailResponseData:( nullable NSData* )data;
/**
 *  Process JSON parsed data. Default is fill value into objects.
 *
 *  @param parsedData JSON parsed data (Array, Dictionary ...)
 *
 *  @return Default always YES. Subclass can override this func to validate data (eg. check code of api response)
 */
-( nullable id )processParsedSuccessData:( nonnull id )parsedData error:( NSError * _Nullable * _Nonnull )error;
/**
 *  Process response data in case of response status is ok.
 *
 *  @param data Raw data from response. Can be nil.
 *
 *  @return YES means request success
 */
-( nullable id )processSuccessResponseData:( nullable NSData* )data error:( NSError * _Nullable * _Nonnull )error;;

@end
