/**
 @file      AppUI_Kit_Switch.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#ifndef testMayGridViewMac_AppUI_Kit_Switch_h
#define testMayGridViewMac_AppUI_Kit_Switch_h

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

// Graphic
#define OBJRect     CGRect
#define OBJSize     CGSize
#define OBJPoint 	CGPoint

#define _OBJRect_   "CGRect"
#define _OBJSize_   "CGSize"
#define _OBJPoint_  "CGPoint"

#define OBJRectZero     CGRectZero
#define OBJSizeZero     CGSizeZero
#define OBJPointZero    CGPointZero

#define OBJPointMake( x, y )        CGPointMake( (x), (y) )
#define OBJSizeMake( w, h )         CGSizeMake( (w), (h) )
#define OBJRectMake( x, y, w, h )   CGRectMake( (x), (y), (w), (h) )

#define OBJRectFromString( s )      CGRectFromString( (s) )
#define OBJSizeFromString( s )      CGSizeFromString( (s) )
#define OBJPointFromString( s )     CGPointFromString( (s) )
#define NSStringFromOBJRect( r )    NSStringFromCGRect( (r) )
#define NSStringFromOBJSize( s )    NSStringFromCGSize( (s) )
#define NSStringFromOBJPoint( p )   NSStringFromCGPoint( (p) )

// NSValue with graphic
#define valueWithOBJRect( rect )    valueWithCGRect:( (rect) )
#define valueWithOBJSize( size )    valueWithCGSize:( (size) )
#define valueWithOBJPoint( point )  valueWithCGPoint:( (point) )
#define OBJRectValue    CGRectValue
#define OBJSizeValue    CGSizeValue
#define OBJPointValue   CGPointValue

// UIColor
#define OBJColor        UIColor
#define _OBJColor_      "UIColor"

// UIView
#define OBJView                     UIView
#define objViewSetNeedsLayout       setNeedsLayout
#define objViewLayoutSubviews       layoutSubviews

#else

#import <Cocoa/Cocoa.h>

// Graphic
#define OBJRect     NSRect
#define OBJSize     NSSize
#define OBJPoint    NSPoint

#define _OBJRect_   "CGRect"
#define _OBJSize_   "CGSize"
#define _OBJPoint_  "CGPoint"

#define OBJRectZero     NSZeroRect
#define OBJSizeZero     NSZeroSize
#define OBJPointZero    NSZeroPoint

#define OBJPointMake( x, y )        NSMakePoint( (x), (y) )
#define OBJSizeMake( w, h )         NSMakeSize( (w), (h) )
#define OBJRectMake( x, y, w, h )   NSMakeRect( (x), (y), (w), (h) )

#define OBJRectFromString( s )      NSRectFromString( (s) )
#define OBJSizeFromString( s )      NSSizeFromString( (s) )
#define OBJPointFromString( s )     NSPointFromString( (s) )
#define NSStringFromOBJRect( r )    NSStringFromRect( (r) )
#define NSStringFromOBJSize( s )    NSStringFromSize( (s) )
#define NSStringFromOBJPoint( p )   NSStringFromPoint( (p) )

// NSValue
#define valueWithOBJRect( rect )    valueWithRect:( (rect) )
#define valueWithOBJSize( size )    valueWithSize:( (size) )
#define valueWithOBJPoint( point )  valueWithPoint:( (point) )
#define OBJRectValue    rectValue
#define OBJSizeValue    sizeValue
#define OBJPointValue   pointValue

// NSColor
#define OBJColor        NSColor
#define _OBJColor_      "NSColor"

// NSView
#define OBJView                     NSView
#define objViewSetNeedsLayout       setNeedsLayout:YES
#define objViewLayoutSubviews       layout

#endif

#endif
