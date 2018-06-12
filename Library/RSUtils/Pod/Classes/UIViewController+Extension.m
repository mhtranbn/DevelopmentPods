/**
 @file      UIViewController+Extension.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "UIViewController+Extension.h"
#import "NSObject+dispatch.h"

#define VC_PRESENT_RETRY_TIME   0.2f

@implementation UIViewController (Extension)

+( UIViewController* )getTopViewControllerFromController:( UIViewController* )viewController {
    if ([ viewController isKindOfClass:[ UINavigationController class ]]){
        UINavigationController *naviController = ( UINavigationController* )viewController;
        if ( naviController.viewControllers.count > 0 ){
            return [ self getTopViewControllerFromController:naviController.viewControllers.lastObject ];
        } else {
            return naviController;
        }
    } else if ([ viewController isKindOfClass:[ UITabBarController class ]]){
        UITabBarController *tabController = ( UITabBarController* )viewController;
        if ( tabController.selectedViewController != nil ){
            return [ self getTopViewControllerFromController:tabController.selectedViewController ];
        } else {
            return tabController;
        }
    } else {
        return viewController;
    }
}

+( UIViewController* )getTopViewController {
    UIViewController *rootController = [[[[ UIApplication sharedApplication ] delegate ] window ] rootViewController ];
    if ( rootController != nil ){
        UIViewController *topController = [ rootController getTopPresentedViewController ];
        return [ self getTopViewControllerFromController:topController ];
    }
    return nil;
}

-( UIViewController* )getTopPresentedViewController {
    UIViewController *controller = self;
    while ( controller.presentedViewController != nil ){
        controller = controller.presentedViewController;
    }
    return controller;
}

-( UIViewController* )searchStatbleViewController {
    UIViewController *controller = self;
    while ( controller.presentingViewController != nil && controller.presentingViewController.isBeingDismissed ) {
        controller = controller.presentingViewController;
    }
    return controller;
}

-( UIViewController* )presentOnTopWith:( UIViewController* )viewController
                              animated:( BOOL )flag completion:( void (^)(void) )completion {
    UIViewController *controller = [ self getTopPresentedViewController ];
    if ( controller.isBeingPresented ){
        delayToMain( VC_PRESENT_RETRY_TIME, ^{
            [ controller presentOnTopWith:viewController animated:flag completion:completion ];
        });
        return nil;
    } else if ( controller.isBeingDismissed ){
        __weak UIViewController *presentingVC = [ controller searchStatbleViewController ];
        delayToMain( VC_PRESENT_RETRY_TIME, ^{
            if ( presentingVC != nil ){
                [ presentingVC presentOnTopWith:viewController animated:flag completion:completion ];
            } else {
                [ UIViewController presentOnTopWith:viewController animated:flag completion:completion ];
            }
        });
        return nil;
    } else {
        [ controller presentViewController:viewController animated:flag completion:completion ];
        return controller;
    }
}

+( UIViewController* )presentOnTopWith:( UIViewController* )viewController animated:( BOOL )flag
                            completion:( void (^)(void) )completion {
    UIViewController *topViewController = [ self getTopViewController ];
    if ( topViewController != nil ){
        return [ topViewController presentOnTopWith:viewController animated:flag completion:completion ];
    }
    return topViewController;
}

@end
