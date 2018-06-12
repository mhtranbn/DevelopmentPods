/**
 @file      OBJMethod.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJMethod.h"
#import <objc/runtime.h>

@implementation OBJMethod

+( NSUInteger )enumerateMethodOfClass:( Class )aClass withBlock:( OBJMethodBlock )block ownerClass:( Class )ownClass {
    if ( block == nil ) return 0;
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList( aClass, &outCount );
    if ( methods ) {
        NSUInteger result = 0;
        for ( unsigned int i = 0; i < outCount; i++ ) {
            Method method = methods[i];
            SEL name = method_getName( method );
            char *s = method_copyReturnType( method );
            NSString *returnType = [ NSString stringWithUTF8String:s ];
            free( s );
            NSMutableArray *argsList = nil;
            unsigned int argNum = method_getNumberOfArguments( method );
            if ( argNum > 2 ) {
                argsList = [ NSMutableArray array ];
                for ( unsigned int i = 2; i < argNum; i++ ) {
                    s = method_copyArgumentType( method, i );
                    [ argsList addObject:[ NSString stringWithUTF8String:s ]];
                    free( s );
                }
            }
            result += 1;
            if ( block( name, returnType, argsList, ownClass ? ownClass : aClass ))
                break;
        }
        free( methods );
        return result;
    }
    return 0;
}

+( NSUInteger )enumerateMethodOfClass:( Class )aClass withBlock:( OBJMethodBlock )block {
    return [ self enumerateMethodOfClass:aClass withBlock:block ownerClass:nil ];
}

+( NSUInteger )enumerateMethodOfClass:( Class )aClass toClass:( Class )ancestorClass withBlock:( OBJMethodBlock )block {
    NSUInteger result = [ self enumerateMethodOfClass:aClass withBlock:block ];
    if ( ancestorClass && [ aClass isSubclassOfClass:ancestorClass ] && aClass != ancestorClass ) {
        Class cls = aClass;
        do {
            cls = [ cls superclass ];
            if ( cls == nil ) break;
            result += [ self enumerateMethodOfClass:cls withBlock:block ];
        } while ( cls != ancestorClass && cls != [ NSObject class ]);
    }
    return result;
}

+( NSUInteger )enumerateStaticMethodOfClass:( Class )aClass withBlock:( OBJMethodBlock )block {
    Class classOfClass = object_getClass( aClass );
    if ( classOfClass ) {
        return [ self enumerateMethodOfClass:classOfClass withBlock:block ownerClass:aClass ];
    }
    return 0;
}

+( NSUInteger )enumerateStaticMethodOfClass:( Class )aClass toClass:( Class )ancestorClass withBlock:( OBJMethodBlock )block {
    NSUInteger result = [ self enumerateStaticMethodOfClass:aClass withBlock:block ];
    if ( ancestorClass && [ aClass isSubclassOfClass:ancestorClass ] && aClass != ancestorClass ) {
        Class cls = aClass;
        do {
            cls = [ cls superclass ];
            if ( cls == nil ) break;
            result += [ self enumerateStaticMethodOfClass:cls withBlock:block ];
        } while ( cls != ancestorClass && cls != [ NSObject class ]);
    }
    return result;
}

@end
