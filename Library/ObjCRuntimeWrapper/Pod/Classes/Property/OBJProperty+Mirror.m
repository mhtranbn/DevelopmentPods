/**
 @file      OBJProperty+Mirror.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+Mirror.h"

@implementation OBJProperty (Mirror)

+( nonnull id )copyDictionary:( NSDictionary* )sourceDic {
    NSMutableDictionary *result = [ NSMutableDictionary dictionary ];
    for ( id key in sourceDic.allKeys ) {
        BOOL hasError = NO;
        id newValue = [ self copyAnObject:[ sourceDic objectForKey:key ] hasError:&hasError ];
        if ( newValue == nil ) continue;
        [ result setObject:newValue forKey:key ];
    }
    if ([ sourceDic isKindOfClass:[ NSMutableDictionary class ]]) {
        return result;
    } else {
        return [ result copy ];
    }
}

+( nonnull id )copyArray:( NSArray* )sourceArray {
    NSMutableArray *result = [ NSMutableArray array ];
    for ( id item in sourceArray ) {
        BOOL hasError = NO;
        id newItem = [ self copyAnObject:item hasError:&hasError ];
        if ( newItem != nil )[ result addObject:newItem ];
    }
    if ([ sourceArray isKindOfClass:[ NSMutableArray class ]]) {
        return  result;
    } else {
        return [ result copy ];
    }
}

+( nullable id )copyAnObject:( nullable id )object hasError:( nonnull BOOL* )error {
    *error = NO;
    if ( object == nil ) return nil;
    id result = nil;
    if ([ object isKindOfClass:[ NSDictionary class ]]) {
        result = [ self copyDictionary:object ];
    } else if ([ object isKindOfClass:[ NSArray class ]]) {
        result = [ self copyArray:object ];
    } else if ([ object isKindOfClass:[ NSMutableString class ]]) {
        result = [ object mutableCopy ];
    } else {
        @try {
            result = [ object copy ];
        }
        @catch (NSException *exception) {
            *error = YES;
            return nil;
        }
    }
    return result;
}

+( void )mirrorFromObject:( nonnull id )sourceObj toObject:( nonnull id )destObj rootClass:( nullable Class )rootClass {
    if ( sourceObj == destObj ) return;
    Class aClass = [ sourceObj class ];
    NSInteger clsDeep = [ OBJCommon countOfLevelsFromClass:aClass toClass:rootClass ];
    if ( clsDeep < 0 ) clsDeep = 0;
    [ self enumeratePropertyOfClass:aClass superClassDeep:clsDeep withBlock:^BOOL(NSString *propertyName, NSMutableDictionary *propertyAttributes, __unsafe_unretained Class ownerClass) {
        if ([ propertyAttributes isReadOnly ]) return NO;
        id value = nil;
        @try {
            value = [ sourceObj valueForKey:propertyName ];
        }
        @catch (NSException *exception) {
            return NO;
        }
        BOOL hasError = NO;
        id newValue = [ self copyAnObject:value hasError:&hasError ];
        if ( hasError ) return NO;
        @try {
            [ destObj setValue:newValue forKey:propertyName ];
        }
        @catch (NSException *exception) {
            
        }
        return NO;
    }];
}

@end
