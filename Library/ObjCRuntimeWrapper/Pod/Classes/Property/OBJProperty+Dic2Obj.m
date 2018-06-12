/**
 @file      OBJProperty+Dic2Obj.m
 @author    Tran Manh Hoang
 @date      2018/06/12

Copyright (c) 2018, 
All rights reserved.

*/

#import "OBJProperty+Dic2Obj.h"
#import "OBJProperty+Debug.h"
#import "OBJMethod+infector.h"
@import CommonLog;
@import RSUtils;

#define OBJLog(fmt, ...) CMLogCat( @"OBJC", (fmt), ##__VA_ARGS__ )

@implementation OBJProperty (Dic2Obj)

#pragma mark - Private (report)

+( void )report:( NSMutableArray* )uInfo ofFillDataFrom:( NSDictionary* )dataDic
       toObject:( id )obj withClassDeep:( NSUInteger )clsLevel {
    NSMutableString *report = [ NSMutableString stringWithString:@"\nFILL VALUE TO OBJECT PROPERTY REPORT\n--------------------------------------------------------------------------------\n" ];
    [ report appendFormat:@"==> Fill values from (%@):\n", [ dataDic class ]];
    [ report appendString:[ dataDic description ]];
    [ report appendFormat:@"\n==> Fill values to (%@):\n", [ obj class ]];
    NSMutableArray *arrInvalidProperties = [ NSMutableArray array ];
    NSString *propsDesc = [ self propertiesDescriptionOfObject:obj superClassDeep:clsLevel
                                     andWrongPropertiesStorage:arrInvalidProperties ];
    if ( propsDesc ) [ report appendString:propsDesc ];
    NSMutableArray *arrUnusedProperties    = [ uInfo objectAtIndex:0 ];
    NSMutableArray *arrUsedDataKeys        = [ uInfo objectAtIndex:1 ];
    NSMutableArray *arrFailedKeys          = [ uInfo objectAtIndex:2 ];
    if ( arrUnusedProperties.count ) {
        [ report appendFormat:@"\n==> Object properties not used ("FM_NSUInteger"):\n", [ arrUnusedProperties count ]];
        for ( NSString *s in arrUnusedProperties ) {
            [ report appendFormat:@"\t%@\n", s ];
        }
    }
    if ( arrFailedKeys.count ) {
        [ report appendFormat:@"\n==> Object properties failed to set value ("FM_NSUInteger"):\n", [ arrFailedKeys count ]];
        for ( NSString *s in arrFailedKeys ) {
            [ report appendFormat:@"\t%@\n", s ];
        }
    }
    if ( arrUsedDataKeys.count < dataDic.allKeys.count ) {
        NSMutableArray *unusedKeys = [ NSMutableArray array ];
        for ( NSString *key in dataDic.allKeys ) {
            if ( ![ arrUsedDataKeys containsObject:key ])
                [ unusedKeys addObject:key ];
        }
        [ report appendFormat:@"\n==> Data key not used ("FM_NSUInteger"):\n", [ unusedKeys count ]];
        for ( NSString *s in unusedKeys ) {
            [ report appendFormat:@"\t%@\n", s ];
        }
    }
    if ( arrInvalidProperties.count ) {
        [ report appendFormat:@"\n==> Object properties invalid ("FM_NSUInteger"):\n", [ arrInvalidProperties count ]];
        for ( NSString *s in arrInvalidProperties ) {
            [ report appendFormat:@"\t%@\n", s ];
        }
    }
    [ report appendString:@"\n--------------------------------------------------------------------------------\n" ];
    OBJLog( @"%@", report );
}

#pragma mark - Basic type property

// Check value can be converted to property datatype (which is basic type eg. int, float...) and set to property
bool OBJProperty_setValueForObjectProperty( id object, id value, NSString *name, SEL selector, id defaultValue ) {
    if ([ value respondsToSelector:selector ]) {
        @try {
            [ object setValue:value forKey:name ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>", name, value, [ object class ], object );
            return true;
        }
    } else {
        @try {
            [ object setValue:defaultValue forKey:name ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>", name, defaultValue, [ object class ], object );
            return true;
        }
    }
    return false;
}

#pragma mark Object property

// Convert value to NSString & fill to object
bool _OBJProperty_setObjectForNSStringProperty( id object, id value, NSString *propertyName ){
    NSString *sVal = nil;
    if ([ value isKindOfClass:[ NSString class ]] || value == nil ) {
        sVal = value;
    } else {
        sVal =[ NSString stringWithFormat:@"%@", value ];
    }
    @try {
        [ object setValue:sVal forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, value, [ object class ], object );
        return true;
    }
    return false;
}

// Convert value to NSMutableString & fill to object
bool _OBJProperty_setObjectForNSMutableStringProperty( id object, id value, NSString *propertyName ){
    NSMutableString *sVal = nil;
    if ([ value isKindOfClass:[ NSMutableString class ]] || value == nil ) {
        sVal = value;
    } else {
        sVal =[ NSMutableString stringWithFormat:@"%@", value ];
    }
    @try {
        [ object setValue:sVal forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, value, [ object class ], object );
        return true;
    }
    return false;
}

// Convert value to NSNumber & fill to object
bool _OBJProperty_setObjectForNSNumberProperty( id object, id value, NSString *propertyName ){
    NSNumber *sVal = nil;
    if ([ value isKindOfClass:[ NSString class ]])
        sVal = [( NSString* )value numberValue ];
    else if ([ value isKindOfClass:[ NSNumber class ]])
        sVal = value;
    else if ( value )
        sVal = [[ NSString stringWithFormat:@"%@", value ] numberValue ];
    @try {
        [ object setValue:sVal forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, value, [ object class ], object );
        return true;
    }
    return false;
}

// Convert from NSString hexa value to UIColor rgba
bool _OBJProperty_setObjectForColorProperty( id object, id value, NSString *propertyName ){
    NSString *rgbColor = nil;
    if ([ value isKindOfClass:[ NSString class ]])
        rgbColor = value;
    else
        rgbColor = [ NSString stringWithFormat:@"%@", value ];
    OBJColor *color = [ rgbColor colorFromHexaString ];
    @try {
        [ object setValue:color forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, value, [ object class ], object );
        return true;
    }
    return false;
}

bool _OBJProperty_setObjectForNSURLProperty( id object, NSString *value, NSString *propertyName ){
    NSURL *url = [ NSURL URLWithString:value ];
    @try {
        [ object setValue:url forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, value, [ object class ], object );
        return true;
    }
    return false;
}

// Value is object and property datatype is object too (prefer NSString & NSNumber)
bool OBJProperty_setObjectAsValueForObjectProperty( id object, id value, NSString *propertyName, NSDictionary *attributes ) {
    if ([[ attributes typeDescription ] isEqualToString:@"@\"NSString\"" ]) {
        return _OBJProperty_setObjectForNSStringProperty( object, value, propertyName );
    } else if ([[ attributes typeDescription ] isEqualToString:@"@\"NSMutableString\"" ]){
        return _OBJProperty_setObjectForNSMutableStringProperty( object, value, propertyName );
    } else if ([[ attributes typeDescription ] isEqualToString:@"@\"NSNumber\"" ]) {
        return _OBJProperty_setObjectForNSNumberProperty( object, value, propertyName );
    } else if ([[ attributes typeDescription ] isEqualToString:@"@\""_OBJColor_"\"" ]) {
        return _OBJProperty_setObjectForColorProperty( object, value, propertyName );
    } else if ([[ attributes typeDescription ] isEqualToString:@"@\"NSURL\"" ] &&
               [ value isKindOfClass:[ NSString class ]]) {
        return _OBJProperty_setObjectForNSURLProperty( object, value, propertyName );
    } else {
        @try {
            [ object setValue:value forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    }
    return false;
}

#pragma mark Structure property

// Convert value to CGRect & fill to object
bool _OBJProperty_setObjectForRectProperty( id object, id value, NSString *propertyName ){
    if ([ value isKindOfClass:[ NSString class ]]) {
        @try {
            [ object setValue:[ NSValue valueWithOBJRect( OBJRectFromString( value ))] forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    } else { // Try to convert using default method
        if ( OBJProperty_setValueForObjectProperty( object, value, propertyName, NSSelectorFromString( @"rectValue" ),
                                                   [ NSValue valueWithOBJRect( OBJRectZero )]))
            return true;
    }
    return false;
}

bool _OBJProperty_setObjectForPointProperty( id object, id value, NSString *propertyName ){
    if ([ value isKindOfClass:[ NSString class ]]) {
        @try {
            [ object setValue:[ NSValue valueWithOBJPoint( OBJPointFromString( value ))] forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    } else {
        if ( OBJProperty_setValueForObjectProperty( object, value, propertyName, NSSelectorFromString( @"pointValue" ),
                                                   [ NSValue valueWithOBJPoint( OBJPointZero )]))
            return true;
    }
    return false;
}

bool _OBJProperty_setObjectForSizeProperty( id object, id value, NSString *propertyName ){
    if ([ value isKindOfClass:[ NSString class ]]) {
        @try {
            [ object setValue:[ NSValue valueWithOBJSize( OBJSizeFromString( value ))] forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    } else {
        if ( OBJProperty_setValueForObjectProperty( object, value, propertyName, NSSelectorFromString( @"sizeValue" ),
                                                   [ NSValue valueWithOBJSize( OBJSizeZero )]))
            return true;
    }
    return false;
}

bool _OBJProperty_setObjectForRangeProperty( id object, id value, NSString *propertyName ){
    if ([ value isKindOfClass:[ NSString class ]]) {
        @try {
            [ object setValue:[ NSValue valueWithRange:NSRangeFromString( value )] forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    } else {
        if ( OBJProperty_setValueForObjectProperty( object, value, propertyName, NSSelectorFromString( @"rangeValue" ),
                                                   [ NSValue valueWithRange:NSMakeRange( 0, 0 )]))
            return true;
    }
    return false;
}

// Property datatype is structure (support CGRect, CGPoint, CGSize, NSRange)
// Value should be NSString and can be converted to structure via function like CGRectFromString( NSString* )
bool OBJProperty_setStructureValueForObjectProperty( id object, id value, NSString *propertyName, NSDictionary *attributes ) {
    if ([[ attributes typeDescription ] rangeOfString:@"{"_OBJRect_"=" ].location == 0 ){
        return _OBJProperty_setObjectForRectProperty( object, value, propertyName );
    } else if ([[ attributes typeDescription ] rangeOfString:@"{"_OBJPoint_"=" ].location == 0 ){
        return _OBJProperty_setObjectForPointProperty( object, value, propertyName );
    } else if ([[ attributes typeDescription ] rangeOfString:@"{"_OBJSize_"=" ].location == 0 ){
        return _OBJProperty_setObjectForSizeProperty( object, value, propertyName );
    } else if ([[ attributes typeDescription ] rangeOfString:@"{_NSRange=" ].location == 0 ){
        return _OBJProperty_setObjectForRangeProperty( object, value, propertyName );
    }
    return false;
}

#pragma mark - Fill data from dictionary to object property

bool _OBJProperty_setObjectsForDictionaryProperty( id object, NSDictionary* value, Class itemClass,
                                                  Class itemRootClass, NSString *propertyName, BOOL reportable ){
    NSMutableDictionary *store = [ NSMutableDictionary dictionary ];
    for ( NSString *itemKey in [ value allKeys ]) {
        NSDictionary *itemDic = [ value objectForKey:itemKey ];
        id itemObj = [ OBJProperty objectFromClass:itemClass fromDictionary:itemDic report:reportable ];
        if ( itemObj != nil )[ store setObject:itemObj forKey:itemKey ];
    }
    @try {
        [ object setValue:store forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, store, [ object class ], object );
        return true;
    }
    return false;
}

bool _OBJProperty_setDictonaryForDictionaryProperty( id object, NSDictionary* value, NSDictionary *attributes,
                                                    NSString *propertyName ){
    if ([[ attributes typeDescription ] isEqualToString:@"@\"NSMutableDictionary\"" ]) {
        @try {
            [ object setValue:[ NSMutableDictionary dictionaryWithDictionary:value ]
                       forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    } else {
        @try {
            [ object setValue:value forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    }
    return false;
}

bool _OBJProperty_setDictionaryForObjectProperty( id object, NSDictionary* value, Class propClass, NSString *propertyName, BOOL reportable ){
    id subObj  = [ object valueForKey:propertyName ]; // Get current object
    if ( subObj == nil ) // No current object, create new one
        subObj = [ OBJProperty objectFromClass:propClass fromDictionary:value report:reportable ];
    else
        [ OBJProperty fillDataIntoObject:subObj fromDictionary:value report:reportable ];
    @try {
        [ object setValue:subObj forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, value, [ object class ], object );
        return true;
    }
    return false;
}

// Value is NSDictionary
+( BOOL )fillDictionaryValue:( NSDictionary* )value forProperty:( NSString* )propertyName
          propertyAttributes:( NSDictionary* )attributes ofObject:( id  )object reportable:( BOOL )isReport {
    Class propClass = [ attributes typeClass ];
    if ( propClass && [ propClass isSubclassOfClass:[ NSDictionary class ]]) {
        // Get meta info from attributes of property
        Class itemClass = [ attributes propertyDictionaryItemClass ];
        Class itemRootClass = [ attributes propertyDictionaryItemRootClass ];
        // Validate items in array as value
        for ( id itemDic in [ value allValues ]) {
            if (![ itemDic isKindOfClass:[ NSDictionary class ]]) {
                itemClass = NULL;
                break;
            }
        }
        if ( itemClass ) { // Class to alloc object for each item of Dicitonary exists
            return _OBJProperty_setObjectsForDictionaryProperty( object, value, itemClass, itemRootClass, propertyName, isReport );
        } else {
            // Try assign direct
            return _OBJProperty_setDictonaryForDictionaryProperty( object, value, attributes, propertyName );
        }
    } else if ( propClass != NULL ) { // Property value is an object
        return _OBJProperty_setDictionaryForObjectProperty( object, value, propClass, propertyName, isReport );
    }
    return NO;
}

#pragma mark Fill array

bool _OBJProperty_setObjectsForArrayProperty( id object, NSArray* value, Class itemClass,
                                             Class itemRootClass, NSString *propertyName, BOOL reportable ){
    NSMutableArray *store = [ NSMutableArray array ];
    for ( NSDictionary *itemDic in value ) {
        id itemObj = [ OBJProperty objectFromClass:itemClass fromDictionary:itemDic report:reportable ];
        if ( itemObj != nil )[ store addObject:itemObj ];
    }
    @try {
        [ object setValue:store forKey:propertyName ];
    }
    @catch (NSException *exception) {
        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
               propertyName, value, [ object class ], object );
        return true;
    }
    return false;
}

bool _OBJProperty_setArrayForArrayProperty( id object, NSArray* value, NSDictionary *attributes,
                                           NSString *propertyName ){
    if ([[ attributes typeDescription ] isEqualToString:@"@\"NSMutableArray\"" ]) {
        @try {
            [ object setValue:[ NSMutableArray arrayWithArray:value ] forKey:propertyName ];
        }
        @catch (NSException *exception) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    } else {
        @try {
            [ object setValue:value forKey:propertyName ];
        }
        @catch ( NSException *exception ) {
            OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                   propertyName, value, [ object class ], object );
            return true;
        }
    }
    return false;
}

+( BOOL )fillArrayValue:( NSArray* )value forPropertyName:( NSString* )propertyName
     propertyAttributes:( NSDictionary* )attirbutes ofObject:( id  )object reportable:( BOOL )isReport {
    Class propClass = [ attirbutes typeClass ];
    if ( propClass != nil && [ propClass isSubclassOfClass:[ NSArray class ]]) {
        Class itemClass = [ attirbutes propertyArrayItemClass ];
        Class itemRootClass = [ attirbutes propertyArrayItemRootClass ];
        for ( id itemDic in value ) {
            if (![ itemDic isKindOfClass:[ NSDictionary class ]]) {
                itemClass = NULL;
                break;
            }
        }
        
        if ( itemClass ) {
            return _OBJProperty_setObjectsForArrayProperty( object, value, itemClass, itemRootClass, propertyName, isReport );
        } else {
            return _OBJProperty_setArrayForArrayProperty( object, value, attirbutes, propertyName );
        }
    }
    return NO;
}

// uInfo: array contains 3 array: 0 to store unused property names, 1 to store used key of data dic, 2 to store name/key failed to assign
+( void )fillValuesForObject:( id )obj fromDictionary:( NSDictionary* )dataDic withClass:( Class )targetClass
                   classDeep:( NSUInteger )clsLevel userInfo:( NSMutableArray* )userInfo report:( BOOL )isNeedReport {
    if (![ dataDic isKindOfClass:[ NSDictionary class ]]) return;
    if ( obj == nil ) return;
    // Get object properties name list
    [ self enumeratePropertyOfClass:targetClass superClassDeep:clsLevel withBlock:^BOOL(NSString *propertyName, NSMutableDictionary *propertyAttributes, __unsafe_unretained Class ownerClass) {
        if ([ propertyAttributes isReadOnly ]) return NO;
        NSString *dataKey = [ propertyAttributes propertyAliasName ];
        if ( dataKey == nil ) dataKey = propertyName;
        NSMutableArray *arrUnusedProperties    = nil;
        NSMutableArray *arrUsedDataKeys        = nil;
        NSMutableArray *arrFailedKeys          = nil;
        if ( isNeedReport ) {
            arrUnusedProperties    = [ userInfo objectAtIndex:0 ];
            arrUsedDataKeys        = [ userInfo objectAtIndex:1 ];
            arrFailedKeys          = [ userInfo objectAtIndex:2 ];
        }
        id val = [ dataDic objectForKey:dataKey ];
        if ( val == nil ){ // Dic has no value for property
            if ( isNeedReport )[ arrUnusedProperties addObject:propertyName ];
            return NO;
        }
        if ( isNeedReport )[ arrUsedDataKeys addObject:propertyName ];
        if ([ val isKindOfClass:[ NSNull class ]]) // empty data from JSON
            val = nil;
        BOOL result = NO;
        if ([ obj respondsToSelector:@selector( shouldTransformValue:forProperty: )] &&
            [ obj respondsToSelector:@selector( transformedValueOf:forProperty: )] &&
            [ obj shouldTransformValue:val forProperty:propertyName ]) {
            val = [ obj transformedValueOf:val forProperty:propertyName ];
        }
        if ([ val isKindOfClass:[ NSDictionary class ]]) { // Value is a dictionary
            result = [ self fillDictionaryValue:val forProperty:propertyName
                             propertyAttributes:propertyAttributes ofObject:obj reportable:isNeedReport ];
        } else if ([ val isKindOfClass:[ NSArray class ]]) { // Value is an array, so try assign to property if property type is array too
            result = [ self fillArrayValue:val forPropertyName:propertyName
                        propertyAttributes:propertyAttributes ofObject:obj reportable:isNeedReport ];
        } else { // Other value type (almost string, number), try to assign to equivalent property
            switch ([ propertyAttributes type ]) {
                case kObjDataTypeObject:
                    result = OBJProperty_setObjectAsValueForObjectProperty( obj, val, propertyName, propertyAttributes );
                    break;
                case kObjDataTypePointer:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( pointerValue ), @0 );
                    break;
                case kObjDataTypeDouble:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( doubleValue ), @0 );
                    break;
                case kObjDataTypeFloat:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( floatValue ), @0 );
                    break;
                case kObjDataTypeInt:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( intValue ), @0 );
                    break;
                case kObjDataTypeLong:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( longValue ), @0 );
                    break;
                case kObjDataTypeLongLong:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( longLongValue ), @0 );
                    break;
                case kObjDataTypeCppBool:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( boolValue ), @0 );
                    break;
                case kObjDataTypeShort:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( shortValue ), @0 );
                    break;
                case kObjDataTypeChar:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( charValue ), @0 );
                    break;
                case kObjDataTypeUnsignedChar:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( unsignedCharValue ), @0 );
                    break;
                case kObjDataTypeUnsignedInt:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( unsignedIntValue ), @0 );
                    break;
                case kObjDataTypeUnsignedLong:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( unsignedLongValue ), @0 );
                    break;
                case kObjDataTypeUnsignedLongLong:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( unsignedLongLongValue ), @0 );
                    break;
                case kObjDataTypeUnsignedShort:
                    result = OBJProperty_setValueForObjectProperty( obj, val, propertyName, @selector( unsignedShortValue ), @0 );
                    break;
                case kObjDataTypeStructure:
                    result = OBJProperty_setStructureValueForObjectProperty( obj, val, propertyName, propertyAttributes );
                    break;
                default:
                    @try {
                        [ obj setValue:val forKey:propertyName ];
                        result = YES;
                    }
                    @catch (NSException *exception) {
                        OBJLog( @"OBJProperty failed to fill field %@ with value %@ for object %@<%p>",
                               propertyName, val, [ obj class ], obj );
                        result = NO;
                    }
                    break;
            }
        }
        if ( isNeedReport && result )[ arrFailedKeys addObject:propertyName ];
        return NO;
    }];
}

+( void )fillDataIntoObject:( id )object fromDictionary:( NSDictionary* )dataDic report:( BOOL )isNeedReport {
    NSUInteger clsDeep = 0;
    if ([ object respondsToSelector:@selector( numberOfSuperClassLevelToFillDataFrom: )])
        clsDeep = [ object numberOfSuperClassLevelToFillDataFrom:dataDic ];
    NSMutableArray *uInfo = nil;
    if ( isNeedReport ) {
        uInfo = [ NSMutableArray array ];
        [ uInfo addObject:[ NSMutableArray array ]];
        [ uInfo addObject:[ NSMutableArray array ]];
        [ uInfo addObject:[ NSMutableArray array ]];
    }
    [ self fillValuesForObject:object fromDictionary:dataDic withClass:[ object class ]
                     classDeep:clsDeep userInfo:uInfo report:isNeedReport ];
    if ( isNeedReport )[ self report:uInfo ofFillDataFrom:dataDic toObject:object withClassDeep:clsDeep ];
}

+( void )fillDataIntoObject:( id )object fromDictionary:( NSDictionary* )dataDic {
    [ self fillDataIntoObject:object fromDictionary:dataDic report:NO ];
}

+( id )objectFromClass:( Class )objClass fromDictionary:( NSDictionary* )dataDic report:( BOOL )isNeedReport {
    id object = nil;
    if ([ OBJMethod doClass:objClass implementStaticMethod:@selector( objectToFillDataFromData: )]) {
        object = [ objClass objectToFillDataFromData:dataDic ];
    } else {
        object = [ objClass new ];
    }
    if ( object != nil )[ self fillDataIntoObject:object fromDictionary:dataDic report:isNeedReport ];
    return object;
}

+( id )objectFromClass:( Class )objClass fromDictionary:( NSDictionary* )dataDic {
    return [ self objectFromClass:objClass fromDictionary:dataDic report:NO ];
}

@end
