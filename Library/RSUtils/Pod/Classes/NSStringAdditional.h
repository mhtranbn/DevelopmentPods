/**
 @file      NSStringAdditional.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM( int, CMStringNumberType ){
    kCMStringIsNotNumber = 0,
    kCMStringIsInterger,   // string can be covert to NSInteger
    kCMStringIsBoolTrue,   // YES, NO
    kCMStringIsBoolFalse,  // TRUE, FALSE in any-case
    kCMStringIsFloat,      // string can be convert to double
    kCMStringIsHex         // string in hexa format, can be convert to unsigned long
};

@interface NSString (utils)

/**
 *  Format a number to grouped number "123,456,789.321"
 *
 *  @param number Value
 *
 *  @return A string like "123,456,789.321"
 */
+( nullable NSString* )decimalStringOfNumber:( nonnull NSNumber* )number;

/**
 *  @return YES if current string is like an email address
 */
-( BOOL )isEmailAddress;

/**
 *  Get the multilines displaying size of text. Note that we should adjust +2 pt to the result for height to UILabel.  
 *
 *  @param font  Font to render text
 *  @param width Max width to render text inside
 *
 *  @return Size to render text
 */
-( CGSize )sizeToDisplayMultiLinesWithFont:( nonnull UIFont* )font
                                fitToWidth:( CGFloat )width;

/**
 *  Get the number of displaying lines of text
 *
 *  @param font  Font to render text
 *  @param width Max width to render text inside
 *
 *  @return Number of lines
 */
-( NSUInteger )numberOfLinesWhenDisplayWithFont:( nonnull UIFont* )font
                                     fitToWidth:( CGFloat )width;

/**
 *  Convert a hexa string to value. Valid: 21AB, 0x21AB .... Remember to use @try catch
 *
 *  @return Raise error if the string is not hexa
 */
-( unsigned long )hexaValue;

/**
 *  Convert a binary string to value. Valid: 1010, 0b1010. Remember to use @try catch
 *
 *  @return Raise if the string is not binary
 */
-( unsigned long )binaryValue;

/**
 *  Convert a hexa string to color. Valid format: (0x) rgb, rgba, rrggbb, rrggbbaa
 *
 *  @return nil if fail to convert
 */
-( nullable UIColor* )colorFromHexaString;

/**
 *  Check that this string can be convert to which format
 *
 *  @return Number format type
 */
-( CMStringNumberType )numberType;

/**
 *  Convert NSString to NSNumber
 *
 *  @return nil if failed
 */
-( nullable NSNumber* )numberValue;

-( long )longValue;
-( short )shortValue;
-( char )charValue;
-( unsigned char )unsignedCharValue;
-( unsigned int )unsignedIntValue;
-( unsigned long )unsignedLongValue;
-( unsigned long long )unsignedLongLongValue;
-( unsigned short )unsignedShortValue;
-( NSUInteger )unsignedIntegerValue;

@end

@interface NSMutableString (util)

/**
 *  Delete last character
 */
-( void )deleteLastCharacter;
/**
 *  Delete number of characters from tail
 *
 *  @param numOfChars Number of characters to delete
 */
-( void )deleteTailCharacters:( NSUInteger )numOfChars;
/**
 *  Delete 1st character
 */
-( void )deleteFirstCharacter;
/**
 *  Delete number of characters from head
 *
 *  @param numOfChars Number of characters to delete
 */
-( void )deleteHeadCharacters:( NSUInteger )numOfChars;

@end

@interface NSAttributedString (util)

/**
 Initialize a attributed string with html text

 @param htmlString HTML text
 @return Attributed string
 */
-( nullable instancetype )initWithHTMLString:( nonnull NSString* )htmlString;
/**
 Convert attributed string to HTML text

 @return HTML text
 */
-( nullable NSString* )htmlString;

@end

@interface NSArray (stringConcat)

/**
 *  Make a string from all items of array
 *
 *  @return String
 */
-( nonnull NSMutableString* )serializeToString;
-( nonnull NSMutableString* )serializeToStringWithSeparator:( nullable NSString* )separator;

@end

//extern NSURL* _Nullable URL( NSString* _Nonnull strUrl );
