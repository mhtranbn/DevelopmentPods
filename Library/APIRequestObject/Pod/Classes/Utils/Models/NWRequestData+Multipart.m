/**
 @file      NWRequestData+Multipart.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWRequestData+Multipart.h"
#import "NWHTTPContentType.h"
#import "NWInternetMediaMimeType.h"
#import "NWHTTPConstant.h"
#import "NWRequest.h"
#import "NWRequestData+Convert.h"
#import "NWUtils.h"
#import "OBJProperty+Request.h"
#import "NWRequestMultiFormData.h"

@import RSUtils;
@import ObjCRuntimeWrapper;

@interface NWRequestData ()

@property ( nonatomic, strong, nullable ) NSString *logDesc;
@property ( nonatomic, readwrite ) NSUInteger size;

@end


@implementation NWRequestData (Multipart)

#pragma mark - Utils

-( NSString* )fileNameFromData:( NWRequestData* )data withParamName:( NSString* )key {
    NSString *fileName = data.fileName;
    if ( fileName == nil || fileName.length == 0 )
        fileName = key;
    NSString *ext = [ fileName pathExtension ];
    if ( ext == nil || ext.length == 0 || [ ext isEqualToString:fileName ]) {
        ext = [ data.mimeType pathExtension ];
        if ( ext != nil )
            fileName = [ fileName stringByAppendingPathExtension:ext ];
    }
    return fileName;
}

-( void )appendRequestArray:( NSArray* )array forKey:( NSString* )paramName
                  partStore:( NSMutableArray<NWRequestMultiFormDataPart*>* )parts {
    for ( id item in array ){
        NSString *key = nil;
        if ( paramName != nil ) key = [ paramName stringByAppendingString:@"[]" ];
        if ( key == nil && [ item isKindOfClass:[ NWRequestData class ]]) key = [( NWRequestData* )item keyName ];
        if ( key == nil ) continue;
        [ self appendRequestItem:item forKey:key partStore:parts ];
    }
}

-( void )appendRequestDictionary:( NSDictionary* )dic forKey:( NSString* )paramName
                       partStore:( NSMutableArray<NWRequestMultiFormDataPart*>* )parts {
    for ( id dicKey in dic.allKeys ){
        if (![ dicKey isKindOfClass:[ NSString class ]] && ![ dicKey isKindOfClass:[ NSNumber class ]]) continue;
        NSString *key = nil;
        if ( paramName != nil ) key = [ paramName stringByAppendingFormat:@"[%@]", dicKey ];
        else key = dicKey;
        id item = [ dic objectForKey:key ];
        [ self appendRequestItem:item forKey:key partStore:parts ];
    }
}

-( void )appendRequestData:( NWRequestData* )data forKey:( NSString* )paramName
                 partStore:( NSMutableArray<NWRequestMultiFormDataPart*>* )parts  {
    NWRequestHeaderAttribute *disposition = [ NWRequestHeaderAttribute new ];
    disposition.key = HTTP_HEADER_REQUEST_CONTENT_DISPOSITION;
    disposition.value = @"form-data";
    disposition.parameters = @{ @"name": [ NSString stringWithFormat:@"\"%@\"", paramName ],
                                @"filename": [ NSString stringWithFormat:@"\"%@\"",
                                              [ self fileNameFromData:data withParamName:paramName ]]};
    NWHTTPContentType *contentType = data.mimeType;
    NWRequestMultiFormDataPart *part = [[ NWRequestMultiFormDataPart alloc ] initWithAttributes:@[ disposition, contentType ]
                                                                                        andData:data.contentData ];
    [ parts addObject:part ];
}

-( void )appendParameterName:( NSString* )paramName parameterValue:( id )paramValue
                   partStore:( NSMutableArray<NWRequestMultiFormDataPart*>* )parts  {
    NWRequestHeaderAttribute *disposition = [ NWRequestHeaderAttribute new ];
    disposition.key = HTTP_HEADER_REQUEST_CONTENT_DISPOSITION;
    disposition.value = @"form-data";
    disposition.parameters = @{ @"name": [ NSString stringWithFormat:@"\"%@\"", paramName ]};
    NWHTTPContentType *contentType = [ NWHTTPContentType new ];
    contentType.value = MIME_TYPE_TEXT_PLAIN;
    contentType.parameters = @{ MIME_PARAMETER_CHARSET: @"utf-8" };
    NWRequestMultiFormDataPart *part = [[ NWRequestMultiFormDataPart alloc ] initWithAttributes:@[ disposition, contentType ]
                                                                                        andData:[[ NSString stringWithFormat:@"%@", paramValue ] dataUsingEncoding:NSUTF8StringEncoding ]];
    [ parts addObject:part ];
}

-( void )appendRequestItem:( id )object forKey:( NSString* )paramName
                 partStore:( NSMutableArray<NWRequestMultiFormDataPart*>* )parts {
    if ([ object isKindOfClass:[ NWRequestData class ]]) {
        [ self appendRequestData:object forKey:paramName partStore:parts ];
    } else if ([ object isKindOfClass:[ NSData class ]]) {
        [ self appendRequestData:[[ NWRequestData alloc ] initWithData:object ]
                          forKey:paramName partStore:parts ];
    } else if ([ object isKindOfClass:[ UIImage class ]]) {
        [ self appendRequestData:[ NWRequestData jpegDataWithImage:object ]
                          forKey:paramName partStore:parts ];
    } else if ([ NWRequestMakerBase validateValueObject:object ]) {
        [ self appendParameterName:paramName parameterValue:object partStore:parts ];
    } else if ([ object isKindOfClass:[ NSArray class ]]) {
        [ self appendRequestArray:object forKey:paramName partStore:parts ];
    } else if ([ object isKindOfClass:[ NSDictionary class ]]) {
        [ self appendRequestDictionary:object forKey:paramName partStore:parts ];
    } else {
        NSDictionary *objDic = [ OBJProperty dictionaryFromObject:object ];
        [ self appendRequestDictionary:objDic forKey:paramName partStore:parts ];
    }
}

#pragma mark - Make

-( NSMutableArray<NWRequestMultiFormDataPart*>* )buildFromObject:( NSObject* )object {
    NSMutableArray<NWRequestMultiFormDataPart*>* parts = [ NSMutableArray new ];
    [ OBJProperty enumeratePropertyOfClass:[ object class ] withBlock:^BOOL( NSString* propertyName,
                                                                            NSMutableDictionary* propertyAttributes,
                                                                            Class ownerClass ) {
        if ( propertyAttributes.isReadOnly ||
            propertyAttributes.isPropertyExcludeAPIParameter ) return NO;
        // Value
        id value = nil;
        NWRequestParameterTransformType transformType = kRawValueOrNotTransform;
        if ([ object.class conformsToProtocol:@protocol( NWRequestTransformParameter )] &&
            [ object respondsToSelector:@selector( shouldTransfromValueOfRequestParameter:encoder: )]) {
            transformType = [( id<NWRequestTransformParameter> )object shouldTransfromValueOfRequestParameter:propertyName encoder:self ];
            value = [ NWRequestMakerBase transformRequestParameter:propertyName
                                                          ofObject:( id<NWRequestTransformParameter> )object
                                                          withType:transformType encoder:self ];
        } else {
            value = [ object valueForKey:propertyName ];
        }
        if ( value == nil ) return NO;
        // Key
        NSString *key = propertyAttributes.propertyAliasName;
        if ( key == nil ) key = propertyName;
        
        if ([ value isKindOfClass:[ NSDictionary class ]]) {
            if ( transformType == kCustomWithKey ){
                [ self appendRequestDictionary:value forKey:nil partStore:parts ];
            } else {
                [ self appendRequestDictionary:value forKey:key partStore:parts ];
            }
        } else if ([ self validateArray:value ]) {
            [ self appendRequestArray:value forKey:key partStore:parts ];
        } else {
            [ self appendRequestItem:value forKey:key partStore:parts ];
        }
        return NO;
    }];
    return parts;
}

-( NSMutableArray<NWRequestMultiFormDataPart*>* )buildFromDictionary:( NSDictionary* )dic {
    NSMutableArray<NWRequestMultiFormDataPart*>* parts = [ NSMutableArray new ];
    [ self appendRequestDictionary:dic forKey:nil partStore:parts ];
    return parts;
}

-( NSMutableArray<NWRequestMultiFormDataPart*>* )buildFromArrayOfData:( NSArray<NWRequestData*>* )array {
    NSMutableArray<NWRequestMultiFormDataPart*>* parts = [ NSMutableArray new ];
    [ self appendRequestArray:array forKey:nil partStore:parts ];
    return parts;
}

-( BOOL )validateArray:( id )object {
    if ([ object isKindOfClass:[ NSArray class ]]) {
        for ( id item in object ) {
            if (![ item isKindOfClass:[ NWRequestData class ]]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

+( instancetype )multipartDataWithObject:( id )object {
    NWRequestData *result = [[ self alloc ] initWithData:[ NSData new ]
                                                mimeType:[[ NWHTTPContentType alloc ] initFromShortString:MIME_TYPE_MULTIPART_FORM_DATA ]
                                         storeInTempFile:YES ];
    NSArray<NWRequestMultiFormDataPart*>* parts = nil;
    NSString *boundary = [ NSString stringWithFormat:@"%@%p",
                          [[ NSDate date ] stringWithFormat:@"yyyyMMddHHmmss" ], result ];
    if ([ object isKindOfClass:[ NSDictionary class ]]) {
        parts = [ result buildFromDictionary:object ];
    } else if ([ result validateArray:object ]) {
        parts = [ result buildFromArrayOfData:object ];
    } else if ([ object isKindOfClass:[ NSObject class ]]) {
        parts = [ result buildFromObject:object ];
    } else {
        [ NSException raise:[ NSString stringWithFormat:@"%@ Error", self.class ]
                     format:@"Object of type \"%@\" is not supported.", [ object class ]];
    }
    NWRequestMultiFormData *formData = [[ NWRequestMultiFormData alloc ] initWithBoundary:boundary andFormDataParts:parts ];
    [ formData saveToFile:result.tempFile ];
    result.logDesc = [ formData logDescription ];
    result.mimeType.parameters = @{ @"boundary": boundary };
    NSDictionary *attr = [[ NSFileManager defaultManager ] attributesOfItemAtPath:result.tempFile error:nil ];
    result.size = [ attr fileSize ];
    return result;
}


@end
