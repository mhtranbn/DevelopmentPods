/**
 @file      NWRequestHeaderAttribute.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestHeaderAttribute.h"

@implementation NWRequestHeaderAttribute

-( instancetype )initWithString:( NSString* )attrString {
    NSArray *array = [ attrString componentsSeparatedByString:@";" ];
    NSString *first = [ array.firstObject stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet ]];
    if ( first == nil ) return nil;
    NSRange range = [ first rangeOfString:@":" ];
    if ( range.location == NSNotFound ) return nil;
    NSString *key = [ first substringToIndex:range.location ];
    NSString *value = [[ first substringFromIndex:range.location + 1 ] stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet ]];
    self = [ super init ];
    if ( self != nil && key != nil && value != nil ) {
        _key = key;
        _value = value;
        if ( array.count > 1 ) {
            NSMutableDictionary *params = [ NSMutableDictionary new ];
            for ( NSUInteger i = 1; i < array.count; i++ ) {
                NSString *param = [[ array objectAtIndex:i ] stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceCharacterSet ]];
                NSRange r = [ param rangeOfString:@"=" ];
                if ( r.location != NSNotFound ) {
                    NSString *k = [ param substringToIndex:r.location ];
                    NSString *v = [ param substringFromIndex:r.location + 1 ];
                    [ params setObject:v forKey:k ];
                }
            }
            if ( params.count > 0 ) _parameters = params;
        }
        return self;
    }
    return nil;
}

-( NSString* )toString {
    NSMutableString *result = [[ NSMutableString alloc ] initWithFormat:@"%@: %@", self.key, self.value ];
    if ( self.parameters != nil && self.parameters.count > 0 ) {
        [ result appendString:@";" ];
        for ( NSString *key in self.parameters.allKeys ) {
            NSString *value = [ self.parameters objectForKey:key ];
            [ result appendFormat:@" %@=%@;", key, value ];
        }
        [ result deleteCharactersInRange:NSMakeRange( result.length - 1, 1 )];
    }
    return result;
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@<%p> %@", self.class, self, [ self toString ]];
}

@end
