/**
 @file      DBTableInfo.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBTableInfo.h"
#import "DBObjectStorage.h"
#import "NSString+DB.h"
#import "DBDataType.h"
@import RSUtils;
@import ObjCRuntimeWrapper;

@interface DBColumnInfo()

-( BOOL )isAutoInc;

@end

@implementation DBColumnInfo

+( NSString* )dbTypeForProperty:( NSDictionary* )propertyAttributes {
    OBJDataType type = [ propertyAttributes type ];
    switch ( type ) {
        case kObjDataTypeObject:
        {
            Class propClass = [ propertyAttributes typeClass ];
            if ( propClass == [ NSString class ] || propClass == [ NSURL class ] || propClass == [ NSNumber class ]
                || propClass == [ UIImage class ] || propClass == [ NSData class ]) {
                return SQLITE_TYPE_STRING;
            } else if ( propClass == [ NSDate class ] || propClass == [ DBReal class ]) {
                return SQLITE_TYPE_REAL;
            } else if ( propClass == [ UIColor class ] || propClass == [ DBInteger class ]
                       || propClass == [ DBBool class ]) {
                return SQLITE_TYPE_INT;
            }
        }
            break;
        case kObjDataTypeCppBool:
        case kObjDataTypeChar:
        case kObjDataTypeInt:
        case kObjDataTypeLong:
        case kObjDataTypeLongLong:
        case kObjDataTypeUnsignedChar:
        case kObjDataTypeUnsignedInt:
        case kObjDataTypeUnsignedLong:
        case kObjDataTypeUnsignedLongLong:
            return SQLITE_TYPE_INT;
            break;
        case kObjDataTypeDouble:
        case kObjDataTypeFloat:
            return SQLITE_TYPE_REAL;
        default:
            break;
    }
    return nil;
}

#pragma mark - Life cycle

+( instancetype )dbColumnWithProperty:( NSString* )propName atttributes:( NSDictionary<NSString*,id>* )propAttr
                          listIgnored:( NSArray<NSString*>* )ignores listPrimary:( NSArray<NSString*>* )primaries {
    if ([ propAttr isReadOnly ] || [ ignores containsObject:propName ]) return nil;
    NSString *type = [ self dbTypeForProperty:propAttr ];
    if ( type != nil ) {
        DBColumnInfo *column = [[ DBColumnInfo alloc ] init ];
        column.name = [ propAttr propertyAliasName ];
        if ( column.name == nil ) column.name = propName;
        column.propertyName = propName;
        column.propertyAttributes = propAttr;
        column.type = type;
        column.isPrimaryKey = [ primaries containsObject:propName ];
        return column;
    }
    return nil;
}

-( BOOL )isAutoInc {
    return self.isPrimaryKey && self.typeId == kDBDataTypeInteger;
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@ <%p> %@ %@%@",
            self.class, self, self.name, self.type, self.isPrimaryKey ? @" PRIMARY": @"" ];
}

#pragma mark - Properties

-( void )setType:( NSString* )type {
    _type = type;
    if ([ type isEqualToString:SQLITE_TYPE_INT ])
        _typeId = kDBDataTypeInteger;
    else if ([ type isEqualToString:SQLITE_TYPE_REAL ])
        _typeId = kDBDataTypeReal;
    else if ([ type isEqualToString:SQLITE_TYPE_STRING ])
        _typeId = kDBDataTypeText;
}

-( id )autoConvertToDBValue:( id )value {
    if ( value == nil || [ value isKindOfClass:[ NSNull class ]]) return nil;
    switch ( self.typeId ) {
        case kDBDataTypeText:
            if ([ value isKindOfClass:[ NSString class ]]) {
                return value;
            } else if ([ value isKindOfClass:[ NSURL class ]]) {
                return [( NSURL* )value absoluteString ];
            } else if ([ value isKindOfClass:[ UIImage class ]]) {
                return [ UIImagePNGRepresentation( value ) base64EncodedStringWithOptions:0 ];
            } else if ([ value isKindOfClass:[ NSData class ]]) {
                return [( NSData* )value base64EncodedStringWithOptions:0 ];
            } else {
                return [ NSString stringWithFormat:@"%@", value ];
            }
        case kDBDataTypeInteger:
            if ([ value isKindOfClass:[ NSNumber class ]] || [ value isKindOfClass:[ DBInteger class ]]
                || [ value isKindOfClass:[ DBBool class ]]) {
                return value;
            } else if ([ value isKindOfClass:[ UIColor class ]]) {
                return [ NSNumber numberWithUnsignedInt:[( UIColor* )value rgbaValue ]];
            }
            break;
        case kDBDataTypeReal:
            if ([ value isKindOfClass:[ NSNumber class ]] || [ value isKindOfClass:[ DBReal class ]]) {
                return value;
            } else if ([ value isKindOfClass:[ NSDate class ]]) {
                return [ NSNumber numberWithDouble:[( NSDate* )value timeIntervalSince1970 ]];
            }
            break;
        default:
            break;
    }
    return nil;
}

-( id )autoConvertFromDBValue:( id )value {
    if ( value == nil || [ value isKindOfClass:[ NSNull class ]]) return nil;
    OBJDataType type = [ self.propertyAttributes type ];
    switch ( type ) {
        case kObjDataTypeObject:
        {
            Class propClass = [ self.propertyAttributes typeClass ];
            if ([ value isKindOfClass:[ NSString class ]]) {
                if ( propClass == [ NSString class ]) {
                    return value;
                } else if ( propClass == [ NSURL class ]) {
                    return [ NSURL URLWithString:value ];
                } else if ( propClass == [ NSNumber class ]) {
                    return [( NSString* )value numberValue ];
                } else if ( propClass == [ UIImage class ]) {
                    NSData *data = [[ NSData alloc] initWithBase64EncodedString:value options:0 ];
                    if ( data != nil ) return [ UIImage imageWithData:data ];
                } else if ( propClass == [ NSData class ]) {
                    return [[ NSData alloc] initWithBase64EncodedString:value options:0 ];
                }
            } else if ([ value isKindOfClass:[ NSNumber class ]]) {
                if ( propClass == [ NSDate class ]) {
                    return [ NSDate dateWithTimeIntervalSince1970:[( NSNumber* )value doubleValue ]];
                } else if ( propClass == [ UIColor class ]) {
                    return RGBa([( NSNumber* )value unsignedIntValue ]);
                } else if ( propClass == [ DBInteger class ]) {
                    return [( NSNumber* )value dbIntValue ];
                } else if ( propClass == [ DBBool class ]) {
                    return [( NSNumber* )value dbBoolValue ];
                } else if ( propClass == [ DBReal class ]) {
                    return [( NSNumber* )value dbRealValue ];
                }
            }
        }
            break;
        case kObjDataTypeCppBool:
        case kObjDataTypeChar:
        case kObjDataTypeInt:
        case kObjDataTypeLong:
        case kObjDataTypeLongLong:
        case kObjDataTypeUnsignedChar:
        case kObjDataTypeUnsignedInt:
        case kObjDataTypeUnsignedLong:
        case kObjDataTypeUnsignedLongLong:
        case kObjDataTypeDouble:
        case kObjDataTypeFloat:
            if ([ value isKindOfClass:[ NSNumber class ]]) {
                return value;
            } else if ([ value isKindOfClass:[ NSString class ]]) {
                return [( NSString* )value numberValue ];
            }
            break;
        default:
            break;
    }
    return nil;
}

@end

#pragma mark -

@implementation DBTableInfo

+( Class )parentClassOfClass:( Class )aClass withDeep:( NSUInteger )deep {
    Class rooClass = aClass;
    for ( NSInteger i = 0; i < deep; i++ ) {
        Class tmpClass = [ rooClass superclass ];
        if ( tmpClass != nil )
            rooClass = tmpClass;
        else
            break;
    }
    return rooClass != aClass ? rooClass : nil;
}

-( instancetype )initWithClass:( Class )tableClass {
    if ( self = [ super init ]) {
        if ( class_conformsToProtocol( tableClass, @protocol( DBObjectEntityProtocol )) && [(id)tableClass respondsToSelector:@selector( tableName )]) {
            _name = [( id<DBObjectEntityProtocol> )tableClass tableName ];
        } else {
            _name = NSStringFromClass( tableClass );
        }
        _objectClass = tableClass;
        NSInteger clsSuperLevel = 0;
        if ([ _objectClass conformsToProtocol:@protocol( DBObjectEntityProtocol )] &&
            [ OBJMethod doClass:_objectClass implementStaticMethod:@selector( numberOfSuperClassLevelToMakeDBTable )]){
            clsSuperLevel = [ _objectClass numberOfSuperClassLevelToMakeDBTable ];
        }
        _classTreeDeep = clsSuperLevel;
        // Columns info + primary columns
        NSMutableDictionary <NSString*, DBColumnInfo*>* columns = [ NSMutableDictionary dictionary ];
        NSMutableArray <NSString*>*primaryCols = [ NSMutableArray new ];
        NSMutableDictionary<NSString*, NSArray<NSString*>*>* mapListPrimary = [ NSMutableDictionary new ];
        NSMutableDictionary<NSString*, NSArray<NSString*>*>* mapListIngored = [ NSMutableDictionary new ];
        [ OBJProperty enumeratePropertyOfClass:tableClass superClassDeep:clsSuperLevel withBlock:
         ^BOOL( NSString* propertyName, NSMutableDictionary* propertyAttributes, Class ownerClass ) {
             NSString *clsName = NSStringFromClass( ownerClass );
             BOOL isConformProtocol = [ ownerClass conformsToProtocol:@protocol( DBObjectEntityProtocol )];
             NSArray <NSString*>* listPrimary = [ mapListPrimary objectForKey:clsName ];
             if ( listPrimary == nil && isConformProtocol && [ OBJMethod doClass:ownerClass implementStaticMethod:@selector( primaryKeyProperties )]) {
                 listPrimary = [ ownerClass primaryKeyProperties ];
                 [ mapListPrimary setObject:listPrimary forKey:clsName ];
             }
             NSArray *listIngored = [ mapListIngored objectForKey:clsName ];
             if ( listIngored == nil && isConformProtocol && [ OBJMethod doClass:ownerClass implementStaticMethod:@selector( ignoredProperties )]) {
                 listIngored = [ ownerClass ignoredProperties ];
                 [ mapListIngored setObject:listIngored forKey:clsName ];
             }
             DBColumnInfo *column = [ DBColumnInfo dbColumnWithProperty:propertyName atttributes:propertyAttributes
                                                            listIgnored:listIngored listPrimary:listPrimary ];
             if ( column != nil ) {
                 [ columns setObject:column forKey:column.name ];
                 if ( column.isPrimaryKey ){
                     [ primaryCols addObject:column.name ];
                 }
             }
             return NO;
        }];
        _columns = columns;
        if ( primaryCols.count > 0 ) {
            _primaryColumns = primaryCols;
        }
        // AUTO INCREMENT column (Integer Primary Key column)
        if ( primaryCols.count == 1 ) {
            NSString *colName = primaryCols.firstObject;
            DBColumnInfo *col = [ columns objectForKey:primaryCols.firstObject ];
            if ([ col isAutoInc ]) {
                _autoIncColumn = colName;
            }
        }
        // Alternative primary columns
        if ( _autoIncColumn == nil ) {
            NSMutableArray <NSString*>* altColumns = [ NSMutableArray arrayWithObjects:@"rowid", @"oid", @"_rowid_", nil ];
            for ( NSString *name in self.columns.allKeys ) {
                if ([ altColumns containsObject:name ])[ altColumns removeObject:name ];
            }
            _alternativePrimaryKey = [ altColumns firstObject ];
        }
    }
    return self;
}

-( NSString* )description {
    return [ NSString stringWithFormat:@"%@ <%p> %@ (%@)",
            self.class, self, self.name, @( self.columns.count )];
}

-( NSMutableString* )generateCreateTableSQL {
    NSMutableString *sql = [ NSMutableString stringWithFormat:@"CREATE TABLE %@ (", [ self.name dbIdentifierQuoted ]];
    if ( self.columns.count > 0 ) {
        for ( DBColumnInfo *column in self.columns.allValues ) {
            if ( self.autoIncColumn != nil && [ self.autoIncColumn isEqualToString:column.name ]) {
                if ([ self.objectClass conformsToProtocol:@protocol( DBObjectEntityProtocol )] &&
                    [ OBJMethod doClass:self.objectClass implementStaticMethod:@selector( isAutoIncrementNotReuse )] &&
                    [ (id<DBObjectEntityProtocol>)self.objectClass isAutoIncrementNotReuse ]) {
                    [ sql appendFormat:@"%@ %@ PRIMARY KEY AUTOINCREMENT, ", [ column.name dbIdentifierQuoted ], column.type ];
                } else {
                    [ sql appendFormat:@"%@ %@ PRIMARY KEY, ", [ column.name dbIdentifierQuoted ], column.type ];
                }
            } else {
                [ sql appendFormat:@"%@ %@, ", [ column.name dbIdentifierQuoted ], column.type ];
            }
        }
        if ( self.primaryColumns.count > 0 && self.autoIncColumn == nil ) {
            [ sql appendString:@"PRIMARY KEY (" ];
            for ( NSString *name in self.primaryColumns ) {
                [ sql appendFormat:@"%@, ", [ name dbIdentifierQuoted ]];
            }
            [ sql deleteTailCharacters:2 ];
            [ sql appendString:@")" ];
        } else {
            [ sql deleteTailCharacters:2 ];
        }
    }
    [ sql appendString:@");" ];
    return sql;
}

-( NSString* )selectAlternativePrimaryKey:( BOOL )withTableName {
    if ( self.alternativePrimaryKey != nil ) {
        if ( withTableName ) {
            return [[ NSString dbTableQuoted:self.name column:self.alternativePrimaryKey ] stringByAppendingString:@", " ];
        }
        return [[ self.alternativePrimaryKey dbIdentifierQuoted ] stringByAppendingString:@", " ];
    }
    return @"";
}

-( NSString* )columnMaskedNameForMultiTablesSelect:( NSString* )column {
    return [ self.name stringByAppendingFormat:@".%@", column ];
}

-( NSString* )unmaskColumnName:( NSString* )column {
    NSString *prefix = [ NSString stringWithFormat:@"%@.", self.name ];
    if ([ column hasPrefix: prefix ]) {
        return [ column substringFromIndex:prefix.length ];
    }
    return column;
}

@end
