/**
 @file      CMLogger.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSArrayDictionary+Description.h"

extern NSString *const _Nonnull CMLogDateFormat;

/**
 *  General log
 *
 *  @param format Format to log
 *  @param ...    Arguments
 */
#define CMLog( format, ... )                    [ CMLogger logAtFile:__FILE__ atMethod:__FUNCTION__ atLine:__LINE__ fromSource:nil withCategory:nil content:(format), ##__VA_ARGS__ ]
/**
 * CMLog with sender (self) (Do not use in block)
 */
#define CMLogS( format, ... )                   [ CMLogger logAtFile:__FILE__ atMethod:__FUNCTION__ atLine:__LINE__ fromSource:self withCategory:nil content:(format), ##__VA_ARGS__ ]
/**
 *  Log with category name
 *
 *  @param category Category
 *  @param format   Format to log
 *  @param ...      Arguments
 */
#define CMLogCat( category, format, ... )       [ CMLogger logAtFile:__FILE__ atMethod:__FUNCTION__ atLine:__LINE__ fromSource:nil withCategory:(category) content:(format), ##__VA_ARGS__ ]
/**
 * CMLogCat with sender (self) (Do not use in block)
 */
#define CMLogCatS( category, format, ... )      [ CMLogger logAtFile:__FILE__ atMethod:__FUNCTION__ atLine:__LINE__ fromSource:self withCategory:(category) content:(format), ##__VA_ARGS__ ]

@protocol CMLogClientProtocol <NSObject>
@required

/**
 Name of client
 */
-( nonnull NSString* )name;
/**
 Description to show
 */
-( nonnull NSString* )details;

-( void )logAtTime:( nonnull NSDate* )date
            atFile:( nullable NSString* )file
          atMethod:( nullable NSString* )method
            atLine:( unsigned long )line
       processName:( nonnull NSString* )procName
         processId:( int  )procId
          threadId:( mach_port_t )thread
      isMainThread:( BOOL )isMainThread
        fromSource:( nullable id )sender
      withCategory:( nullable NSString* )category
           content:( nonnull NSString* )content;

@optional

-( void )crashAtTime:( nonnull NSDate* )date
         processName:( nonnull NSString* )procName
           processId:( int  )procId
            threadId:( mach_port_t )thread
        isMainThread:( BOOL )isMainThread
              detail:( nonnull NSException* )error;

@end

@interface CMLogger : NSObject

@property ( nonatomic, strong, readonly, nonnull ) NSOperationQueue *logQueue;

/**
 *  Configure log.
 *
 *  @param isLogEnable        Set log enable. We can set enable only in DEBUG. If NO, this option disable all other options.
 */
+( void )configLogEnable:( BOOL )isLogEnable;

/**
 *  Enable/Disable log by category
 *
 *  @param logCategory Category to filter
 *  @param enable      Enable/Disable
 */
+( void )filterByCategory:( nonnull NSString* )logCategory enable:( BOOL )enable;
/**
 *  Only log given category. Use nil category to unset.
 *
 *  @param logCategory Log category name
 */
+( void )logOnlyCategory:( nullable NSString* )logCategory;

// User CMLog, SKLog instead
+( void )logAtFile:( nonnull const char * )file
          atMethod:( nonnull const char * )method
            atLine:( unsigned long )line
        fromSource:( nullable id )sender
      withCategory:( nullable NSString* )category
           content:( nullable NSString* )format, ...;
+( void )logAtSwiftFile:( nonnull NSString* )file
               atMethod:( nonnull NSString* )method
                 atLine:( NSInteger )line
             fromSource:( nullable id )sender
           withCategory:( nullable NSString* )category
                content:( nonnull NSString* )content;

/**
 Add log client

 @param logClient A client to do additional job of logging
 @param identifier Name for client
 */
+( void )addLogClient:( nonnull id<CMLogClientProtocol> )logClient forKey:( nonnull NSString* )identifier;
/**
 Remove log client

 @param identifier Name of client
 @return Client object
 */
+( nullable id<CMLogClientProtocol> )removeLogClientForKey:( nonnull NSString* )identifier;

@end
