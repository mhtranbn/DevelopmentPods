/**
 @file      CMGraphics.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/**
 *  Make random integer value in given range
 *
 *  @param minValue Minimum value
 *  @param maxValue Maximum value
 *
 *  @return Integer value
 */
extern NSInteger NSIntegerRandomNumberBetween( NSInteger minValue, NSInteger maxValue );
/**
 *  @param rect A rectangle
 *
 *  @return Center point of given rectangle
 */
extern CGPoint CGPointCenterOfRect( CGRect rect );
/**
 *  @param point1 Point 1
 *  @param point2 Point 2
 *
 *  @return Distance between 2 given points
 */
extern double CGPointDistanceBetween2Points( CGPoint point1, CGPoint point2 );
/**
 *  @param rect   Rect
 *  @param center Point
 *
 *  @return Make new rect with given center point
 */
extern CGRect CGRectMoveToCenter( CGRect rect, CGPoint center );
/**
 *  @param rect A rectangle
 *  @param size Size
 *
 *  @return A new rectangle with given size & center point same place with given rectangle center point
 */
extern CGRect CGRectMakeRectCenterOfRect( CGRect rect, CGSize size );
/**
 *  @param rect A rectangle
 *  @param size Size
 *
 *  @return Make new rectangle same center point of given rectangle, size ratio same as given size &
 fill the given rectangle area.
 */
extern CGRect CGRectMakeFillWithSize( CGRect rect, CGSize size );
/**
 *  @param sizeToFill Size fixed
 *  @param sizeRatio  Size to resize keeping ratio
 *
 *  @return New size same ration with sizeRation & fill the sizeToFill
 */
extern CGSize CGSizeMakeFillSize( CGSize sizeToFill, CGSize sizeRatio );
/**
 *  @param rect A rectangle
 *  @param size Size
 *
 *  @return Make new rectangle same center point of given rectangle, size ratio same as given size &
 fit the given rectangle area.
 */
extern CGRect CGRectMakeFitWithSize( CGRect rect, CGSize size );
/**
 *  @param sizeToFit Size fixed
 *  @param sizeRatio Size to resize keeping ratio
 *
 *  @return New size same ratio with sizeRatio & fit into sizeToFit
 */
extern CGSize CGSizeMakeFitSize( CGSize sizeToFit, CGSize sizeRatio );
/**
 *  @param size Size
 *
 *  @return Length of diagonal of given size
 */
extern CGFloat CGSizeDiagonalLength( CGSize size );
/**
 *  @param radius    Circle radius
 *  @param sizeRatio Size of ratio
 *
 *  @return New size same ratio with given size and fit inside circle
 */
extern CGSize CGSizeMakeFitCircle( CGFloat radius, CGSize sizeRatio );
/**
 *  @param center    Circle center point
 *  @param radius    Circle radius
 *  @param sizeRatio Size of ratio
 *
 *  @return New rect with size same ratio with given size and fit inside circle
 */
extern CGRect CGRectMakeFitCircle( CGPoint center, CGFloat radius, CGSize sizeRatio );
/**
 *  @param radius    Circle radius
 *  @param sizeRatio Size of ratio
 *
 *  @return New size same ratio with given size and circle can fit inside
 */
extern CGSize CGSizeMakeFillCircle( CGFloat radius, CGSize sizeRatio );
/**
 *  @param center    Circle center point
 *  @param radius    Circle radius
 *  @param sizeRatio Size of ratio
 *
 *  @return New rect with size same ratio with given size and circle can fit inside rect (at center
 of rect also)
 */
extern CGRect CGRectMakeFillCircle( CGPoint center, CGFloat radius, CGSize sizeRatio );
/**
 *  Return UIColor from Red-Green-Blue value
 *
 *  @param red Red value. Integer 0-255
 *  @param green Green value. Integer 0-255
 *  @param blue Blue value. Integer 0-255
 *
 *  @return UIColor instance
 */
extern UIColor* _Nonnull RGB( UInt8 red, UInt8 green, UInt8 blue );
/**
 *  Return UIColor from Red-Green-Blue value
 *
 *  @param red Red value. Integer 0-255
 *  @param green Green value. Integer 0-255
 *  @param blue Blue value. Integer 0-255
 *  @param alpha Alpha value. Float 0.0-1.0
 *
 *  @return UIColor instance
 */
extern UIColor* _Nonnull RGBA( UInt8 red, UInt8 green, UInt8 blue, float alpha );
/**
 *  Return UIColor from Alpha-Red-Green-Blue hexa value. Tip: project spec can use RGB hexa color 
 (like HTML), so we can type 0xFF then paste hexa color from project spec.
 *
 *  @param hexa A hexa present for color
 *
 *  @return UIColor
 */
extern UIColor* _Nonnull ARGB( UInt32 hexa );
extern UIColor* _Nonnull RGBa( UInt32 hexa );
/// Vector (1, 0)
extern CGVector CGVectorOX(void);
/// Vector (0, 1)
extern CGVector CGVectorOY(void);
/**
 *  Make vector from point p0 to p1. Also can be used as vector p1 - vector p0.
 *
 *  @param p0 Start point of vector
 *  @param p1 End point of vector
 *
 *  @return Vector from p0 to p1.
 */
extern CGVector CGVectorMakeFromPoints( CGPoint p0, CGPoint p1 );
/**
 Make vector from Root coordinate (point 0) to given point

 @param p Point
 @return Vector
 */
extern CGVector CGVectorMakeFromPoint( CGPoint p );
/**
 *  @param vector Vector
 *
 *  @return Length of given vector
 */
extern double CGVectorGetLength( CGVector vector );
/**
 *  @param vec0 Vector 0
 *  @param vec1 Vector 1
 *
 *  @return Cross product of 2 vectors (vec0 x vec1)
 */
extern double CGVectorGetCrossProduct( CGVector vec0, CGVector vec1 );
/**
 *  @param vec0 Vector 0
 *  @param vec1 Vector 1
 *
 *  @return Dot product of 2 vectors (vec0•vec1)
 */
extern double CGVectorGetDotProduct( CGVector vec0, CGVector vec1 );
/**
 *  @param vec0 Vector 0
 *  @param vec1 Vector 1
 *
 *  @return Angle from vector 0 to vector 1 with clockwise orientation
 */
extern double CGVectorGetAngleBetweenVectors( CGVector vec0, CGVector vec1 );
/**
 Check a point is between 2 points (assume that 3 points are collinear).

 @param pt0 Terminal point.
 @param middlePt Middle point (point to check).
 @param pt1 Terminal point.
 @return YES if `middlePt` is between 2 points.
 */
extern BOOL CGCheckPointMiddle( CGPoint pt0, CGPoint middlePt, CGPoint pt1 );
/// Intersection relation of 2 lines or vectors
typedef NS_ENUM(int, CGIntersectionType) {
    /// 2 lines are same
    kCGCollinear,
    /// 2 lines are parallel
    kCGParallel,
    /// 2 lines have a common point
    kCGIntersection,
    /// Can not determine
    kCGUnknown,
};
/**
 Find the intersection point of 2 lines which pass the given 2 couple points

 @param p00 First point of first line
 @param p01 Second point of first line
 @param p10 First point of second line
 @param p11 Second point of second line
 @param intersection Intersection point buffer
 @return Intersection type
 */
extern CGIntersectionType CGGetIntersectionOfSegments( CGPoint p00, CGPoint p01,
                                                      CGPoint p10, CGPoint p11,
                                                      CGPoint* _Nullable intersection );
/**
 Check a point on edges of rect

 @param pt Point to check
 @param rect Rect to check
 @return YES if pt is on an edge of rect
 */
extern BOOL CGPointIsOnEdgeOfRect( CGPoint pt, CGRect rect );
/**
 Get intersection of given segment with rect.

 @param pt0 Segment terminal point.
 @param pt1 Segment terminal point.
 @param rect Rect
 @param intersection Intersection point buffer.
 @return YES if segment intersects with any edge of rect.
 */
extern BOOL CGGetIntersectionOfSegmentRect( CGPoint pt0, CGPoint pt1, CGRect rect,
                                           CGPoint* _Nullable intersection );
/**
 *  Get point on cycle with given radius & center, which vector center-point makes with Ox axe the given angle.
 *
 *  @param center Center of cycle
 *  @param radius Radius of cycle
 *  @param angle Angle of point to Ox
 *
 *  @return Point coordinate
 */
extern CGPoint CGGetPointOnCycle( CGPoint center, double radius, double angle );

@interface NSNumber (graphic)

-( CGFloat )CGFloatValue;
+( nonnull NSNumber* )numberWithCGFloat:( CGFloat )f;

@end

@interface UIColor (graphic)

-( UInt32 )rgbaValue;
/**
 *  @return rrggbbaa format string to represent the color
 */
-( nonnull NSString* )rgbaHexaString;

@end

@interface UIImage (graphic)

/**
 *  Make grayscale color image
 *
 *  @return New image
 */
-( nullable UIImage* )makeGrayscale;
/**
 *  Render a view to image
 *
 *  @param view View to render
 *
 *  @return New image
 */
+( nonnull UIImage* )imageWithView:( nonnull UIView* )view;
/**
 *  Scale image to size
 *
 *  @param targetSize Size to scale
 *
 *  @return New image with specified size
 */
-( nonnull UIImage* )scaleImageToSize:( CGSize )targetSize;
/**
 *  Scale image to fit into size but keep ratio
 *
 *  @param targetSize Size to scale
 *
 *  @return New image
 */
-( nonnull UIImage* )fitImageInSize:( CGSize )targetSize;
/**
 *  Scale image to fit into size but keep ratio
 *
 *  @param targetSize Size to scale
 *  @param canZoom    Zoom smaller image to fit the size
 *
 *  @return New image
 */
-( nonnull UIImage* )fitImageInSize:( CGSize )targetSize zoomToFit:( BOOL )canZoom;
/**
 *  Scale image to fill into size but keep ratio
 *
 *  @param targetSize Size to scale
 *
 *  @return New image
 */
-( nonnull UIImage* )fillImageInSize:( CGSize )targetSize;
/**
 *  Scale image to fill into size but keep ratio
 *
 *  @param targetSize Size to scale
 *  @param canZoom    Zoom smaller image to fill the size
 *
 *  @return New image
 */
-( nonnull UIImage* )fillImageInSize:( CGSize )targetSize zoomToFill:( BOOL )canZoom;
/**
 *  Crop image to size
 *
 *  @param size Size
 *
 *  @return New image
 */
-( nonnull UIImage* )cropToSize:( CGSize )size;
/**
 *  Draw image with specified frame in image coordinate
 *
 *  @param rect   Frame to draw
 *  @param radius Round corner
 *
 *  @return New image
 */
-( nonnull UIImage* )cropToRect:( CGRect )rect roundCorner:( CGFloat )radius;
/**
 *  Draw image with specified frame in image coordinate
 *
 *  @param rect   Frame to draw
 *  @param radius Round corner
 *  @param fillColor Background color
 *
 *  @return New image
 */
-( nonnull UIImage* )cropToRect:( CGRect )rect roundCorner:( CGFloat )radius
                backgroundColor:( nullable UIColor* )fillColor;
/**
 *  Crop image to circle fit inside of image at center
 *
 *  @return New image
 */
-( nonnull UIImage* )cropToCircle;
/**
 *  Crop image to circle at center of image and with given radius
 *
 *  @param radius Circle radius
 *
 *  @return New image
 */
-( nonnull UIImage* )cropToCircleWithRadius:( CGFloat )radius;
/**
 *  Crop image to given circle
 *
 *  @param center    Center point of circle
 *  @param radius    Radius of circle
 *  @param fillColor Background color
 *
 *  @return New image
 */
-( nonnull UIImage* )cropToCircle:( CGPoint )center radius:( CGFloat )radius
                  backgroundColor:( nullable UIColor* )fillColor;

/**
 *  @return New image horizontal flipped
 */
-( nonnull UIImage* )horizontalFlippedImage;
/**
 *  @return New image vertical flipped
 */
-( nonnull UIImage* )verticalFlippedImage;
/**
 *  @param radian Angle to rotate
 *
 *  @return New image rotated with given angle
 */
-( nonnull UIImage* )rotatedImageWithAngle:( CGFloat )radian;
/**
 *  @return New image rotated 90 degree clockwise
 */
-( nonnull UIImage* )rotated90DegreeClockwise;
/**
 *  @return New image rotated 90 degree counter-clockwise
 */
-( nonnull UIImage* )rotated90DegreeCounterClockwise;
/**
 *  @return New image rotated 180 degree
 */
-( nonnull UIImage* )rotatedUpSideDown;
/**
 Make a square image by rotate the current image & also add shadow

 @param radian Angle to rotate
 @param size Size of result image. Value 0 makes result size from origin image + 4 * shadow offset
 @param offset Shadow offset
 @param blur Shadow blur
 @return New image
 */
-( nonnull UIImage* )rotatedImageWithAngle:( CGFloat )radian limitSize:( CGFloat )size
                              shadowOffset:( CGSize )offset shadowBlur:( CGFloat )blur;

@end
