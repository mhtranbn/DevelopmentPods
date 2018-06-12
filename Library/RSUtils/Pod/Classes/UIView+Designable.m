/**
 @file      UIView+Designable.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "UIView+Designable.h"

@implementation UIView (Designable)

-( void )setCornerRadius:( CGFloat )cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

-( CGFloat )cornerRadius {
    return self.layer.cornerRadius;
}

-( void )setBorderWidth:( CGFloat )borderWidth {
    self.layer.borderWidth = borderWidth;
}

-( CGFloat )borderWidth {
    return self.layer.borderWidth;
}

-( void )setBorderColor:( UIColor* )borderColor {
    self.layer.borderColor = [ borderColor CGColor ];
}

-( UIColor* )borderColor {
    if ( self.layer.borderColor != nil ) return [ UIColor colorWithCGColor:self.layer.borderColor ];
    return nil;
}

-( void )setShadowColor:( UIColor* )shadowColor {
    self.layer.shadowColor = [ shadowColor CGColor ];
}

-( UIColor* )shadowColor {
    if ( self.layer.shadowColor != nil ) return [ UIColor colorWithCGColor:self.layer.shadowColor ];
    return nil;
}

-( void )setShadowOpacity:( CGFloat )shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

-( CGFloat )shadowOpacity {
    return self.layer.shadowOpacity;
}

-( void )setShadowRadius:( CGFloat )shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

-( CGFloat )shadowRadius {
    return self.layer.shadowRadius;
}

-( void )setShadowOffset:( CGSize )shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

-( CGSize )shadowOffset {
    return self.layer.shadowOffset;
}

@end
