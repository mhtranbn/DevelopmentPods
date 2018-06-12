/**
 @file      OBJProperty+Dynamic.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty.h"

@interface NSObject (OBJProperty)

@property ( nonatomic, strong, nullable ) NSMutableDictionary *customProperties;

@end

@interface OBJProperty (Dynamic)

/**
 *  Add GET and SET method for dynamic properties of specified class if needed.
 *  Property Data type allowed: id (object), number type ( int, float, double, long,
 NSInteger, CGFloat ...), CGRect, CGPoint, CGSize, NSRange.
 *  With other data types we can using object to store value (eg. NSValue or NSNumber).
 *
 *  @param targetClass Class to add dynamic properties method implement.
 *
 *  @note  Example, we implement a class category to extend the property
 
 (a)interface NSObject (custom)
 
 (a)property ( nonatomic, retain/strong ) NSString *propertyName;
 
 (a)end
 
 (a)implement NSObject (custom)
 
 (a)dynamic propertyName;
 
 // Normally we have to implement GET & SET methods here
 
 (a)end
 
 *  Add methods before use (eg. AppLaunch)
 
 [ OBJProperty applyDynamicPropertiesOfClass:[ NSObject class ]];
 */
+( void )applyDynamicProperties:( nonnull NSArray<NSString*>* )propNames ofClass:( nonnull Class )targetClass;

/**
 *  Add a dynamic property for class
 *
 *  @param name        Name of property
 *  @param type        Data type description string
 *  @param targetClass Target class
 *
 *  @return BOOL if success
 */
+( BOOL )addDynamicPropertyWithName:( nonnull NSString* )name dataTypeDescription:( nonnull NSString* )type
                            ofClass:( nonnull Class )targetClass;

@end
