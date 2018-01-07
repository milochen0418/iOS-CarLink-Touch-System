//
//  ViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBoxDelegate.h"
#import "RouteSettingObj.h"

@class ComboBox;

@class CoreDataHelper;
@interface TrafficSettingsViewController:UIViewController<UITextFieldDelegate, ComboBoxDelegate, UITableViewDelegate, UITableViewDataSource>{}

@property (nonatomic,strong) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray * mObjArray; //NSString Array
@property (nonatomic,strong) CoreDataHelper * mCoreDataHelper;

-(IBAction) clickToBack:(id)sender;
-(void) addRouteSettingObj:(RouteSettingObj*)obj;
-(void) editRouteSettingObj:(RouteSettingObj*)obj;
-(void) deleteRouteSettingObj:(RouteSettingObj*)obj;
-(void) replaceConvertedObjArrayToCoreData;
-(void) replaceCoreDataToObjArray;


//@property (nonatomic,strong) NSMutableArray * mCellDataObjs;
//mCellDataObjs is the same to mObjArray
//@property (nonatomic,strong) IBOutlet UITableView * mTableView;
-(IBAction) clickToCheck:(id)sender;

@end
