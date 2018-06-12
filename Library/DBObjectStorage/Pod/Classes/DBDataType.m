/**
 @file      DBDataType.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBDataType.h"

@implementation DBInteger

-( instancetype )initWithValue:( NSInteger )value {
    if ( self = [ super init ]) {
        _value = value;
    }
    return self;
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@", @( self.value )];
}

-( BOOL )isEqual:( id )object {
    if ([ object isKindOfClass:[ DBInteger class ]]) {
        return self.value == (( DBInteger* )object ).value;
    }
    return NO;
}

-( id )copy {
    return [[ DBInteger alloc ] initWithValue:self.value ];
}

@end

@implementation DBBool

-( instancetype )initWithValue:( BOOL )value {
    if ( self = [ super init ]) {
        _value = value;
    }
    return self;
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@", @( self.value )];
}

-( BOOL )isEqual:( id )object {
    if ([ object isKindOfClass:[ DBBool class ]]) {
        return self.value == (( DBBool* )object ).value;
    }
    return NO;
}

-( id )copy {
    return [[ DBBool alloc ] initWithValue:self.value ];
}

-( NSInteger )intValue {
    return self.value ? 1 : 0;
}

-( NSString* )stringValue {
    return self.value ? @"true" : @"false";
}

@end

@implementation DBReal

-( instancetype )initWithDouble:( double )value {
    if ( self = [ super init ]) {
        _doubleValue = value;
        _floatValue = value;
        _cgFloatValue = value;
    }
    return self;
}

-( instancetype )initWithFloat:( float )value {
    if ( self = [ super init ]) {
        _doubleValue = value;
        _floatValue = value;
        _cgFloatValue = value;
    }
    return self;
}

-( instancetype )initWithCGFloat:( CGFloat )value {
    if ( self = [ super init ]) {
        _doubleValue = value;
        _floatValue = value;
        _cgFloatValue = value;
    }
    return self;
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@", @( self.doubleValue )];
}

-( BOOL )isEqual:( id )object {
    if ([ object isKindOfClass:[ DBReal class ]]) {
        return self.doubleValue == (( DBReal* )object ).doubleValue;
    }
    return NO;
}

-( id )copy {
    return [[ DBReal alloc ] initWithDouble:self.doubleValue ];
}

@end

@implementation NSNumber (DB)

-( instancetype )initWithDBInt:( DBInteger* )dbInt {
    return [ self initWithInteger:dbInt.value ];
}

-( DBInteger* )dbIntValue {
    return [[ DBInteger alloc ] initWithValue:[ self integerValue ]];
}

-( instancetype )initWithDBBool:( DBBool* )dbBool {
    return [ self initWithBool:dbBool.value ];
}

-( DBBool* )dbBoolValue {
    return [[ DBBool alloc ] initWithValue:[ self boolValue ]];
}

-( instancetype )initWithDBReal:( DBReal* )dbReal {
    return [ self initWithDouble:dbReal.doubleValue ];
}

-( DBReal* )dbRealValue {
    return [[ DBReal alloc ] initWithDouble:[ self doubleValue ]];
}

@end
