/**
 @file      OBJProperty+Obj2Dic.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+CustomAttributes.h"

@protocol OBJPropertyObj2DicTransform <NSObject>
@optional

-( BOOL )shouldTransformValueOfProperty:( nonnull NSString* )propertyName;
-( nullable id )transformedValueOfProperty:( nonnull NSString* )propertyName;

@end

@interface OBJProperty (Obj2Dic)

/**
 *  Make dictionary from properties of object.
 *  Property of type NSString, NSNumber, NSData, NSValue, NSDate will be stored as origin.
 *  Property of type basic type will be converted to NSNumber, CGRect (CGPoint...) will be converted to NSValue, CGColor, NSURL will be converted to NSString.
 *  If property value is an object, the host object should implement OBJPropertyObj2DicTransform to convert object to dictionary; or this value will be ignored.
 *  If property value is an array or dictionary, it will be stored as origin (host object can implement OBJPropertyObj2DicTransform to convert each object to dictionary)
 *
 *  @param object       Object to make dictionary
 *  @param rootClass    Superclass to get properties
 *
 *  @return Dictionary from object
*/
+( nonnull NSMutableDictionary* )dictionaryFromObject:( nonnull id )object rootClass:( nullable Class )rootClass;
+( nonnull NSMutableDictionary* )dictionaryFromObject:( nonnull id )object;
/**
 *  Convert array of objects to array of dictionaries.
 *  Item object of type NString, NSNumber, NSData, NSDate, NSValue, NSArray, NSDictionary will be stored as origin.
 *  Property of type basic type will be converted to NSNumber, CGRect, CGColor, NSURL will be converted to NSString.
 *  Item object of other types will be converted to dictionary.
 *
 *  @param arrayOfObjects   Array of objects
 *  @param rootClass        Superclass to get properties
 *
 *  @return Array of dictionary.
 */
+( nonnull NSMutableArray* )dictionariesFromArray:( nonnull NSArray* )arrayOfObjects rootClass:( nullable Class )rootClass;
/**
 *  Convert dictionary of objects to dictionary of dictionaries.
 *  Item object of type NString, NSNumber, NSData, NSDate, NSValue, NSArray, NSDictionary will be stored as origin.
 *  Property of type basic type will be converted to NSNumber, CGRect, CGColor, NSURL will be converted to NSString.
 *  Item object of other types will be converted to dictinary without superclass properties.
 *
 *  @param dicOfObjects Dictionary of objects
 *  @param rootClass    Superclass to get properties
 *
 *  @return Dictionary of dictionaries
 */
+( nonnull NSMutableDictionary* )dictionaryFromDictionary:( nonnull NSDictionary* )dicOfObjects rootClass:( nullable Class )rootClass;

@end
