/**
 @file      APIURLSession.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIURLSession.h"
@import RSUtils;

/*
 BACKGROUND
 
 @property ( nonatomic, copy, nullable ) void (^backgroundSessionCompletionHandler)();
 
 
 @implementation NSURLSession (APIManager)
 
 -( BOOL )isBackgroundSession {
 return [ self.class isSubclassOfClass:NSClassFromString( @"__NSURLBackgroundSession" )];
 }
 
 @end
 
 -( void )application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier
 completionHandler:(void (^)())completionHandler {
 [[ APIManager sharedManager ] handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler ];
 }
 
 -( void )handleEventsForBackgroundURLSession:( NSString* )identifier completionHandler:( void (^)() )completionHandler {
 self.backgroundSessionCompletionHandler = completionHandler;
 [ self addSessionWithConfiguration:[ NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kAPISessionNameBackground ]
 forIdentifier:identifier ];
 }

 
 
 -( void )autoImplementBackgroundHandler {
 id appDelegate = [[ UIApplication sharedApplication ] delegate ];
 if (![ appDelegate respondsToSelector:@selector( application:handleEventsForBackgroundURLSession:completionHandler: )]) {
 Class appDelegateClass = [ appDelegate class ];
 [ OBJMethod addMethod:@selector( application:handleEventsForBackgroundURLSession:completionHandler: )
 fromClass:[ self class ] intoClass:appDelegateClass ];
 }
 }
 
 -( void )URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
 
 }
 */

NSString *const _Nonnull kAPIURLSessionRqErrorDomain    = @"API.URLSession.Error";

@interface APIURLSession() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

@property ( nonatomic, strong, nonnull ) NSMutableDictionary<NSNumber*, id<APIRequestPattern>> *requests;
@property ( nonatomic, strong, nonnull ) NSMutableDictionary<NSNumber*, NSURLSessionTask*> *tasks;
@property ( nonatomic, strong, nonnull ) NSMutableDictionary<NSNumber*, NSMutableData*> *buffers;
@property ( nonatomic, strong, nonnull ) NSMutableDictionary<NSNumber*, NSError*> *errors;
@property ( nonatomic, strong, nonnull ) NSURLSession *session;
@property ( nonatomic, strong, nonnull ) NSMutableArray<NSString*>* knownHosts;

@end

@implementation APIURLSession

-( instancetype )init {
    return [ self initWithConfiguration:[ NSURLSessionConfiguration defaultSessionConfiguration ]];
}

-( instancetype )initWithConfiguration:(NSURLSessionConfiguration *)config {
    return [ self initWithConfiguration:config operationQueue:[[ APIManager sharedManager ] apiQueue ]];
}

-( instancetype )initWithConfiguration:( NSURLSessionConfiguration* )config operationQueue:( NSOperationQueue* )queue {
    if ( self = [ super init ]) {
        _requests = [ NSMutableDictionary new ];
        _tasks = [ NSMutableDictionary new ];
        _buffers = [ NSMutableDictionary new ];
        _errors = [ NSMutableDictionary new ];
        _session = [ NSURLSession sessionWithConfiguration:config delegate:self
                                             delegateQueue:queue ];
        _doNotTrustUntrustedServer = false;
        _knownHosts = [ NSMutableArray new ];
    }
    return self;
}

#pragma mark - Request

-( BOOL )startRequest:( id<APIRequestPattern> )request {
    NSArray *allRequests = [ self.requests allValues ];
    if ( allRequests.count == 0 || ![ allRequests containsObject:request ]) {
        NSNumber *key = [ self getKeyOfRequest:request ];
        if ( key != nil ) return NO;
        if ([ request.class conformsToProtocol:@protocol( APIURLSessionDownloadPattern )] &&
            [ request respondsToSelector:@selector( dataToResumeURLSessionRequest )] &&
            [( id<APIURLSessionDownloadPattern> )request pathToDownloadFromURLSession ] != nil ) {
            NSData *data = [( id<APIURLSessionDownloadPattern> )request dataToResumeURLSessionRequest ];
            if ( data != nil ) {
                APILog( @"URL SESSION resumes downloading request %@ with %@ bytes data",
                       [ APIURLSession descriptionOfAPIRequest:request ], @( data.length ));
                [ self startRequest:request withTask:[ self.session downloadTaskWithResumeData:data ]];
                return YES;
            }
        }
        NSURLRequest *rqData = [ request getRequestData ];
        if (![ rqData isKindOfClass:[ NSURLRequest class ]]) {
            [ NSException raise:kAPIURLSessionRqErrorDomain format:@"\"%@\" must return NSURLRequest from \"makeRequestData\"", request.class ];
        }
        NSString *host = rqData.URL.host;
        if ( host != nil && ![ self.knownHosts containsObject:host ]) {
            [ self.knownHosts addObject:host ];
        }
        if ([ request.class conformsToProtocol:@protocol( APIURLSessionDownloadPattern )]) {
            NSString *path = [( id<APIURLSessionDownloadPattern> )request pathToDownloadFromURLSession ];
            if ( path != nil ) {
                APILog( @"URL SESSION starts downloading request %@ to \"%@\" with:\n%@",
                       [ APIURLSession descriptionOfAPIRequest:request ], path,
                       [ APIURLSession descriptionOfRequest:rqData ]);
                [ self startRequest:request withTask:[ self.session downloadTaskWithRequest:rqData ]];
                return YES;
            }
        }
        if ([ request.class conformsToProtocol:@protocol( APIURLSessionUploadPattern )]) {
            NSString *fPath = [( id<APIURLSessionUploadPattern> )request bodyFileOfURLSessionUploadRequest ];
            if ( fPath != nil && [[ NSFileManager defaultManager ] fileExistsAtPath:fPath ]) {
                APILog( @"URL SESSION starts uploading request %@ from \"%@\" with:\n%@",
                       [ APIURLSession descriptionOfAPIRequest:request ],
                       fPath, [ APIURLSession descriptionOfRequest:rqData ]);
                [ self startRequest:request
                           withTask:[ self.session uploadTaskWithRequest:rqData
                                                                fromFile:[ NSURL fileURLWithPath:fPath ]]];
                return YES;
            }
        }
        APILog( @"URL SESSION starts request %@ with:\n%@",
               [ APIURLSession descriptionOfAPIRequest:request ],
               [ APIURLSession descriptionOfRequest:rqData ]);
        [ self startRequest:request withTask:[ self.session dataTaskWithRequest:rqData ]];
        return YES;
    }
    return NO;
}

-( void )cancelRequest:( id<APIRequestPattern> )request {
    NSNumber *key = [ self getKeyOfRequest:request ];
    if ( key != nil ) {
        NSURLSessionTask *task = [ self.tasks objectForKey:key ];
        if ( task != nil ){
            if ([ task isKindOfClass:[ NSURLSessionDownloadTask class ]] &&
                [ request.class conformsToProtocol:@protocol( APIURLSessionDownloadPattern )] &&
                [ request respondsToSelector:@selector( saveResumableURLSessionRequestData: )]) {
                [( NSURLSessionDownloadTask* )task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
                    [( id<APIURLSessionDownloadPattern> )request saveResumableURLSessionRequestData:resumeData ];
                }];
            } else {
                [ task cancel ];
            }
        }
        [ self cleanRequest:key ];
    }
}

#pragma mark - Internal

+( NSMutableString* )descriptionOfRequest:( NSURLRequest* )request {
    NSMutableString *result = [ NSMutableString new ];
    [ result appendFormat:@"%@ <%p>:\n", request.class, request ];
    [ result appendFormat:@"URL: %@\n", request.URL ];
    [ result appendFormat:@"METHOD: %@\n", request.HTTPMethod ];
    NSDictionary *header = request.allHTTPHeaderFields;
    if ( header != nil && header.count > 0 )
        [ result appendFormat:@"HEADER:\n%@\n", [ header description ]];
    if ( request.HTTPBody != nil ) {
        NSString *body = [[ NSString alloc ] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding ];
        if ( body != nil ) {
            [ result appendFormat:@"BODY: %@\n", body ];
        } else {
            [ result appendFormat:@"BODY: <Binary data: %@ bytes>\n", @( request.HTTPBody.length )];
        }
    }
    return result;
}

+( NSString* )descriptionOfAPIRequest:( id<APIRequestPattern> )request {
    return [ NSString stringWithFormat:@"%@ <%p>", [ request class ], request ];
}

+( NSString* )descriptionOfResponse:( NSHTTPURLResponse* )response responseData:( NSData* )data
                              error:( NSError* )error {
    NSMutableString *result = [ NSMutableString new ];
    [ result appendFormat:@"URL: %@\n", response.URL ];
    [ result appendFormat:@"STATUS: %@ (%@)\n", @( response.statusCode ), [ NSHTTPURLResponse localizedStringForStatusCode:response.statusCode ]];
    [ result appendFormat:@"HEADER:\n%@\n", response.allHeaderFields.description ];
    if ( data != nil ) {
        NSString *strData = [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding ];
        if ( strData != nil ) {
            [ result appendFormat:@"DATA: %@\n", strData ];
        } else {
            [ result appendFormat:@"DATA: <Binary %@ bytes>\n", @( data.length )];
        }
    } else {
        [ result appendString:@"DATA: <nil>\n" ];
    }
    if ( error != nil ) {
        [ result appendFormat:@"ERROR: domain=\"%@\" code=\"%@\" localDesc=\"%@\" userInfo=\n%@",
         error.domain, @( error.code ), error.localizedDescription, [ error.userInfo description ]];
    }
    return result;
}

-( void )cleanRequest:( NSNumber* )rqKey {
    [ self.requests removeObjectForKey:rqKey ];
    [ self.buffers removeObjectForKey:rqKey ];
    [ self.tasks removeObjectForKey:rqKey ];
    [ self.errors removeObjectForKey:rqKey ];
}

-( NSNumber* )getKeyOfRequest:( id<APIRequestPattern> )request {
    for ( NSNumber *key in self.requests.allKeys ) {
        id<APIRequestPattern> req = [ self.requests objectForKey:key ];
        if ( req == request ) {
            return key;
        }
    }
    return nil;
}

-( void )startRequest:( id<APIRequestPattern> )request withTask:( NSURLSessionTask* )task {
    NSNumber *key = @( task.taskIdentifier );
    [ self.requests setObject:request forKey:key ];
    [ self.tasks setObject:task forKey:key ];
    [ task resume ];
}

#pragma mark - URL Session delegate

-( void )URLSession:( NSURLSession* )session dataTask:( NSURLSessionDataTask* )dataTask didReceiveData:( NSData* )data {
    NSNumber *key = @( dataTask.taskIdentifier );
    NSMutableData *buffer = [ self.buffers objectForKey:key ];
    if ( buffer == nil ) {
        buffer = [ NSMutableData new ];
        [ self.buffers setObject:buffer forKey:key ];
    }
    [ buffer appendData:data ];
}

-( void )URLSession:( NSURLSession* )session task:( NSURLSessionTask* )task didCompleteWithError:( NSError* )error {
    NSNumber *key = @( task.taskIdentifier );
    id<APIRequestPattern> request = [ self.requests objectForKey:key ];
    if ( request != nil ){
        NSError *err = error;
        if ( err == nil ) err = [ self.errors objectForKey:key ];
        NSHTTPURLResponse *response = ( NSHTTPURLResponse* )task.response;
        NSData *data = [ self.buffers objectForKey:key ];
        APILog( @"URL SESSION finish request %@:\n%@",
               [ APIURLSession descriptionOfAPIRequest:request ],
               [ APIURLSession descriptionOfResponse:response responseData:data error:err ]);
        [ request requestDidFinish:response data:data error:err ];
    }
    [ self cleanRequest:key ];
}

-( void )URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent
     totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSNumber *key = @( task.taskIdentifier );
    id<APIRequestPattern> request = [ self.requests objectForKey:key ];
    if ( request != nil && [ request.class conformsToProtocol:@protocol( APIURLSessionRequestPattern )] &&
        [ request respondsToSelector:@selector( didURLSessionUpload:withUploaded:onTotal: )]) {
        execOnMain(^{
            [( id<APIURLSessionRequestPattern> )request didURLSessionUpload:bytesSent
                                                               withUploaded:totalBytesSent
                                                                    onTotal:totalBytesExpectedToSend ];
        });
    }
}

-( void )URLSession:( NSURLSession* )session downloadTask:( NSURLSessionDownloadTask* )downloadTask
         didFinishDownloadingToURL:( NSURL* )location {
    NSNumber *key = @( downloadTask.taskIdentifier );
    id<APIRequestPattern> request = [ self.requests objectForKey:key ];
    if ( request != nil && [ request.class conformsToProtocol:@protocol( APIURLSessionDownloadPattern )]) {
        NSString *path = [( id<APIURLSessionDownloadPattern> )request pathToDownloadFromURLSession ];
        NSFileManager *fileMan = [ NSFileManager defaultManager ];
        [ fileMan removeItemAtPath:path error:nil ];
        NSString *tempFile = [ NSString stringWithUTF8String:[ location fileSystemRepresentation ]];
        if ( tempFile != nil && [ fileMan fileExistsAtPath:tempFile ]) {
            NSError *error = nil;
            if (![ fileMan moveItemAtPath:tempFile toPath:path error:&error ] && error != nil ) {
                [ self.errors setObject:error forKey:key ];
            }
        }
    }
}

-( void )URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
        didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten
        totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSNumber *key = @( downloadTask.taskIdentifier );
    id<APIRequestPattern> request = [ self.requests objectForKey:key ];
    if ( request != nil && [ request.class conformsToProtocol:@protocol( APIURLSessionDownloadPattern )] &&
        [ request respondsToSelector:@selector( didURLSessionDownload:withDownloaded:onTotal: )]) {
        execOnMain(^{
            [( id<APIURLSessionDownloadPattern> )request didURLSessionDownload:bytesWritten
                                                                withDownloaded:totalBytesWritten
                                                                       onTotal:totalBytesExpectedToWrite ];
        });
    }
}

-( void )URLSession:( NSURLSession* )session didReceiveChallenge:( NSURLAuthenticationChallenge* )challenge
  completionHandler:( void (^)( NSURLSessionAuthChallengeDisposition, NSURLCredential* ))completionHandler {
    if ([ challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust ] &&
        !self.doNotTrustUntrustedServer && [ self.knownHosts containsObject:challenge.protectionSpace.host ]) {
        NSURLCredential *credential = [ NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust ];
        completionHandler( NSURLSessionAuthChallengeUseCredential, credential );
        return;
    }
    completionHandler( NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil );
}

@end
