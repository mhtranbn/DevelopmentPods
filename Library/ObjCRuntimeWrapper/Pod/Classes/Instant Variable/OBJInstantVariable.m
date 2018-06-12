/**
 @file      OBJInstantVariable.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJInstantVariable.h"

@implementation OBJInstantVariable

+( NSUInteger )enumerateInstantVariableOfClass:( Class )aClass withPrivateBlock:( BOOL (^)(Ivar) )ivarBlock {
    if ( aClass == nil || ivarBlock == nil ) return 0;
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList( aClass, &count );
    if ( ivars != nil ){
        for ( unsigned int i = 0; i < count; i++ ) {
            Ivar ivar = ivars[i];
            if ( ivarBlock( ivar )) break;
        }
        free( ivars );
    }
    NSUInteger result = count;
    return result;
}

+( NSUInteger )enumerateInstantVariableOfClass:( Class )aClass withBlock:( OBJInstantVariableBlock )ivarBlock {
    return [ self enumerateInstantVariableOfClass:aClass withPrivateBlock:^BOOL( Ivar ivar ) {
        const char *name = ivar_getName( ivar );
        const char *type = ivar_getTypeEncoding( ivar );
        return ivarBlock([ NSString stringWithUTF8String:name ], [ NSString stringWithUTF8String:type ], aClass );
    }];
}

+( id )getInstantVariableValue:( NSString* )name ofObject:( id )obj {
    Class cls = [ obj class ];
    if ( cls == nil ) return nil;
    __block id result = nil;
    [ self enumerateInstantVariableOfClass:cls withPrivateBlock:^BOOL( Ivar ivar ) {
        NSString *ivarName = [ NSString stringWithUTF8String:ivar_getName( ivar )];
        if ([ ivarName isEqualToString:name ]) {
            result = object_getIvar( obj, ivar );
            return YES;
        }
        return NO;
    }];
    return result;
}

@end
