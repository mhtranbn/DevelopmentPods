/**
 @file      NSString+DB.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

@interface NSString(DB)

/// @return `null` if value is nil, `"value"` if isText = YES, otherwise `'value'`
+( nonnull instancetype )dbValueQuoted:( nullable id )value isTextType:( BOOL )isText;
/// @return `"column"`
+( nonnull instancetype )dbColumnQuoted:( nonnull NSString* )column;
/// @return `"table"."column"`
+( nonnull instancetype )dbTableQuoted:( nonnull NSString* )table column:( nonnull NSString* )column;

/// Double quoted
-( nonnull instancetype )dbIdentifierQuoted;
/// Single quoted
-( nonnull instancetype )dbValueQuoted;

@end
