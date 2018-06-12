/**
 @file      NSDate+format.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

#define DFM_AM_PM       @"a"    // AM/PM
#define DFM_WDAY_S      @"E"    // Mon
#define DFM_WDAY_L      @"EEEE" // Monday
#define DFM_WDAY_NUM_S  @"e"    // 2
#define DFM_WDAY_NUM_L  @"ee"   // 02
#define DFM_DAY_S       @"d"    // 1
#define DFM_DAY_L       @"dd"   // 01
#define DFM_MONTH_NUM_S @"M"    // 1
#define DFM_MONTH_NUM_L @"MM"   // 01
#define DFM_MONTH_S     @"MMM"  // Jan
#define DFM_MONTH_L     @"MMMM" // January
#define DFM_YEAR_S      @"yy"   // 14
#define DFM_YEAR_L      @"y"    // 2014
#define DFM_HOUR24_S    @"H"    // 1 (0..23)
#define DFM_HOUR24_L    @"HH"   // 01 (00..23)
#define DFM_HOUR12_S    @"h"    // 1 (1..12)
#define DFM_HOUR12_L    @"hh"   // 01 (1..12)
#define DFM_MINUTE_S    @"m"    // 1
#define DFM_MINUTE_L    @"mm"   // 01
#define DFM_SECOND_S    @"s"    // 1
#define DFM_SECOND_L    @"ss"   // 01
#define DFM_MILISECOND  @"SSS"  // 012
#define DFM_TZONE_S     @"Z"    // +0700
#define DFM_TZONE_L     @"ZZZZZ"// +07:00
#define DFM_LCL_TZONE_S @"z"    // GMT+7
#define DFM_LCL_TZONE_L @"ZZZZ" // GMT+07:00

@interface NSDate (format)

/**
 *  Return the calendar identifier with current iOS version
 *
 *  @param calendarId Calendar ID
 *
 *  @return Eg. input NSCalendarIdentifierGregorian or NSGregorianCalendar,
 *  return NSCalendarIdentifierGregorian if iOS 8, otherwise NSGregorianCalendar.
 *  Return nil if calendar id is unavailable.
 */
+( nullable NSString* )calendarIdentifierBridge:( nullable NSString* )calendarId;

/**
 *  Convert date to string using standard settings
 *
 *  @param format Format to make string
 *
 *  @return String of date with Gregorian calendar, timezone GMT+0, locale settings "en-US"
 */
-( nullable NSString* )stringWithFormat:( nullable NSString* )format;
/**
 *  Convert date to string using local settings
 *
 *  @param format Format to make string
 *
 *  @return String of date
 */
-( nullable NSString* )stringWithLocalSettingsAndFormat:( nullable NSString* )format;
/**
 *  Convert date to string using default settings
 *
 *  @param format Format to make string
 *
 *  @return String of date
 */
-( nullable NSString* )stringWithDefaultSettingsAndFormat:( nullable NSString* )format;
/**
 *  Convert date to string using specified settings
 *
 *  @param format       Format to make string
 *  @param calendarType Calendar identifier
 *  @param seconds      Seconds from GMT
 *  @param locale       Locale identifier (this is setting about time format digit...)
 *
 *  @return String of date
 */
-( nullable NSString* )stringWithFormat:( nullable NSString* )format calendarType:( nullable NSString* )calendarType
              timezoneWitSecondsFromGMT:( NSInteger )seconds localeIdentifier:( nullable NSString* )locale;
/**
 *  Try to convert the specified string to NSDate, using standard settings (Gregorian calendar, timezone GMT+0, locale "en-US").
 *
 *  @param string Date string
 *  @param format Format of given date string
 *
 *  @return nil if failed.
 */
+( nullable NSDate* )dateTimeFromString:( nullable NSString* )string withFormat:( nullable NSString* )format;
/**
 *  Convert string to NSDate, using local settings.
 *
 *  @param string Date string
 *  @param format Format of given date string
 *
 *  @return nil if failed.
 */
+( nullable NSDate* )dateTimeWithLocalSettingsFromString:( nullable NSString* )string withFormat:( nullable NSString* )format;
/**
 *  Convert string to NSDate, using default settings.
 *
 *  @param string Date string
 *  @param format Format of given date string
 *
 *  @return nil if failed.
 */
+( nullable NSDate* )dateTimeWithDefaultSettingsFromString:( nullable NSString* )string withFormat:( nullable NSString* )format;
/**
 *  Convet string to NSDate using given settings
 *
 *  @param string       String to convert
 *  @param format       Date format of input string
 *  @param calendarType Calendar identifier
 *  @param seconds      Seconds from GMT
 *  @param locale       Locale identifier
 *
 *  @return nil if failed.
 */
+( nullable NSDate* )dateTimeFromString:( nullable NSString* )string withFormat:( nullable NSString* )format
                           calendarType:( nullable NSString* )calendarType
              timezoneWitSecondsFromGMT:( NSInteger )seconds
                       localeIdentifier:( nullable NSString* )locale;
/**
 *  Extract year, month, day, hour, min, second from date using starndard locale & timezone
 *
 *  @return NSDateComponents object
 */
-( nonnull NSDateComponents* )commonComponents;
-( nonnull NSDateComponents* )commonLocalComponents;
-( nonnull NSDateComponents* )commonDefaultComponents;
-( nonnull NSDateComponents* )commonComponentsWithLocaleIdentifier:( nullable NSString* )locale
                                         timezoneWitSecondsFromGMT:( NSInteger )seconds;

@end
