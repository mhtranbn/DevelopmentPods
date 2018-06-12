/**
 @file      OBJCommon.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef NS_ENUM( unsigned char, OBJDataType ) {
    kObjDataTypeNone                = 0,
    kObjDataTypeChar                = _C_CHR,
    kObjDataTypeUnsignedChar        = _C_UCHR,
    kObjDataTypeInt                 = _C_INT,
    kObjDataTypeUnsignedInt         = _C_UINT,
    kObjDataTypeShort               = _C_SHT,
    kObjDataTypeUnsignedShort       = _C_USHT,
    kObjDataTypeLong                = _C_LNG,
    kObjDataTypeLongLong            = _C_LNG_LNG,
    kObjDataTypeUnsignedLong        = _C_ULNG,
    kObjDataTypeUnsignedLongLong    = _C_ULNG_LNG,
    kObjDataTypeFloat               = _C_FLT,
    kObjDataTypeDouble              = _C_DBL,
    kObjDataTypeCppBool             = _C_BOOL,
    kObjDataTypeVoid                = _C_VOID,
    kObjDataTypeCharString          = _C_CHARPTR,
    kObjDataTypeObject              = _C_ID,
    kObjDataTypeClass               = _C_CLASS,
    kObjDataTypeSelector            = _C_SEL,
    kObjDataTypePointer             = _C_PTR,
    kObjDataTypeUnknown             = _C_UNDEF,
    kObjDataTypeArray               = _C_ARY_B,
    kObjDataTypeStructure           = _C_STRUCT_B,
    kObjDataTypeUnion               = _C_UNION_B,
    kObjDataTypeBits                = _C_BFLD
};

@interface OBJCommon : NSObject

+( OBJDataType )dataTypeFromStringDescription:( nullable NSString* )typeDesc;
+( nullable Class )classFromDataTypeDescription:( nullable NSString* )typeDesc;

/**
 *  @param type Type id
 *
 *  @return String description for property data type as basic type (int, NSInteger, float ...)
 */
+( nullable NSString* )stringDescriptionFromDataType:( OBJDataType )type;
/**
 *  @param aClass Class as type
 *
 *  @return String description for property data type as Class
 */
+( nonnull NSString* )dataTypeStringDescriptionUsingClass:( nonnull Class )aClass;

// Struct description: {component description}. Eg: CGRect {{f,f}{f,f}}

/**
 *  Count how many superclass from aClass to ancestorClass.
 *
 *  @param aClass        Current
 *  @param ancestorClass Ancestor
 *
 *  @return -1 if Current is not subclass of Ancestor. 0 if same class.
 */
+( NSInteger )countOfLevelsFromClass:( nonnull Class )aClass toClass:( nullable Class )ancestorClass;

@end
