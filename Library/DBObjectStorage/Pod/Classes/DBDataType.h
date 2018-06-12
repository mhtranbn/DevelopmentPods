/**
 @file      DBDataType.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import UIKit;

@interface DBInteger: NSObject

@property ( nonatomic, readonly ) NSInteger value;

-( nonnull instancetype )initWithValue:( NSInteger )value;

@end

@interface DBBool: NSObject

@property ( nonatomic, readonly ) BOOL value;

-( nonnull instancetype )initWithValue:( BOOL )value;

-( NSInteger )intValue;
-( nonnull NSString* )stringValue;

@end

@interface DBReal: NSObject

@property ( nonatomic, readonly ) double doubleValue;
@property ( nonatomic, readonly ) float floatValue;
@property ( nonatomic, readonly ) CGFloat cgFloatValue;

-( nonnull instancetype )initWithDouble:( double )value;
-( nonnull instancetype )initWithFloat:( float )value;
-( nonnull instancetype )initWithCGFloat:( CGFloat )value;

@end


@interface NSNumber (DB)

-( nonnull instancetype )initWithDBInt:( nonnull DBInteger* )dbInt;
-( nonnull DBInteger* )dbIntValue;
-( nonnull instancetype )initWithDBBool:( nonnull DBBool* )dbBool;
-( nonnull DBBool* )dbBoolValue;
-( nonnull instancetype )initWithDBReal:( nonnull DBReal* )dbBool;
-( nonnull DBReal* )dbRealValue;

@end
