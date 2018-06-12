/**
 @file      OBJMethod+infector.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJMethod+infector.h"
#import <objc/runtime.h>

@implementation OBJMethod (infector)

+( BOOL )doClass:( Class )aClass implementMethod:( SEL )method {
    __block BOOL result = NO;
    [ self enumerateMethodOfClass:aClass withBlock:^BOOL( SEL methodName, NSString *returnType, NSArray *argumentsType, __unsafe_unretained Class ownerClass ) {
        if ( method == methodName ) {
            result = YES;
            return YES;
        }
        return NO;
    }];
    return result;
}

+( BOOL )doClass:( Class )aClass implementStaticMethod:( SEL )method {
    Class classOfClass = object_getClass( aClass );
    if ( classOfClass ) {
        return [ self doClass:classOfClass implementMethod:method ];
    }
    return NO;
}

+( BOOL )switchImplementationOfMethod:( SEL )method1 andMethod:( SEL )method2 ofClass:( Class )aClass {
    Method mtd1 = class_getInstanceMethod( aClass, method1 );
    Method mtd2 = class_getInstanceMethod( aClass, method2 );
    if ( mtd1 && mtd2 ) {
        const char *type1 = method_getTypeEncoding( mtd1 );
        const char *type2 = method_getTypeEncoding( mtd2 );
        if ( strcmp( type1, type2 ) == 0 ) {
            method_exchangeImplementations( mtd1, mtd2 );
            return YES;
        }
    }
    return NO;
}

+( BOOL )switchImplementationOfClassMethod:( SEL )method1 andClassMethod:( SEL )method2 ofClass:( Class )aClass {
    Method mtd1 = class_getClassMethod( aClass, method1 );
    Method mtd2 = class_getClassMethod( aClass, method2 );
    if ( mtd1 && mtd2 ) {
        const char *type1 = method_getTypeEncoding( mtd1 );
        const char *type2 = method_getTypeEncoding( mtd2 );
        if ( strcmp( type1, type2 ) == 0 ) {
            method_exchangeImplementations( mtd1, mtd2 );
            return YES;
        }
    }
    return NO;
}

+( IMP )replaceImplementationOfMethod:( SEL )method ofClass:( Class )targetClass withImplementation:( IMP )newImp {
    if ( newImp == nil ) return nil;
    Method mtd = class_getInstanceMethod( targetClass, method );
    IMP originalImp = class_getMethodImplementation( targetClass, method );
    if ( mtd && originalImp ) {
        method_setImplementation( mtd, newImp );
        return originalImp;
    }
    return nil;
}

+( IMP )replaceImplementationOfMethod:( SEL )method1 ofClass:( Class )targetClass
                   withImplementation:( SEL )method2 fromClass:( Class )sourceClass {
    Method mtd1 = class_getInstanceMethod( targetClass, method1 );
    Method mtd2 = class_getInstanceMethod( sourceClass, method2 );
    if ( mtd1 && mtd2 ) {
        const char *type1 = method_getTypeEncoding( mtd1 );
        const char *type2 = method_getTypeEncoding( mtd2 );
        if ( strcmp( type1, type2 ) == 0 ) {
            IMP originalImp = class_getMethodImplementation( targetClass, method1 );
            IMP sourceImp = class_getMethodImplementation( sourceClass, method2 );
            if ( originalImp && sourceImp ) {
                method_setImplementation( mtd1, sourceImp );
                return originalImp;
            }
        }
    }
    return nil;
}

+( BOOL )addNewMethod:( SEL )method implementation:( IMP )methodImp
methodTypeDescription:(const char *)typeDesc intoClass:( Class )targetClass {
    if ([ self doClass:targetClass implementMethod:method ]) return NO;
    class_addMethod( targetClass, method, methodImp, typeDesc );
    return [ self doClass:targetClass implementMethod:method ];
}

+( BOOL )addMethod:( SEL )method fromClass:( Class )sourceClass intoClass:( Class )targetClass {
    if ([ self doClass:targetClass implementMethod:method ]) return NO;
    IMP methodImp = class_getMethodImplementation( sourceClass, method );
    Method mtd = class_getInstanceMethod( sourceClass, method );
    if ( methodImp && mtd ) {
        const char *type = method_getTypeEncoding( mtd );
        class_addMethod( targetClass, method, methodImp, type );
        return [ self doClass:targetClass implementMethod:method ];
    }
    return NO;
}

@end
