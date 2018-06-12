/**
 @file      CMDefaults.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const _Nonnull CMDefaultsLogCategory;

@protocol CMDefaultsTransformValue <NSObject>
@required

/**
 @param propertyName Property name
 @return YES if class supports transforming the given property value to usable type value
 */
-( BOOL )shouldTransformValueOfProperty:( nonnull NSString* )propertyName;
/**
 @param propertyName Property name
 @param value Value tro transform
 @param isSaving YES: Transform from raw value to usable type value which can be saved into NSUserDefaults.
 NO: transform value from NSUserDefaults to property type value.
 @return Transformed value.
 */
-( nullable id )transformedValue:( nonnull id )value OfOfProperty:( nonnull NSString* )propertyName isSaving:( BOOL )isSaving;

@end

/**
 Base class to make object whose properties are get/set directly from/to NSUserDefaults.
 
 Usage:
 
 - Make a subclass of CMDefaults. Subclass must call `[super init]` in any `init` method.
 An app should have only one shared instance.
 
 - Define properties (Swift property must come with `dynamic`): property name is the key to save into NSUserDefaults.
 Subclass can override func `authorizeKey:` to transform the key name.
 
 - Data type must be available in ObjC (so not support data type like `Int?`, `Float?`).
 Optional objects (`String?` also) are fine. Data type also must be supported by NSUserDefaults
 (NSString, NSData, NSURL, NSDate, NSNumber, NSArray, NSDictionary).
 Also support CGRect, CGPoint, CGSize, NSRange. Subclass should implement `CMDefaultsTransformValue`
 for support other data type.
 */
@interface CMDefaults : NSObject

@property ( nonatomic, strong, nonnull ) NSUserDefaults *userDefaults;

+( nonnull instancetype )shared;
    
/**
 Subclass can override this method to transform the value of key to save into NSUserDefaults
 (eg. append User name to save data for each user)

 @param key Original key name
 @return New key name. Default is the original key name.
 */
-( nonnull NSString* )authorizeKey:( nonnull NSString* )key;

/**
 Remove all defined keys from NSUserDefaults
 */
-( void )reset;

@end
