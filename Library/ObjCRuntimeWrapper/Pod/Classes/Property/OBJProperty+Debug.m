/**
 @file      OBJProperty+Debug.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+Debug.h"

@implementation OBJProperty (Debug)

+( NSString* )nameOfDataType:( NSString* )fullTypeDesc {
    if ( fullTypeDesc == nil || fullTypeDesc.length == 0 ) return @"";
    OBJDataType datType = [ fullTypeDesc characterAtIndex:0 ];
    switch ( datType ) {
        case kObjDataTypeArray:
            return @"__[]";
            break;
        case kObjDataTypeBits:
            return @"Bits";
            break;
        case kObjDataTypeChar:
            return @"char";
            break;
        case kObjDataTypeCharString:
            return @"char*";
            break;
        case kObjDataTypeClass:
            return @"Class";
            break;
        case kObjDataTypeCppBool:
            return @"bool";
            break;
        case kObjDataTypeDouble:
            return @"double";
            break;
        case kObjDataTypeFloat:
            return @"float";
            break;
        case kObjDataTypeInt:
            return @"int";
            break;
        case kObjDataTypeLong:
            return @"long";
            break;
        case kObjDataTypeLongLong:
            return @"long long";
            break;
        case kObjDataTypeNone:
            return @"<none>";
            break;
        case kObjDataTypeObject:
            if ( fullTypeDesc.length > 3 )
                return [[ fullTypeDesc substringWithRange:NSMakeRange( 2, fullTypeDesc.length - 3 )] stringByAppendingString:@"*" ];
            else if ( fullTypeDesc.length == 1 )
                return @"id";
            else
                return fullTypeDesc;
            break;
        case kObjDataTypePointer:
            return @"void *";
            break;
        case kObjDataTypeSelector:
            return @"SEL";
            break;
        case kObjDataTypeShort:
            return @"short";
            break;
        case kObjDataTypeStructure:
            if ([ fullTypeDesc rangeOfString:@"{"_OBJRect_"=" ].location == 0 ) {
                return @_OBJRect_;
            } else if ([ fullTypeDesc rangeOfString:@"{"_OBJPoint_"=" ].location == 0 ) {
                return @_OBJPoint_;
            } else if ([ fullTypeDesc rangeOfString:@"{"_OBJSize_"=" ].location == 0 ) {
                return @_OBJSize_;
            } else if ([ fullTypeDesc rangeOfString:@"{_NSRange=" ].location == 0 ) {
                return @"NSRange";
            }
            return fullTypeDesc;
            break;
        case kObjDataTypeUnion:
            return @"union";
            break;
        case kObjDataTypeUnknown:
            return @"";
            break;
        case kObjDataTypeUnsignedChar:
            return @"unsigned char";
            break;
        case kObjDataTypeUnsignedInt:
            return @"unsigned int";
            break;
        case kObjDataTypeUnsignedLong:
            return @"unsigned long";
            break;
        case kObjDataTypeUnsignedLongLong:
            return @"unsigned long long";
            break;
        case kObjDataTypeUnsignedShort:
            return @"unsigned short";
            break;
        case kObjDataTypeVoid:
            return @"void";
            break;
        default:
            break;
    }
    return @"";
}

+( NSMutableString* )propertiesDescriptionOfObject:( id )object superClassDeep:( NSUInteger )levelUp
                         andWrongPropertiesStorage:( NSMutableArray* )wrongProperties {
    if ( object == nil ) return nil;
    NSMutableString *string = [ NSMutableString string ];
    [ self enumeratePropertyOfClass:[ object class ] superClassDeep:levelUp withBlock:^BOOL(NSString *propertyName, NSMutableDictionary *propertyAttributes, __unsafe_unretained Class ownerClass) {
        [ string appendFormat:@"%@ (", propertyName ];
        id value = [ object valueForKey:propertyName ];
        switch ([ propertyAttributes type ]) {
            case kObjDataTypeObject:
            {
                if ( value ) {
                    NSString *propClassName = [ propertyAttributes typeDescription ];
                    propClassName = [ propClassName substringWithRange:NSMakeRange( 2, propClassName.length - 3 )];
                    [ string appendFormat:@"@%@) = %@ (%@);\n",
                     propClassName, [ value description ], NSStringFromClass([ value class ])];
                    if ( wrongProperties ) {
                        Class propClass = NSClassFromString( propClassName );
                        if (![ value isKindOfClass:propClass ])
                            [ wrongProperties addObject:propertyName ];
                    }
                } else {
                    [ string appendFormat:@"%@) = <nil>;\n",
                     [ propertyAttributes typeDescription ]];
                }
            }
                break;
            default:
            {
                if ( value ) {
                    [ string appendFormat:@"%@) = %@;\n",
                     [ self nameOfDataType:[ propertyAttributes typeDescription ]],
                     [ value description ]];
                } else {
                    [ string appendFormat:@"%@) = <nil>;\n",
                     [ propertyAttributes typeDescription ]];
                }
            }
                break;
        }
        return NO;
    }];
    return string;
}

@end
