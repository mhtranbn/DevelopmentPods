/**
 @file      NSString+language.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSString+language.h"

@implementation NSString (language)

+( UniCharType )typeOfUnicodeCharacter:( UniChar )uChar {
    UniCharType type = kUCTypeOther;
    if ( uChar >= 0x0020 && uChar <= 0x007E ){
        if ( uChar >= 0x0030 && uChar <= 0x0039 ){
            type = kUCTypeLatinDigit;
        } else if ( uChar >= 0x0041 && uChar <= 0x005A ){
            type = kUCTypeLatinAlphaUp;
        } else if ( uChar >= 0x0061 && uChar <= 0x007A ){
            type = kUCTypeLatinAlphaLow;
        } else {
            type = kUCTypeLatinSymbol;
        }
    } else if ( uChar >= 0x3041 && uChar <= 0x3096 ){
        type = kUCTypeJPHiragana;
    } else if ( uChar >= 0x30A1 && uChar <= 0x30FF ){
        type = kUCTypeJPKatakana;
    } else if ( uChar >= 0xFF01 && uChar <= 0xFFEE ){
        if ( uChar >= 0xFF10 && uChar <= 0xFF19 ){
            type = kUCTypeJPRomanjiDigit;
        } else if ( uChar >= 0xFF21 && uChar <= 0xFF3A ){
            type = kUCTypeJPRomanjiAlphaUp;
        } else if ( uChar >= 0xFF41 && uChar <= 0xFF5A ){
            type = kUCTypeJPRomanjiAlphaLow;
        } else if ( uChar >= 0xFF66 && uChar <= 0xFFDC ){
            type = kUCTypeJPKatakanaHalfWidth;
        } else {
            type = kUCTypeJPRomanjiSymbol;
        }
    } else if ( uChar >= 0x4E00 && uChar <= 0x9FAF ){
        type = kUCTypeCJKCommon;
    } else if ( uChar >= 0x3400 && uChar <= 0x4DB5 ){
        type = kUCTypeCJKRare;
    } else if ( uChar >= 0x3000 && uChar <= 0x303F ){
        type = kUCTypeJPSymbol;
    } else if (( uChar >= 0x2010 && uChar <= 0x2027 ) ||
               ( uChar >= 0x2033 && uChar <= 0x205E )){
        type = kUCTypeGeneralSymbol;
    }
    return type;
}

-( BOOL )isEnglishText {
    return [ self canBeConvertedToEncoding:NSASCIIStringEncoding ];
}

-( BOOL )isContainingJapaneseCharacter {
    NSRange range = NSMakeRange( 0, self.length );
    UniChar *buffer = calloc( range.length, sizeof( UniChar ));
    [ self getCharacters:buffer range:range ];
    BOOL result = NO;
    for ( NSInteger i = 0; i < range.length; i++ ){
        UniCharType type = [ NSString typeOfUnicodeCharacter:buffer[i] ];
        if ( type == kUCTypeCJKCommon ||
            type == kUCTypeCJKRare||
            type == kUCTypeJPHiragana ||
            type == kUCTypeJPKatakana ||
            type == kUCTypeJPKatakanaHalfWidth ||
            type == kUCTypeJPRomanjiAlphaLow ||
            type == kUCTypeJPRomanjiAlphaUp ||
            type == kUCTypeJPRomanjiDigit ||
            type == kUCTypeJPRomanjiSymbol ||
            type == kUCTypeJPSymbol ){
            result = YES;
            break;
        }
    }
    free( buffer );
    return result;
}


@end
