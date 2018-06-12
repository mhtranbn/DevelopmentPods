/**
 @file      CMBaseCustomView.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "CMBaseCustomView.h"

@implementation CMBaseCustomView

+( void )addFillLayoutConstrainsForView:( UIView* )view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [[ view superview ] addConstraints:[ NSLayoutConstraint constraintsWithVisualFormat:@"|[view]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{ @"view" : view }]];
    [[ view superview ] addConstraints:[ NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:@{ @"view" : view }]];
}

-( void )loadContentViewFromXib {
    if ( self.viewContent == nil ){
        NSBundle *bundle = [ NSBundle bundleForClass:[ self class ]];
        NSString *nibName = NSStringFromClass( self.class );
        if ([ nibName rangeOfString:@"."].location != NSNotFound ){
            nibName = [ nibName pathExtension ];
        }
        NSArray *viewArray = nil;
        if ([ bundle pathForResource:nibName ofType:@"nib" ]){
            @try {
                viewArray = [ bundle loadNibNamed:nibName owner:self options:nil ];
            }
            @catch (NSException *exception){
                NSLog( @"CUSTOM VIEW: %@", exception );
                return;
            }
        } else {
            NSLog( @"CUSTOM VIEW: couldn't find xib %@ from bundle %@", nibName, bundle.bundlePath );
        }
        if ( self.viewContent == nil ){
            if ( viewArray == nil || [ viewArray count ] == 0 ) return;
            self.viewContent = viewArray[0];
        }
        self.originalContentSize = self.viewContent.frame.size;
        self.viewContent.frame = self.bounds;
        self.viewContent.translatesAutoresizingMaskIntoConstraints = NO;
        [ self addSubview:self.viewContent ];
        NSArray *constraints = [ NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[view]-0-|"
                                                                        options:NSLayoutFormatAlignAllLeading
                                                                        metrics:@{ @"0" : @0 }
                                                                          views:@{ @"view" : self.viewContent }];
        [ self addConstraints:constraints ];
        constraints = [ NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|"
                                                               options:NSLayoutFormatAlignAllTop
                                                               metrics:@{ @"0" : @0 }
                                                                 views:@{ @"view" : self.viewContent }];
        [ self addConstraints:constraints ];
        [ self layoutIfNeeded ];
        [ self viewDidLoad ];
    }
}

-( void )viewDidLoad {
    // SUBCLASS
}

-( void )awakeFromNib {
    [ super awakeFromNib ];
    [ self loadContentViewFromXib ];
}

-( instancetype )init {
    if ( self = [ super init ]){
        [ self loadContentViewFromXib ];
    }
    return self;
}

-( instancetype )initWithFrame:( CGRect )frame {
    if ( self = [ super initWithFrame:frame ]){
        [ self loadContentViewFromXib ];
    }
    return self;
}

@end

@implementation UIButton(usable)

-( BOOL )isUsable {
    return self.isEnabled && self.isUserInteractionEnabled && !self.isHidden;
}

-( void )setUsable:( BOOL )usable {
    self.enabled = self.userInteractionEnabled = usable;
    self.hidden = !usable;
}

@end
