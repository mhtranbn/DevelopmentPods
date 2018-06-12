/**
 @file      APIRequest.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIRequest.h"
#import "NWHTTPConstant.h"
#import "NWUrlEncodedRequest.h"
#import "APIJSONResponse.h"
@import RSUtils;

@interface APIRequestErrorHandler : NSObject

@property ( nonatomic, nullable, readonly ) NSError *error;
@property ( nonatomic, readonly, nonnull ) APIRequestFailureHandler handler;

-( nonnull instancetype )initWithError:( nullable NSError* )error andHandle:( nonnull APIRequestFailureHandler )handler;

@end

@implementation APIRequestErrorHandler

-( instancetype )initWithError:( NSError* )error andHandle:( APIRequestFailureHandler )handler {
    if ( self = [ super init ]) {
        _error = error;
        _handler = handler;
    }
    return self;
}

@end

#pragma mark -

@interface APIRequest()

@property ( nonatomic, nullable, strong ) id requestData;
@property ( nonatomic, strong, nonnull ) NSMutableDictionary<NSString*, id> *additionalHeader;
@property ( nonatomic, strong, nonnull ) NSMutableArray<APIRequestErrorHandler*> *errorHandlers;
@property ( nonatomic, assign ) BOOL isCancelled;

@end

@implementation APIRequest

-( instancetype )init {
    if ( self = [ super init ]) {
        _requestInfo = [ NSMutableDictionary new ];
        _additionalHeader = [ NSMutableDictionary new ];
        _errorHandlers = [ NSMutableArray new ];
        _httpMethod = HTTP_METHOD_GET;
        _requestMaker = [ NWUrlEncodedRequest new ];
        _responseHandler = [ APIJSONResponse new ];
    }
    return self;
}

-( NSDictionary<NSString*, id>* )httpHeader {
    return [ self.additionalHeader copy ];
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@ <%p>: %@ %@",
            self.class, self, self.httpMethod, self.path ];
}

-( void )setValue:( id )value forHTTPHeader:( NSString* )key {
    if ( value != nil ){
        [ self.additionalHeader setObject:value forKey:key ];
    } else {
        [ self.additionalHeader removeObjectForKey:key ];
    }
}

-( void )addHTTPHeaders:( NSDictionary<NSString*, id>* )headers {
    [ self.additionalHeader addEntriesFromDictionary:headers ];
}

-( void )setHTTPHeaders:( NSDictionary<NSString*, id>* )headers {
    [ self.additionalHeader removeAllObjects ];
    if ( headers != nil )[ self.additionalHeader addEntriesFromDictionary:headers ];
}

-( void )removeAllErrorHandlers {
    [ self.errorHandlers removeAllObjects ];
}

-( void )processError:( NSError* )error withHandler:( APIRequestFailureHandler )handler {
    APIRequestErrorHandler *errHandler = [[ APIRequestErrorHandler alloc ] initWithError:error andHandle:handler ];
    [ self.errorHandlers addObject:errHandler ];
}

#pragma mark - Connection start

-( void )startRequest {
    [ self startRequestWithEngine:kAPIEngineDefault ];
}

-( void )startRequestWithEngine:( NSString* )engineId {
    if ( self.isLoading ) return;
    // Validate input
    NSAssert( self.path != nil && self.path.length > 0, @"API ERROR: url not set for %@", NSStringFromClass([ self class ]));
    NSAssert( self.requestMaker != nil, @"API ERROR: request maker not set for %@", NSStringFromClass([ self class ]));
    NSAssert( self.responseHandler != nil, @"API ERROR: parser object not set for %@", NSStringFromClass([ self class ]));
    
    _isLoading = YES;
    _isCancelled = NO;
    APIRequest *mySelf = self;
    APIManager *manager = APIManager.sharedManager;
    NSBlockOperation *operation = [ NSBlockOperation blockOperationWithBlock:^{
        [ mySelf.requestMaker generateRequestBodyWithRequestObject:mySelf onComplete:^( id requestData, NSError* error ) {
            if ( mySelf.isCancelled ) return;
            if ( error == nil ) {
                mySelf.requestData = requestData;
                [ mySelf logRequest ];
                execOnMain(^{
                    if (![ manager startRequest:mySelf withEngine:engineId ]) {
                        [ mySelf finishRequestWithError:[ NSError errorWithDomain:NSURLErrorDomain
                                                                             code:NSURLErrorNotConnectedToInternet
                                                                         userInfo:nil ]];
                    }
                });
            } else {
                [ mySelf finishRequestWithError:error ];
            }
        }];
    }];
    [ manager.apiQueue addOperation:operation ];
}

-( void )cancelRequest {
    if ( self.isLoading ) {
        APILog( @"API CANCEL: %@", NSStringFromClass([ self class ]));
        self.isCancelled = YES;
        [[ APIManager sharedManager ] cancelRequest:self ];
        _isLoading = NO;
    }
}

#pragma mark - Auto kill

-( void )autoKillRequest {
    if ( self.isLoading ) {
        [ self cancelRequest ];
        [ self finishRequestWithError:[ NSError errorWithDomain:NSURLErrorDomain
                                                           code:NSURLErrorTimedOut
                                                       userInfo:nil ]];
    }
}

#pragma mark - Private

-( void )logRequest {
    NSMutableString *log = [ NSMutableString stringWithFormat:@"API REQUEST: %@ <%p>\nMAKER: %@\n",
                            NSStringFromClass( self.class ), self,
                            NSStringFromClass( self.requestMaker.class )];
    if ( self.parameters != nil ){
        if ([ self.parameters respondsToSelector:@selector( description )]) {
            [ log appendFormat:@"PARAMETERS:\n%@\n", [ self.parameters description ]];
        } else {
            [ log appendFormat:@"PARAMETERS:\n%@\n", self.parameters ];
        }
    }
    APILog( @"%@", log );
}

-( void )logResponseWithError:( NSError* )error responseObject:( id )object
                 httpResponse:( NSHTTPURLResponse* )response rawData:( id )data {
    NSMutableString *log = [ NSMutableString stringWithFormat:@"API RESPONSE: %@ <%p>\nPATH: %@\nMETHOD: %@\nHANDLER: %@\n",
                            NSStringFromClass( self.class ), self,
                            self.path,
                            self.httpMethod,
                            NSStringFromClass( self.responseHandler.class )];
    if ( object != nil && ![ object isKindOfClass:[ NSData class ]]) {
        if ([ object respondsToSelector:@selector( description )]) {
            [ log appendFormat:@"RESPONSE OBJECT:\n%@\n", [ object description ]];
        } else {
            [ log appendFormat:@"RESPONSE OBJECT:\n%@\n", object ];
        }
    }
    if ( error != nil )[ log appendFormat:@"ERROR: %@\n", error.description ];
    APILog( @"%@", log );
}

-( BOOL )checkError:( NSError* )error matchingWithPattern:( NSError* )patternError {
    if ([ error.domain isEqualToString:patternError.domain ]) {
        NSUInteger match = 0;
        if ( patternError.code != 0 ) {
            if ( patternError.code == error.code ) match += 1;
        } else {
            match += 1;
        }
        if ( patternError.localizedDescription != nil && patternError.localizedDescription.length > 0 ) {
            if ([ patternError.localizedDescription isEqualToString:error.localizedDescription ]) match += 1;
        } else {
            match += 1;
        }
        return match == 2;
    }
    return NO;
}

// Finish request without response from server
-( void )finishRequestWithError:( NSError* )error {
    [ self finishRequestWithError:error responseObject:nil httpResponse:nil rawData:nil ];
}

-( void )finishRequestWithError:( NSError* )error responseObject:( id )object
                   httpResponse:( NSHTTPURLResponse* )response rawData:( id )data {
    [ self logResponseWithError:error responseObject:object httpResponse:response rawData:data ];
    _isLoading = NO;
    APIRequest *mSelf = self;
    if ([ self.requestMaker respondsToSelector:@selector( apiRequestDidFinish: )]) {
        [ self.requestMaker apiRequestDidFinish:self ];
    }
    if ( self.onFinish != nil ) {
        execOnMain(^{
            mSelf.onFinish();
        });
    }
    if ( error == nil ) {
        if ( self.onSuccess != nil ) {
            execOnMain(^{
                mSelf.onSuccess( object, response, data );
            });
        }
    } else if ( self.errorHandlers.count > 0 ) {
        for ( NSInteger i = self.errorHandlers.count - 1; i >= 0; i-- ) {
            APIRequestErrorHandler *handler = [ self.errorHandlers objectAtIndex:i ];
            if ( handler.error != nil ) {
                if ([ self checkError:error matchingWithPattern:handler.error ]) {
                    execOnMain(^{
                        handler.handler( error, object, response, data );
                    });
                    return;
                }
            } else {
                execOnMain(^{
                    handler.handler( error, object, response, data );
                });
                return;
            }
        }
    }
}

#pragma mark - APIRequestPattern

-( id )getRequestData {
    return self.requestData;
}

-( void )requestDidFinish:( NSHTTPURLResponse* )response data:( id )data error:( NSError* )error {
    APIRequest *mySelf = self;
    [ self.responseHandler parseResponseData:data responseInfo:response error:error andRequest:self
            onComplete:^( NSError* error1, id parsedObject, NSHTTPURLResponse* httpResponse, id rawData) {
        [ mySelf finishRequestWithError:error1 responseObject:parsedObject
                           httpResponse:httpResponse rawData:rawData ];
    }];
}

@end
