/**
 @file      DBObjectStorage.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "DBObjectStorage.h"
#import "DBObjectStorage_Private.h"
@import ObjCRuntimeWrapper;

@implementation FMResultSet (DBObject)

-( NSMutableArray* )allColumnNames {
    NSMutableArray *result = [ NSMutableArray array ];
    for ( int i = 0; i < self.columnCount; i++ ) {
        [ result addObject:[ self columnNameForIndex:i ]];
    }
    return result;
}

@end

NSString *const DBObjectStorageErrorDomain = @"DBObjectStorageErrorDomain";

@interface DBObjectStorage()

@property ( nonatomic, strong ) FMDatabase *database;
@property ( nonatomic, assign ) int dbVersion;
@property ( nonatomic, strong ) NSDictionary *tablesInfo;

@end

@implementation DBObjectStorage

#pragma mark - Life cycle

+( instancetype )sharedStorage {
    static DBObjectStorage *__db_object_storage = nil;
    if ( __db_object_storage == nil )
        __db_object_storage = [[ self alloc ] init ];
    return __db_object_storage;
}

-( void )dealloc {
    if ( self.database != nil ) [ self.database close ];
}

-( NSError* )initializeDBWithName:( NSString* )name andClasses:( NSArray* )classes
                        dbVersion:(int)version additionalInitTask:(DBInitializeOperation)initTask {
    NSFileManager *fileMan = [ NSFileManager defaultManager ];
    NSString *dbName = ( name != nil && name.length > 0 ) ? name : [[[[ NSBundle mainBundle ] objectForInfoDictionaryKey:( NSString* )kCFBundleIdentifierKey ] stringByAppendingPathExtension:@"sqlite" ] stringByAppendingPathExtension:@"sqlite" ];
    NSString *dbPath = [[ fileMan cachesPath ] stringByAppendingPathComponent:dbName ];
    BOOL dbExisted = [ fileMan fileExistsAtPath:dbPath ];
    BOOL dbFromApp = NO;
    DBLog( @"DB (existed %d): %@", dbExisted, dbPath );
    if ( !dbExisted ){
        NSString *resourcePath = [[ NSBundle mainBundle ] pathForResource:dbName ofType:nil ];
        if ( resourcePath != nil ) {
            dbExisted = [ fileMan copyItemAtPath:resourcePath toPath:dbPath error:NULL ];
            dbFromApp = YES;
            DBLog( @"DB copy from App Bundle %@ to %@ result %d", resourcePath, dbPath, dbExisted );
        }
    }
    self.database = [ FMDatabase databaseWithPath:dbPath ];
    BOOL result = [ self.database open ];
    if ( !result ) {
        NSError *error = self.database.lastError;
        DBLog( @"ERROR OPEN DB: %@", error );
        self.database = nil;
        return error;
    }
    
    self.dbVersion = version;
    [ self loadTablesInfoFromClasses:classes ];
    
    NSError *error = nil;
    if ( dbExisted ) {
        if ( dbFromApp ){
            [ self updateDBVersion ];
            [ self upgradeDatabase ]; // Try to synchronize DB Structure with classes
        } else {
            int currentVersion = [ self getDBVersion ];
            DBLog( @"DB VERSION: %d (DB file) / %d (code)", currentVersion, version );
            if ( currentVersion != version ) {
                if ( initTask )
                    error = initTask( self.database, YES, currentVersion );
                else
                    error = [ self upgradeDatabase ];
                if ( error == nil )[ self updateDBVersion ];
            }
        }
    } else {
        error = [ self createNewDatabase ];
        if ( error == nil && initTask ) {
            error = initTask( self.database, NO, version );
        }
    }
    
    for ( DBTableInfo *tableInfo in self.tablesInfo.allValues ) {
        if ( tableInfo.alternativePrimaryKey != nil ) {
            [ OBJProperty addDynamicPropertyWithName:tableInfo.alternativePrimaryKey
                                 dataTypeDescription:[ OBJCommon stringDescriptionFromDataType:kObjDataTypeInt ]
                                             ofClass:tableInfo.objectClass ];
        }
    }
    
    return error;
}

-( NSError* )initializeDBWithName:( NSString* )name andClasses:( NSArray* )classes dbVersion:( int )version {
    return [ self initializeDBWithName:name andClasses:classes dbVersion:version additionalInitTask:nil ];
}

#pragma mark - Create DB

-( Class )classFromItem:( id  )obj {
    if ( obj == [ obj class ])
        return obj;
    else if ([ obj isKindOfClass:[ NSString class ]])
        return NSClassFromString( obj );
    return nil;
}

-( void )loadTablesInfoFromClasses:( NSArray * )classes {
    NSMutableDictionary *tables = [ NSMutableDictionary dictionary ];
    for ( id cls in classes ) {
        Class tblClass = nil;
        if ([ cls isKindOfClass:[ NSArray class ]]) {
            tblClass = [ self classFromItem:cls[0] ];
        } else {
            tblClass = [ self classFromItem:cls ];
        }
        if ( tblClass ) {
            DBTableInfo *tblInfo = [[ DBTableInfo alloc ] initWithClass:tblClass ];
            [ tables setObject:tblInfo forKey:NSStringFromClass( tblClass )];
        }
    }
    self.tablesInfo = tables;
}

-( NSError* )createNewDatabase {
    DBLog( @"--- [CREATE DATABASE] ---" );
    NSError *result = nil;
    [ self.database beginTransaction ];
    [ self updateDBVersion ];
    for ( DBTableInfo *table in self.tablesInfo.allValues ) {
        result = [ self createNewTable:table ];
    }
    [ self.database commit ];
    return result;
}

-( NSError* )createNewTable:( DBTableInfo* )table {
    NSError *error = nil;
    NSString *sql = [ table generateCreateTableSQL ];
    DBLogSQL( sql );
    if (![ self.database executeUpdate:sql ]) {
        error = self.database.lastError;
        DBLog( @"ERROR CREATE TABLE: %@", error );
    }
    return error;
}

-( void )updateDBVersion {
    if ( self.dbVersion > 0 ) {
        NSString *sql = [ NSString stringWithFormat:@"PRAGMA user_version = %d", self.dbVersion ];
        [ self.database executeUpdate:sql ];
    }
}

#pragma mark - Upgrade DB

-( int )getDBVersion {
    NSString *sql = @"PRAGMA user_version;";
    FMResultSet *resultSet = [ self.database executeQuery:sql ];
    int result = 0;
    if ( resultSet != nil ) {
        if ([ resultSet next ]) result = [ resultSet intForColumn:@"user_version" ];
        [ resultSet close ];
    }
    return result;
}

-( NSMutableDictionary* )getDBTablesInfo {
    NSMutableDictionary *result = [ NSMutableDictionary dictionary ];
    NSString *sql = @"SELECT name FROM sqlite_master WHERE name<>'sqlite_sequence' AND type='table';";
    FMResultSet *resultSet = [ self.database executeQuery:sql ];
    if ( resultSet != nil ) {
        while ([ resultSet next ]) {
            DBTableInfo *tableInfo = [[ DBTableInfo alloc ] init ];
            tableInfo.name = [ resultSet stringForColumn:@"name" ];
            [ result setObject:tableInfo forKey:tableInfo.name ];
        }
        [ resultSet close ];
    }
    if ( result.count > 0 ) {
        for ( NSString *tableName in result.allKeys ) {
            sql = [ NSString stringWithFormat:@"PRAGMA table_info(\"%@\");", tableName ];
            resultSet = [ self.database executeQuery:sql ];
            if ( resultSet != nil ) {
                NSMutableDictionary *columns = [ NSMutableDictionary dictionary ];
                while ([ resultSet next ]) {
                    DBColumnInfo *column = [[ DBColumnInfo alloc ] init ];
                    column.name = [ resultSet stringForColumn:@"name" ];
                    column.type = [ resultSet stringForColumn:@"type" ];
                    column.isPrimaryKey = [ resultSet boolForColumn:@"pk" ];
                    [ columns setObject:column forKey:column.name ];
                }
                DBTableInfo *tableInfo = [ result objectForKey:tableName ];
                tableInfo.columns = columns;
                DBLog( @"%@\n%@", tableInfo, tableInfo.columns );
                [ resultSet close ];
            }
        }
        return result;
    }
    return nil;
}

-( NSError* )dropTable:( NSString* )tableName {
    NSError *error = nil;
    NSString *sql = [ NSString stringWithFormat:@"DROP TABLE \"%@\";", tableName ];
    DBLogSQL( sql );
    if (![ self.database executeUpdate:sql ]) {
        error = self.database.lastError;
        DBLog( @"ERROR DROP TABLE: %@", error );
    }
    return error;
}

-( NSError* )compareNewTable:( DBTableInfo* )newTableInfo withOldTable:( DBTableInfo* )oldTableInfo {
    NSError *error = nil;
    BOOL tableChanged = NO;
    NSMutableString *columnsList = [ NSMutableString string ];
    for ( NSString *colName in newTableInfo.columns.allKeys ) {
        DBColumnInfo *newCol = [ newTableInfo.columns objectForKey:colName ];
        DBColumnInfo *oldCol = [ oldTableInfo.columns objectForKey:colName ];
        if ( oldCol != nil ) {
            if (![ oldCol.type isEqualToString:newCol.type ])
                tableChanged = YES;
            [ columnsList appendFormat:@"\"%@\", ", colName ];
        } else {
            tableChanged = YES;
        }
    }
    if ( columnsList.length > 0 )[ columnsList deleteTailCharacters:2 ];
    if ( tableChanged ) {
        oldTableInfo.name = [ NSString stringWithFormat:@"%@_old", newTableInfo.name ];
        NSString *sql = [ NSString stringWithFormat:@"ALTER TABLE \"%@\" RENAME TO \"%@\";",
                         newTableInfo.name, oldTableInfo.name ];
        DBLogSQL( sql );
        if ([ self.database executeUpdate:sql ]) {
            error = [ self createNewTable:newTableInfo ];
            if ( error == nil && columnsList.length ) {
                sql = [ NSString stringWithFormat:@"INSERT INTO \"%@\" (%@) SELECT %@ FROM \"%@\"",
                       newTableInfo.name, columnsList, columnsList, oldTableInfo.name ];
                DBLogSQL( sql );
                if (![ self.database executeUpdate:sql ]) {
                    error = self.database.lastError;
                    DBLog( @"ERROR MIRROR TABLE: %@", error );
                    sql = [ NSString stringWithFormat:@"ALTER TABLE \"%@\" RENAME TO \"%@\";", oldTableInfo.name, newTableInfo.name ];
                    if (![ self.database executeUpdate:sql ]) {
                        DBLog( @"ERROR RESTORE BACK UP TABLE: %@", self.database.lastError );
                    }
                    oldTableInfo.name = [ newTableInfo.name copy ];
                }
            }
        } else {
            error = self.database.lastError;
            DBLog( @"ERROR BACKUP TABLE: %@", error );
        }
    }
    return error;
}

/// Try to add/remove columns following class structure & keep data. TODO: case db from file?
-( NSError* )upgradeDatabase {
    DBLog( @"--- [UPGRADE DATABASE] ---" );
    NSError *result = nil;
    NSMutableDictionary *currentDBTables = [ self getDBTablesInfo ]; // Key is table name, self.tableInfo key is class name
    [ self.database beginTransaction ];
    for ( DBTableInfo *newTable in self.tablesInfo.allValues ) {
        DBTableInfo *oldTable = [ currentDBTables objectForKey:newTable.name ];
        if ( oldTable != nil ) {
            // Compare tables
            result = [ self compareNewTable:newTable withOldTable:oldTable ];
            [ currentDBTables removeObjectForKey:oldTable.name ];
        } else {
            // Add new table
            result = [ self createNewTable:newTable ];
        }
    }
    // Drop unused tables
    if ( currentDBTables.count > 0 ) {
        for ( DBTableInfo *table in currentDBTables.allValues ) {
            [ self dropTable:table.name ];
        }
    }
    [ self.database commit ];
    return result;
}

@end
