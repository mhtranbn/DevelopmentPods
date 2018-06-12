/**
 @file      OBJCommon.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJCommon.h"

@implementation OBJCommon

+( OBJDataType )dataTypeFromStringDescription:( NSString* )typeDesc {
    if ( typeDesc != nil && typeDesc.length > 0 )
        return [ typeDesc characterAtIndex:0 ];
    return kObjDataTypeNone;
}

+( Class )classFromDataTypeDescription:( NSString* )typeDesc {
    if ( typeDesc.length > 3 && [ typeDesc characterAtIndex:0 ] == kObjDataTypeObject )
        return NSClassFromString([ typeDesc substringWithRange:NSMakeRange( 2, typeDesc.length - 3 )]);
    return nil;
}

+( NSString* )stringDescriptionFromDataType:( OBJDataType )type {
    switch ( type ) {
        case kObjDataTypeChar:
        case kObjDataTypeUnsignedChar:
        case kObjDataTypeInt:
        case kObjDataTypeUnsignedInt:
        case kObjDataTypeShort:
        case kObjDataTypeUnsignedShort:
        case kObjDataTypeLong:
        case kObjDataTypeLongLong:
        case kObjDataTypeUnsignedLong:
        case kObjDataTypeUnsignedLongLong:
        case kObjDataTypeFloat:
        case kObjDataTypeDouble:
        case kObjDataTypeCppBool:
        case kObjDataTypeVoid:
        case kObjDataTypeCharString:
        case kObjDataTypeObject:
        case kObjDataTypeClass:
        case kObjDataTypeSelector:
        case kObjDataTypePointer:
        case kObjDataTypeUnknown:
        case kObjDataTypeBits:
            return [[ NSString alloc ] initWithBytes:&type length:1 encoding:NSASCIIStringEncoding ];
            break;
        default:
            return nil;
            break;
    }
}

+( NSString* )dataTypeStringDescriptionUsingClass:( Class )aClass {
    return [ NSString stringWithFormat:@"@\"%@\"", NSStringFromClass( aClass )];
}

+( NSInteger )countOfLevelsFromClass:( Class )aClass toClass:( Class )ancestorClass {
    if ( aClass == ancestorClass ) return 0;
    if ( ancestorClass == nil || ![ aClass isSubclassOfClass:ancestorClass ]) return -1;
    NSInteger lvCnt = 0;
    Class cls = aClass;
    while ( cls != ancestorClass ) {
        cls = [ cls superclass ];
        lvCnt += 1;
    }
    return lvCnt;
}

@end
