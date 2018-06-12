/**
 @file      NSObject+dispatch.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

/**
 *  Use dispatch_async to execute the given code block on main_queue.
 *
 *  @param block Code block to execute.
 */
extern void execOnMain( void (^block)(void) );
/**
 *  Use dispatch_after to execute the given code block on main_queue, delay with given time in seconds.
 *
 *  @param seconds Time (second) to delay.
 *  @param block  Code block to execute.
 */
extern void delayToMain( double seconds, void (^block)(void) );

@interface NSObject (dispatch)

/**
 *  Use dispatch_async to execute the given code block on main_queue.
 *
 *  @param block Code block to execute.
 */
+( void )execOnMain:( void (^)(void) )block;
/**
 *  Use dispatch_async to execute the given code block on main_queue.
 *
 *  @param block Code block to execute.
 */
-( void )execOnMain:( void (^)(void) )block;
/**
 *  Use dispatch_after to execute the given code block on main_queue, delay with given time in seconds.
 *
 *  @param seconds Time (second) to delay.
 *  @param block  Code block to execute.
 */
+( void )delayToMain:( double )seconds exec:( void (^)(void) )block;
/**
 *  Use dispatch_after to execute the given code block on main_queue, delay with given time in seconds.
 *
 *  @param seconds Time (second) to delay.
 *  @param block  Code block to execute.
 */
-( void )delayToMain:( double )seconds exec:( void (^)(void) )block;

@end
