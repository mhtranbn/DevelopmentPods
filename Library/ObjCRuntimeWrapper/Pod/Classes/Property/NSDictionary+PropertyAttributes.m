/**
 @file      NSDictionary+PropertyAttributes.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSDictionary+PropertyAttributes.h"

@implementation NSDictionary (OBJPropertyAttribute)

-( NSString* )variableName {
    return [ self objectForKey:@"V" ];
}

-( OBJDataType )type {
    NSString *s = [ self typeDescription ];
    return [ OBJCommon dataTypeFromStringDescription:s ];
}

-( Class )typeClass {
    NSString *type = [ self typeDescription ];
    return [ OBJCommon classFromDataTypeDescription:type ];
}

-( NSString* )typeDescription {
    return [ self objectForKey:@"T" ];
}

-( BOOL )isReadOnly {
    return [ self.allKeys containsObject:@"R" ];
}

-( BOOL )isCopy {
    return [ self.allKeys containsObject:@"C" ];
}

-( BOOL )isRetain {
    return [ self.allKeys containsObject:@"&" ];
}

-( OBJPropertyAttributeMemoryType )valType {
    if ([ self.allKeys containsObject:@"C" ])
        return kObjPropAttrMemCopy;
    else if ([ self.allKeys containsObject:@"&" ])
        return kObjPropAttrMemRetainOrStrong;
    else if ([ self.allKeys containsObject:@"W" ])
        return kOBjPropAttrMemWeak;
    else
        return kObjPropAttrMemAssign;
}

-( BOOL )isNonAtomic {
    return [ self.allKeys containsObject:@"N" ];
}

-( BOOL )isDynamic {
    return [ self.allKeys containsObject:@"D" ];
}

-( BOOL )isWeakRef {
    return [ self.allKeys containsObject:@"W" ];
}

-( BOOL )isEligible {
    return [ self.allKeys containsObject:@"P" ];
}

-( NSString* )getterName {
    return [ self objectForKey:@"G" ];
}

-( NSString* )setterName {
    return [ self objectForKey:@"S" ];
}

-( NSString* )encoding {
    return [ self objectForKey:@"t" ];
}

-( id )defaultValueForCommonDataType {
    switch ([ self type ]) {
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
            return @0;
        case kObjDataTypeCppBool:
            return @NO;
        default:
            return nil;
            break;
    }
}

@end
