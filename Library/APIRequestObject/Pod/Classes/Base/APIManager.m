/**
 @file      APIManager.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIManager.h"
#import "APIURLSession.h"
#import "Reachability.h"

NSString *const _Nonnull kAPIEngineDefault = @"APIManager.Default";
NSString *const _Nonnull kAPIRequestEngineName = @"API.Request.EngineName";

@interface APIManager()

@property ( nonatomic, strong, nonnull ) NSMutableDictionary<NSString*, id<APIConnectionEngine>> *engines;

@end

@implementation APIManager

+( nonnull APIManager* )sharedManager {
    static APIManager *__sharedManager = nil;
    if ( __sharedManager == nil ) {
        __sharedManager = [[ APIManager alloc ] init ];
    }
    return __sharedManager;
}

-( instancetype )init {
    if ( self = [ super init ]) {
        _apiQueue = [ NSOperationQueue new ];
        _engines = [ NSMutableDictionary new ];
        [ self addEngine:[[ APIURLSession alloc ] initWithConfiguration:[ NSURLSessionConfiguration defaultSessionConfiguration ]
                                                         operationQueue:_apiQueue ]
                 forName:kAPIEngineDefault ];
    }
    return self;
}

-( void )addEngine:( id<APIConnectionEngine> )engine forName:( NSString* )name {
    [ self.engines setObject:engine forKey:name ];
}

-( BOOL )startRequest:( id<APIRequestPattern> )request withEngine:( NSString* )name {
    if (!self.disableInternetCheck && [[ Reachability reachabilityForInternetConnection ] currentReachabilityStatus ] == NotReachable ) {
        return NO;
    }
    id<APIConnectionEngine> engine = [ self.engines objectForKey:name ];
    if ( engine != nil ) {
        BOOL result = [ engine startRequest:request ];
        if ( result ) {
            NSMutableDictionary *params = request.requestInfo;
            if ( params == nil ) {
                params = [ NSMutableDictionary new ];
                request.requestInfo = params;
            }
            [ params setObject:name forKey:kAPIRequestEngineName ];
        }
        return result;
    } else {
        [ NSException raise:@"APIManager Error" format:@"No connection engine for name \"%@\".", name ];
    }
    return NO;
}

-( void )cancelRequest:( id<APIRequestPattern> )request {
    NSString *name = [ request.requestInfo objectForKey:kAPIRequestEngineName ];
    if ( name != nil ) {
        id<APIConnectionEngine> engine = [ self.engines objectForKey:name ];
        if ( engine != nil ) {
            [ engine cancelRequest:request ];
        } else {
            [ NSException raise:@"APIManager Error" format:@"No connection engine for name \"%@\".", name ];
        }
    } else {
        [ NSException raise:@"APIManager Error" format:@"Connection engine not found from 'request.requestInfo'." ];
    }
}

@end
