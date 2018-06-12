/**
 @file      OBJProperty+Debug.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty.h"

@interface OBJProperty (Debug)

/**
 *  @param fullTypeDesc Original string about proprety data type
 *
 *  @return Human friendly data type name
 */
+( nonnull NSString* )nameOfDataType:( nullable NSString* )fullTypeDesc;

/**
 *  Describe about the object properties values
 *
 *  @param object          object
 *  @param levelUp       Root class to browse properties
 *  @param wrongProperties A mutable array to store property name whose value has data type not same with property data type.
 *
 *  @return String of description
 */
+( nullable NSMutableString* )propertiesDescriptionOfObject:( nullable id )object superClassDeep:( NSUInteger )levelUp
                                  andWrongPropertiesStorage:( nullable NSMutableArray* )wrongProperties;

@end
