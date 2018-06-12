/**
 @file      NSArrayDictionary+Description.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSArrayDictionary+Description.h"

#ifndef DESC_VALUE_CLASS
#define DESC_VALUE_CLASS 0
#endif

@implementation NSString (description)

+( NSString* )descriptionOfObject:( id )value {
    NSString *valDesc = nil;
    if ([ value isKindOfClass:[ NSNumber class ]]) {
#if DESC_VALUE_CLASS
        valDesc = [ NSString stringWithFormat:@"%@", value ];
#else
        if ([ NSStringFromClass([ value class ]) isEqualToString:@"__NSCFBoolean" ]) {
            valDesc = [ value boolValue ] ? @"TRUE" : @"FALSE";
        } else {
            valDesc = [ NSString stringWithFormat:@"%@", value ];
        }
#endif
    } else if ([ value isKindOfClass:[ NSString class ]]) {
        valDesc = value;
    } else {
        valDesc = [[ value description ] stringByReplacingOccurrencesOfString:@"\n"
                                                                   withString:@"\n\t" ];
        if (([ value isKindOfClass:[ NSArray class ]] || [ value isKindOfClass:[ NSDictionary class ]])
            && [ valDesc characterAtIndex:valDesc.length - 1 ] == '\t'
            && [ valDesc characterAtIndex:valDesc.length - 2 ] == '\n'
            && [ valDesc isKindOfClass:[ NSMutableString class ]]) {
            [( NSMutableString* )valDesc deleteCharactersInRange:NSMakeRange( valDesc.length - 2, 2 )];
        }
    }
    return valDesc;
}

@end

@implementation NSDictionary (description)

-( NSString* )description {
    NSMutableString *descString = [ NSMutableString stringWithFormat:@"[(%@){\n", @( self.count )];
    for ( NSString *key in self.allKeys ) {
        id value = [ self objectForKey:key ];
        NSString *valDesc = [ NSString descriptionOfObject:value ];
#if DESC_VALUE_CLASS
        [ descString appendFormat:@"\t%@ ＝ %@ (%@);\n", key, valDesc, NSStringFromClass([ value class ])];
#else
        if ([ value isKindOfClass:[ NSString class ]]) {
            [ descString appendFormat:@"\t%@ ＝ \"%@\";\n", key, valDesc ];
        } else {
            [ descString appendFormat:@"\t%@ ＝ %@;\n", key, valDesc ];
        }
#endif
    }
    [ descString appendString:@"}]\n" ];
    return descString;
}

@end

@implementation NSArray (description)

-( NSString* )description {
    NSMutableString *descString = [ NSMutableString stringWithFormat:@"[(%@)(\n", @( self.count )];
    for ( id value in self ) {
        NSString *valDesc = [ NSString descriptionOfObject:value ];
#if DESC_VALUE_CLASS
        [ descString appendFormat:@"\t%@ (%@),\n", valDesc, NSStringFromClass([ value class ])];
#else
        if ([ value isKindOfClass:[ NSString class ]]) {
            [ descString appendFormat:@"\t\"%@\",\n", valDesc ];
        } else {
            [ descString appendFormat:@"\t%@,\n", valDesc ];
        }
#endif
    }
    [ descString deleteCharactersInRange:NSMakeRange( descString.length - 2, 2 )];
    [ descString appendString:@"\n)]\n" ];
    return descString;
}

@end
