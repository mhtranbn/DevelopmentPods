/**
 @file      NSDate+format.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSDate+format.h"
#import "UIDevice+systemVersion.h"

@implementation NSDate (format)

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+( NSString* )calendarIdentifierBridge:( NSString* )calendarId {
    if ([[ UIDevice currentDevice ] compareSystemVersionWithVersion:@"8.0"
                                                        compareMode:kiOSVerCmpSameOrNewer ]){
        if ([ calendarId isEqualToString:NSGregorianCalendar ] ||
            [ calendarId isEqualToString:NSCalendarIdentifierGregorian ]){
            return NSCalendarIdentifierGregorian;
        } else if ([ calendarId isEqualToString:NSBuddhistCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierBuddhist ]){
            return NSCalendarIdentifierBuddhist;
        } else if ([ calendarId isEqualToString:NSChineseCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierChinese ]){
            return NSCalendarIdentifierChinese;
        } else if ([ calendarId isEqualToString:NSHebrewCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierHebrew ]){
            return NSCalendarIdentifierHebrew;
        } else if ([ calendarId isEqualToString:NSIslamicCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIslamic ]){
            return NSCalendarIdentifierIslamic;
        } else if ([ calendarId isEqualToString:NSIslamicCivilCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIslamicCivil ]){
            return NSCalendarIdentifierIslamicCivil;
        } else if ([ calendarId isEqualToString:NSJapaneseCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierJapanese ]){
            return NSCalendarIdentifierJapanese;
        } else if ([ calendarId isEqualToString:NSRepublicOfChinaCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierRepublicOfChina ]){
            return NSCalendarIdentifierRepublicOfChina;
        } else if ([ calendarId isEqualToString:NSPersianCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierPersian ]){
            return NSCalendarIdentifierPersian;
        } else if ([ calendarId isEqualToString:NSIndianCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIndian ]){
            return NSCalendarIdentifierIndian;
        } else if ([ calendarId isEqualToString:NSISO8601Calendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierISO8601 ]){
            return NSCalendarIdentifierISO8601;
        } else if ([ calendarId isEqualToString:NSCalendarIdentifierCoptic ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierEthiopicAmeteAlem ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierEthiopicAmeteMihret ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIslamicTabular ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIslamicUmmAlQura ]){
            return calendarId;
        }
    } else {
        if ([ calendarId isEqualToString:NSGregorianCalendar ] ||
            [ calendarId isEqualToString:NSCalendarIdentifierGregorian ]){
            return NSGregorianCalendar;
        } else if ([ calendarId isEqualToString:NSBuddhistCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierBuddhist ]){
            return NSBuddhistCalendar;
        } else if ([ calendarId isEqualToString:NSChineseCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierChinese ]){
            return NSChineseCalendar;
        } else if ([ calendarId isEqualToString:NSHebrewCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierHebrew ]){
            return NSHebrewCalendar;
        } else if ([ calendarId isEqualToString:NSIslamicCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIslamic ]){
            return NSIslamicCalendar;
        } else if ([ calendarId isEqualToString:NSIslamicCivilCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIslamicCivil ]){
            return NSIslamicCivilCalendar;
        } else if ([ calendarId isEqualToString:NSJapaneseCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierJapanese ]){
            return NSJapaneseCalendar;
        } else if ([ calendarId isEqualToString:NSRepublicOfChinaCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierRepublicOfChina ]){
            return NSRepublicOfChinaCalendar;
        } else if ([ calendarId isEqualToString:NSPersianCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierPersian ]){
            return NSPersianCalendar;
        } else if ([ calendarId isEqualToString:NSIndianCalendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierIndian ]){
            return NSIndianCalendar;
        } else if ([ calendarId isEqualToString:NSISO8601Calendar ] ||
                   [ calendarId isEqualToString:NSCalendarIdentifierISO8601 ]){
            return NSISO8601Calendar;
        }
    }
    return nil;
}

-( NSString* )stringWithFormat:( NSString* )format {
    if ( format == nil || format.length == 0 ) return nil;
    NSString *calendarType = nil;
    if ([[ UIDevice currentDevice ] compareSystemVersionWithVersion:@"8.0"
                                                        compareMode:kiOSVerCmpSameOrNewer ]){
        calendarType = NSCalendarIdentifierGregorian;
    } else {
        calendarType = NSGregorianCalendar;
    }
    return [ self stringWithFormat:format calendarType:calendarType
         timezoneWitSecondsFromGMT:0 localeIdentifier:@"en_US" ];
}

-( NSString* )stringWithLocalSettingsAndFormat:( NSString* )format {
    return [ self stringWithFormat:format
                      calendarType:[[ NSCalendar currentCalendar ] calendarIdentifier ]
         timezoneWitSecondsFromGMT:[[ NSTimeZone localTimeZone ] secondsFromGMT ]
                  localeIdentifier:[[ NSLocale currentLocale ] localeIdentifier ]];
}

-( NSString* )stringWithDefaultSettingsAndFormat:( NSString* )format {
    if ( format == nil || format.length == 0 ) return nil;
    NSDateFormatter *formatter = [[ NSDateFormatter alloc ] init ];
    formatter.dateFormat = format;
    return [ formatter stringFromDate:self ];
}

-( NSString* )stringWithFormat:( NSString* )format calendarType:( NSString* )calendarType
     timezoneWitSecondsFromGMT:( NSInteger )seconds localeIdentifier:( NSString* )locale {
    if ( format == nil || format.length == 0 ) return nil;
    NSDateFormatter *dateFormatter = [[ NSDateFormatter alloc ] init ];
    if ( calendarType )
        dateFormatter.calendar = [[ NSCalendar alloc ] initWithCalendarIdentifier:calendarType ];
    dateFormatter.timeZone = [ NSTimeZone timeZoneForSecondsFromGMT:seconds ];
    if ( locale )
        dateFormatter.locale = [ NSLocale localeWithLocaleIdentifier:locale ];
    dateFormatter.dateFormat = format;
    return [ dateFormatter stringFromDate:self ];
}

+( NSDate* )dateTimeFromString:( NSString* )string withFormat:( NSString* )format {
    if ( string == nil || string.length == 0 || format == nil || format.length == 0 ) return nil;
    NSString *calendarType = nil;
    if ([[ UIDevice currentDevice ] compareSystemVersionWithVersion:@"8.0"
                                                        compareMode:kiOSVerCmpSameOrNewer ]){
        calendarType = NSCalendarIdentifierGregorian;
    } else {
        calendarType = NSGregorianCalendar;
    }
    return [ self dateTimeFromString:string
                          withFormat:format
                        calendarType:calendarType
           timezoneWitSecondsFromGMT:0
                    localeIdentifier:@"en_US" ];
}

+( NSDate* )dateTimeWithLocalSettingsFromString:( NSString* )string withFormat:( NSString* )format {
    return [ self dateTimeFromString:string
                          withFormat:format
                        calendarType:[[ NSCalendar currentCalendar ] calendarIdentifier ]
           timezoneWitSecondsFromGMT:[[ NSTimeZone localTimeZone ] secondsFromGMT ]
                    localeIdentifier:[[ NSLocale currentLocale ] localeIdentifier ]];
}

+( NSDate* )dateTimeWithDefaultSettingsFromString:( NSString* )string withFormat:( NSString* )format {
    if ( string == nil || string.length == 0 || format == nil || format.length == 0 ) return nil;
    NSDateFormatter *formatter = [[ NSDateFormatter alloc ] init ];
    formatter.dateFormat = format;
    return [ formatter dateFromString:string ];
}

+( NSDate* )dateTimeFromString:( NSString* )string withFormat:( NSString* )format
                  calendarType:( NSString* )calendarType
     timezoneWitSecondsFromGMT:( NSInteger )seconds
              localeIdentifier:( NSString* )locale {
    if ( string == nil || string.length == 0 || format == nil || format.length == 0 ) return nil;
    NSDateFormatter *dateFormatter = [[ NSDateFormatter alloc ] init ];
    if ( calendarType )
        dateFormatter.calendar = [[ NSCalendar alloc ] initWithCalendarIdentifier:calendarType ];
    dateFormatter.timeZone = [ NSTimeZone timeZoneForSecondsFromGMT:seconds ];
    if ( locale )
        dateFormatter.locale = [ NSLocale localeWithLocaleIdentifier:locale ];
    dateFormatter.dateFormat = format;
    return [ dateFormatter dateFromString:string ];
}

-( NSDateComponents* )commonComponents {
    return [ self commonComponentsWithLocaleIdentifier:@"en_US" timezoneWitSecondsFromGMT:0 ];
}

-( NSDateComponents* )commonLocalComponents {
    return [ self commonComponentsWithLocaleIdentifier:[[ NSLocale currentLocale ] localeIdentifier ]
                             timezoneWitSecondsFromGMT:[[ NSTimeZone localTimeZone ] secondsFromGMT ]];
}

-( NSDateComponents* )commonDefaultComponents {
    if ([[ UIDevice currentDevice ] compareSystemVersionWithVersion:@"8.0"
                                                        compareMode:kiOSVerCmpSameOrNewer ]){
        NSCalendar *aCalender = [[ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
        return [ aCalender components:( NSCalendarUnitSecond |
                                       NSCalendarUnitMinute |
                                       NSCalendarUnitHour |
                                       NSCalendarUnitDay |
                                       NSCalendarUnitMonth |
                                       NSCalendarUnitYear )
                             fromDate:self ];
    } else {
        NSCalendar *aCalender = [[ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
        return [ aCalender components:( NSSecondCalendarUnit |
                                       NSMinuteCalendarUnit |
                                       NSHourCalendarUnit |
                                       NSDayCalendarUnit |
                                       NSMonthCalendarUnit |
                                       NSYearCalendarUnit )
                             fromDate:self ];
    }
}

-( NSDateComponents* )commonComponentsWithLocaleIdentifier:( NSString* )locale timezoneWitSecondsFromGMT:( NSInteger )seconds {
    if ([[ UIDevice currentDevice ] compareSystemVersionWithVersion:@"8.0"
                                                        compareMode:kiOSVerCmpSameOrNewer ]){
        NSCalendar *aCalender = [[ NSCalendar alloc ] initWithCalendarIdentifier:NSCalendarIdentifierGregorian ];
        if ( locale ) aCalender.locale = [ NSLocale localeWithLocaleIdentifier:locale ];
        aCalender.timeZone = [ NSTimeZone timeZoneForSecondsFromGMT:seconds ];
        return [ aCalender components:( NSCalendarUnitSecond |
                                       NSCalendarUnitMinute |
                                       NSCalendarUnitHour |
                                       NSCalendarUnitDay |
                                       NSCalendarUnitMonth |
                                       NSCalendarUnitYear )
                             fromDate:self ];
    } else {
        NSCalendar *aCalender = [[ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
        if ( locale ) aCalender.locale = [ NSLocale localeWithLocaleIdentifier:locale ];
        aCalender.timeZone = [ NSTimeZone timeZoneForSecondsFromGMT:seconds ];
        return [ aCalender components:( NSSecondCalendarUnit |
                                       NSMinuteCalendarUnit |
                                       NSHourCalendarUnit |
                                       NSDayCalendarUnit |
                                       NSMonthCalendarUnit |
                                       NSYearCalendarUnit )
                             fromDate:self ];
    }
}

#pragma GCC diagnostic pop
@end
