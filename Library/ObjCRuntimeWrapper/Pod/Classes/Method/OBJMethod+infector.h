/**
 @file      OBJMethod+infector.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJMethod.h"

@interface OBJMethod (infector)

/**
 *  Check class implement selector (not care the super class - if super class implements the selector but specified class dones not, return NO)
 *
 *  @param aClass Class to check
 *  @param method Selector to check
 *
 *  @return YES if class implements selector.
 */
+( BOOL )doClass:( nonnull Class )aClass implementMethod:( nonnull SEL )method;
+( BOOL )doClass:( nonnull Class )aClass implementStaticMethod:( nonnull SEL )method;
/**
 *  Switch implementation of 2 methods of same class: when call method1, code in method2 is executed; & reversed.
 *  2 methods must have same pattern (same return type & arguments type).
 *  It's usefull with class category.
 *
 *  @param method1 Method 1
 *  @param method2 Method 2
 *  @param aClass  Class
 *
 *  @return YES if success
 */
+( BOOL )switchImplementationOfMethod:( nonnull SEL )method1 andMethod:( nonnull SEL )method2 ofClass:( nonnull Class )aClass;
+( BOOL )switchImplementationOfClassMethod:( nonnull SEL )method1 andClassMethod:( nonnull SEL )method2 ofClass:( nonnull Class )aClass;
/**
 *  Replace implementation of method
 *
 *  @param method     Target method
 *  @param targetClass Target class
 *  @param newImp      New IMP (a C function with same return type of target method, 1st arg is id (self), 2nd arg is SEL, the rest args is same as target method)
 *  Reference: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtDynamicResolution.html#//apple_ref/doc/uid/TP40008048-CH102-SW1
 *
 *  @return Original IMP of target method
 */
+( nullable IMP )replaceImplementationOfMethod:( nonnull SEL )method ofClass:( nonnull Class )targetClass
                   withImplementation:( nonnull IMP )newImp;
/**
 *  Replace implementation of method with one of other method of other class.
 *  Explain: targetObject is instance of targetClass. sourceObject is instance of sourceClass.
 *  When call [ targetObject method1 ] => code in method2 will be executed, but 'self' in method2 is targetObject (this can be like [ targetObject method2 ];)
 *  And when call [ sourceObject method2 ]; => executed as normal with 'self' in method2 is sourceObject.
 *  2 methods must have same pattern (same return value, args type).
 *
 *  @param method1     Target method
 *  @param targetClass Target class
 *  @param method2     Source method
 *  @param sourceClass Source class
 *
 *  @return Original implementation of target method
 */
+( nullable IMP )replaceImplementationOfMethod:( nonnull SEL )method1 ofClass:( nonnull Class )targetClass
                   withImplementation:( nonnull SEL )method2 fromClass:( nonnull Class )sourceClass;
/**
 *  Add new method for class. Then we can use protocol & type-cast to tell object executed this method.
 *
 *  @param method      Method name. The target class should not implement this method.
 *  @param methodImp   IMP for method (C function)
 *  @param typeDesc    Description about data type of method
 *  (https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1)
 *  @param targetClass Target class
 *
 *  @return YES if success
 */
+( BOOL )addNewMethod:( nonnull SEL )method implementation:( nonnull IMP )methodImp
methodTypeDescription:( nonnull const char* )typeDesc intoClass:( nonnull Class )targetClass;
/**
 *  User method of a class to add into target class
 *
 *  @param method      Method
 *  @param sourceClass Source class
 *  @param targetClass Target class
 *
 *  @return YES if success
 */
+( BOOL )addMethod:( nonnull SEL )method fromClass:( nonnull Class )sourceClass intoClass:( nonnull Class )targetClass;

@end
