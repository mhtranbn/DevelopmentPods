/**
 @file      NWHTTPContentType.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NWHTTPContentType.h"
#import "NWInternetMediaMimeType.h"
#import "NWUtils.h"
#import "NWHTTPConstant.h"

@implementation NWHTTPContentType

-( instancetype )init {
    if ( self = [ super init ]) {
        self.key = HTTP_HEADER_REQUEST_CONTENT_TYPE;
    }
    return self;
}

-( void )setKey:( NSString* )key {
    [ super setKey:HTTP_HEADER_REQUEST_CONTENT_TYPE ];
}

-( NSString* )key {
    return HTTP_HEADER_REQUEST_CONTENT_TYPE;
}

-( void )setValue:( NSString* )value {
    [ super setValue:value ];
    NSArray *arrTypes = [ self.value componentsSeparatedByString:@"/" ];
    if ( arrTypes && arrTypes.count > 1 ) {
        _type = arrTypes[0];
        _subtype = arrTypes[1];
    } else {
        _type = self.value;
    }
}

-( instancetype )initFromShortString:( NSString* )contentTypeString {
    if ( self = [ super initWithString:[ NSString stringWithFormat:@"%@: %@", HTTP_HEADER_REQUEST_CONTENT_TYPE, contentTypeString ]]) {
        [ self setValue:self.value ];
    }
    return self;
}

-( void )settingValueBeforeMakeString {
    if ( self.type != nil && self.type.length > 0 ) {
        if ( self.subtype != nil && self.subtype.length > 0 ) {
            self.value = [ NSString stringWithFormat:@"%@/%@", self.type, self.subtype ];
        } else {
            self.value = self.type;
        }
    }
}

-( NSString* )toString {
    [ self settingValueBeforeMakeString ];
    return [ super toString ];
}

-( NSString* )toShortString {
    [ self settingValueBeforeMakeString ];
    NSString *result = [ super toString ];
    NSRange range = [ result rangeOfString:@": " ];
    if ( range.location != NSNotFound ) {
        return [ result substringFromIndex:range.location + 2 ];
    }
    return result;
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@ <%p>: %@", self.class, self, [ self toString ]];
}

// Reference: http://www.iana.org/assignments/character-sets/character-sets.xhtml
-( NSStringEncoding )stringEncoding {
    NSString *charset = nil;
    if ( self.parameters != nil ) charset = [ self.parameters objectForKey:MIME_PARAMETER_CHARSET ];
    if ( charset && charset.length )
        return [ NWUtils stringEncodingFromCharsetName:charset ];
    return 0;
}

-( instancetype )initFromPathExtension:( NSString* )extension {
    if ( self = [ self init ]) {
        extension = [ extension lowercaseString ];
        if ([ extension isEqualToString:@"jpg" ]) {
            _type = MIME_MAIN_TYPE_IMAGE;
            _subtype = @"jpeg";
        } else if ([ extension isEqualToString:@"gif" ]) {
            _type = MIME_MAIN_TYPE_IMAGE;
            _subtype = @"gif";
        } else if ([ extension isEqualToString:@"png" ]) {
            _type = MIME_MAIN_TYPE_IMAGE;
            _subtype = @"png";
        } else if ([ extension isEqualToString:@"svg" ]) {
            _type = MIME_MAIN_TYPE_IMAGE;
            _subtype = @"svg";
        } else if ([ extension isEqualToString:@"mp3" ]) {
            _type = MIME_MAIN_TYPE_AUDIO;
            _subtype = @"mpeg";
        } else if ([ extension isEqualToString:@"wav" ]) {
            _type = MIME_MAIN_TYPE_AUDIO;
            _subtype = @"vnd.wave";
        } else if ([ extension isEqualToString:@"mp4" ]) {
            _type = MIME_MAIN_TYPE_VIDEO;
            _subtype = @"mp4";
        } else if ([ extension isEqualToString:@"mpeg" ] ||
                   [ extension isEqualToString:@"mpg" ]) {
            _type = MIME_MAIN_TYPE_VIDEO;
            _subtype = @"mpeg";
        } else if ([ extension isEqualToString:@"mov" ]) {
            _type = MIME_MAIN_TYPE_VIDEO;
            _subtype = @"quicktime";
        } else if ([ extension isEqualToString:@"xml" ]) {
            _type = MIME_MAIN_TYPE_APP;
            _subtype = @"xml";
        } else if ([ extension isEqualToString:@"pdf" ]) {
            _type = MIME_MAIN_TYPE_APP;
            _subtype = @"pdf";
        } else if ([ extension isEqualToString:@"txt" ]) {
            _type = MIME_MAIN_TYPE_TEXT;
            _subtype = @"plain";
        } else if ([ extension isEqualToString:@"rtf" ]) {
            _type = MIME_MAIN_TYPE_TEXT;
            _subtype = @"rtf";
        } else if ([ extension isEqualToString:@"htm" ] ||
                   [ extension isEqualToString:@"html" ]) {
            _type = MIME_MAIN_TYPE_TEXT;
            _subtype = @"html";
        } else if ([ extension isEqualToString:@"csv" ]) {
            _type = MIME_MAIN_TYPE_TEXT;
            _subtype = @"csv";
        } else if ([ extension isEqualToString:@"css" ]) {
            _type = MIME_MAIN_TYPE_TEXT;
            _subtype = @"css";
        } else if ([ extension isEqualToString:@"flv" ]) {
            _type = MIME_MAIN_TYPE_VIDEO;
            _subtype = @"x-flv";
        } else if ([ extension isEqualToString:@"json" ]) {
            _type = MIME_MAIN_TYPE_APP;
            _subtype = @"json";
        } else if ([ extension isEqualToString:@"js" ]) {
            _type = MIME_MAIN_TYPE_TEXT;
            _subtype = @"javascript";
        } else if ([ extension isEqualToString:@"gz" ]) {
            _type = MIME_MAIN_TYPE_APP;
            _subtype = @"gzip";
        } else if ([ extension isEqualToString:@"zip" ]) {
            _type = MIME_MAIN_TYPE_APP;
            _subtype = @"zip";
        }
        if ( _type != nil && _subtype != nil ) {
            self.value = [ NSString stringWithFormat:@"%@/%@", _type, _subtype ];
        }
        self.key = HTTP_HEADER_REQUEST_CONTENT_TYPE;
    }
    return self;
}

-( NSString* )pathExtension {
    if ([ self.type isEqualToString:MIME_MAIN_TYPE_IMAGE ]) {
        if ([ self.subtype isEqualToString:@"jpeg" ]) {
            return @"jpg";
        }
        return self.subtype;
    } else if ([ self.type isEqualToString:MIME_MAIN_TYPE_AUDIO ]) {
        if ([ self.subtype isEqualToString:@"vnd.wave" ]) {
            return @"wav";
        }
        return self.subtype;
    } else if ([ self.type isEqualToString:MIME_MAIN_TYPE_VIDEO ]) {
        if ([ self.subtype isEqualToString:@"quicktime" ]) {
            return @"mov";
        } else if ([ self.subtype isEqualToString:@"x-flv" ]) {
            return @"flv";
        }
        return self.subtype;
    } else if ([ self.type isEqualToString:MIME_MAIN_TYPE_TEXT ]) {
        return self.subtype;
    } else if ([ self.type isEqualToString:MIME_MAIN_TYPE_APP ]) {
        if ([ self.subtype isEqualToString:@"javascript" ]) {
            return @"js";
        }
        return self.subtype;
    }
    return nil;
}

@end
