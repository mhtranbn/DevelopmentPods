/**
 @file      OBJProperty+CustomAttributes.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty.h"

// Define the key of Dictionary to get value to set to current property
extern NSString *const _Nonnull kOBJPropertyAliasName;
// Use that key to define class to alloc object in method [fillValuesForObject:fromDictionary:]
// If property is an NSArray of objects (input is an array of NSDictionary)
extern NSString *const _Nonnull kOBJPropertyArrayItemClass;
extern NSString *const _Nonnull kOBJPropertyArrayItemRootClass;
// If property is an NSDictionary of objects (input is an NSDictionary of NSDictionary)
extern NSString *const _Nonnull kOBJPropertyDictionaryItemClass;
extern NSString *const _Nonnull kOBJPropertyDictionaryItemRootClass;
// Use in Encode object to NSDictionary. Property has this attributes will not be encode.
extern NSString *const _Nonnull kOBJPropertyEncodeExlude;

typedef NSDictionary<NSString*, NSDictionary<NSString*, NSString*>*> OBJPropetyCustomAttributesMap;

#pragma mark -

@interface NSDictionary (OBJPropertyCustomAttributes)

-( nullable NSString* )propertyAliasName;
-( nullable Class )propertyArrayItemClass;
-( nullable Class )propertyArrayItemRootClass;
-( nullable Class )propertyDictionaryItemClass;
-( nullable Class )propertyDictionaryItemRootClass;
-( BOOL )isPropertyExcludeInDictionary;

@end

@interface NSMutableDictionary (OBJPropertyCustomAttributes)

-( void )setPropertyAliasName:( nullable NSString* )alias;
-( void )setPropertyArrayItemClass:( nullable Class )className;
-( void )setPropertyArrayItemRootClass:( nullable Class )className;
-( void )setPropertyDictionaryItemClass:( nullable Class )className;
-( void )setPropertyDictionaryItemRootClass:( nullable Class )className;
-( void )setPropertyExcludeInDictionary:( BOOL )excluded;

@end

@protocol OBJPropertyCustomAttributesProtocol <NSObject>

@optional
/**
 @return List of properties to set custom attrbutes
 */
+( nullable OBJPropetyCustomAttributesMap* )registCustomAttributesOfClassProperties;

@end

@interface OBJProperty (CustomAttributes)

/**
 Plase this function in AppDelegate `didLaunchWithOptions:`.
 
 Every class which has custom attibutes property implement protocol `OBJPropertyCustomAttributesProtocol`
 (sublcass can override super function without call super function).
 
 Apply only for classes from main module
 */
+( void )registClassesCustomAttributesProperties;
/**
 Regist custom attributes for all class in the module which the given class belongs to
 
 @param cls Any class of target module
 @return YES if module is found
 */
+( BOOL )registClassesCustomAttributesPropertiesOfModule:( nonnull Class )cls;


@end

/** Helping function to make OBJPropetyCustomAttributesMap */
@interface NSMutableDictionary (CustomAttributesMap)

-( nonnull NSMutableDictionary* )getAttributesMapForPropertyName:( nonnull NSString* )propName;
/** Add attribute **alias** to map */
-( void )setAliasAttribute:( nullable NSString* )alias forProperty:( nonnull NSString* )propName;
/** Add attribute **array item class** to map */
-( void )setArrayItemClassAttribute:( nullable Class )className forProperty:( nonnull NSString* )propName;
/** Add attribute **item class** & **item class ancestor class** to map */
-( void )setArrayItemClassAttribute:( nullable Class )className ancestorClass:( nullable Class )superName
                   forProperty:( nullable NSString* )propName;
/** Add attribute **dictionary item class** to map */
-( void )setDictionaryItemClassAttribute:( nullable Class )className forProperty:( nonnull NSString* )propName;
/** Add attribute **dictionary class** & **item class ancestor class** to map */
-( void )setDictionaryItemClassAttribute:( nullable Class )className ancestorClass:( nullable Class )superName
                             forProperty:( nullable NSString* )propName;
/** Add attribute **exclude from dictionary encoding** to map */
-( void )setExcludedEncodingToDictionaryWithProperty:( nullable NSString* )propName;

@end
