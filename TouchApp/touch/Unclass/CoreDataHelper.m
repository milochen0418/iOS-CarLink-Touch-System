//
//  CoreDataHelper.m
//  helloworld.testCoreData
//
//  Created by Milo Chen on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataHelper.h"
//#import "CoreDataHelperAtomic.h"


//CoreDataHelperAtomic
@implementation CoreDataHelper

@synthesize mContext,mManagedObjectModel;

static CoreDataHelper * staticInstance = nil;
+(CoreDataHelper*) sharedInstance 
{
    @synchronized ([CoreDataHelper class])
    {
        if(staticInstance == nil)
        {
            staticInstance = [[CoreDataHelper alloc] init];
            [staticInstance initCoreData];
        }
        return staticInstance;
    }
//    return [CoreDataHelperAtomic getAtomicCoreDataHelper];
}







-(NSMutableDictionary*) readSettingDict:(NSString*) entityName
{
    NSLog(@"readSettingDict");
    NSString * attrFiled = @"mAttribute";
    NSString * valField = @"mValue";
    NSArray * entities = mManagedObjectModel.entities;
    
    BOOL isFound = NO; //check whether found the entity with attrField and valField
    for (NSEntityDescription * ed in entities )
    {
        if([entityName isEqual:ed.name])
        {
            isFound = YES;
            NSDictionary * dict = ed.attributesByName;
//            NSObject * attrObj = [dict objectForKey:attrFiled];
//            NSObject * valObj = [dict objectForKey:valField];
            NSValue * attrObj = [dict valueForKey:attrFiled];
            NSValue * valObj = [dict valueForKey:valField];
            
            if(attrObj!= nil && valObj != nil)
            {
                //NSLog(@"there are attrField and valField in this entity");
                isFound = YES;
            }
            else {
                isFound = NO;
            }
            //NSLog(@"dict = %@", dict);
            break;
        }
    }
    if(isFound == NO) return nil;
    
    NSMutableArray * array = [self readItems:entityName];
    if(array != nil && [array count]>1)
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
        int idx;
        for(idx = 0; idx < [array count]; idx++) {
            NSManagedObject *obj = [array objectAtIndex:idx];
            NSString *attrStr = (NSString*)[obj valueForKey:@"mAttribute"];
            NSString *valStr = (NSString*)[obj valueForKey:@"mValue"];
            //[dict setObject:valStr forKey:attrStr];
            [dict setValue:valStr forKey:attrStr];
        }
        return dict;
    }
    else
    {
        return nil;
    }
    return nil;
}

-(BOOL) writeSettingDict:(NSString*) entityName withDict:(NSDictionary*)dict
{
 
    if(dict == nil || [dict count]==0) return NO;
    
    //    NSLog(@"readSettingDict");
    NSString * attrFiled = @"mAttribute";
    NSString * valField = @"mValue";
    NSArray * entities = mManagedObjectModel.entities;
    
    BOOL isFound = NO; //check whether found the entity with attrField and valField
    for (NSEntityDescription * ed in entities )
    {
        if([entityName isEqual:ed.name])
        {
            isFound = YES;
            NSDictionary * dict = ed.attributesByName;
//            NSObject * attrObj = [dict objectForKey:attrFiled];
//            NSObject * valObj = [dict objectForKey:valField];
            NSValue * attrObj = [dict valueForKey:attrFiled];
            NSValue * valObj = [dict valueForKey:valField];
            
            if(attrObj!= nil && valObj != nil)
            {
                //                NSLog(@"there are attrField and valField in this entity");
                isFound = YES;
            }
            else
            {
                isFound = NO;
            }
            //NSLog(@"dict = %@", dict);
            break;
        }
    }
    
    if(isFound == NO) return NO;
    
    [self deleteAllItemsAndSave:entityName];
    for ( NSString * key in [dict allKeys])
    {
//        NSString * val = [dict objectForKey:key];
        NSString * val = [dict valueForKey:key];
        if(val!= nil && key != nil) {
            EditItemCallback callback = ^(NSManagedObject *item) {
                [item setValue:key forKey:attrFiled];
                [item setValue:val forKey:valField];
                
            };
            [self addItem:entityName withBlock:callback];
        }
    }
    [self saveAll];
    return YES;
}




-(BOOL) isEntityExist:(NSString*)entityName 
{
    
    NSArray * entities = mManagedObjectModel.entities;
    BOOL isFound = NO;
    for (NSEntityDescription * ed in entities )
    {
        if([entityName isEqual:ed.name]) {
            isFound = YES;
            break;
        }
    }
    return isFound;
    
}


-(void) saveAll {
@synchronized(self) {
    NSError *error = nil;
    @synchronized(mContext) {
        [mContext lock];
        if(![mContext save:&error]) {
            NSLog(@"save error with desc= %@", [error description]);
        }
        [mContext unlock];
        
    }
}
}

-(void) showEntityItems:(NSString*) entityName withBlock:(ShowItemCallback)showCallback {
    @synchronized(self) {
        
    if(entityName == nil) {
        NSLog(@"there is no entity name parameter for showEntityItems func");
        return;
    }
    
    if(showCallback == nil) {
        NSLog(@"there is no showCallback parameter for showEntityItems func");
        return;
    }
    
    if(![self isEntityExist:entityName]) {
        NSLog(@"there is no entity=%@ in  managed object model",entityName);
        return;
    }    
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity;
        @synchronized (mContext){
            [mContext lock];
    entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
            [mContext unlock];
        }
    [request setEntity:entity];
    
    NSError * error = nil;
    NSMutableArray * items;
    NSArray * tmpItems;
    @synchronized (mContext) {
        [mContext lock];
        tmpItems = [mContext executeFetchRequest:request error:&error];
        [mContext unlock];
    }
    @synchronized (tmpItems) {
        items = [tmpItems mutableCopy];
    }
        
    if(items == nil) {
        NSLog(@"items is nil");
    }
    else 
    {
        NSLog(@"entity=%@ items is not nil with count = %d", entityName, [items count]);
        int idx;
        for(idx = 0; idx < [items count] ; idx++) 
        {
            NSManagedObject * item = (NSManagedObject*)[items objectAtIndex:idx];
            showCallback(idx,item);
        }
    }
        
    }
}


-(NSManagedObject*) readItem:(NSString*)entityName withIdx:(int)idx 
{

    NSMutableArray * items = [self readItems:entityName];
    if(items != nil && idx < [items count])
    {
@synchronized(self) {
        NSManagedObject * obj = [items objectAtIndex:idx];
        return obj;
}
    }
    return nil;

}

//static BOOL IS_READ_ITEMS = NO;
-(NSMutableArray*) readItems:(NSString*)entityName
{
    @synchronized(self) {
        

//    if(IS_READ_ITEMS == YES) {
//        return nil;
//    }
//    IS_READ_ITEMS = YES;
    if(entityName == nil) {
        NSLog(@"there is no entity name parameter for showEntityItems func");
//            IS_READ_ITEMS = NO;
        return nil;
    }
    if(![self isEntityExist:entityName]) {
        NSLog(@"there is no entity=%@ in  managed object model",entityName);
//            IS_READ_ITEMS = NO;
        return nil;
    }    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
    NSEntityDescription * entity;
    @synchronized (mContext) {
        [mContext lock];
        entity= [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
        [mContext unlock];
    }
        
    [request setEntity:entity];
    
    NSError * error = nil;

    //NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    NSArray * tmpItems;
    NSMutableArray * items;
    @synchronized (mContext) {
        @synchronized(tmpItems) {
            [mContext lock];
            tmpItems = [mContext executeFetchRequest:request error:&error];
            items = [tmpItems mutableCopy];
            [mContext unlock];
        }
    }

//    mTmpItems = [mContext executeFetchRequest:request error:&error];
//    if(error != nil ) {
//        NSLog(@"executeFetchRequest error");
////        IS_READ_ITEMS = NO;
//        return nil;
//    }
//    if(mTmpItems == nil) return nil ;
//    
//    NSMutableArray * items = [mTmpItems mutableCopy];
    
    if(items == nil)
    {
        NSLog(@"items is nil");
    }
//        IS_READ_ITEMS = NO;
    return items;
        
    }
}



-(BOOL)addItem:(NSString*) entityName withBlock:(EditItemCallback)editCallback 
{
    if(editCallback == nil || entityName == nil) return NO;
    if(![self isEntityExist:entityName]) return NO;
@synchronized(self) {
    NSManagedObject * entity;
    @synchronized (mContext) {
        [mContext lock];
        entity = (NSManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:mContext];
        [mContext unlock];
    }
    @synchronized (entity) {
        editCallback(entity);
    }
}
    return YES;
}

-(BOOL)editItem:(NSString*) entityName withIdx:(int)idx withBlock:(EditItemCallback)editCallback {
    //after edit item, and order in the items will be got randomly.
    NSMutableArray * items = [self readItems:entityName];
    if(items != nil && idx < [items count])
    {

@synchronized (self ) {
        NSManagedObject * obj = [items objectAtIndex:idx];
        editCallback(obj);
        return YES;
}
    }
    return NO;
}

-(BOOL)deleteItem:(NSString*) entityName withIdx:(int)idx {
    NSMutableArray * items = [self readItems:entityName];
    
    if(items != nil && idx < [items count]) 
    {
@synchronized(self) {
        NSManagedObject * obj = [items objectAtIndex:idx];
        @synchronized (mContext){
            @synchronized (obj) {
                [mContext lock];
            [mContext deleteObject:obj];
                [mContext unlock];
            }
        }
        return YES;
}
    }
    return NO;
}




-(void) initCoreData 
{
    NSLog(@"initCoreData be invoked");
    //    mFetchedResultsController.delegate = self;
    NSError *error;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/CoreDataHelper.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    mManagedObjectModel = managedObjectModel; //add by milo
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];


    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) {
        NSLog(@"Error: %@", [error localizedFailureReason]);
    }
    else 
    {    
        mContext = [[NSManagedObjectContext alloc] init];
        [mContext setPersistentStoreCoordinator:persistentStoreCoordinator];
        
    }    
}


-(BOOL)addItemAndSave:(NSString*) entityName withBlock:(EditItemCallback)editCallback 
{    
    BOOL isWell= NO;
    isWell = [self addItem:entityName withBlock:editCallback];
    if(YES == isWell) 
    {
        //after addItem, the order for items is random to sort
        //so this is why wee need call addItemAndSave
        [self saveAll];
    }
    return isWell;
}

-(BOOL)editItemAndSave:(NSString*) entityName withIdx:(int)idx withBlock:(EditItemCallback)editCallback 
{
    BOOL isWell = [self editItem:entityName withIdx:idx withBlock:editCallback];
    if(!isWell) 
    {
        NSLog(@"edit %@[%d] error", entityName,idx);
        return NO;
    }
    else 
    {
        [self saveAll];
        return YES;
    }
    
}

-(BOOL)deleteItemAndSave:(NSString*) entityName withIdx:(int)idx {
    BOOL isWell = [self deleteItem:entityName withIdx:idx];
    if(YES == isWell) 
    {
        [self saveAll];
    }
    else 
    {
        NSLog(@"delete %@[%d] failed", entityName,idx);
    }
    return isWell;
}


-(BOOL)deleteAllItemsAndSave:(NSString*) entityName
{
    
//    if(![self isEntityExist:entityName]) return NO;
    NSMutableArray * items = [self readItems:entityName];
    if(items == nil) return NO;
    if([items count] == 0) return NO;
    int count = [items count];
    int idx;
    for ( idx = 0; idx < count; idx++ ) 
    {
        [self deleteItem:entityName withIdx:0];
    }

    
    [self saveAll];
    return YES;
}

@end



