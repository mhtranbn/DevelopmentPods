/**
 @file      OBJProperty+CustomAttributes.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+CustomAttributes.h"
#import "OBJMethod+infector.h"

NSString *const kOBJPropertyAliasName               = @"AlN";
NSString *const kOBJPropertyArrayItemClass          = @"AIC";
NSString *const kOBJPropertyArrayItemRootClass      = @"AIR";
NSString *const kOBJPropertyDictionaryItemClass     = @"DIC";
NSString *const kOBJPropertyDictionaryItemRootClass = @"DIR";
NSString *const kOBJPropertyEncodeExlude            = @"EnX";

@implementation NSDictionary (OBJPropertyCustomAttributes)

-( NSString* )propertyAliasName {
    return [ self objectForKey:kOBJPropertyAliasName ];
}

-( Class )propertyClassWithKey:( NSString* )key {
    NSString *className = [ self objectForKey:key ];
    if ( className ) return NSClassFromString( className );
    return nil;
}

-( Class )propertyArrayItemClass {
    return [ self propertyClassWithKey:kOBJPropertyArrayItemClass ];
}

-( Class )propertyArrayItemRootClass {
    return [ self propertyClassWithKey:kOBJPropertyArrayItemRootClass ];
}

-( Class )propertyDictionaryItemClass {
    return [ self propertyClassWithKey:kOBJPropertyDictionaryItemClass ];
}

-( Class )propertyDictionaryItemRootClass {
    return [ self propertyClassWithKey:kOBJPropertyDictionaryItemRootClass ];
}

-( BOOL )isPropertyExcludeInDictionary {
    return [ self.allKeys containsObject:kOBJPropertyEncodeExlude ];
}

@end

#pragma mark -

@implementation NSMutableDictionary (OBJPropertyCustomAttributes)

-( void )setPropertyAliasName:( NSString* )alias {
    if ( alias )
        [ self setObject:alias forKey:kOBJPropertyAliasName ];
    else
        [ self removeObjectForKey:kOBJPropertyAliasName ];
}

-( void )setPropertyItemClass:( Class )className forKey:( NSString* )key {
    if ( className ) {
        NSString *strClass = NSStringFromClass( className );
        [ self setObject:strClass forKey:key ];
    } else {
        [ self removeObjectForKey:key ];
    }
}

-( void )setPropertyArrayItemClass:( Class )className {
    [ self setPropertyItemClass:className forKey:kOBJPropertyArrayItemClass ];
}

-( void )setPropertyArrayItemRootClass:( Class )className {
    [ self setPropertyItemClass:className forKey:kOBJPropertyArrayItemRootClass ];
}

-( void )setPropertyDictionaryItemClass:( Class )className {
    [ self setPropertyItemClass:className forKey:kOBJPropertyDictionaryItemClass ];
}

-( void )setPropertyDictionaryItemRootClass:( Class )className {
    [ self setPropertyItemClass:className forKey:kOBJPropertyDictionaryItemRootClass ];
}

-( void )setPropertyExcludeInDictionary:( BOOL )excluded {
    if ( excluded )[ self setObject:@"" forKey:kOBJPropertyEncodeExlude ];
    else [ self removeObjectForKey:kOBJPropertyEncodeExlude ];
}

@end

#pragma mark -

@implementation OBJProperty (CustomAttributes)

+( BOOL )isClass:( Class )class subclassOfOneOf:( NSArray<Class>* )classes {
    for ( Class cls in classes ) {
        if ([ class isSubclassOfClass:cls ]) return YES;
    }
    return NO;
}

+( BOOL )registClassesCustomAttributesPropertiesOfModule:( Class )cls {
    NSMutableArray *customClasses = [ NSMutableArray array ];
    NSMutableArray *childClasses = [ NSMutableArray array ];
    const char *mainImage = class_getImageName(cls);
    if ( mainImage == nil ) return NO;
    unsigned int count = 0;
    const char **listClass = objc_copyClassNamesForImage( mainImage, &count );
    if ( listClass != nil ) {
        for (int i = 0; i < count; i++ ) {
            Class cls = NSClassFromString([ NSString stringWithFormat:@"%s", listClass[i] ]);
            if ( cls != nil ) {
                if ( class_conformsToProtocol( cls, @protocol( OBJPropertyCustomAttributesProtocol ))) {
                    if ([ OBJMethod doClass:cls implementStaticMethod:@selector( registCustomAttributesOfClassProperties )]) {
                        NSDictionary *map = [ cls registCustomAttributesOfClassProperties ];
                        if ( map != nil && map.count > 0 ) {
                            [ OBJProperty editPropertiesAttributes:[ map allKeys ] ofClass:cls withEditBlock:^BOOL(NSString * _Nonnull propertyName, NSMutableDictionary * _Nonnull propertyAttributes, Class  _Nonnull __unsafe_unretained ownerClass) {
                                NSDictionary *attributes = [ map objectForKey:propertyName ];
                                if ( attributes != nil ) {
                                    [ propertyAttributes addEntriesFromDictionary:attributes ];
                                    return YES;
                                }
                                return NO;
                            }];
                        }
                    }
                    [ customClasses addObject:cls ];
                } else {
                    [ childClasses addObject:cls ];
                }
            }
        }
        free( listClass );
    }
    for ( Class cls in childClasses ) {
        if ([ OBJMethod doClass:cls implementStaticMethod:@selector( registCustomAttributesOfClassProperties )] &&
            [ self isClass:cls subclassOfOneOf:customClasses ]) {
            NSDictionary *map = [ cls registCustomAttributesOfClassProperties ];
            if ( map != nil && map.count > 0 ) {
                [ OBJProperty editPropertiesAttributes:[ map allKeys ] ofClass:cls withEditBlock:^BOOL(NSString * _Nonnull propertyName, NSMutableDictionary * _Nonnull propertyAttributes, Class  _Nonnull __unsafe_unretained ownerClass) {
                    NSDictionary *attributes = [ map objectForKey:propertyName ];
                    if ( attributes != nil ) {
                        [ propertyAttributes addEntriesFromDictionary:attributes ];
                        return YES;
                    }
                    return NO;
                }];
            }
        }
    }
    return YES;
}

+( void )registClassesCustomAttributesProperties {
    [ self registClassesCustomAttributesPropertiesOfModule:[[[ UIApplication sharedApplication ] delegate ] class ]];
}

@end

@implementation NSMutableDictionary (CustomAttributesMap)

-( NSMutableDictionary* )getAttributesMapForPropertyName:( NSString* )propName {
    NSMutableDictionary *dic = [ self objectForKey:propName ];
    if ( dic == nil ) {
        dic = [ NSMutableDictionary new ];
        [ self setObject:dic forKey:propName ];
    }
    return dic;
}

-( void )setAliasAttribute:( nullable NSString* )alias forProperty:( nonnull NSString* )propName {
    NSMutableDictionary *dic = [ self getAttributesMapForPropertyName:propName ];
    [ dic setPropertyAliasName:alias ];
}

-( void )setArrayItemClassAttribute:( nullable Class )className forProperty:( nonnull NSString* )propName {
    [ self setArrayItemClassAttribute:className ancestorClass:nil forProperty:propName ];
}

-( void )setArrayItemClassAttribute:( nullable Class )className ancestorClass:( nullable Class )superName
                        forProperty:( nullable NSString* )propName {
    NSMutableDictionary *dic = [ self getAttributesMapForPropertyName:propName ];
    [ dic setPropertyArrayItemClass:className ];
    [ dic setPropertyArrayItemRootClass:superName ];
}

-( void )setDictionaryItemClassAttribute:( nullable Class )className forProperty:( nonnull NSString* )propName {
    [ self setDictionaryItemClassAttribute:className ancestorClass:nil forProperty:propName ];
}

-( void )setDictionaryItemClassAttribute:( nullable Class )className ancestorClass:( nullable Class )superName
                             forProperty:( nullable NSString* )propName {
    NSMutableDictionary *dic = [ self getAttributesMapForPropertyName:propName ];
    [ dic setPropertyDictionaryItemClass:className ];
    [ dic setPropertyDictionaryItemRootClass:superName ];
}

-( void )setExcludedEncodingToDictionaryWithProperty:( nullable NSString* )propName {
    NSMutableDictionary *dic = [ self getAttributesMapForPropertyName:propName ];
    [ dic setPropertyExcludeInDictionary:YES ];
}

@end
