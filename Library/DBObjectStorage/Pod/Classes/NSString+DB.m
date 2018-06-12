/**
 @file      NSString+DB.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "NSString+DB.h"

@implementation NSString (DB)

+( instancetype )dbValueQuoted:( id )value isTextType:( BOOL )isText {
    if ( value == nil ) {
        return @"null";
    } else if ( isText ) {
        return [ self stringWithFormat:@"'%@'", value ];
    } else {
        return [ self stringWithFormat:@"%@", value ];
    }
}

+( instancetype )dbColumnQuoted:( NSString* )column {
    return [ self stringWithFormat:@"\"%@\"", column ];
}

+( instancetype )dbTableQuoted:( NSString* )table column:( NSString* )column {
    return [ self stringWithFormat:@"\"%@\".\"%@\"", table, column ];
}

-( instancetype )dbIdentifierQuoted {
    return [ NSString stringWithFormat:@"\"%@\"", self ];
}

-( instancetype )dbValueQuoted {
    return [ NSString stringWithFormat:@"'%@'", self ];
}

@end
