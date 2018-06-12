/**
 @file      OBJProperty+Dynamic.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+Dynamic.h"

#pragma mark - Class dynamic properties store

NSString *const kOBJPropertyDynamicKeyNames = @"kOBJPropertyDynamicKeyNames";


@interface  NSMutableDictionary (PropertyAttributes)

-( objc_property_attribute_t* )dictionaryToPropertiesStructList;

@end

#pragma mark -

@implementation NSObject (OBJProperty)
@dynamic customProperties;

-( void )setCustomProperties:(NSMutableDictionary *)customProperties {
    objc_setAssociatedObject(self, (__bridge const void *)( kOBJPropertyDynamicKeyNames ), customProperties, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

-( NSMutableDictionary* )customProperties {
    return objc_getAssociatedObject( self, (__bridge const void *)( kOBJPropertyDynamicKeyNames ));
}

@end

#pragma mark - 

@implementation OBJProperty (Dynamic)

void OBJProperty_setDictionaryObjectForKey( NSMutableDictionary *dic, id key, id value ) {
    if ( value )
        [ dic setObject:value forKey:key ];
    else
        [ dic removeObjectForKey:key ];
}

/**
 *  Search for property
 *
 *  @param propName    Property name
 *  @param targetClass Target class
 *
 *  @return nil if not found
 */
objc_property_t OBJProperty_getProperty( const char* propName, Class targetClass ) {
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList( targetClass, &outCount );
    if ( properties ) {
        for ( unsigned int i = 0; i < outCount; i++ ) {
            objc_property_t property = properties[i];
            if ( strcmp( propName, property_getName( property )) == 0 ) {
                free( properties );
                return property;
            }
        }
    }
    return class_getProperty( targetClass, propName );
}

// Handle default get/set method of properties

#pragma mark - GET method

id OBJProperty_getPropertyValue( id object, SEL selector ) {
    NSMutableDictionary *dictionary = (( NSObject* )object ).customProperties;
    if ( dictionary )
        return [ dictionary objectForKey:NSStringFromSelector( selector )];
    return nil;
}

long long OBJProperty_getPropertyINTValue( id object, SEL selector ) {
    return [ OBJProperty_getPropertyValue( object, selector ) longLongValue ];
}

double OBJProperty_getPropertyFLTValue( id object, SEL selector ) {
    return [ OBJProperty_getPropertyValue( object, selector ) doubleValue ];
}

OBJRect OBJProperty_getPropertyCGRectValue( id object, SEL selector ) {
    return [ OBJProperty_getPropertyValue( object, selector ) OBJRectValue ];
}

OBJPoint OBJProperty_getPropertyCGPointValue( id object, SEL selector ) {
    return [ OBJProperty_getPropertyValue( object, selector ) OBJPointValue ];
}

NSRange OBJProperty_getPropertyNSRangeValue( id object, SEL selector ) {
    return [ OBJProperty_getPropertyValue( object, selector ) rangeValue ];
}

#pragma mark - SET method

void OBJProperty_setPropertyObjectValue( id object, SEL selector, id value ) {
    NSString *selectorName = NSStringFromSelector( selector );
    NSString *propName = [ NSString stringWithFormat:@"%@%@", [[ selectorName substringWithRange:NSMakeRange( 3, 1 )] lowercaseString ],
                          [ selectorName substringWithRange:NSMakeRange( 4, selectorName.length - 5 )]];
    NSMutableDictionary *dictionary = (( NSObject* )object ).customProperties;
    if ( dictionary == nil ) {
        dictionary = [ NSMutableDictionary dictionary ];
        (( NSObject* )object ).customProperties = dictionary;
    }
    OBJProperty_setDictionaryObjectForKey( dictionary, propName, value );
}

void OBJProperty_setPropertyINTValue( id object, SEL selector, long long value ) {
    OBJProperty_setPropertyObjectValue( object, selector, [ NSNumber numberWithLongLong:value ]);
}

void OBJProperty_setPropertyFLTValue( id object, SEL selector, double value ) {
    OBJProperty_setPropertyObjectValue( object, selector, [ NSNumber numberWithDouble:value ]);
}

void OBJProperty_setPropertyCGRectValue( id object, SEL selector, OBJRect value ) {
    OBJProperty_setPropertyObjectValue( object, selector, [ NSValue valueWithOBJRect( value )]);
}

void OBJProperty_setPropertyCGPointValue( id object, SEL selector, OBJPoint value ) {
    OBJProperty_setPropertyObjectValue( object, selector, [ NSValue valueWithOBJPoint( value )]);
}

void OBJProperty_setPropertyNSRangeValue( id object, SEL selector, NSRange value ) {
    OBJProperty_setPropertyObjectValue( object, selector, [ NSValue valueWithRange:value ]);
}

#pragma mark - Public

+( void )addGetterMethodForProperty:( NSString* )propName propertyAttributes:( const char* )propType
                            ofClass:( Class )targetClass {
    SEL getterSel = NSSelectorFromString( propName );
    if ( !class_respondsToSelector( targetClass, getterSel )) {
        switch ( propType[0] ) {
            case kObjDataTypeChar:
            case kObjDataTypeCppBool:
            case kObjDataTypeInt:
            case kObjDataTypeLong:
            case kObjDataTypeLongLong:
            case kObjDataTypeShort:
            case kObjDataTypeUnsignedChar:
            case kObjDataTypeUnsignedInt:
            case kObjDataTypeUnsignedLong:
            case kObjDataTypeUnsignedLongLong:
            case kObjDataTypeUnsignedShort:
                class_addMethod( targetClass, getterSel, ( IMP )&OBJProperty_getPropertyINTValue, "q@:" );
                break;
            case kObjDataTypeFloat:
            case kObjDataTypeDouble:
                class_addMethod( targetClass, getterSel, ( IMP )&OBJProperty_getPropertyFLTValue, "d@:" );
                break;
            case kObjDataTypeObject:
                class_addMethod( targetClass, getterSel, ( IMP )&OBJProperty_getPropertyValue, "@@:" );
                break;
            case kObjDataTypeStructure:
            {
                NSString *fullType = [ NSString stringWithUTF8String:propType ];
                char *methodType = malloc( strlen( propType ) + 2 );
                strcpy( methodType, propType );
                methodType = strcat( methodType, "@:" );
                if ([ fullType rangeOfString:@"{"_OBJRect_"=" ].location == 0 )
                    class_addMethod( targetClass, getterSel, ( IMP )&OBJProperty_getPropertyCGRectValue, methodType );
                else if ([ fullType rangeOfString:@"{"_OBJPoint_"=" ].location == 0 )
                    class_addMethod( targetClass, getterSel, ( IMP )&OBJProperty_getPropertyCGPointValue, methodType );
                else if ([ fullType rangeOfString:@"{"_OBJSize_"=" ].location == 0 )
                    class_addMethod( targetClass, getterSel, ( IMP )&OBJProperty_getPropertyCGPointValue, methodType );
                else if ([ fullType rangeOfString:@"{_NSRange=" ].location == 0 )
                    class_addMethod( targetClass, getterSel, ( IMP )&OBJProperty_getPropertyNSRangeValue, methodType );
                free( methodType );
            }
                break;
            case kObjDataTypeCharString:
            case kObjDataTypePointer:
            case kObjDataTypeSelector:
            case kObjDataTypeNone:
            case kObjDataTypeVoid:
            case kObjDataTypeClass:
            case kObjDataTypeArray:
            case kObjDataTypeBits:
            case kObjDataTypeUnion:
            case kObjDataTypeUnknown:
                // Not support
                break;
            default:
                break;
        }
    }
}

+( void )addSetterMethodForProperty:( NSString* )propName propertyAttributes:( const char* )propType
                            ofClass:( Class )targetClass {
    NSString *setterName = [ NSString stringWithFormat:@"set%@%@:", [[ propName substringWithRange:NSMakeRange( 0, 1 )] uppercaseString ],
                            [ propName substringFromIndex:1 ]];
    SEL setterSel = NSSelectorFromString( setterName );
    if ( !class_respondsToSelector( targetClass, setterSel )) {
        switch ( propType[0] ) {
            case kObjDataTypeChar:
            case kObjDataTypeCppBool:
            case kObjDataTypeInt:
            case kObjDataTypeLong:
            case kObjDataTypeLongLong:
            case kObjDataTypeShort:
            case kObjDataTypeUnsignedChar:
            case kObjDataTypeUnsignedInt:
            case kObjDataTypeUnsignedLong:
            case kObjDataTypeUnsignedLongLong:
            case kObjDataTypeUnsignedShort:
                class_addMethod( targetClass, setterSel, ( IMP )&OBJProperty_setPropertyINTValue, "v@:q" );
                break;
            case kObjDataTypeFloat:
            case kObjDataTypeDouble:
                class_addMethod( targetClass, setterSel, ( IMP )&OBJProperty_setPropertyFLTValue, "v@:d" );
                break;
            case kObjDataTypeObject:
                class_addMethod( targetClass, setterSel, ( IMP )&OBJProperty_setPropertyObjectValue, "v@:@" );
                break;
            case kObjDataTypeStructure:
            {
                NSString *fullType = [ NSString stringWithUTF8String:propType ];
                char *methodType = malloc( strlen( propType ) + 2 );
                strcpy( methodType, "v@:" );
                methodType = strcat( methodType, propType );
                if ([ fullType rangeOfString:@"{"_OBJRect_"=" ].location == 0 )
                    class_addMethod( targetClass, setterSel, ( IMP )&OBJProperty_setPropertyCGRectValue, methodType );
                else if ([ fullType rangeOfString:@"{"_OBJPoint_"=" ].location == 0 )
                    class_addMethod( targetClass, setterSel, ( IMP )&OBJProperty_setPropertyCGPointValue, methodType );
                else if ([ fullType rangeOfString:@"{"_OBJSize_"=" ].location == 0 )
                    class_addMethod( targetClass, setterSel, ( IMP )&OBJProperty_setPropertyCGPointValue, methodType );
                else if ([ fullType rangeOfString:@"{_NSRange=" ].location == 0 )
                    class_addMethod( targetClass, setterSel, ( IMP )&OBJProperty_setPropertyNSRangeValue, methodType );
                free( methodType );
            }
                break;
            case kObjDataTypeCharString:
            case kObjDataTypePointer:
            case kObjDataTypeSelector:
            case kObjDataTypeNone:
            case kObjDataTypeVoid:
            case kObjDataTypeClass:
            case kObjDataTypeArray:
            case kObjDataTypeBits:
            case kObjDataTypeUnion:
            case kObjDataTypeUnknown:
                // Not support
                break;
            default:
                break;
        }
    }
}

+( void )applyDynamicProperties:( NSArray* )propNames ofClass:( Class )targetClass {
    for ( NSString *propName in propNames ) {
        objc_property_t property = OBJProperty_getProperty( propName.UTF8String, targetClass );
        if ( property ) {
            unsigned int oCnt = 0;
            BOOL isDynamic = NO;
            char *propType = NULL;
            objc_property_attribute_t *attributes = property_copyAttributeList( property, &oCnt );
            if ( attributes ) {
                for ( unsigned int j = 0; j < oCnt; j++ ) {
                    objc_property_attribute_t attr = attributes[j];
                    if ( attr.name[0] == 'D' )
                        isDynamic = YES;
                    else if ( attr.name[0] == 'T' )
                        propType = strdup( attr.value );
                }
                free( attributes );
            }
            if ( isDynamic ) {
                [ self addGetterMethodForProperty:propName
                               propertyAttributes:propType
                                          ofClass:targetClass ];
                [ self addSetterMethodForProperty:propName
                               propertyAttributes:propType
                                          ofClass:targetClass ];
            }
            if ( propType ) free( propType );
        }
    }
}

+( BOOL )addDynamicPropertyWithName:( NSString* )name dataTypeDescription:( NSString* )type
                            ofClass:( Class )targetClass {
    NSMutableDictionary *attributesDic = [ NSMutableDictionary dictionary ];
    [ attributesDic setObject:@"" forKey:@"D" ];
    [ attributesDic setObject:type forKey:@"T" ];
    objc_property_attribute_t* attributes = [ attributesDic dictionaryToPropertiesStructList ];
    BOOL result = class_addProperty( targetClass, [ name UTF8String ], attributes, ( unsigned int )attributesDic.count );
    if ( result )
        [ self applyDynamicProperties:@[ name ] ofClass:targetClass ];
    free( attributes );
    return result;
}

@end
