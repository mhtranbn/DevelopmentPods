/**
 @file      NWUtils.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

@class NWHTTPContentType;
/**
 *	@brief	Some common method used in HTTP request/response. Require Security Framework.
 */
@interface NWUtils : NSObject

/**
 *	@brief	URL encode that transforms all the non-ASCII, special & space characters into byte percent code.
	We can use [ NSString stringByAddingPercentEscapesUsingEncoding: ] but it does
	not transform all characters. Its advantage is ablity to encode whole the URL.
	This method encodes the '&' character so we have to encode each URL parameter
	and join into the completed (GET) URL.
 *
 *	@param 	urlString 	String to add percent encode
 *
 *	@return	The Percent URL encoded string
 */
+( nonnull NSString* )urlencode:( nonnull NSString* )urlString;

/**
 *	@brief	Decode the string which is encoded by urlencode: method
 *
 *	@param 	urlString 	String to decode
 *
 *	@return	THe decoded string
 */
+( nonnull NSString* )urldecode:( nonnull NSString* )urlString;

/**
 *	@brief	Join the given array's items to GET URL string with key as array name
 *
 *	@param 	params 	GET URL parameter values
 *	@param 	key 	The key of parameter
 *	@param 	s 	Append result to this string. If nil, create new one.
 *
 *	@return	String with format: array_name[]=array_item_value_1&array_name[]=array_item_value_2...
 */
+( nonnull NSMutableString* )joinParameters:( nonnull NSArray* )params
                                     forKey:( nonnull NSString* )key
                              intoURLString:( nullable NSMutableString* )s;

/**
 *	@brief	Join the given dictionary's items to GET URL string with key as dictionary name
 *
 *	@param 	params 	The dictionary information
 *	@param 	key 	The dictionary name
 *	@param 	s 	String to append result. If nil, create new one.
 *
 *	@return	String with format: dic_name[key1]=value1&dic_name[key2]=value2...
 */
+( nonnull NSMutableString* )joinParametersDictionary:( nonnull NSDictionary* )params
                                               forKey:( nonnull NSString* )key
                                        intoURLString:( nullable NSMutableString* )s;

// The array/dictionary for above 2 joinParameters methods must contain only items
// with type NSString, NSArray & NSDictinary (item array and dictionary will be
// join recursive).
// The above joinParameters methods don't URL encode the value. We have to encode
// before joining.

/**
 *	@brief	Join the given dictionary's items to GET URL string
 *
 *	@param 	params 	The dictionary information
 *	@param 	s 	String to append result. If nil, create new one.
 *
 *	@return	String with format: key1=value1&key2=value2
 */
+( nonnull NSMutableString* )joinParametersFromDictionary:( nonnull NSDictionary* )params
                                            intoURLString:( nullable NSMutableString* )s;

///**
// *	@brief	Append key-value pair into request data with format of Multi-Part Form-Data
// *
// *	@param 	params 	Key-value pair, support only NSString, NSNumber, NSNull (NSNull will be ignored). Value should not URL encoded.
// *	@param 	formData 	Request data. Can be nil. If it's nil, create new one and return.
// *	@param 	boundary 	Separator string
// *
// *	@return	Request data
// */
//+( nonnull NSMutableData* )appendParameters:( nonnull NSDictionary* )params
//                   intoMultiPartRequestData:( nullable NSMutableData* )formData
//                               withBoundary:( nonnull NSString* )boundary
//                                   logStore:( nullable NSMutableString* )logData;
///**
// *	Append data into request data with format of Multi-Part Form-Data for upload file
// *
// *	@param 	fileData    Data
// *	@param 	fieldName   Field name
// *	@param 	fileName    File name
// *	@param 	mime        MIME type
// *	@param 	formData    Request data. Can be nil. If it's nil, create new one and return.
// *	@param 	boundary    Separator string
// *
// *	@return Binary data for Multipart format
// */
//+( nonnull NSMutableData* )appendFileContent:( nonnull NSData* )fileData
//                                forFieldName:( nonnull NSString* )fieldName
//                                withFileName:( nonnull NSString* )fileName
//                                    mimeType:( nonnull NWHTTPContentType* )mime
//                    intoMultiPartRequestData:( nullable NSMutableData* )formData
//                                withBoundary:( nonnull NSString* )boundary
//                                    logStore:( nullable NSMutableString* )logData;
//
///**
// *	Shortcut for above function, with data loaded form filePath, MIME binary (application/octet-stream)
// *
// *	@param 	filePath    File path
// *	@param 	fieldName   Field name
// *	@param 	formData    Request data. Can be nil. If it's nil, create new one and return.
// *	@param 	boundary    Separator string
// *
// *	@return Binary data for Multipart format
// */
//+( nonnull NSMutableData* )appendFile:( nonnull NSString* )filePath
//                         forFieldName:( nonnull NSString* )fieldName
//             intoMultiPartRequestData:( nullable NSMutableData* )formData
//                         withBoundary:( nonnull NSString* )boundary
//                             logStore:( nullable NSMutableString* )logData;
///**
// *	Append ending signature to request data
// *
// *	@param 	formData    Request data. Can not be nil.
// *	@param 	boundary    Separator string
// *
// *	@return Binary data for Multipart format
// */
//+( nonnull NSMutableData* )endMultiPartRequestData:( nullable NSMutableData* )formData
//                                      withBoundary:( nonnull NSString* )boundary
//                                          logStore:( nullable NSMutableString* )logData;

/**
 *  Fix some error of URL string so we can create NSURL
 *
 *  @param url URL string
 *
 *  @return URL string: add http if needed; urlencode parts of URL (except domain)
 */
+( nonnull NSString* )completeURL:( nonnull NSString* )url;

/**
 *  Convert charset name to NSStringEncoding
 *
 *  @param charsetName Charset name
 *
 *  @return 0 if failed
 */
+( NSStringEncoding )stringEncodingFromCharsetName:( nonnull NSString* )charsetName;

/**
 *  Convert NSStringEncoding to charset name
 *
 *  @param encoding NSStringEncoding value
 *
 *  @return nil if failed
 */
+( nonnull NSString* )charsetNameFromStringEncoding:( NSStringEncoding )encoding;

/**
 Parsing parameters in an url-encoded query into dictionary

 @param query Query to parse (part after '?' in URL)
 @return List or request pararmeters
 */
+( nullable NSMutableDictionary* )parametersListFromUrlEncodedQuery:( nonnull NSString* )query;

@end

@interface NSURL (params)

/**
 *  Parsing parameters in URL to dictionary
 *
 *  @return nil if failed
 */
-( nullable NSMutableDictionary* )parametersList;

@end
