/**
 @file      OBJProperty+Mirror.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+Obj2Dic.h"

@interface OBJProperty (Mirror)

/**
 *  Make copy of sourceObj properties then set to equivalent properties of destObj.
 *  Property values of sourceObj should conform to NSCopying (not support NSMutableCopying, except NSMutableString) protocol to make copy. If not, the property will be ignored.
 *  Property values of type NSArray/NSDictionary (& NSMutable_) will be copied by copy each item.
 *
 *  @param sourceObj Object to get values
 *  @param destObj   Object to receive the values
 *  @param rootClass Superclass of sourceObj to get properties.
 */
+( void )mirrorFromObject:( nonnull id )sourceObj toObject:( nonnull id )destObj rootClass:( nullable Class )rootClass;

@end
