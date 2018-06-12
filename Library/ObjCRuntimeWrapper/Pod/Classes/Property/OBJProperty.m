/**
 @file      OBJProperty.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty.h"

#pragma mark - Property attributes Dictionary

@implementation  NSMutableDictionary (PropertyAttributes)

-( objc_property_attribute_t* )dictionaryToPropertiesStructList {
    objc_property_attribute_t *attributes = calloc( self.count, sizeof( objc_property_attribute_t ));
    unsigned int i = 0;
    for ( NSString *key in self.allKeys ) {
        NSString *value = [ self objectForKey:key ];
        objc_property_attribute_t *attr = &attributes[i];
        attr->name = [ key UTF8String ];
        attr->value = [ value UTF8String ];
        i += 1;
    }
    return attributes;
}

@end

/*-----------------------------------------------------------------------------*/
#pragma mark - OBJProperty

@implementation OBJProperty

#pragma mark - Enumerate

+( NSUInteger )enumeratePropertyOfClass:(Class)aClass withBlock:( OBJPropertyBlock )propertyBlock {
    if ( propertyBlock == nil ) return 0;
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList( aClass, &outCount );
    if ( properties ) {
        for ( unsigned int i = 0; i < outCount; i++ ) {
            objc_property_t property = properties[i];
            const char *name = property_getName( property );
            unsigned int oCnt = 0;
            NSMutableDictionary *dicAttributes = nil;
            objc_property_attribute_t *attributes = property_copyAttributeList( property, &oCnt );
            if ( attributes ) {
                dicAttributes = [ NSMutableDictionary dictionary ];
                for ( unsigned int j = 0; j < oCnt; j++ ) {
                    objc_property_attribute_t attr = attributes[j];
                    [ dicAttributes setObject:[ NSString stringWithUTF8String:attr.value ]
                                       forKey:[ NSString stringWithUTF8String:attr.name ]];
                }
                free( attributes );
            }
            NSString *strName = [ NSString stringWithUTF8String:name ];
            if ( propertyBlock( strName, dicAttributes, aClass )) break;
        }
        free( properties );
    }
    return ( NSUInteger )outCount;
}

+( NSUInteger )enumeratePropertyOfClass:( Class )aClass superClassDeep:( NSUInteger )levelUp
                              withBlock:( OBJPropertyBlock )propertyBlock {
    Class cls = aClass;
    NSUInteger result = [ self enumeratePropertyOfClass:cls withBlock:propertyBlock ];
    NSUInteger levelCnt = 0;
    while ( levelCnt < levelUp && cls != [ cls superclass ]) {
        cls = [ cls superclass ];
        if ( cls == nil ) break;
        result += [ self enumeratePropertyOfClass:cls withBlock:propertyBlock ];
        levelCnt += 1;
    }
    return result;
}

#pragma mark - Edit Attributes

+( BOOL )editPropertyAttributes:( NSString* )propertyName ofClass:( Class )aClass
                  withEditBlock:( OBJPropertyBlock )editBlock {
    return [ self editPropertiesAttributes:@[ propertyName ] ofClass:aClass withEditBlock:editBlock ];
}

+( BOOL )editPropertiesAttributes:( NSArray* )propertyNames ofClass:( Class )aClass
                    withEditBlock:( OBJPropertyBlock )editBlock {
    if ( editBlock == nil || propertyNames == nil ||
        propertyNames.count == 0 || aClass == nil ) return NO;
    NSMutableArray *arrTemp = [ NSMutableArray arrayWithArray:propertyNames ];
    [ self enumeratePropertyOfClass:aClass withBlock:^BOOL(NSString *propertyName, NSMutableDictionary *propertyAttributes, __unsafe_unretained Class ownerClass) {
        if ([ arrTemp containsObject:propertyName ] && aClass == ownerClass ) {
            if ( editBlock( propertyName, propertyAttributes, ownerClass )) {
                const char *propName = [ propertyName UTF8String ];
                objc_property_attribute_t *attributes = [ propertyAttributes dictionaryToPropertiesStructList ];
                unsigned int oCnt = ( unsigned int )propertyAttributes.count;
                class_replaceProperty( ownerClass, propName, attributes, oCnt );
                free( attributes );
            }
            [ arrTemp removeObject:propertyName ];
        }
        return arrTemp.count == 0;
    }];
    return arrTemp.count == 0;
}

@end
