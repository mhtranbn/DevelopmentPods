/**
 @file      UIDevice+systemVersion.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "UIDevice+systemVersion.h"
#import <sys/sysctl.h>

NSString *const kCMDevice_Simulator                 = @"i386";
NSString *const kCMDevice_Simulator_64              = @"x86_64";

NSString *const kCMDevice_iPad_1G                   = @"iPad1,1";
NSString *const kCMDevice_iPad_2_Wifi               = @"iPad2,1";
NSString *const kCMDevice_iPad_2_GSM                = @"iPad2,2";
NSString *const kCMDevice_iPad_2_CDMA               = @"iPad2,3";
NSString *const kCMDevice_iPad_2_WifiRevA           = @"iPad2,4";
NSString *const kCMDevice_iPad_Mini_Wifi            = @"iPad2,5";
NSString *const kCMDevice_iPad_Mini_GSM             = @"iPad2,6";
NSString *const kCMDevice_iPad_Mini_GSM_CDMA        = @"iPad2,7";
NSString *const kCMDevice_iPad_3_Wifi               = @"iPad3,1";
NSString *const kCMDevice_iPad_3_GSM_CDMA           = @"iPad3,2";
NSString *const kCMDevice_iPad_3_GSM                = @"iPad3,3";
NSString *const kCMDevice_iPad_4_Wifi               = @"iPad3,4";
NSString *const kCMDevice_iPad_4_GSM                = @"iPad3,5";
NSString *const kCMDevice_iPad_4_GSM_CDMA           = @"iPad3,6";
NSString *const kCMDevice_iPad_Air_Wifi             = @"iPad4,1";
NSString *const kCMDevice_iPad_Air_Cellular         = @"iPad4,2";
NSString *const kCMDevice_iPad_Mini2_Wifi           = @"iPad4,4";
NSString *const kCMDevice_iPad_Mini2_Cellular       = @"iPad4,5";
NSString *const kCMDevice_iPad_Mini2_Cellular_CN    = @"iPad4,6";
NSString *const kCMDevice_iPad_Mini3_Wifi           = @"iPad4,7";
NSString *const kCMDevice_iPad_Mini3_Cellular       = @"iPad4,8";
NSString *const kCMDevice_iPad_Mini3_Cellular_CN    = @"iPad4,9";
NSString *const kCMDevice_iPad_Mini4_Wifi           = @"iPad5,1";
NSString *const kCMDevice_iPad_Mini4_Cellular       = @"iPad5,2";
NSString *const kCMDevice_iPad_Air2_Wifi            = @"iPad5,3";
NSString *const kCMDevice_iPad_Air2_Cellular        = @"iPad5,4";
NSString *const kCMDevice_iPad_Pro_129_Wifi         = @"iPad6,7";
NSString *const kCMDevice_iPad_Pro_129_Cellular     = @"iPad6,8";
NSString *const kCMDevice_iPad_Pro_97_Wifi          = @"iPad6,3";
NSString *const kCMDevice_iPad_Pro_97_Cellular      = @"iPad6,4";
NSString *const kCMDevice_iPad_Gen5_Wifi            = @"iPad6,11";
NSString *const kCMDevice_iPad_Gen5_Cellular        = @"iPad6,12";
NSString *const kCMDevice_iPad_Pro_129_Gen2_Wifi    = @"iPad7,1";
NSString *const kCMDevice_iPad_Pro_129_Gen2_Cellular = @"iPad7,2";
NSString *const kCMDevice_iPad_Pro_105_Wifi         = @"iPad7,3";
NSString *const kCMDevice_iPad_Pro_105_Cellular     = @"iPad7,4";

NSString *const kCMDevice_iPhone_2G                 = @"iPhone1,1";
NSString *const kCMDevice_iPhone_3G                 = @"iPhone1,2";
NSString *const kCMDevice_iPhone_3GS                = @"iPhone2,1";
NSString *const kCMDevice_iPhone_4_GSM              = @"iPhone3,1";
NSString *const kCMDevice_iPhone_4_GSMRevA          = @"iPhone3,2";
NSString *const kCMDevice_iPhone_4_CDMA             = @"iPhone3,3";
NSString *const kCMDevice_iPhone_4S                 = @"iPhone4,1";
NSString *const kCMDevice_iPhone_5_GSM              = @"iPhone5,1";
NSString *const kCMDevice_iPhone_5_GSM_CDMA         = @"iPhone5,2";
NSString *const kCMDevice_iPhone_5C_GSM             = @"iPhone5,3";
NSString *const kCMDevice_iPhone_5C_Global          = @"iPhone5,4";
NSString *const kCMDevice_iPhone_5S_GSM             = @"iPhone6,1";
NSString *const kCMDevice_iPhone_5S_Global          = @"iPhone6,2";
NSString *const kCMDevice_iPhone_6P                 = @"iPhone7,1";
NSString *const kCMDevice_iPhone_6                  = @"iPhone7,2";
NSString *const kCMDevice_iPhone_6S                 = @"iPhone8,1";
NSString *const kCMDevice_iPhone_6SP                = @"iPhone8,2";
NSString *const kCMDevice_iPhone_SE                 = @"iPhone8,4";
NSString *const kCMDevice_iPhone_7_CDMA             = @"iPhone9,1";
NSString *const kCMDevice_iPhone_7P_CDMA            = @"iPhone9,2";
NSString *const kCMDevice_iPhone_7_Global           = @"iPhone9,3";
NSString *const kCMDevice_iPhone_7P_Global          = @"iPhone9,4";
NSString *const kCMDevice_iPhone_8_Global           = @"iPhone10,1";
NSString *const kCMDevice_iPhone_8P_Global          = @"iPhone10,2";
NSString *const kCMDevice_iPhone_X_Global           = @"iPhone10,3";
NSString *const kCMDevice_iPhone_8_Japan            = @"iPhone10,4";
NSString *const kCMDevice_iPhone_8P_Japan           = @"iPhone10,5";
NSString *const kCMDevice_iPhone_X_Japan            = @"iPhone10,6";

NSString *const kCMDevice_iPod_1G                   = @"iPod1,1";
NSString *const kCMDevice_iPod_2G                   = @"iPod2,1";
NSString *const kCMDevice_iPod_3G                   = @"iPod3,1";
NSString *const kCMDevice_iPod_4G                   = @"iPod4,1";
NSString *const kCMDevice_iPod_5G                   = @"iPod5,1";
NSString *const kCMDevice_iPod_6G                   = @"iPod7,1";

NSString *const kCMDevice_Watch_38                  = @"Watch1,1";
NSString *const kCMDevice_Watch_42                  = @"Watch1,2";

NSString *const kCMDevice_Tv_2G                     = @"AppleTV2,1";
NSString *const kCMDevice_Tv_3G                     = @"AppleTV3,1";
NSString *const kCMDevice_Tv_3GRevA                 = @"AppleTV3,2";
NSString *const kCMDevice_Tv_4G                     = @"AppleTV5,3";
NSString *const kCMDevice_Tv_4G_4K                  = @"AppleTV6,2";

@implementation UIDevice (systemVersion)

-( BOOL )compareSystemVersionWithVersion:( NSString* )version
                             compareMode:( iOSVersionComparisonMode )mode {
    NSComparisonResult result = [[ self systemVersion ] compare:version
                                                        options:NSNumericSearch ];
    switch ( mode ){
        case kiOSVerCmpSame:
            return ( result == NSOrderedSame );
            break;
        case kiOSVerCmpNewer:
            return ( result == NSOrderedDescending );
            break;
        case kiOSVerCmpSameOrNewer:
            return ( result != NSOrderedAscending );
            break;
        case kiOSVerCmpOlder:
            return ( result == NSOrderedAscending );
            break;
        case kiOSVerCmpSameOrOlder:
            return ( result != NSOrderedDescending );
            break;
    }
    return NO;
}

+( NSString* )getHardwareIdentifier {
    size_t size;
    sysctlbyname( "hw.machine", NULL, &size, NULL, 0 );
    
    char *answer = malloc( size );
    sysctlbyname( "hw.machine", answer, &size, NULL, 0 );
    
    NSString *result = [ NSString stringWithCString:answer encoding:NSUTF8StringEncoding ];
    free( answer );
    
    return result;
}

+( CMDeviceHardwareType )getDeviceHardwareType {
    NSString *hwMachine = [ self getHardwareIdentifier ];
    if ([@[ kCMDevice_Simulator, kCMDevice_Simulator_64 ] containsObject:hwMachine ])
        return kCMDeviceSimulator;
    else if ([ hwMachine rangeOfString:@"iPad" ].location == 0 )
        return kCMDeviceiPad;
    else if ([ hwMachine rangeOfString:@"iPhone" ].location == 0 )
        return kCMDeviceiPhone;
    else if ([ hwMachine rangeOfString:@"iPod" ].location == 0 )
        return kCMDeviceiPodTouch;
    else if ([ hwMachine rangeOfString:@"Watch" ].location == 0 )
        return kCMDeviceWatch;
    else if ([ hwMachine rangeOfString:@"AppleTV" ].location == 0 )
        return kCMDeviceTv;
    else
        return kCMDeviceUnknown;
}

@end
