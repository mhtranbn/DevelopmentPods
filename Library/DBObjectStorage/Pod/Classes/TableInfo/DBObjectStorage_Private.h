/**
 @file      DBObjectStorage_Private.h
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#ifndef DBObjectStorage_Private_h
#define DBObjectStorage_Private_h

#import "CMLogger.h"
#import "NSStringAdditional.h"
#import "NSFileManager+appFolder.h"
#import "DBTableInfo.h"
#import "NSString+DB.h"
#import "DBObjectStorage.h"

#if DEBUG
#define DBLog(fmt, ...) CMLogCat( @"DB", (fmt), ##__VA_ARGS__ )
#else
#define DBLog(fmt, ...)
#endif

#define DBLogSQL(sql)   DBLog( @"SQL: %@", (sql) )

#define DB_ERR_MESG_UNK_CLASS(tableName)            [ NSString stringWithFormat:@"INSERT DB: Unknown object class %@.", (tableName) ]
#define DB_ERR_MSG_NO_FIELD(tableName)              [ NSString stringWithFormat:@"DB PROCESS: No field to process of %@.", (tableName) ]
#define DB_ERR_MSG_NO_PRIMARY(tableName)            [ NSString stringWithFormat:@"DB PROCESS: %@ has no primary field value to identify.", (tableName) ]
#define DB_ERR_MSG_OBJ_NOT_FOUND(tableName, filter) [ NSString stringWithFormat:@"DB PROCESS: Can not find object %@ %@.", (tableName), (filter) ]
#define DB_ERR_MSG_OBJ_DB_CLOSED                    @"DB ERROR: Database not opened"

#define DB_ERR_UNK_CLASS    [ NSError errorWithDomain:DBObjectStorageErrorDomain code:kDBObjectStorageErrorUnknownObjectClass userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MESG_UNK_CLASS( tableName )}]

#define DB_CHECK_OPENED     if ( self.database == nil ) return [ NSError errorWithDomain:DBObjectStorageErrorDomain code:kDBObjectStorageErrorDBClosed userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_OBJ_DB_CLOSED }];
#define DB_CHECK_OPENED2    if ( self.database == nil ) { if ( error ) *error = [ NSError errorWithDomain:DBObjectStorageErrorDomain code:kDBObjectStorageErrorDBClosed userInfo:@{ NSLocalizedDescriptionKey: DB_ERR_MSG_OBJ_DB_CLOSED }]; return nil; }

#endif /* DBObjectStorage_Private_h */
