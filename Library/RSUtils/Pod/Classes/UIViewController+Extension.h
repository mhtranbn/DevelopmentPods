/**
 @file      UIViewController+Extension.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

/**
 *  Search for current top view controller:
 *  - Last modal view controller
 *  - Last view controller of navigation controller
 *  - Current selected view controller of tab bar controller
 *
 *  @return nil if not found
 */
+( nullable UIViewController* )getTopViewController;
/**
 Get top presented view controller from current view controller.

 @return Top presented view controller. Itself if it has not presented view controller.
 */
-( nonnull UIViewController* )getTopPresentedViewController;
/**
 Present modal a view controller using the top-presented view controller from current view controller.
 Be noticed that if the presenter is in presenting/dismissing progress, we have to wait a bit to present the target view controller.

 @param viewController View controller to present
 @param flag Animation
 @param completion Completion block
 @return The top-presented view controller. Nil if we have to wait to present the target view controller.
 */
-( nullable UIViewController* )presentOnTopWith:( nonnull UIViewController* )viewController animated:( BOOL )flag
                                     completion:( void (^__nullable)(void) )completion;
/**
 Find the app top view controller (use [UIViewController getTopViewController]) and present the given view controller

 @param viewController View controller to present
 @param flag Animation flag
 @param completion Completion block
 @return The top view controller will present the given view controller
 */
+( nullable UIViewController* )presentOnTopWith:( nonnull UIViewController* )viewController
                                       animated:( BOOL )flag completion:( void (^__nullable)(void) )completion;

@end
