/**
 @file      CMBaseCustomView.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <UIKit/UIKit.h>

/**
 *  Base class to load custom view from XIB file.
 *  XIB name should be class name. Class of XIB owner file is custom class.
 *  Connect the root view of xib to IBOutlet viewContent.
 */
@interface CMBaseCustomView : UIView

/**
 *  Add constraints H/V:|[view]| for view
 *
 *  @param view View to add constraint. It must be inside its parent view.
 */
+( void )addFillLayoutConstrainsForView:( nonnull UIView* )view;

-( void )viewDidLoad;

/**
 *  Content view load from xib
 */
@property ( nonatomic, weak, nullable ) IBOutlet UIView *viewContent;
/**
 *  Size of content view when load from xib
 */
@property ( nonatomic, assign ) CGSize originalContentSize;

/**
 *  Load content view from xib if content view nil
 */
-( void )loadContentViewFromXib;

@end

@interface UIButton(usable)

@property (nonatomic, assign, getter=isUsable) BOOL usable;

@end
