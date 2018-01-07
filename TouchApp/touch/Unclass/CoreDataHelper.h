//
//  CoreDataHelper.h
//  helloworld.testCoreData
//
//  Created by Milo Chen on 10/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataHelper : NSObject {}

+(CoreDataHelper*) sharedInstance ;

typedef void (^ShowItemCallback)(int itemIdx, NSManagedObject *obj);
typedef void (^EditItemCallback)(NSManagedObject *obj);
@property (nonatomic,strong) NSManagedObjectContext *mContext;
@property (nonatomic,strong) NSManagedObjectModel * mManagedObjectModel;
//@property (atomic,strong) NSManagedObjectContext *mContext;
//@property (atomic,strong) NSManagedObjectModel * mManagedObjectModel;

-(BOOL) isEntityExist:(NSString*)entityName;
-(void) saveAll;
-(void)showEntityItems:(NSString*) entityName withBlock:(ShowItemCallback)showCallback;
-(NSMutableArray*) readItems:(NSString*)entityName;
-(NSManagedObject*) readItem:(NSString*)entityName withIdx:(int)idx;
-(BOOL)addItem:(NSString*) entityName withBlock:(EditItemCallback)editCallback;
-(BOOL)editItem:(NSString*) entityName withIdx:(int)idx withBlock:(EditItemCallback)editCallback;
-(BOOL)deleteItem:(NSString*) entityName withIdx:(int)idx;

-(BOOL)addItemAndSave:(NSString*) entityName withBlock:(EditItemCallback)editCallback;
-(BOOL)editItemAndSave:(NSString*) entityName withIdx:(int)idx withBlock:(EditItemCallback)editCallback;
-(BOOL)deleteItemAndSave:(NSString*) entityName withIdx:(int)idx;

-(BOOL)deleteAllItemsAndSave:(NSString*) entityName;



-(BOOL) writeSettingDict:(NSString*) entityName withDict:(NSDictionary*)dict;
-(NSMutableDictionary*) readSettingDict:(NSString*) entityName;

@property (nonatomic,strong) NSArray * mTmpItems;



@end



