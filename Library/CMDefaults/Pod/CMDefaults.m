/**
 @file      CMDefaults.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "CMDefaults.h"
@import CommonLog;
@import ObjCRuntimeWrapper;
@import RSUtils;

NSString *const CMDefaultsLogCategory = @"CMDefaults";

@interface CMDefaults()

@property ( nonatomic, strong ) NSMutableDictionary *setterKeyMap;
@property ( nonatomic, strong ) NSMutableDictionary *getterKeyMap;
@property ( nonatomic, strong ) NSMutableDictionary *typeKeyMap;

@end

@implementation CMDefaults

#pragma mark - Swizzle IMP

unsigned char CMDefaultGetUChar( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned char" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num unsignedCharValue ];
}

void CMDefaultsSetUChar( CMDefaults* sender, SEL cmd, unsigned char value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithUnsignedChar:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned char" value:[ NSString stringWithFormat:@"%@", num ]];
}

char CMDefaultGetChar( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"char" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num charValue ];
}

void CMDefaultsSetChar( CMDefaults* sender, SEL cmd, char value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithChar:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"char" value:[ NSString stringWithFormat:@"%@", num ]];
}

unsigned int CMDefaultGetUInt( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned int" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num unsignedIntValue ];
}

void CMDefaultsSetUInt( CMDefaults* sender, SEL cmd, unsigned int value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithUnsignedInt:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned int" value:[ NSString stringWithFormat:@"%@", num ]];
}

int CMDefaultGetInt( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"int" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num intValue ];
}

void CMDefaultsSetInt( CMDefaults* sender, SEL cmd, int value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithInt:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"int" value:[ NSString stringWithFormat:@"%@", num ]];
}

unsigned short CMDefaultGetUShort( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned short" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num unsignedShortValue ];
}

void CMDefaultsSetUShort( CMDefaults* sender, SEL cmd, unsigned short value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithUnsignedShort:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned short" value:[ NSString stringWithFormat:@"%@", num ]];
}

short CMDefaultGetShort( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"short" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num shortValue ];
}

void CMDefaultsSetShort( CMDefaults* sender, SEL cmd, short value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithShort:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"short" value:[ NSString stringWithFormat:@"%@", num ]];
}

unsigned long CMDefaultGetULong( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned long" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num unsignedLongValue ];
}

void CMDefaultsSetULong( CMDefaults* sender, SEL cmd, unsigned long value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithUnsignedLong:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned long" value:[ NSString stringWithFormat:@"%@", num ]];
}

long CMDefaultGetLong( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"long" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num longValue ];
}

void CMDefaultsSetLong( CMDefaults* sender, SEL cmd, long value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithLong:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"long" value:[ NSString stringWithFormat:@"%@", num ]];
}

unsigned long long CMDefaultGetULL( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned long long" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num unsignedLongLongValue ];
}

void CMDefaultsSetULL( CMDefaults* sender, SEL cmd, unsigned long long value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithUnsignedLongLong:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"unsigned long long" value:[ NSString stringWithFormat:@"%@", num ]];
}

long long CMDefaultGetLL( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"long long" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num longLongValue ];
}

void CMDefaultsSetLL( CMDefaults* sender, SEL cmd, long long value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithLongLong:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"long long" value:[ NSString stringWithFormat:@"%@", num ]];
}

float CMDefaultGetFloat( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"float" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num floatValue ];
}

void CMDefaultsSetFloat( CMDefaults* sender, SEL cmd, float value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithFloat:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"float" value:[ NSString stringWithFormat:@"%@", num ]];
}

double CMDefaultGetDouble( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"double" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num doubleValue ];
}

void CMDefaultsSetDouble( CMDefaults* sender, SEL cmd, double value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithDouble:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"double" value:[ NSString stringWithFormat:@"%@", num ]];
}

bool CMDefaultGetBool( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num = [ sender.userDefaults objectForKey:key ];
    [ sender log:isSet method:cmd key:key type:@"bool" value:[ NSString stringWithFormat:@"%@", num ]];
    return [ num boolValue ];
}

void CMDefaultsSetBool( CMDefaults* sender, SEL cmd, bool value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSNumber *num =[ NSNumber numberWithBool:value ];
    [ sender.userDefaults setObject:num forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"bool" value:[ NSString stringWithFormat:@"%@", num ]];
}

CGPoint CMDefaultGetPoint( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = [ sender.userDefaults objectForKey:key ];
    CGPoint result = CGPointZero;
    if ( data != nil && [ data isKindOfClass:[ NSString class ]] && data.length > 0 ) {
        result = CGPointFromString( data );
    }
    [ sender log:isSet method:cmd key:key type:@"CGPoint" value:NSStringFromCGPoint( result )];
    return result;
}

void CMDefaultsSetPoint( CMDefaults* sender, SEL cmd, CGPoint value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = NSStringFromCGPoint( value );
    [ sender.userDefaults setObject:data forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"CGPoint" value:data ];
}

CGSize CMDefaultGetSize( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = [ sender.userDefaults objectForKey:key ];
    CGSize result = CGSizeZero;
    if ( data != nil && [ data isKindOfClass:[ NSString class ]] && data.length > 0 ) {
        result = CGSizeFromString( data );
    }
    [ sender log:isSet method:cmd key:key type:@"CGSize" value:NSStringFromCGSize( result )];
    return result;
}

void CMDefaultsSetSize( CMDefaults* sender, SEL cmd, CGSize value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = NSStringFromCGSize( value );
    [ sender.userDefaults setObject:data forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"CGSize" value:data ];
}

CGRect CMDefaultGetRect( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = [ sender.userDefaults objectForKey:key ];
    CGRect result = CGRectNull;
    if ( data != nil && [ data isKindOfClass:[ NSString class ]] && data.length > 0 ) {
        result = CGRectFromString( data );
    }
    [ sender log:isSet method:cmd key:key type:@"CGRect" value:NSStringFromCGRect( result )];
    return result;
}

void CMDefaultsSetRect( CMDefaults* sender, SEL cmd, CGRect value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = NSStringFromCGRect( value );
    [ sender.userDefaults setObject:data forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"CGRect" value:data ];
}

NSRange CMDefaultGetRange( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = [ sender.userDefaults objectForKey:key ];
    NSRange result = NSMakeRange( 0, 0 );
    if ( data != nil && [ data isKindOfClass:[ NSString class ]] && data.length > 0 ) {
        result = NSRangeFromString( data );
    }
    [ sender log:isSet method:cmd key:key type:@"NSRange" value:NSStringFromRange( result )];
    return result;
}

void CMDefaultsSetRange( CMDefaults* sender, SEL cmd, NSRange value ) {
    BOOL isSet = YES;
    NSString *key = [ sender authorizedKeyForSelector:cmd isSetter:isSet ];
    NSString *data = NSStringFromRange( value );
    [ sender.userDefaults setObject:data forKey:key ];
    [ sender log:isSet method:cmd key:key type:@"NSRange" value:data ];
}

id CMDefaultsGetObject( CMDefaults* sender, SEL cmd ) {
    BOOL isSet = NO;
    NSString *propName = [ sender propertyNameOfSelector:cmd isSetter:isSet ];
    NSString *key = [ sender authorizeKey:propName ];
    id rawValue = [ sender.userDefaults objectForKey:key ];
    id result = rawValue;
    NSString *desc = [ sender descriptionOfObject:rawValue ];
    NSString *type = [ sender.typeKeyMap objectForKey:propName ];
   
    if ( rawValue != nil && [ sender conformsToProtocol:@protocol( CMDefaultsTransformValue )] &&
        [( id<CMDefaultsTransformValue>)sender shouldTransformValueOfProperty:propName ]) {
        result = [( id<CMDefaultsTransformValue>)sender transformedValue:rawValue OfOfProperty:propName isSaving:isSet ];
        desc = [ NSString stringWithFormat:@"\nRAW_OBJECT: %@\nTRANSFORMED_OBJECT: %@",
                [ sender descriptionOfObject:rawValue ], [ sender descriptionOfObject:result ]];
    }
    [ sender log:isSet method:cmd key:key type:type value:desc ];
    return result;
}

void CMDefaultsSetObject( CMDefaults* sender, SEL cmd, id value ) {
    BOOL isSet = YES;
    NSString *propName = [ sender propertyNameOfSelector:cmd isSetter:isSet ];
    NSString *key = [ sender authorizeKey:propName ];
    NSString *desc = [ sender descriptionOfObject:value ];
    NSString *type = [ sender.typeKeyMap objectForKey:propName ];

    id data = value;
    if (value != nil && [ sender conformsToProtocol:@protocol( CMDefaultsTransformValue )] &&
        [( id<CMDefaultsTransformValue>)sender shouldTransformValueOfProperty:propName ]) {
        data = [( id<CMDefaultsTransformValue>)sender transformedValue:value OfOfProperty:propName isSaving:isSet ];
        desc = [ NSString stringWithFormat:@"\nRAW_OBJECT: %@\nTRANSFORMED_OBJECT: %@",
                [ sender descriptionOfObject:value ], [ sender descriptionOfObject:data ]];
    }
    if ( data == nil ) {
        [ sender.userDefaults removeObjectForKey:key ];
        [ sender log:isSet method:cmd key:key type:@"remove" value:nil ];
        return;
    }
    [ sender.userDefaults setObject:data forKey:key ];
    [ sender log:isSet method:cmd key:key type:type value:desc ];
}

#pragma mark - Swizzle

-( void )swizzleGetterIMP:( IMP )getter setterIMP:( IMP )setter ofProperty:( NSString* )propName
       propertyAttributes:( NSDictionary* )propAttr ownerClass:( Class )ownerClass {
    NSString *getterName = [ propAttr getterName ];
    if ( getterName == nil ) getterName = propName;
    [ self.getterKeyMap setObject:propName forKey:getterName ];
    [ OBJMethod replaceImplementationOfMethod:NSSelectorFromString( getterName )
                                      ofClass:ownerClass
                           withImplementation:getter ];
    NSString *setterName = [ propAttr setterName ];
    if ( setterName == nil ) setterName = [ self setterNameOfProperty:propName ];
    [ self.setterKeyMap setObject:propName forKey:setterName ];
    [ OBJMethod replaceImplementationOfMethod:NSSelectorFromString( setterName )
                                      ofClass:ownerClass
                           withImplementation:setter ];
}

-( void )buildMySelf {
    _setterKeyMap = [ NSMutableDictionary new ];
    _getterKeyMap = [ NSMutableDictionary new ];
    _typeKeyMap = [ NSMutableDictionary new ];
    NSUInteger level = [ OBJCommon countOfLevelsFromClass:[ self class ] toClass:[ CMDefaults class ]];
    if ( level == 0 ) return;
    [ OBJProperty enumeratePropertyOfClass:[ self class ] superClassDeep:level - 1 withBlock:^BOOL( NSString* propertyName, NSMutableDictionary* propertyAttributes, Class ownerClass ) {
        if ([ propertyAttributes isReadOnly ]) return NO;
        switch ( propertyAttributes.type ) {
            case kObjDataTypeChar:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetChar setterIMP:( IMP )CMDefaultsSetChar
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeUnsignedChar:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetUChar setterIMP:( IMP )CMDefaultsSetUChar
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeInt:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetInt setterIMP:( IMP )CMDefaultsSetInt
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeUnsignedInt:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetUInt setterIMP:( IMP )CMDefaultsSetUInt
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeShort:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetShort setterIMP:( IMP )CMDefaultsSetShort
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeUnsignedShort:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetUShort setterIMP:( IMP )CMDefaultsSetUShort
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeLong:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetLong setterIMP:( IMP )CMDefaultsSetLong
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeLongLong:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetLL setterIMP:( IMP )CMDefaultsSetLL
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeUnsignedLong:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetULong setterIMP:( IMP )CMDefaultsSetULong
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeUnsignedLongLong:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetULL setterIMP:( IMP )CMDefaultsSetULL
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeFloat:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetFloat setterIMP:( IMP )CMDefaultsSetFloat
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeDouble:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetDouble setterIMP:( IMP )CMDefaultsSetDouble
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeCppBool:
                [ self swizzleGetterIMP:( IMP )CMDefaultGetBool setterIMP:( IMP )CMDefaultsSetBool
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                break;
            case kObjDataTypeStructure:
                if ([[ propertyAttributes typeDescription ] rangeOfString:@"{CGRect=" ].location == 0 ){
                    [ self swizzleGetterIMP:( IMP )CMDefaultGetRect setterIMP:( IMP )CMDefaultsSetRect
                                 ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                } else if ([[ propertyAttributes typeDescription ] rangeOfString:@"{CGSize=" ].location == 0 ){
                    [ self swizzleGetterIMP:( IMP )CMDefaultGetSize setterIMP:( IMP )CMDefaultsSetSize
                                 ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                } else if ([[ propertyAttributes typeDescription ] rangeOfString:@"{CGPoint=" ].location == 0 ){
                    [ self swizzleGetterIMP:( IMP )CMDefaultGetPoint setterIMP:( IMP )CMDefaultsSetPoint
                                 ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                } else if ([[ propertyAttributes typeDescription ] rangeOfString:@"{_NSRange=" ].location == 0 ){
                    [ self swizzleGetterIMP:( IMP )CMDefaultGetRange setterIMP:( IMP )CMDefaultsSetRange
                                 ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                }
                break;
            case kObjDataTypeObject:
            {
                [ self swizzleGetterIMP:( IMP )CMDefaultsGetObject setterIMP:( IMP )CMDefaultsSetObject
                             ofProperty:propertyName propertyAttributes:propertyAttributes ownerClass:ownerClass ];
                NSString *typeName = NSStringFromClass([ propertyAttributes typeClass ]);
                if ( typeName == nil || typeName.length == 0 ) typeName = @"object";
                [ self.typeKeyMap setObject:typeName forKey:propertyName ];
            }
                break;
            default:
                break;
        }
        return NO;
    }];
}

#pragma mark - Init

+( instancetype )shared {
    static CMDefaults *__sharedInstance = nil;
    if ( __sharedInstance == nil ) {
        __sharedInstance = [ self new ];
    }
    return __sharedInstance;
}

-( instancetype )init {
    if ( self = [ super init ]) {
        _userDefaults = [ NSUserDefaults standardUserDefaults ];
        [ self buildMySelf ];
    }
    return self;
}

-( void )setUserDefaults:( NSUserDefaults* )userDefaults {
    if ( userDefaults == nil ) return;
    _userDefaults = userDefaults;
}

#pragma mark - Internal

/// Setter function name from property name
-( NSString* )setterNameOfProperty:( NSString* )propName {
    return [ NSString stringWithFormat:@"set%@%@:",
            [[ propName substringWithRange:NSMakeRange( 0, 1 )] uppercaseString ],
            [ propName substringFromIndex:1 ]];
}

/// Transformed key to save into NSUserDefaults from property name
-( NSString* )authorizedKeyForSelector:( SEL )sel isSetter:( BOOL )isSetter {
    return [ self authorizeKey:[ self propertyNameOfSelector:sel isSetter:isSetter ]];
}

/// Get property name of property getter/setter function
-( NSString* )propertyNameOfSelector:( SEL )sel isSetter:( BOOL )isSetter {
    NSString *name = NSStringFromSelector( sel );
    if ( isSetter ) {
        name = [ self.setterKeyMap objectForKey:name ];
    } else {
        name = [ self.getterKeyMap objectForKey:name ];
    }
    return name;
}

-( NSString* )descriptionOfObject:( id )object {
    if ( object == nil ) return @"<nil>";
    if ([ object respondsToSelector:@selector( description )]) {
        return [ object description ];
    } else {
        return [ NSString stringWithFormat:@"%@", object ];
    }
}

-( void )log:( BOOL )isSet method:( SEL )cmd key:( NSString* )key type:( NSString* )typeDesc value:( NSString* )valDesc {
    [ CMLogger logAtFile:[ NSStringFromClass( self.class ) UTF8String ]
                atMethod:[ NSStringFromSelector( cmd ) UTF8String ]
                  atLine:0 fromSource:nil withCategory:CMDefaultsLogCategory
                 content:[ NSString stringWithFormat:@"%@ \"%@\" %@: %@",
                          isSet ? @"SET" : @"GET",
                          key, typeDesc, valDesc ]];
}

-( void )reset {
    NSUInteger level = [ OBJCommon countOfLevelsFromClass:[ self class ] toClass:[ CMDefaults class ]];
    if ( level == 0 ) return;
    NSMutableArray *allKeys = [ NSMutableArray new ];
    [ OBJProperty enumeratePropertyOfClass:[ self class ] superClassDeep:level - 1 withBlock:^BOOL( NSString* propertyName, NSMutableDictionary* propertyAttributes, Class ownerClass ) {
        if ([ propertyAttributes isReadOnly ]) return NO;
        NSString *key = [ self authorizeKey:propertyName ];
        [ allKeys addObject:key ];
        return NO;
    }];
    NSMutableString *desc = [ NSMutableString stringWithString:@"REMOVE ALL KEYS:" ];
    for ( NSString * key in allKeys ) {
        [ self.userDefaults removeObjectForKey:key ];
        [ desc appendFormat:@" %@", key ];
    }
    [ CMLogger logAtFile:[ NSStringFromClass( self.class ) UTF8String ]
                atMethod:"reset"
                  atLine:0 fromSource:nil withCategory:CMDefaultsLogCategory
                 content:desc ];
}

#pragma mark - Overridable

-( NSString* )authorizeKey:( NSString* )key {
    return key;
}

@end
