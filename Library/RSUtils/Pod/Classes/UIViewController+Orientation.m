/**
 @file      UIViewController+Orientation.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <UIKit/UIKit.h>
#import "UIViewController+Orientation.h"

@implementation UIApplication (Orientation)

-( UIInterfaceOrientationMask )supportedInterfaceOrientationsForMainWindow {
    return [ self supportedInterfaceOrientationsForWindow:[ self.delegate window ]];
}

@end

@implementation UIViewController (Orientation)

-( UIInterfaceOrientationMask )getSupportedInterfaceOrientation {
    if ( self.navigationController != nil ) return [ self.navigationController getSupportedInterfaceOrientation ];
    if ( self.tabBarController != nil ) return [ self.tabBarController getSupportedInterfaceOrientation ];
    if ([ self shouldAutorotate ]){
        return [ self supportedInterfaceOrientations ];
    } else {
        return 0;
    }
}

@end

@implementation CMOrientationNavigationController

-( BOOL )shouldAutorotate {
    UIViewController *controller = self.viewControllers.lastObject;
    if ( controller != nil ) return [ controller shouldAutorotate ];
    else return [ super shouldAutorotate ];
}

-( UIInterfaceOrientationMask )supportedInterfaceOrientations {
    UIViewController *controller = self.viewControllers.lastObject;
    if ( controller != nil ){
        return [ controller supportedInterfaceOrientations ];
    } else {
        UIInterfaceOrientationMask mask = [[ UIApplication sharedApplication ] supportedInterfaceOrientationsForMainWindow ];
        if ( mask != 0 ){
            return mask;
        } else {
            return [ super supportedInterfaceOrientations ];
        }
    }
}

@end

@implementation CMOrientationTabbarController

-( BOOL )shouldAutorotate {
    UIViewController *controller = self.selectedViewController;
    if ( controller != nil ) return [ controller shouldAutorotate ];
    else return [ super shouldAutorotate ];
}

-( UIInterfaceOrientationMask )supportedInterfaceOrientations {
    UIViewController *controller = self.selectedViewController;
    if ( controller != nil ){
        return [ controller supportedInterfaceOrientations ];
    } else {
        UIInterfaceOrientationMask mask = [[ UIApplication sharedApplication ] supportedInterfaceOrientationsForMainWindow ];
        if ( mask != 0 ){
            return mask;
        } else {
            return [ super supportedInterfaceOrientations ];
        }
    }
}

@end
