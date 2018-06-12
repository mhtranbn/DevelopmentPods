/**
 @file      UIViewController+Orientation.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <UIKit/UIKit.h>

@interface UIApplication (Orientation)

-( UIInterfaceOrientationMask )supportedInterfaceOrientationsForMainWindow;

@end

@interface UIViewController (Orientation)

/**
 *  Get supported interface orientation. If view controller does not implement related functions, return the default values.
 *  If view controller is inside UINavigationController/UITabbarController, use value form them.
 *
 *  @return Inteface orienation
 */
-( UIInterfaceOrientationMask )getSupportedInterfaceOrientation;

@end

/**
 *  Use orientations with priority: last view controller, app supported orientations, default of navigation controller.
 */
@interface CMOrientationNavigationController : UINavigationController

@end

/**
 *  Use orientations with priority: last view controller, app supported orientations, default of navigation controller.
 */
@interface CMOrientationTabbarController : UITabBarController

@end
