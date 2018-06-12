/**
 @file      DBTableInfo.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>

#define SQLITE_TYPE_STRING  @"TEXT"
#define SQLITE_TYPE_INT     @"INTEGER"
#define SQLITE_TYPE_REAL    @"REAL"

typedef NS_ENUM( NSUInteger, DBDataType ) {
    kDBDataTypeNone = 0,
    kDBDataTypeInteger,
    kDBDataTypeReal,
    kDBDataTypeText
};

@import FMDB;

@interface DBColumnInfo : NSObject

/// Table column name.
@property ( nonatomic, strong, nonnull ) NSString* name;
/// Class property name represents the column.
@property ( nonatomic, strong, nonnull ) NSString* propertyName;
@property ( nonatomic, strong, nonnull ) NSDictionary<NSString*, id>* propertyAttributes;
/// Data type name.
@property ( nonatomic, strong, nullable ) NSString* type;
/// Data type (enum).
@property ( nonatomic, readonly ) DBDataType typeId;
/// Is primary key?
@property ( nonatomic, assign ) BOOL isPrimaryKey; // pk

+( nullable instancetype )dbColumnWithProperty:( nonnull NSString* )propName
                                   atttributes:( nonnull NSDictionary<NSString*, id>* )propAttr
                                   listIgnored:( nullable NSArray<NSString*>* )ignores
                                   listPrimary:( nullable NSArray<NSString*>* )primaries;

+( nullable NSString* )dbTypeForProperty:( nonnull NSDictionary<NSString*, id>* )propertyAttributes;

-( nullable id )autoConvertToDBValue:( nullable id )value;
-( nullable id )autoConvertFromDBValue:( nullable id )value;

@end

@interface DBTableInfo : NSObject

/// Table name.
@property ( nonatomic, strong, nonnull ) NSString *name;
/// Columns info.
@property ( nonatomic, strong, nonnull ) NSDictionary<NSString*, DBColumnInfo*> *columns;
/// List of primary key column name (not property name).
@property ( nonatomic, strong, nullable ) NSArray<NSString*> *primaryColumns;
/// Default primary key column (INTEGER PRIMARY KEY AUTOINCREMENT). Equal `nil` if table has no suitable column.
@property ( nonatomic, strong, nullable ) NSString *autoIncColumn;
/// This is the default colum of SQLite ("rowid" or "oid" or "_rowid_"). Equal `nil` if table has already an INTEGER PRIMARY KEY AUTOINCREMENT.
@property ( nonatomic, strong, nullable ) NSString *alternativePrimaryKey;
/// Class represents the table.
@property ( nonatomic, assign, nonnull ) Class objectClass;
/// Superclass level to use properties as columns.
@property ( nonatomic, assign ) NSUInteger classTreeDeep;

-( nonnull instancetype )initWithClass:( Class _Nonnull )tableClass;
-( nonnull NSMutableString* )generateCreateTableSQL;

/// Should add alternative primary key into SELECT statement?
-( nonnull NSString* )selectAlternativePrimaryKey:( BOOL )withTableName;
/// Column alias name (`AS`) for SELECT SQL from multi-tables (to avoid tables have same column name)
-( nonnull NSString* )columnMaskedNameForMultiTablesSelect:( nonnull NSString* )column;
-( nonnull NSString* )unmaskColumnName:( nonnull NSString* )column;

@end
