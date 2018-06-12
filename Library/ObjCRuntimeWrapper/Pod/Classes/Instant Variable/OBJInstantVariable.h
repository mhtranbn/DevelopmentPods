/**
 @file      OBJInstantVariable.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import Foundation;
@import ObjectiveC;

typedef BOOL ( ^OBJInstantVariableBlock )(  NSString* _Nonnull ivarName, NSString* _Nonnull ivarType, Class _Nonnull ownerClass );

@interface OBJInstantVariable : NSObject

+( NSUInteger )enumerateInstantVariableOfClass:( nonnull Class )aClass
                                     withBlock:( nonnull OBJInstantVariableBlock )ivarBlock;
+( nullable id )getInstantVariableValue:( nonnull NSString* )name ofObject:( nonnull id )obj;

@end
