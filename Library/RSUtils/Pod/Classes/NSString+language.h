/**
 @file      NSString+language.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

typedef NS_ENUM( NSUInteger, UniCharType ){
    kUCTypeOther = 0,
    kUCTypeGeneralSymbol,
    kUCTypeLatinAlphaUp,
    kUCTypeLatinAlphaLow,
    kUCTypeLatinDigit,
    kUCTypeLatinSymbol,
    kUCTypeJPHiragana,
    kUCTypeJPKatakana,
    kUCTypeJPSymbol,
    kUCTypeJPRomanjiSymbol,
    kUCTypeJPRomanjiDigit,
    kUCTypeJPRomanjiAlphaUp,
    kUCTypeJPRomanjiAlphaLow,
    kUCTypeJPKatakanaHalfWidth,
    kUCTypeCJKCommon, // kanji
    kUCTypeCJKRare
};

@interface NSString (language)

+( UniCharType )typeOfUnicodeCharacter:( UniChar )uChar;

-( BOOL )isContainingJapaneseCharacter;
-( BOOL )isEnglishText;

@end
