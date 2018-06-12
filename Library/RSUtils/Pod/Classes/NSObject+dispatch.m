/**
 @file      NSObject+dispatch.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSObject+dispatch.h"

void execOnMain( void (^block)(void) ){
    dispatch_async( dispatch_get_main_queue(), block );
}

void delayToMain( double seconds, void (^block)(void) ){
    dispatch_after( dispatch_time( DISPATCH_TIME_NOW, ( int64_t )( seconds * NSEC_PER_SEC )), dispatch_get_main_queue(), block );
}

@implementation NSObject (dispatch)

+( void )execOnMain:( void (^)(void) )block; {
    execOnMain( block );
}

-( void )execOnMain:( void (^)(void) )block; {
    execOnMain( block );
}

+( void )delayToMain:( double )seconds exec:( void (^)(void) )block {
    delayToMain( seconds, block );
}

-( void )delayToMain:( double )seconds exec:( void (^)(void) )block {
    delayToMain( seconds, block );
}

@end
