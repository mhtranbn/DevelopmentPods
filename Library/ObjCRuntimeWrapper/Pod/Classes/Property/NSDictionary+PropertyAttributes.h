/**
 @file      NSDictionary+PropertyAttributes.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty.h"
#import "OBJCommon.h"

typedef NS_ENUM( NSUInteger, OBJPropertyAttributeMemoryType ) {
    kObjPropAttrMemAssign,
    kObjPropAttrMemCopy,
    kObjPropAttrMemRetainOrStrong,
    kOBjPropAttrMemWeak
};

@interface NSDictionary (OBJPropertyAttribute)

/** Internal variable name which stores value of class property */
-( nullable NSString* )variableName;
/**  Full type description string */
-( nullable NSString* )typeDescription;
/**	Data type of class property */
-( OBJDataType )type;
/**
 If property type is object, try get class from typeDescription

 @return May be nil
 */
-( nullable Class )typeClass;
/** Class property is read-only */
-( BOOL )isReadOnly;
-( BOOL )isCopy;
-( BOOL )isRetain;
/** Class property value assigning type */
-( OBJPropertyAttributeMemoryType )valType;
/** Class property is non-atomic */
-( BOOL )isNonAtomic;
/** Class property is dynamic */
-( BOOL )isDynamic;
/** Class property is weak reference */
-( BOOL )isWeakRef;
/** Class property is eligible */
-( BOOL )isEligible;
/** Name of method to get property value */
-( nullable NSString* )getterName;
/** Name of method to set property value */
-( nullable NSString* )setterName;
/** Encoding */
-( nullable NSString* )encoding;

/** Swift4 does not allow to set `nil` with `setValue:forKey:` for native data type field  */
-( nullable id )defaultValueForCommonDataType;

@end
