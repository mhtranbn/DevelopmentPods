/**
 @file      OBJProperty+Dic2Obj.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+CustomAttributes.h"

@protocol OBJPropertyDic2ObjTransform <NSObject>
@optional

-( BOOL )shouldTransformValue:( nonnull id )valueFromDic forProperty:( nonnull NSString* )propertyName;
-( nullable id )transformedValueOf:( nonnull id )valueFromDic forProperty:( nonnull NSString* )propertyName;

@end

@protocol OBJPropertyDic2ObjInstanceSource <NSObject>
@optional

+( nullable id )objectToFillDataFromData:( nonnull NSDictionary* )dataDic;
-( NSUInteger )numberOfSuperClassLevelToFillDataFrom:( nonnull NSDictionary* )dataDic;

@end

@interface OBJProperty (Object)

/**
 *  Create new object from given class then fill data from given dataDic into object.
 *  If objClass does not implement protocol "OBJPropertyDic2ObjInstanceSource", new object will be created by '[objClass new]'.
 *  If objClass returns nil from 'objectToFillDataFromData:', return nil (no object will be filled data).
 *  If objClass returns an object from 'objectToFillDataFromData:', use that object to fill data.
 *  Fill data flow:
 *	Read dataDic and set value to given object. Datatype of dataDic value should be compatible with property datatype.
 *  Convert NSNumber, NSString to basic data type (int, long, float ...), CGRect, CGPoint..., CGColor (rgb hexa eg. ffffff)
 *  If property type is array, property attribute defines item class, value from dataDic is array of dictionaries
 *  => create object with given class and use dictionary to fill value to object.
 *  Similar, if property type is dictionary, property attribute defines item class, value from dataDic is dictionary of dictionaries
 *  => create object with given class and use dictonary from value to fill.
 *  But common, property is object, value is dictionary => create new object and use value to fill.
 *  Object class can implement the protocol "OBJPropertyDic2ObjTransform" to tranform special data to supported data to fill to object.
 *  Creating child object use this function too.
 *
 *  @param objClass     Class to create object
 *  @param dataDic      Data to fill into object
 *  @param isNeedReport YES to log the filling job
 *
 *  @return Object
 */
+( nullable id )objectFromClass:( nonnull Class )objClass fromDictionary:( nonnull NSDictionary* )dataDic
                         report:( BOOL )isNeedReport;
// Above function with isNeedReport=NO
+( nullable id )objectFromClass:( nonnull Class )objClass fromDictionary:( nonnull NSDictionary* )dataDic;
// Fill data into given instance
+( void )fillDataIntoObject:( nonnull id )object fromDictionary:( nonnull NSDictionary* )dataDic
                     report:( BOOL )isNeedReport;
// Above function with isNeedReport=NO
+( void )fillDataIntoObject:( nonnull id )object fromDictionary:( nonnull NSDictionary* )dataDic;

@end
