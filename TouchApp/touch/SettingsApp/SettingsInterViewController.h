//
//  ViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XOAPWhereDom.h"
#import "RosenWeatherDom.h"


@class ActionTable;
@interface SettingsInterViewController:UIViewController
{
    UILabel *mRosenLbl;
    UITextView * mDbgTextView;    
    UITableView * mTableView;
    ActionTable * mActTbl;
    BOOL mDontLeaveExternalView;
}
@property (nonatomic) BOOL mDontLeaveExternalView;

-(IBAction)clickTableCell:(id)sender; 
@property (nonatomic,strong) ActionTable * mActTbl;
@property (nonatomic,strong) IBOutlet UITableView * mTableView;

-(IBAction) clickToSetWeather:(id)sender;
-(IBAction) clickToSetSpeedCamera:(id)sender;
-(IBAction) clickToSetMedia:(id)sender;
-(IBAction) clickToSetTraffic:(id)sender;
@property (nonatomic,strong) IBOutlet UILabel *mRosenLbl;
-(IBAction) clickToBack:(id)sender;
@property (nonatomic,strong) IBOutlet UITextView * mDbgTextView;


@end
