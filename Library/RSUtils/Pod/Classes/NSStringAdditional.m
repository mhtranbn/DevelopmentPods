/**
 @file      NSStringAdditional.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

@import UIKit;
#import "NSStringAdditional.h"

@implementation NSString (utils)

+( NSString* )decimalStringOfNumber:( NSNumber* )number {
    NSNumberFormatter *formatter = [[ NSNumberFormatter alloc ] init ];
    [ formatter setNumberStyle:NSNumberFormatterDecimalStyle ];
    [ formatter setGroupingSize:3 ];
    [ formatter setGroupingSeparator:@"," ];
    return [ formatter stringFromNumber:number ];
}

-( BOOL )isEmailAddress {
    NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$";
    NSPredicate *emailTest = [ NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString ];
    return [ emailTest evaluateWithObject:self ];
}

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-( CGSize )sizeToDisplayMultiLinesWithFont:( UIFont* )font fitToWidth:( CGFloat )width {
    CGSize expectedSize = CGSizeMake( width, CGFLOAT_MAX );
    CGSize displaySize = CGSizeZero;
    if ([ self respondsToSelector:@selector( boundingRectWithSize:options:attributes:context: )]){
        displaySize = [ self boundingRectWithSize:expectedSize
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName : font }
                                          context:NULL ].size;
    } else {
        displaySize = [ self sizeWithFont:font
                        constrainedToSize:expectedSize
                            lineBreakMode:NSLineBreakByWordWrapping ];
    }
    return displaySize;
}

-( NSUInteger )numberOfLinesWhenDisplayWithFont:( UIFont* )font fitToWidth:( CGFloat )width {
    CGSize singleLineSize = CGSizeMake( CGFLOAT_MAX, CGFLOAT_MAX );
    CGSize displaySize = CGSizeMake( width, CGFLOAT_MAX );
    if ([ self respondsToSelector:@selector( boundingRectWithSize:options:attributes:context: )]){
        singleLineSize = [ self boundingRectWithSize:singleLineSize
                                             options:0
                                          attributes:@{ NSFontAttributeName : font }
                                             context:NULL ].size;
        displaySize = [ self boundingRectWithSize:displaySize
                                          options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName : font }
                                          context:NULL ].size;
    } else {
        singleLineSize = [ self sizeWithFont:font ];
        displaySize = [ self sizeWithFont:font
                        constrainedToSize:displaySize
                            lineBreakMode:NSLineBreakByWordWrapping ];
    }
    return ceil( displaySize.height / singleLineSize.height );
}
#pragma GCC diagnostic pop

-( unsigned long )hexaValue {
    long l = [ self length ];
    unichar *chars = calloc( l, sizeof( unichar ));
    [ self getCharacters:chars ];
    BOOL isHexHead = ( chars[0] == '0' && chars[1] == 'x' );
    unsigned long value = 0;
    int p = 0;
    for ( long i = l - 1; isHexHead ? i > 1 : i >= 0; i-- ){
        unichar c = chars[i];
        int base = 0;
        switch ( c ){
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                base = c - '0';
                break;
            case 'A':
            case 'B':
            case 'C':
            case 'D':
            case 'E':
            case 'F':
                base = c - 'A' + 10;
                break;
            case 'a':
            case 'b':
            case 'c':
            case 'd':
            case 'e':
            case 'f':
                base = c - 'a' + 10;
                break;
            default:
                free( chars );
                [ NSException raise:@"Can not convert string to value"
                             format:@"%@ is not hexa", self ];
                return 0;
                break;
        }
        value += base * pow( 16.0f, p );
        p += 1;
    }
    free( chars );
    return value;
}

-( unsigned long )binaryValue {
    long l = [ self length ];
    unichar *chars = calloc( l, sizeof( unichar ));
    [ self getCharacters:chars ];
    BOOL isHexHead = ( chars[0] == '0' && chars[1] == 'b' );
    unsigned long value = 0;
    int p = 0;
    for ( long i = l - 1; isHexHead ? i > 1 : i >= 0; i-- ){
        unichar c = chars[i];
        switch ( c ){
            case '0':
                continue;
                break;
            case '1':
                value += pow( 2.0f, p );
                break;
            default:
                free( chars );
                [ NSException raise:@"Can not convert string to value"
                             format:@"%@ is not binary", self ];
                return 0;
                break;
        }
        p += 1;
    }
    free( chars );
    return value;
}

-( UIColor* )colorFromHexaString {
    @try {
        unsigned long value = [ self hexaValue ];
        CGFloat red, green, blue, alpha;
        red = green = blue = 0;
        alpha = 1.0f;
        switch ( self.length ){
            case 3: // #fff
                red = (( value >> 8 ) & 0xf ) / 15.0f;
                green = (( value >> 4 ) & 0xf ) / 15.0f;
                blue = ( value & 0xf ) / 15.0f;
                break;
            case 4: // #ffff
                red = (( value >> 12 ) & 0xf ) / 15.0f;
                green = (( value >> 8 ) & 0xf ) / 15.0f;
                blue = (( value >> 4 ) & 0xf ) / 15.0f;
                alpha = ( value & 0xf ) / 15.0f;
                break;
            case 6: // #ffffff
                red = (( value >> 16 ) & 0xff ) / 255.0f;
                green = (( value >> 8 ) & 0xff ) / 255.0f;
                blue = ( value & 0xff ) / 255.0f;
                break;
            case 8: // #ffffffff
                red = (( value >> 24 ) & 0xff ) / 255.0f;
                green = (( value >> 16 ) & 0xff ) / 255.0f;
                blue = (( value >> 8 ) & 0xff ) / 255.0f;
                alpha = ( value & 0xff ) / 255.0f;
                break;
            default:
                return nil;
                break;
        }
        return [ UIColor colorWithRed:red green:green blue:blue alpha:alpha ];
    }
    @catch (NSException *exception){
        return nil;
    }
}

-( CMStringNumberType )numberType {
    if ( self.length == 0 ) return kCMStringIsInterger;
    if ([[ self uppercaseString ] isEqualToString:@"YES" ] ||
        [[ self uppercaseString ] isEqualToString:@"TRUE" ])
        return kCMStringIsBoolTrue;
    else if ([[ self uppercaseString ] isEqualToString:@"NO" ] ||
             [[ self uppercaseString ] isEqualToString:@"FALSE" ])
        return kCMStringIsBoolFalse;
    
    unichar *chars = calloc( self.length, sizeof( unichar ));
    [ self getCharacters:chars ];
    BOOL isNumber = YES;
    BOOL isDouble = NO;
    BOOL isHex = NO;
    BOOL isMinus = NO;
    for ( unsigned int i = 0; i < self.length; i++ ){
        unichar c = chars[i];
        switch ( c ){
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
                isNumber = YES;
                break;
            case '.':
                if ( !isDouble ){
                    isDouble = YES;
                    if ( isHex )
                        isNumber = NO;
                } else
                    isNumber = NO;
                break;
            case '-':
                isMinus = YES;
                if ( i > 0 )
                    isNumber = NO;
                break;
            case 'A':
            case 'a':
            case 'B':
            case 'b':
            case 'C':
            case 'c':
            case 'D':
            case 'd':
            case 'E':
            case 'e':
            case 'F':
            case 'f':
                isHex = YES;
                if ( isDouble || isMinus )
                    isNumber = NO;
                break;
            case 'x':
                if ( i == 1 && chars[0] == '0' ){
                    isHex = YES;
                    if ( isDouble || isMinus )
                        isNumber = NO;
                } else
                    isNumber = NO;
                break;
            default:
                isNumber = NO;
                break;
        }
        if ( !isNumber ) break;
    }
    CMStringNumberType result = kCMStringIsNotNumber;
    if ( isNumber ){
        if ( isDouble )
            result = kCMStringIsFloat;
        else if ( isHex )
            result = kCMStringIsHex;
        else
            result = kCMStringIsInterger;
    }
    free( chars );
    return result;
}

-( NSNumber* )numberValue {
    if ( self.length == 0 ) return [ NSNumber numberWithInt:0 ];
    CMStringNumberType numType = [ self numberType ];
    switch ( numType ){
        case kCMStringIsInterger:
#if defined(__LP64__) && __LP64__
            return [ NSNumber numberWithLong:atol([ self UTF8String ])];
#else
            return [ NSNumber numberWithInt:atoi([ self UTF8String ])];
#endif
            break;
        case kCMStringIsHex:
        {
            unsigned long value = 0;
            @try {
                value = [ self hexaValue ];
            }
            @catch (NSException *exception){
                
            }
            return [ NSNumber numberWithUnsignedLong:value ];
        }
            break;
        case kCMStringIsFloat:
            return [ NSNumber numberWithDouble:atof([ self UTF8String ])];
            break;
        case kCMStringIsBoolFalse:
            return [ NSNumber numberWithBool:NO ];
            break;
        case kCMStringIsBoolTrue:
            return [ NSNumber numberWithBool:YES ];
            break;
        default:
            break;
    }
    return nil;
}

-( long )longValue {
    return atol([ self UTF8String ]);
}

-( short )shortValue {
    return atoi([ self UTF8String ]);
}

-( char )charValue {
    return atoi([ self UTF8String ]);
}

-( unsigned char )unsignedCharValue {
    return atoi([ self UTF8String ]);
}

-( unsigned int )unsignedIntValue {
    return atoi([ self UTF8String ]);
}

-( unsigned long )unsignedLongValue {
    return atol([ self UTF8String ]);
}

-( unsigned long long )unsignedLongLongValue {
    return atoll([ self UTF8String ]);
}

-( unsigned short )unsignedShortValue {
    return atoi([ self UTF8String ]);
}

-( NSUInteger )unsignedIntegerValue {
#if defined(__LP64__) && __LP64__
    return [ self unsignedLongValue ];
#else
    return [ self unsignedIntValue ];
#endif
}

@end

@implementation NSMutableString (utils)

-( void )deleteHeadCharacters:( NSUInteger )numOfChars {
    [ self deleteCharactersInRange:NSMakeRange( 0, numOfChars )];
}

-( void )deleteFirstCharacter {
    [ self deleteHeadCharacters:1 ];
}

-( void )deleteTailCharacters:( NSUInteger )numOfChars {
    [ self deleteCharactersInRange:NSMakeRange( self.length - numOfChars, numOfChars )];
}

-( void )deleteLastCharacter {
    [ self deleteTailCharacters:1 ];
}

@end

@implementation NSAttributedString (util)

-( instancetype )initWithHTMLString:( NSString* )htmlString {
    NSData *data = [ htmlString dataUsingEncoding:NSUTF8StringEncoding ];
    if ( data != nil ) {
        return [ self initWithData:data options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                   NSCharacterEncodingDocumentAttribute: [ NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding ]}
                documentAttributes:nil error:NULL ];
    }
    return nil;
}

-( NSString* )htmlString {
    NSData *data = [ self dataFromRange:NSMakeRange( 0, self.length )
                     documentAttributes:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                           NSCharacterEncodingDocumentAttribute: [ NSNumber numberWithUnsignedInteger:NSUTF8StringEncoding ]}
                                  error:NULL ];
    if ( data != nil ) return [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding ];
    return nil;
}

@end

@implementation NSArray (stringConcat)

-( NSMutableString* )serializeToStringWithSeparator:( NSString* )separator {
    if ( separator == nil ) separator = @"";
    NSMutableString *result = [ NSMutableString string ];
    for ( NSString *s in self ){
        [ result appendFormat:@"%@%@", s, separator ];
    }
    if ( self.count > 0 && separator.length > 0 ){
        [ result deleteTailCharacters:separator.length ];
    }
    return result;
}

-( NSMutableString* )serializeToString {
    return [ self serializeToStringWithSeparator:@"" ];
}

@end

NSURL *URL( NSString* strUrl ){
    return [ NSURL URLWithString:strUrl ];
}
