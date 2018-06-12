/**
 @file      NWRequestData+JSON.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestData.h"

@interface NWRequestData (JSON)

/**
 Make request JSON data from object using NSJSONSerialization

 @param object Array<Dictonary>, Dictionary will be converted directly using NSJSONSerialization.
 Custom object will be converted to dictionary using ObjCRuntimeWrapper.OBJProperty+Obj2Dic
 before be converted to JSON. Custom object can implement `OBJPropertyObj2DicTransform` to transform
 value to supported type.
 @param error Error
 @return New instance
 */
+( nullable instancetype )jsonDataWithObject:( nonnull id )object error:( NSError *_Nullable *_Nullable )error;
+( nullable instancetype )jsonDataWithObject:( nonnull id )object rootClass:( nullable Class )objRootClass
                                       error:( NSError *_Nullable *_Nullable )error;

@end
