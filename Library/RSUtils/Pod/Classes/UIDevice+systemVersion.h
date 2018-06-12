/**
 @file      UIDevice+systemVersion.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <UIKit/UIKit.h>

typedef NS_ENUM( unsigned int, iOSVersionComparisonMode ){
    /**
     *  System version is same with target version
     */
    kiOSVerCmpSame,
    /**
     *  System version is newer than target version
     */
    kiOSVerCmpNewer,
    /**
     *  System version is newer or same with target version
     */
    kiOSVerCmpSameOrNewer,
    /**
     *  System version is older than target version
     */
    kiOSVerCmpOlder,
    /**
     *  System verison is older or same with target version
     */
    kiOSVerCmpSameOrOlder
};

typedef NS_ENUM( unsigned int, CMDeviceHardwareType ){
    kCMDeviceUnknown,
    kCMDeviceSimulator,
    kCMDeviceiPad,
    kCMDeviceiPhone,
    kCMDeviceiPodTouch,
    kCMDeviceWatch,
    kCMDeviceTv
};

extern NSString *const _Nonnull kCMDevice_Simulator;
extern NSString *const _Nonnull kCMDevice_Simulator_64;

extern NSString *const _Nonnull kCMDevice_iPad_1G;
extern NSString *const _Nonnull kCMDevice_iPad_2_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_2_GSM;
extern NSString *const _Nonnull kCMDevice_iPad_2_CDMA;
extern NSString *const _Nonnull kCMDevice_iPad_2_WifiRevA;
extern NSString *const _Nonnull kCMDevice_iPad_Mini_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Mini_GSM;
extern NSString *const _Nonnull kCMDevice_iPad_Mini_GSM_CDMA;
extern NSString *const _Nonnull kCMDevice_iPad_3_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_3_GSM_CDMA;
extern NSString *const _Nonnull kCMDevice_iPad_3_GSM;
extern NSString *const _Nonnull kCMDevice_iPad_4_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_4_GSM;
extern NSString *const _Nonnull kCMDevice_iPad_4_GSM_CDMA;
extern NSString *const _Nonnull kCMDevice_iPad_Air_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Air_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Mini2_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Mini2_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Mini2_Cellular_CN;
extern NSString *const _Nonnull kCMDevice_iPad_Mini3_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Mini3_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Mini3_Cellular_CN;
extern NSString *const _Nonnull kCMDevice_iPad_Mini4_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Mini4_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Air2_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Air2_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_129_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_129_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_97_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_97_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Gen5_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Gen5_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_129_Gen2_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_129_Gen2_Cellular;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_105_Wifi;
extern NSString *const _Nonnull kCMDevice_iPad_Pro_105_Cellular;

extern NSString *const _Nonnull kCMDevice_iPhone_2G;
extern NSString *const _Nonnull kCMDevice_iPhone_3G;
extern NSString *const _Nonnull kCMDevice_iPhone_3GS;
extern NSString *const _Nonnull kCMDevice_iPhone_4_GSM;
extern NSString *const _Nonnull kCMDevice_iPhone_4_GSMRevA;
extern NSString *const _Nonnull kCMDevice_iPhone_4_CDMA;
extern NSString *const _Nonnull kCMDevice_iPhone_4S;
extern NSString *const _Nonnull kCMDevice_iPhone_5_GSM;
extern NSString *const _Nonnull kCMDevice_iPhone_5_GSM_CDMA;
extern NSString *const _Nonnull kCMDevice_iPhone_5C_GSM;
extern NSString *const _Nonnull kCMDevice_iPhone_5C_Global;
extern NSString *const _Nonnull kCMDevice_iPhone_5S_GSM;
extern NSString *const _Nonnull kCMDevice_iPhone_5S_Global;
extern NSString *const _Nonnull kCMDevice_iPhone_6P;
extern NSString *const _Nonnull kCMDevice_iPhone_6;
extern NSString *const _Nonnull kCMDevice_iPhone_6S;
extern NSString *const _Nonnull kCMDevice_iPhone_6SP;
extern NSString *const _Nonnull kCMDevice_iPhone_SE;
extern NSString *const _Nonnull kCMDevice_iPhone_7_CDMA;
extern NSString *const _Nonnull kCMDevice_iPhone_7P_CDMA;
extern NSString *const _Nonnull kCMDevice_iPhone_7_Global;
extern NSString *const _Nonnull kCMDevice_iPhone_7P_Global;
extern NSString *const _Nonnull kCMDevice_iPhone_8_Global;
extern NSString *const _Nonnull kCMDevice_iPhone_8P_Global;
extern NSString *const _Nonnull kCMDevice_iPhone_X_Global;
extern NSString *const _Nonnull kCMDevice_iPhone_8_Japan;
extern NSString *const _Nonnull kCMDevice_iPhone_8P_Japan;
extern NSString *const _Nonnull kCMDevice_iPhone_X_Japan;

extern NSString *const _Nonnull kCMDevice_iPod_1G;
extern NSString *const _Nonnull kCMDevice_iPod_2G;
extern NSString *const _Nonnull kCMDevice_iPod_3G;
extern NSString *const _Nonnull kCMDevice_iPod_4G;
extern NSString *const _Nonnull kCMDevice_iPod_5G;
extern NSString *const _Nonnull kCMDevice_iPod_6G;

extern NSString *const _Nonnull kCMDevice_Watch_38;
extern NSString *const _Nonnull kCMDevice_Watch_42;

extern NSString *const _Nonnull kCMDevice_Tv_2G;
extern NSString *const _Nonnull kCMDevice_Tv_3G;
extern NSString *const _Nonnull kCMDevice_Tv_3GRevA;
extern NSString *const _Nonnull kCMDevice_Tv_4G;
extern NSString *const _Nonnull kCMDevice_Tv_4G_4K;

@interface UIDevice (systemVersion)

/**
 *  Compare systemVersion with specified version
 *
 *  @param version Version to compare with
 *  @param mode    Comparison mode
 *
 *  @return YES if systemVersion is match with target version for selected mode.
 */
-( BOOL )compareSystemVersionWithVersion:( nonnull NSString* )version
                             compareMode:( iOSVersionComparisonMode )mode;
/**
 *  @return Hardware identifier string
 */
+( nonnull NSString* )getHardwareIdentifier;
/**
 *  @return Hardware type by Hardware identifier string
 */
+( CMDeviceHardwareType )getDeviceHardwareType;

@end
