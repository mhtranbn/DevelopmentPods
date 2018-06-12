/**
 @file      OBJMethod.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

// @param methodName    Selector of method
// @param returnType    A string descripes the return data type
// @param argumentsType An array of strings descripe the arguments data type
// @return YES to break the loop of method browsing
typedef BOOL ( ^OBJMethodBlock )( SEL _Nonnull methodName, NSString* _Nonnull returnType, NSArray* _Nonnull argumentsType, Class _Nonnull ownerClass );

@interface OBJMethod : NSObject

/**
 *  Browse methods of class
 *
 *  @param aClass Target class
 *  @param block  Block to execute with each method
 *
 *  @return Number of methods
 */
+( NSUInteger )enumerateMethodOfClass:( nonnull Class )aClass
                            withBlock:( nonnull OBJMethodBlock )block;
+( NSUInteger )enumerateMethodOfClass:( nonnull Class )aClass
                              toClass:( nullable Class )ancestorClass
                            withBlock:( nonnull OBJMethodBlock )block;
+( NSUInteger )enumerateStaticMethodOfClass:( nonnull Class )aClass
                                  withBlock:( nonnull OBJMethodBlock )block;
+( NSUInteger )enumerateStaticMethodOfClass:( nonnull Class )aClass
                                    toClass:( nullable Class )ancestorClass
                                  withBlock:( nonnull OBJMethodBlock )block;

@end
