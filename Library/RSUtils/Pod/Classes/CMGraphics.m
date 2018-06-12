/**
 @file      CMGraphics.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "CMGraphics.h"

NSInteger NSIntegerRandomNumberBetween( NSInteger minValue, NSInteger maxValue ){
    NSInteger i = arc4random() % ( maxValue + 1 - minValue );
    return i + minValue;
}

CGPoint CGPointCenterOfRect( CGRect rect ){
    return CGPointMake( rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2 );
}

double CGPointDistanceBetween2Points( CGPoint point1, CGPoint point2 ){
    return sqrt( pow( point1.x - point2.x, 2 ) + pow( point1.y - point2.y, 2 ));
}

CGRect CGRectMoveToCenter( CGRect rect, CGPoint center ){
    rect.origin.x = center.x - rect.size.width / 2;
    rect.origin.y = center.y - rect.size.height / 2;
    return rect;
}

CGRect CGRectMakeRectCenterOfRect( CGRect rect, CGSize size ){
    rect.origin.x += ( rect.size.width - size.width ) / 2;
    rect.origin.y += ( rect.size.height - size.height ) / 2;
    rect.size = size;
    return rect;
}

CGSize CGSizeMakeFillSize( CGSize sizeToFill, CGSize sizeRatio ){
    CGSize result = sizeToFill;
    result.height = result.width * sizeRatio.height / sizeRatio.width;
    if ( result.height < sizeToFill.height ){
        result.height = sizeToFill.height;
        result.width = result.height * sizeRatio.width / sizeRatio.height;
    }
    return result;
}

CGRect CGRectMakeFillWithSize( CGRect rect, CGSize size ){
    CGSize fillSize = CGSizeMakeFillSize( rect.size, size );
    return CGRectMakeRectCenterOfRect( rect, fillSize );
}

CGSize CGSizeMakeFitSize( CGSize sizeToFit, CGSize sizeRatio ){
    CGSize result = sizeToFit;
    result.height = result.width * sizeRatio.height / sizeRatio.width;
    if ( result.height > sizeToFit.height ){
        result.height = sizeToFit.height;
        result.width = result.height * sizeRatio.width / sizeRatio.height;
    }
    return result;
}

CGRect CGRectMakeFitWithSize( CGRect rect, CGSize size ){
    CGSize fitSize = CGSizeMakeFitSize( rect.size, size );
    return CGRectMakeRectCenterOfRect( rect, fitSize );
}

CGFloat CGSizeDiagonalLength( CGSize size ){
    return sqrt( pow( size.width, 2 ) + pow( size.height, 2 ));
}

CGSize CGSizeMakeFitCircle( CGFloat radius, CGSize sizeRatio ){
    CGFloat dia = CGSizeDiagonalLength( sizeRatio ) / 2;
    CGFloat ratio = radius / dia;
    sizeRatio.width *= ratio;
    sizeRatio.height *= ratio;
    return sizeRatio;
}

CGRect CGRectMakeFitCircle( CGPoint center, CGFloat radius, CGSize sizeRatio ){
    sizeRatio = CGSizeMakeFitCircle( radius, sizeRatio );
    CGRect result = CGRectZero;
    result.size = sizeRatio;
    return CGRectMoveToCenter( result, center );
}

CGSize CGSizeMakeFillCircle( CGFloat radius, CGSize sizeRatio ){
    CGFloat dia = radius * 2;
    return CGSizeMakeFillSize( CGSizeMake( dia, dia ), sizeRatio );
}

CGRect CGRectMakeFillCircle( CGPoint center, CGFloat radius, CGSize sizeRatio ){
    sizeRatio = CGSizeMakeFillCircle( radius, sizeRatio );
    CGRect result = CGRectZero;
    result.size = sizeRatio;
    return CGRectMoveToCenter( result, center );
}

UIColor* RGB( UInt8 red, UInt8 green, UInt8 blue ){
    return [ UIColor colorWithRed:red / 255.0f
                            green:green / 255.0f
                             blue:blue / 255.0f
                            alpha:1.0f ];
}

UIColor* RGBA( UInt8 red, UInt8 green, UInt8 blue, float alpha ){
    return [ UIColor colorWithRed:red / 255.0f
                            green:green / 255.0f
                             blue:blue / 255.0f
                            alpha:alpha ];
}

UIColor* ARGB( UInt32 hexa ){
    float alpha = (( hexa >> 24 ) & 0xFF ) * 1.0f;
    alpha = alpha / 0xFF;
    UInt8 red = ( hexa >> 16 ) & 0xFF;
    UInt8 green = ( hexa >> 8 ) & 0xFF;
    UInt8 blue = hexa & 0xFF;
    return RGBA( red, green, blue, alpha );
}

UIColor* RGBa( UInt32 hexa ){
    float alpha = ( hexa & 0xFF ) * 1.0f;
    alpha = alpha / 0xFF;
    UInt8 red = ( hexa >> 24 ) & 0xFF;
    UInt8 green = ( hexa >> 16 ) & 0xFF;
    UInt8 blue = ( hexa >> 8 ) & 0xFF;
    return RGBA( red, green, blue, alpha );
}

// 2D graphic Math

double CGVectorFixAngleSinCosValue( double a ){
    if ( a > 1.0f ) a = 1.0f;
    if ( a < -1.0f ) a = -1.0f;
    return a;
}

CGVector CGVectorOX() {
    return CGVectorMake(1, 0);
}

CGVector CGVectorOY() {
    return CGVectorMake(0, 1);
}

CGVector CGVectorMakeFromPoint( CGPoint p ){
    return CGVectorMakeFromPoints( CGPointZero, p );
}

CGVector CGVectorMakeFromPoints( CGPoint p0, CGPoint p1 ){
    return CGVectorMake( p1.x - p0.x, p1.y - p0.y );
}

double CGVectorGetLength( CGVector vector ){
    return CGPointDistanceBetween2Points( CGPointMake( vector.dx, vector.dy ), CGPointZero );
}

double CGVectorGetCrossProduct( CGVector vec0, CGVector vec1 ){
    return vec0.dx * vec1.dy - vec0.dy * vec1.dx;
}

double CGVectorGetDotProduct( CGVector vec0, CGVector vec1 ){
    return vec0.dx * vec1.dx + vec0.dy * vec1.dy;
}

double CGVectorGetAngleBetweenVectors( CGVector vec0, CGVector vec1 ){
    double dot = CGVectorGetDotProduct( vec0, vec1 );
    double l1 = CGVectorGetLength( vec0 );
    double l2 = CGVectorGetLength( vec1 );
    double cross = CGVectorGetCrossProduct( vec0, vec1 );
    double angle = CGVectorFixAngleSinCosValue( dot / ( l1 * l2 ));
    // Still reason of double division error
    angle = acos( angle );
    if ( cross <= 0 )
        return angle;
    else
        return 2 * M_PI - angle;
}

BOOL CGCheckPointMiddle( CGPoint pt0, CGPoint middlePt, CGPoint pt1 ){
    return ( middlePt.x <= MAX( pt0.x, pt1.x ) && middlePt.x >= MIN( pt0.x, pt1.x ) && middlePt.y <= MAX( pt0.y, pt1.y ) && middlePt.y >= MIN( pt0.y, pt1.y ));
}

// http://www.codeproject.com/Tips/862988/Find-the-Intersection-Point-of-Two-Line-Segments
CGIntersectionType CGGetIntersectionOfSegments( CGPoint p00, CGPoint p01, CGPoint p10, CGPoint p11, CGPoint* intersection ){
    CGVector vec0 = CGVectorMakeFromPoints( p00, p01 );
    CGVector vec1 = CGVectorMakeFromPoints( p10, p11 );
    CGVector vec2 = CGVectorMakeFromPoints( p00, p10 );
    double cross0 = CGVectorGetCrossProduct( vec0, vec1 );
    double abs0 = ABS( cross0 );
    double cross1 = CGVectorGetCrossProduct( vec2, vec0 );
    double abs1 = ABS( cross1 );
    double zero = pow( 10, -10 );
    if ( abs0 < zero && abs1 < zero ) return kCGCollinear; // 2 segments are collinear
    if ( abs0 < zero && abs1 >= zero ) return kCGParallel; // 2 segements are parallel
    double cross2 = CGVectorGetCrossProduct( vec2, vec1 );
    double t = cross2 / cross0;
    double u = cross1 / cross0;
    if ( abs0 >= zero && ( 0 <= t && t <= 1 ) && ( 0 <= u && u <= 1 )){
        if ( intersection != nil ){
            (*intersection).x = p00.x + t * vec0.dx;
            (*intersection).y = p00.y + t * vec0.dy;
        }
        return kCGIntersection;
    }
    return kCGUnknown;
}

BOOL CGPointIsOnEdgeOfRect( CGPoint pt, CGRect rect ) {
    CGPoint pt0 = rect.origin;
    CGPoint pt1 = CGPointMake( rect.origin.x, CGRectGetMaxY( rect ));
    if ( pt.x == pt0.x && CGCheckPointMiddle( pt0, pt, pt1 )){
        return YES;
    }
    pt0 = rect.origin;
    pt1 = CGPointMake( CGRectGetMaxX( rect ), rect.origin.y );
    if ( pt.y == pt0.y && CGCheckPointMiddle( pt0, pt, pt1 )){
        return YES;
    }
    pt0 = CGPointMake( rect.origin.x, CGRectGetMaxY( rect ));
    pt1 = CGPointMake( CGRectGetMaxX( rect ), CGRectGetMaxY( rect ));
    if ( pt.y == pt0.y && CGCheckPointMiddle( pt0, pt, pt1 )){
        return YES;
    }
    pt0 = CGPointMake( CGRectGetMaxX( rect ), rect.origin.y );
    pt1 = CGPointMake( CGRectGetMaxX( rect ), CGRectGetMaxY( rect ));
    if ( pt.x == pt0.x && CGCheckPointMiddle( pt0, pt, pt1 )){
        return YES;
    }
    return NO;
}

BOOL CGGetIntersectionOfSegmentRect( CGPoint pt0, CGPoint pt1, CGRect rect, CGPoint* intersection ) {
    if ( CGPointEqualToPoint( pt0, pt1 )) {
        if ( CGPointIsOnEdgeOfRect( pt0, rect )) {
            if ( intersection != nil ) {
                *intersection = pt0;
            }
            return YES;
        }
    } else {
        CGPoint interPoint = CGPointZero;
        CGIntersectionType type = CGGetIntersectionOfSegments( pt0, pt1,
                                                              rect.origin, CGPointMake( rect.origin.x, CGRectGetMaxY(rect) ),
                                                              &interPoint );
        if ( type == kCGIntersection && CGCheckPointMiddle( pt0, interPoint, pt1 )) {
            if ( intersection != nil ) {
                *intersection = interPoint;
            }
            return YES;
        }
        type = CGGetIntersectionOfSegments( pt0, pt1,
                                           rect.origin, CGPointMake( CGRectGetMaxX(rect), rect.origin.y ),
                                           &interPoint );
        if ( type == kCGIntersection && CGCheckPointMiddle( pt0, interPoint, pt1 )) {
            if ( intersection != nil ) {
                *intersection = interPoint;
            }
            return YES;
        }
        type = CGGetIntersectionOfSegments( pt0, pt1,
                                           CGPointMake( CGRectGetMaxX( rect ), CGRectGetMaxY( rect )),
                                           CGPointMake( rect.origin.x, CGRectGetMaxY(rect) ),
                                           &interPoint );
        if ( type == kCGIntersection && CGCheckPointMiddle( pt0, interPoint, pt1 )) {
            if ( intersection != nil ) {
                *intersection = interPoint;
            }
            return YES;
        }
        type = CGGetIntersectionOfSegments( pt0, pt1,
                                           CGPointMake( CGRectGetMaxX( rect ), CGRectGetMaxY( rect )),
                                           CGPointMake( rect.origin.x, CGRectGetMaxY(rect) ),
                                           &interPoint );
        if ( type == kCGIntersection && CGCheckPointMiddle( pt0, interPoint, pt1 )) {
            if ( intersection != nil ) {
                *intersection = interPoint;
            }
            return YES;
        }
    }
    return NO;
}

CGPoint CGGetPointOnCycle( CGPoint center, double radius, double angle ){
    double x = center.x + radius * cos( angle );
    double y = center.y + radius * sin( angle );
    return CGPointMake( x, y );
}

@implementation NSNumber (graphic)

-( CGFloat )CGFloatValue {
#if defined(__LP64__) && __LP64__
    return [ self doubleValue ];
#else
    return [ self floatValue ];
#endif
}

+( NSNumber* )numberWithCGFloat:(CGFloat)f {
#if defined(__LP64__) && __LP64__
    return [ self numberWithDouble:f ];
#else
    return [ self numberWithFloat:f ];
#endif
}

@end

@implementation UIColor (graphic)

-( UInt32 )rgbaValue {
    CGFloat red = 0;
    CGFloat green = 0;
    CGFloat blue = 0;
    CGFloat alpha = 1.0f;
    [ self getRed:&red green:&green blue:&blue alpha:&alpha ];
    UInt8 redHex = red * 0xFF;
    UInt8 greenHex = green * 0xFF;
    UInt8 blueHex = blue * 0xFF;
    UInt8 alphaHex = alpha * 0xFF;
    UInt32 result = (( redHex & 0xff ) << 24 ) |
                    (( greenHex & 0xff ) << 16 ) |
                    (( blueHex & 0xff ) << 8 ) |
                    ( alphaHex & 0xff );
    return result;
}

-( NSString* )rgbaHexaString {
    return [ NSString stringWithFormat:@"%08x", (unsigned int)[ self rgbaValue ]];
}

@end

@implementation UIImage (graphic)

-( UIImage* )makeGrayscale {
    UIGraphicsBeginImageContextWithOptions( self.size, false, self.scale );
    CGRect rect = CGRectMake( 0, 0, self.size.width, self.size.height );
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ( context == NULL ) return nil;
    CGContextSetFillColorWithColor( context, [[ UIColor whiteColor ] CGColor ]);
    CGContextFillRect(context, rect);
    [ self drawInRect:rect
            blendMode:kCGBlendModeLuminosity
                alpha:1.0 ];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+( UIImage* )imageWithView:( UIView* )view {
    UIGraphicsBeginImageContextWithOptions( view.bounds.size, view.opaque, [[ UIScreen mainScreen ] scale ]);
    [ view.layer renderInContext:UIGraphicsGetCurrentContext() ];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - Resize

-( UIImage* )scaleImageToSize:( CGSize )targetSize {
    UIGraphicsBeginImageContextWithOptions( targetSize, false, self.scale );
    [ self drawInRect:CGRectMake( 0, 0, targetSize.width, targetSize.height )];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-( UIImage* )fitImageInSize:( CGSize )targetSize zoomToFit:( BOOL )canZoom {
    if ( self.size.width < targetSize.width  && self.size.height < targetSize.height && !canZoom )
        return [ self copy ];
    CGSize sizeToFit = CGSizeMakeFitSize( targetSize, self.size );
    return [ self scaleImageToSize:sizeToFit ];
}

-( UIImage* )fitImageInSize:( CGSize )targetSize {
    return [ self fitImageInSize:targetSize zoomToFit:NO ];
}

-( UIImage* )fillImageInSize:( CGSize )targetSize zoomToFill:( BOOL )canZoom {
    if ( self.size.width < targetSize.width  && self.size.height < targetSize.height && !canZoom )
        return [ self copy ];
    CGSize sizeToFill = CGSizeMakeFillSize( targetSize, self.size );
    return [ self scaleImageToSize:sizeToFill ];
}

-( UIImage* )fillImageInSize:( CGSize )targetSize {
    return [ self fillImageInSize:targetSize zoomToFill:NO ];
}

#pragma mark - Crop

-( UIImage* )cropToSize:( CGSize )size {
    CGRect rect = CGRectZero;
    rect.size = size;
    return [ self cropToRect:rect ];
}

-( UIImage* )cropToRect:( CGRect )rect {
    CGRect targetRect = CGRectZero;
    targetRect.size = self.size;
    UIGraphicsBeginImageContextWithOptions( rect.size, false, self.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClipToRect( context, rect );
    [ self drawInRect:targetRect ];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

-( UIImage* )cropToRect:( CGRect )rect roundCorner:( CGFloat )radius {
    return [ self cropToRect:rect roundCorner:radius backgroundColor:[ UIColor clearColor ]];
}

-( UIImage* )cropToRect:( CGRect )rect roundCorner:( CGFloat )radius backgroundColor:( UIColor* )fillColor {
    CGRect targetRect = CGRectZero;
    targetRect.size = self.size;
    targetRect.origin.x = -rect.origin.x;
    targetRect.origin.y = -rect.origin.y;

    UIGraphicsBeginImageContextWithOptions( rect.size, false, self.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect drawRect = CGRectMake( 0, 0, rect.size.width, rect.size.height );
    if ( fillColor ){
        [ fillColor setFill ];
        CGContextFillRect( context, drawRect );
    }
    if ( radius > 0 ){
        CGContextBeginPath( context );
        CGContextMoveToPoint( context, radius, 0 );
        CGContextAddLineToPoint( context, rect.size.width - radius, 0 );
        CGContextAddArcToPoint( context, rect.size.width, 0, rect.size.width, radius, radius );
        CGContextAddLineToPoint( context, rect.size.width, rect.size.height - radius );
        CGContextAddArcToPoint( context, rect.size.width, rect.size.height, rect.size.width - radius, rect.size.height, radius );
        CGContextAddLineToPoint( context, radius, rect.size.height );
        CGContextAddArcToPoint( context, 0, rect.size.height, 0, rect.size.height - radius, radius );
        CGContextAddLineToPoint( context, 0, radius );
        CGContextAddArcToPoint( context, 0, 0, radius, 0, radius );
        CGContextClosePath( context );
        CGContextClip( context );
    } else {
        CGContextClipToRect( context, drawRect );
    }
    
    [ self drawInRect:targetRect ];
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

-( UIImage* )cropToCircle {
    CGRect rect = CGRectZero;
    rect.size = self.size;
    return [ self cropToCircle:CGPointCenterOfRect( rect )
                        radius:MIN( rect.size.width, rect.size.height ) / 2
               backgroundColor:nil ];
}

-( UIImage* )cropToCircleWithRadius:( CGFloat )radius {
    CGRect rect = CGRectZero;
    rect.size = self.size;
    return [ self cropToCircle:CGPointCenterOfRect( rect )
                        radius:radius
               backgroundColor:nil ];
}

-( UIImage* )cropToCircle:( CGPoint )center radius:( CGFloat )radius backgroundColor:( UIColor* )fillColor {
    CGRect targetRect = CGRectZero;
    targetRect.size = self.size;
    targetRect.origin.x = -( center.x - radius );
    targetRect.origin.y = -( center.y - radius );
    
    CGRect drawRect = CGRectZero;
    drawRect.size.width = drawRect.size.height = radius * 2;
    UIGraphicsBeginImageContextWithOptions( drawRect.size, false, self.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    if ( fillColor ){
        [ fillColor setFill ];
        CGContextFillRect( context, drawRect );
    }
    CGContextBeginPath( context );
    CGContextAddEllipseInRect( context, drawRect );
    CGContextClip( context );
    [ self drawInRect:targetRect ];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

#pragma mark - Flip

-( UIImage* )horizontalFlippedImage {
    UIGraphicsBeginImageContextWithOptions( self.size, false, self.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM( context, -1.0, 1.0 );
    CGContextTranslateCTM( context, -self.size.width, 0 );
    [ self drawAtPoint:CGPointZero ];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-( UIImage* )verticalFlippedImage {
    UIGraphicsBeginImageContextWithOptions( self.size, false, self.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM( context, 1.0, -1.0 );
    CGContextTranslateCTM( context, 0, -self.size.height );
    [ self drawAtPoint:CGPointZero ];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Rotate

-( UIImage* )rotatedImageWithAngle:( CGFloat )radian {
    // Calculate max area to draw image
    CGRect rect = CGRectZero;
    rect.size = self.size;
    rect = CGRectApplyAffineTransform( rect, CGAffineTransformMakeRotation( radian ));
    // Draw
    UIGraphicsBeginImageContextWithOptions( rect.size, false, self.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Move center of axes to center of drawing area & rotate it
    CGContextTranslateCTM( context, rect.size.width / 2, rect.size.height / 2 );
    CGContextRotateCTM( context, radian );
    // Draw image so the center of image is on the center of axes
    [ self drawAtPoint:CGPointMake( -self.size.width / 2, -self.size.height / 2 )];
    // Export image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-( UIImage* )rotated90DegreeClockwise {
    return [ self rotatedImageWithAngle:M_PI_2 ];
}

-( UIImage* )rotated90DegreeCounterClockwise {
    return [ self rotatedImageWithAngle:-M_PI_2 ];
}

-( UIImage* )rotatedUpSideDown {
    return [ self rotatedImageWithAngle:M_PI ];
}

-( UIImage* )rotatedImageWithAngle:( CGFloat )radian limitSize:( CGFloat )size
                      shadowOffset:( CGSize )offset shadowBlur:( CGFloat )blur {
    CGFloat maxOffset = MAX( fabs( offset.width), fabs( offset.height ));
    CGFloat imgSize = size;
    if ( imgSize <= 0 ){
        imgSize = MAX( self.size.width, self.size.height) + 4 * maxOffset;
    }
    CGRect imgFrame = CGRectZero;
    if ( self.size.width > self.size.height ) {
        imgFrame.size.width = imgSize - 4 * maxOffset;
        imgFrame.size.height = imgFrame.size.width * self.size.height / self.size.width;
    } else {
        imgFrame.size.height = imgSize - 4 * maxOffset;
        imgFrame.size.width = imgFrame.size.height * self.size.width / self.size.height;
    }
    imgFrame.origin.x = -imgFrame.size.width / 2;
    imgFrame.origin.y = -imgFrame.size.height / 2;

    UIGraphicsBeginImageContextWithOptions( CGSizeMake( imgSize, imgSize), NO, self.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( context, imgSize / 2, imgSize / 2 );
    CGContextRotateCTM( context, radian );
    CGContextSetShadow( context, offset, blur);
    [ self drawInRect:imgFrame ];
    UIImage *resutl = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  resutl;
}

@end
