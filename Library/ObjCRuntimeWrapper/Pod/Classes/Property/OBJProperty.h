/**
 @file      OBJProperty.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import Foundation;
@import CoreGraphics;
@import ObjectiveC;
#import "AppUI_Kit_Switch.h"
#import "NSDictionary+PropertyAttributes.h"

@class OBJProperty;

typedef BOOL ( ^OBJPropertyBlock )(  NSString* _Nonnull propertyName, NSMutableDictionary* _Nonnull propertyAttributes, Class _Nonnull ownerClass );

/**
 *	Class contains information about other class properties (not include properties of its super class)
 */
@interface OBJProperty : NSObject

/**
 *  Using block to process each property item of class
 *
 *  @param aClass    Class to get list of properties
 *  @param propertyBlock Block to execute to with each property. Return YES to break for loop.
 *  @return Number of properties
 */
+( NSUInteger )enumeratePropertyOfClass:( nonnull Class )aClass
                              withBlock:( nonnull OBJPropertyBlock )propertyBlock;
+( NSUInteger )enumeratePropertyOfClass:( nonnull Class )aClass superClassDeep:( NSUInteger )levelUp
                              withBlock:( nonnull OBJPropertyBlock )propertyBlock;

/**
 *  Edit property attributes
 *
 *  @param propertyName Property name
 *  @param aClass       Class owns the property
 *  @param editBlock    Block to edit the attributes. Return NO if not changed.
 *
 *  @return NO if failed or class has not specified property
 */
+( BOOL )editPropertyAttributes:( nonnull NSString* )propertyName ofClass:( nonnull Class )aClass
                    withEditBlock:( nonnull OBJPropertyBlock )editBlock;
+( BOOL )editPropertiesAttributes:( nonnull NSArray<NSString*>* )propertyNames ofClass:( nonnull Class )aClass
                    withEditBlock:( nonnull OBJPropertyBlock )editBlock;

@end
