/**
 @file      DBObjectStorage.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import <Foundation/Foundation.h>
@import FMDB;

@interface FMResultSet (DBObject)

/// FMResultSet map column name with column index using column name in lower case string => this can make mistake => so we use our map.
-( nonnull NSMutableArray<NSString*>* )allColumnNames;

@end

/// NSError.domain of DBObjectStorage.
extern NSString *const _Nonnull DBObjectStorageErrorDomain;

/// NSError.code: DB was closed, can not execute SQL statement.
extern NSInteger const kDBObjectStorageErrorDBClosed;
/// NSError.code: given class is not specified in `initializeDBWithName:`.
extern NSInteger const kDBObjectStorageErrorUnknownObjectClass;
/// NSError.code: given field (column) is unknown.
extern NSInteger const kDBObjectStorageErrorNoField;
/// NSError.code: table does not have any primary key to make filter.
extern NSInteger const kDBObjectStorageErrorNoPrimaryValueForFilter;
/// NSError.code: DB returns no object for SQL query.
extern NSInteger const kDBObjectStorageErrorObjectNotFound;

/// Protocol for DB Table classes
@protocol DBObjectEntityProtocol <NSObject>
@optional

/// Number of superclass level to use properties as table columns.
+( NSUInteger )numberOfSuperClassLevelToMakeDBTable;
/// Table name. If not specified, table name is the class name.
+( nonnull NSString* )tableName;
/// List of class properties are not used as table columns.
+( nonnull NSArray<NSString*>* )ignoredProperties;
/// List of class properties as primary key, applied to create table & to make SQL filter statement.
+( nonnull NSArray<NSString*>* )primaryKeyProperties;
/// Add AUTOINCREMENT into CREATE TABLE statment to make INTEGER PRIMARY KEY not reusing the deleted id.
+( BOOL )isAutoIncrementNotReuse;

@end

/**
 Addtional operation run after init DB

 @param database    FMDatabase instance to work with database
 @param dbVersion   Is DB version read from DB
 @param isDBExisted Is NO if DB just created
 @return Error occurred
 */
typedef NSError* _Nullable ( ^ DBInitializeOperation )( FMDatabase* _Nonnull database, BOOL isDBExisted, int dbVersion );

/**
 *  Create, update database
 */
@interface DBObjectStorage : NSObject

+( nonnull instancetype )sharedStorage;

/**
 *  Create new database for store objects or upgrade version if needed
 *
 *  @param name        Name to use as DB file name, default is Bundle ID. Try to copy from App bundle, if not, create new one.
 *  @param classes     List of object classes to store in DB
 *  @param version     Database version. Increase version when we change DB structure (add field (class property), change name ...)
 *  @param initTask    Manually upgrade database if version change. If nil (and version changes), try to auto upgrade by create new table and copy old data.
 *
 *  @return Error occured
 */
-( nullable NSError* )initializeDBWithName:( nullable NSString* )name andClasses:( nonnull NSArray* )classes
                                 dbVersion:( int )version additionalInitTask:( nullable DBInitializeOperation )initTask;
-( nullable NSError* )initializeDBWithName:( nullable NSString* )name andClasses:( nonnull NSArray* )classes dbVersion:( int )version;

@end

/**
 *  Get, set single object into database
 */
@interface DBObjectStorage (object)

/**
 *  Insert object into DB
 *
 *  @param object Object. The primary autoincreament integer field is ignored when insert & will update with lastest insert id from DB.
 *
 *  @return Error if occured.
 */
-( nullable NSError* )insertObject:( nonnull id )object;
/**
 *  Write (UPDATE) object values into DB using its primary field to filter (if no primary specified, use rowid).
 *
 *  @param object Object to save
 *
 *  @return Error
 */
-( nullable NSError* )saveObject:( nonnull id )object;
/**
 *  Combine of insertObject & saveObject. Update if object exists in DB or insert new.
 *
 *  @param object Object to store
 *
 *  @return Error
 */
-( nullable NSError* )storeObject:( nonnull id )object;
/**
 *  Read data from DB and fill into object using object primary field to filter (or use rowid).
 *
 *  @param object Object to get data
 *
 *  @return Error from FMDB or can not find equivalent data.
 */
-( nullable NSError* )loadObject:( nonnull id )object;
/**
 *  Remove object in DB
 *
 *  @param object Object
 *
 *  @return Error
 */
-( nullable NSError* )removeObject:( nonnull id )object;

@end

/*
 SQLite understands the following binary operators, in order from highest to lowest precedence:
 
 ||
 *    /    %
 +    -
 <<   >>   &    |
 <    <=   >    >=
 =    ==   !=   <>   IS   IS NOT   IN   LIKE   GLOB   MATCH   REGEXP
 AND
 OR
 Supported unary prefix operators are these:
 
 -    +    ~    NOT
 */

/*
 These below functions use SQL 'WHERE' to filter data.
 Not that class property can have alias name which is the DB table column name. So use column name in 'WHERE' statement.
 Also column name should be quoted inside "" & value with type text should be quoted inside ''
 Eg.: Class DBBook @property NSString bookName; // alias "name"
 We want get all books having name containing "ABC"
 Filter string should be: "name" LIKE '%ABC'
 */

/**
 *  Get, set multi objects with same class
 */
@interface DBObjectStorage (singletype)

/**
 *  Get all objects from DB (SELECT without WHERE)
 *
 *  @param objClass Class of object
 *  @param error    Error store
 *
 *  @return List of objects. Nil if error.
 */
-( nullable NSArray* )getAllObjectsOfClass:( nonnull Class )objClass error:( NSError* _Nullable * _Nullable )error;
/**
 *  Get objects using filter by SQL WHERE (eg. SELECT * FROM table1 WHERE table1.name LIKE '%abc%')
 *
 *  @param objClass       Object class
 *  @param whereStatement SQL statement for WHERE (without WHERE - note: use DB column name (property alias name if available))
 *  @param error          Error store
 *
 *  @return List of objects. Nil if error.
 */
-( nullable NSArray* )getObjectsOfClass:( nonnull Class )objClass withWhereStatement:( nonnull NSString* )whereStatement error:( NSError* _Nullable * _Nullable )error;
/**
 *  Get objects from one table with filter by multi tables (eg SELECT table1.id, table1.name FROM table1, table2 WHERE table1.id=table2.id AND table2.name LIKE '%abc%')
 *
 *  @param objClass      Class to get objects
 *  @param fromStatement SQL statement part after SELECT (eg.: FROM table1, table2 WHERE table1.id=table2.id...; or FROM table1 INNER JOIN table2 ON table1.id=table2.id WHERE ...)
 *  @param error         Error store
 *
 *  @return List of objects. Nil if error.
 */
-( nullable NSArray* )getObjectsOfClass:( nonnull Class )objClass withFromStatement:( nonnull NSString* )fromStatement error:( NSError* _Nullable * _Nullable )error;
/**
 *  Get objects from SQL query result. Use this function to query custom SQL like SELECT SUM(price) as price FROM .... Remember to set AS of custom field to equivalent object property name.
 *
 *  @param objClass Class of object
 *  @param sql      Full SQL. If table has not primary column, SQL SELECT must include field `rowid`.
 *  @param error    Error store
 *
 *  @return List of object. Nil if error.
 */
-( nullable NSArray* )getObjectsOfClass:( nonnull Class )objClass withSQLStatement:( nonnull NSString* )sql error:( NSError* _Nullable * _Nullable )error;
/**
 *  Run an update SQL
 *
 *  @param sql SQL to run
 *
 *  @return Error
 */
-( nullable NSError* )executeUpdate:( nonnull NSString* )sql;
/**
 *  Remove all objects
 *
 *  @param objClass Object class
 *
 *  @return Error
 */
-( nullable NSError* )deleteAllObjectsOfClass:( nonnull Class )objClass;
/**
 *  Create DELETE SQL and run, filter by SQL WHERE
 *
 *  @param objClass       Object class
 *  @param whereStatement SQL statement for WHERE (without WHERE - note: use DB column name (property alias name if available)
 *
 *  @return Error
 */
-( nullable NSError* )deleteObjectsOfClass:( nonnull Class )objClass withWhereStatement:( nonnull NSString* )whereStatement;

@end

/**
 *  Get multi objects with multi class
 */
@interface DBObjectStorage (multitype)

/**
 *  Get objects from multi tables in single SQL query
 *
 *  @param classes          List of object classes
 *  @param whereStatement   SQL part to append after SELECT FROM WHERE
 *  @param error            Error store
 *
 *  @return List of objects: each table has an array with key as Class name, number of rows stored in key "". Nil of error.
 */
-( nullable NSDictionary* )objectsFromClasses:( nonnull NSArray* )classes withWhereStatement:( nonnull NSString* )whereStatement error:( NSError* _Nullable * _Nullable )error;
/**
 *  Get objects from multi tables in single SQL query
 *
 *  @param classes      List of object classes
 *  @param sqlFilter    SQL part to append after SELECT (maybe FROM ... WHERE; or FROM ... INNER JOIN ... WHERE ...)
 *  @param error        Error store
 *
 *  @return List of objects: each table has an array with key as Class name, number of rows stored in key "". Nil of error.
 */
-( nullable NSDictionary* )objectsFromClasses:( nonnull NSArray* )classes withFromStatement:( nonnull NSString* )sqlFilter error:( NSError* _Nullable * _Nullable )error;
/**
 *  Get objects with multi-class from full SQL queyr
 *
 *  @param classes Classes of objects
 *  @param sql     SQL statement. SELECT must be: SELECT table1.column1 AS "table1.column1" ... FROM .... If table has not primary column, SQL SELECT must include field rowid.
 *  @param error   Error store
 *
 *  @return List of objects: each table has an array with key as Class name, number of rows stored in key "". Nil of error.
 */
-( nullable NSDictionary* )objectsFromClasses:( nonnull NSArray* )classes withSQLStatement:( nonnull NSString* )sql error:( NSError* _Nullable * _Nullable )error;
/**
 *  Get result of SELECT SQL
 *
 *  @param sql   SQL statement.
 *  @param error Error store
 *
 *  @return Each result row will be stored as NSDictionary.
 */
-( nullable NSArray* )resultOfQuery:( nonnull NSString* )sql error:( NSError* _Nullable * _Nullable )error;

@end

/**
 *  Use to print debug
 */
@interface DBObjectStorage (Debug)

/**
 *  Create random data, just for dev
 */
-( void )generateDummyData;

+( nullable NSString* )printStatus;
+( nullable NSString* )printTables;
+( nullable NSString* )printTableStructure:( nonnull NSString* )tableName;
+( nullable NSString* )dumpTable:( nonnull NSString* )tableName;
+( nullable NSString* )printQuery:( nonnull NSString* )sql;

@end

