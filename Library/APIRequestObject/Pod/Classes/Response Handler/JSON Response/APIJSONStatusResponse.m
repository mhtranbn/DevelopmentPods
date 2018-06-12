/**
 @file      APIJSONStatusResponse.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "APIJSONStatusResponse.h"
#import "NSError+APIRequest.h"

NSInteger const kAPIResponseErrorJSONParserInvalidData = 4;

@implementation APIJSONStatusResponse

-( BOOL )isApiCodeSuccess:( NSNumber* )code {
    return [ code integerValue ] == 1;
}

-( NSNumber* )apiCodeFromData:( NSDictionary* )dataDic {
    if ([ dataDic.allKeys containsObject:@"code"]) {
        return @([[ dataDic objectForKey:@"code" ] integerValue ]);
    }
    return nil;
}

-( NSString* )apiMessageFromData:( NSDictionary* )dataDic {
    return [ dataDic objectForKey:@"message" ];
}

-( id )dataToFillToObject:( NSDictionary* )dataDic {
    return [ dataDic objectForKey:@"data" ];
}

-( id )processParsedSuccessData:( id )parsedData error:( NSError** )error {
    if ([ parsedData isKindOfClass:[ NSDictionary class ]]) {
        NSString *message = [ self apiMessageFromData:parsedData ];
        NSNumber *apiCode = [ self apiCodeFromData:parsedData ];
        if ( apiCode != nil ) {
            id data = [ self dataToFillToObject:parsedData ];
            if ([ self isApiCodeSuccess:apiCode ]) {
                if ( data != nil ) {
                    return [ super processParsedSuccessData:data error:error ];
                } else if ( error != nil && *error == nil ) {
                    *error = [ NSError apiErrorWithCode:kAPIResponseErrorJSONParserInvalidData
                                            description:@"JSON structure not supported: Fail to extract data from response JSON." ];
                }
            } else if ( error != nil && *error == nil ) {
                *error = [ NSError errorWithDomain:kAPIResponseErrorAPIDomain
                                                 code:[ apiCode integerValue ]
                                          description:message ];
            }
        } else if ( error != nil && *error == nil ) {
            *error = [ NSError errorWithDomain:kAPIResponseErrorJSONParserDomain
                                          code:kAPIResponseErrorJSONParserInvalidData
                                   description:@"JSON structure not supported: Fail to extract API status from response JSON." ];
        }
    } else if ( error != nil && *error == nil ) {
        *error = [ NSError errorWithDomain:kAPIResponseErrorJSONParserDomain
                                      code:kAPIResponseErrorJSONParserInvalidData
                               description:@"JSON structure not supported: Response JSON should be dictionary." ];
    }
    return nil;
}

@end
