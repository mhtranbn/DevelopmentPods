/**
 @file      CMLogger.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "CMLogger.h"
#import <pthread.h>

NSString *const CMLogDateFormat = @"y-MM-dd HH:mm:ss.SSS";

@import RSUtils;

@interface CMLogger()

@property ( nonatomic, assign ) BOOL isLogEnable;

@property ( nonatomic, strong ) NSMutableArray *arrDisabledCategories;
@property ( nonatomic, strong ) NSString *onlyCategory;
@property ( nonatomic, strong ) NSMutableDictionary<NSString*, id<CMLogClientProtocol>> *clients;

+( instancetype )defaultLogger;

@end

@implementation CMLogger

+( void )_logAtFile:( const char* )file atMethod:( const char* )method atLine:( unsigned long )line
         fromSource:( id )sender withCategory:( NSString* )category content:( NSString* )content {
    CMLogger *defaultLogger = [ self defaultLogger ];
    if ( !defaultLogger.isLogEnable ) return;

    NSDate *date = [ NSDate date ];
    NSProcessInfo *processInfo = [ NSProcessInfo processInfo ];
    int processId = processInfo.processIdentifier;
    mach_port_t threadId = pthread_mach_thread_np( pthread_self() );
    BOOL isMainThread = [ NSThread isMainThread ];

    NSBlockOperation *operation = [ NSBlockOperation blockOperationWithBlock:^{
        // Category
        if ( category ) {
            if ([ defaultLogger isCategoryDisabled:category ]) return;
            printf( "[%s] ", [ category UTF8String ]);
        }
        // Date-time
        NSString *dateString = [ date stringWithLocalSettingsAndFormat:CMLogDateFormat ];
        printf( "%s ", [ dateString UTF8String ]);
        // Process, thread
        NSString *processName = processInfo.processName;
        printf( "[%s:%d:%x%s] ", [ processName UTF8String ], processId, threadId, isMainThread ? "-m" : "" );
        // File, line, function
        char * fileName = ( char* )file;
        if ( file ) {
            fileName = strrchr( file, '/' );
            if ( fileName )
                fileName += 1;
            else
                fileName = ( char* )file;
            printf( "%s [%lu]: %s ", fileName, line, method ? method : "" );
        }
        if ( sender != nil ) {
            printf( "[%s <%p>]", [ NSStringFromClass([ sender class ]) UTF8String ], sender );
        }
        printf( "\n" );
        // Content
        printf( "%s\n", content.UTF8String );
        // End log
        char *endOfLog = "¶";
        printf( "%s\n", endOfLog );

        if ( defaultLogger.clients != nil ) {
            for ( id<CMLogClientProtocol> client in defaultLogger.clients.allValues ) {
                [ client logAtTime:date
                            atFile:fileName != nil ? [ NSString stringWithUTF8String:fileName ] : nil
                          atMethod:method != nil ? [ NSString stringWithUTF8String:method ] : nil
                            atLine:line
                       processName:processName
                         processId:processId
                          threadId:threadId
                      isMainThread:isMainThread
                        fromSource:sender
                      withCategory:category
                           content:content ];
            }
        }
    }];
    [ defaultLogger.logQueue addOperation:operation ];
}

+( void )logAtSwiftFile:( NSString* )file atMethod:( NSString* )method atLine:( NSInteger )line fromSource:( id )sender
           withCategory:( NSString* )category content:( NSString* )content {
    [ self _logAtFile:[ file UTF8String ] atMethod:[ method UTF8String ] atLine:line fromSource:sender
         withCategory:category content:content ];
}

+( void )logAtFile:( const char* )file atMethod:( const char* )method atLine:( unsigned long )line fromSource:( id )sender
      withCategory:( NSString* )category content:( NSString* )format, ... {
    va_list args;
    va_start( args, format );
    NSString *content = [[ NSString alloc ] initWithFormat:format arguments:args ];
    va_end( args );
    [ self _logAtFile:file atMethod:method atLine:line fromSource:sender withCategory:category content:content ];
}

#pragma mark - Private

-( BOOL )isCategoryDisabled:( NSString* )category {
    if ( self.onlyCategory != nil ) return ![ category isEqualToString:self.onlyCategory ];
    if ( category ) return [ self.arrDisabledCategories containsObject:category ];
    return NO;
}

-( void )setCategory:( NSString* )category enable:( BOOL )enable {
    if ( category == nil ) return;
    if ( enable ) {
        [ self.arrDisabledCategories removeObject:category ];
    } else if (![ self.arrDisabledCategories containsObject:category ]) {
        [ self.arrDisabledCategories addObject:[ NSString stringWithString:category ]];
    }
}

void SKLog_uncaughtExceptionHandler( NSException *exception ){
    CMLogger *logger = [ CMLogger defaultLogger ];
    if ( !logger.isLogEnable || logger.clients == nil || logger.clients.count == 0 ) return;
    NSDate *date = [ NSDate date ];
    NSProcessInfo *processInfo = [ NSProcessInfo processInfo ];
    NSString *processName = processInfo.processName;
    int processId = processInfo.processIdentifier;
    mach_port_t threadId = pthread_mach_thread_np( pthread_self() );
    BOOL isMainThread = [ NSThread isMainThread ];
    for ( id<CMLogClientProtocol> client in logger.clients.allValues ) {
        if ([ client respondsToSelector:@selector( crashAtTime:processName:processId:threadId:isMainThread:detail: )]) {
            [ client crashAtTime:date processName:processName processId:processId
                        threadId:threadId isMainThread:isMainThread detail:exception ];
        }
    }
}

#pragma mark - Clients

+( void )addLogClient:( id<CMLogClientProtocol> )logClient forKey:( NSString* )identifier {
    CMLogger *logger = [ self defaultLogger ];
    if ( logger.clients == nil ) logger.clients = [ NSMutableDictionary new ];
    [ logger.clients setObject:logClient forKey:identifier ];
}

+( id<CMLogClientProtocol> )removeLogClientForKey:( NSString* )identifier {
    CMLogger *logger = [ self defaultLogger ];
    if ( logger.clients != nil && [ logger.clients.allKeys containsObject:identifier ]) {
        id<CMLogClientProtocol> obj = [ logger.clients objectForKey:identifier ];
        [ logger.clients removeObjectForKey:identifier ];
        return obj;
    }
    return nil;
}

#pragma mark - Life cycle

+( instancetype )defaultLogger {
    static CMLogger *__logger;
    if ( __logger == nil ) __logger = [[ self alloc ] init ];
    return __logger;
}

-( instancetype )init {
    if ( self = [ super init ]) {
        _arrDisabledCategories = [ NSMutableArray array ];
        _logQueue = [ NSOperationQueue new ];
        _logQueue.maxConcurrentOperationCount = 1;
        NSSetUncaughtExceptionHandler( &SKLog_uncaughtExceptionHandler );
    }
    return self;
}

-( void )configLogEnable:( BOOL )isLogEnable {
    self.isLogEnable = isLogEnable;
}

+( void )configLogEnable:( BOOL )isLogEnable {
    [[ self defaultLogger ] configLogEnable:isLogEnable ];
}

+( void )filterByCategory:( NSString* )logCategory enable:( BOOL )enable {
    [[ self defaultLogger ] setCategory:logCategory enable:enable ];
}

+( void )logOnlyCategory:( NSString* )logCategory {
    [[ self defaultLogger ] setOnlyCategory:logCategory ];
}

@end
