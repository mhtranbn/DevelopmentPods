/**
 @file      OBJProperty+Obj2Dic.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+Obj2Dic.h"
@import RSUtils;

@implementation OBJProperty (Obj2Dic)

+( BOOL )isObjectOfArrayDicBasicType:( id )object {
    return [ object isKindOfClass:[ NSString class ]] ||
    [ object isKindOfClass:[ NSNumber class ]] ||
    [ object isKindOfClass:[ NSValue class ]] ||
    [ object isKindOfClass:[ NSData class ]] ||
    [ object isKindOfClass:[ NSArray class ]] ||
    [ object isKindOfClass:[ NSDate class ]] ||
    [ object isKindOfClass:[ NSDictionary class ]];
}

+( id )internalTransformedObject:( id )object {
    if ([ self isObjectOfArrayDicBasicType:object ]) {
        return object;
    } else if ([ object isKindOfClass:[ OBJColor class ]]){
        return [( OBJColor* )object rgbaHexaString ];
    } else if ([ object isKindOfClass:[ NSURL class ]]){
        return [( NSURL* )object absoluteString ];
    }
    return nil;
}

+( void )appendObject:( id )object ofProperty:( NSString* )propName
        andAttributes:( NSDictionary* )propAttr
  intoDictionaryStore:( NSMutableDictionary* )store {
    NSString *key = [ propAttr propertyAliasName ];
    if ( key == nil ) key = propName;
    id val = [ self internalTransformedObject:object ];
    if ( val != nil ) {
        [ store setObject:val forKey:key ];
    }
}

+( NSMutableDictionary* )dictionaryFromObject:(id)object rootClass:( Class )rootClass {
    NSMutableDictionary *result = [ NSMutableDictionary dictionary ];
    Class objClass = [ object class ];
    NSInteger clsDeep = [ OBJCommon countOfLevelsFromClass:objClass toClass:rootClass ];
    if ( clsDeep < 0 ) clsDeep = 0;
    [ self enumeratePropertyOfClass:objClass superClassDeep:clsDeep withBlock:^BOOL(NSString *propertyName, NSMutableDictionary *propertyAttributes, __unsafe_unretained Class ownerClass) {
        if ([ propertyAttributes isPropertyExcludeInDictionary ]) return NO;
        id val = [ object valueForKey:propertyName ];
        if ([ object respondsToSelector:@selector( shouldTransformValueOfProperty: )] &&
            [ object respondsToSelector:@selector( transformedValueOfProperty: )] &&
            [ object shouldTransformValueOfProperty:propertyName ]) {
            val = [ object transformedValueOfProperty:propertyName ];
        }
        if ( val != nil ) {
            [ self appendObject:val ofProperty:propertyName
                  andAttributes:propertyAttributes intoDictionaryStore:result ];
        }
        return NO;
    }];
    return result;
}

+( NSMutableDictionary* )dictionaryFromObject:( id )object {
    return [ self dictionaryFromObject:object rootClass:nil ];
}

+( NSMutableArray* )dictionariesFromArray:( NSArray* )arrayOfObjects rootClass:( nullable Class )rootClass {
    NSMutableArray *result = [ NSMutableArray array ];
    for ( id object in arrayOfObjects ) {
        id val = [ self internalTransformedObject:object ];
        if ( val == nil ) val = [ self dictionaryFromObject:object rootClass:rootClass ];
        [ result addObject:val ];
    }
    return result;
}

+( NSMutableDictionary* )dictionaryFromDictionary:( NSDictionary* )dicOfObjects rootClass:(nullable Class)rootClass {
    NSMutableDictionary *result = [ NSMutableDictionary dictionary ];
    for ( id key in dicOfObjects.allKeys ) {
        id val = [ dicOfObjects objectForKey:key ];
        id obj = [ self internalTransformedObject:val ];
        if ( obj == nil ) obj = [ self dictionaryFromObject:val rootClass:rootClass ];
        [ result setObject:obj forKey:key ];
    }
    return result;
}

@end
