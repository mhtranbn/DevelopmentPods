/**
 @file      UIScreen+type.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <UIKit/UIKit.h>

// iPhone, iPod touch
extern const CGSize kCMScreenSize35inch;
extern const CGSize kCMScreenSize35inch2x;
extern const CGSize kCMScreenSize4inch;
extern const CGSize kCMScreenSize47inch;
extern const CGSize kCMScreenSize55inch;
// iPhone X (Super Retina)
extern const CGSize kCMScreenSize58inch;
// iPad, iPad mini, iPad pro 9.7
extern const CGSize kCMScreenSize97inch;
extern const CGSize kCMScreenSize97inch2x;
#define kCMScreenSize79inch     kCMScreenSize97inch
#define kCMScreenSize79inch2x   kCMScreenSize97inch2x
// iPad Pro 10.5
extern const CGSize kCMScreenSize105inch;
// iPad Pro 12.9
extern const CGSize kCMScreenSize129inch;
// Apple watch
extern const CGSize kCMScreenSize38inch;
extern const CGSize kCMScreenSize42inch ;

typedef NS_ENUM( unsigned int, CMScreenSizeType ){
    kCMScreenUnknown,
    /// iPhone 3.5 inch display (iPhone 3G, 3GS)
    kCMScreeniPhone35Inch,
    /// iPhone Retina 3.5 inch display (iPhone 4, 4S)
    kCMScreeniPhone35InchRetina,
    /// iPhone Retina 4 inch display (iPhone 5, 5S, 5C, SE)
    kCMScreeniPhone4Inch,
    /// iPhone Retina 4.7 inch display (iPhone 6, 6S)
    kCMScreeniPhone47Inch,
    /// iPhone Retina 5.5 inch display (iPhone 6+, 6S+)
    kCMScreeniPhone55Inch,
    /// iPhone Super Retina 5.8 inch display (iPhone X)
    kCMScreeniPhone58Inch,
    /// iPad display (iPad, iPad Mini)
    kCMScreeniPad,
    /// iPad Retina display (iPad Retina, iPad Mini Retina, iPad Pro 9.7, iPad Gen5)
    kCMScreeniPadRetina,
    /// iPad Pro 10.5 display
    kCMScreeniPadPro105,
    /// iPad Pro 12.9 display
    kCMScreeniPadPro129,
    /// Apple TV
    kCMScreenTv
};

@interface UIScreen (type)

/**
 *  Get current screen type - SDK screen size, not Hardware size.
 *
 *  @return Type of screen.
 */
-( CMScreenSizeType )screenType;

@end

extern NSString *const _Nonnull kCMImageNameSuffixRetina3_5; // @2x
extern NSString *const _Nonnull kCMImageNameSuffixRetina4;   // -568h@2x
extern NSString *const _Nonnull kCMImageNameSuffixRetina4_7; // -667h@2x
extern NSString *const _Nonnull kCMImageNameSuffixRetina5_5; // @3x
extern NSString *const _Nonnull kCMImageNameSuffixIpad;      // ~ipad
extern NSString *const _Nonnull kCMImageNameSuffixIpadRetina;// ~ipad@2x

@interface NSBundle (screen)

/**
 *  Get full path of resource file in app bundle depending on current screen type.
 *  If image for current screen not available, return the path of image of smaller screen
 *  iPhone 3.5 < iPhone Retina 3.5 < iPhone 4 < iPhone 4.7 < iPhone 5.5
 *  iPhone 3.5 < iPhone Retina 3.5 < iPad < iPad Retina
 *  Eg: iPad retina, but image~ipad@2x not available, will use image~ipad then image@2x then image
 *
 *  @param name      File name.
 *  @param extension File extension.
 *  @param subDir    Sub folder in bundle, can be nil.
 *
 *  @return Full path. Nil if file not found.
 */
-( nullable NSString* )pathForCurrentScreenOfResourceName:( nonnull NSString* )name
                                                  andType:( nullable NSString* )extension
                                                 inFolder:( nullable NSString* )subDir;
@end

@interface UIImage (screen)

/**
 *  Load PNG image from app bundle depending on current screen type.
 *
 *  @param name File name (no extension).
 *
 *  @return Nil if file not found.
 */
+( nullable UIImage* )pngImageFromName:( nonnull NSString* )name;
/**
 *  Load image from app bundle depending on current screen type.
 *
 *  @param name      File name.
 *  @param extension File extension.
 *  @param subDir    Sub folder in bundle. Can be nil.
 *
 *  @return Nil if fail to load file.
 */
+( nullable UIImage* )imageWithName:( nonnull NSString* )name andType:( nullable NSString* )extension inFolder:( nullable NSString* )subDir;

@end
