//
//  RouteSettingViewController.h
//  touch
//
//  Created by Milo Chen on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBox.h"
#import "ComboBoxDelegate.h"
#import "TrafficSettingsViewController.h"

#import "ParseHelper.h"
#import "CoreDataHelper.h"

@interface RouteSettingViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIActionSheetDelegate,ComboBoxDelegate,UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{}

@property (nonatomic,strong) IBOutlet UIButton * mMonBtn;
@property (nonatomic,strong) IBOutlet UIButton * mTueBtn;
@property (nonatomic,strong) IBOutlet UIButton * mWedBtn;
@property (nonatomic,strong) IBOutlet UIButton * mThuBtn;
@property (nonatomic,strong) IBOutlet UIButton * mFriBtn;
@property (nonatomic,strong) IBOutlet UIButton * mSatBtn;
@property (nonatomic,strong) IBOutlet UIButton * mSunBtn;

@property (nonatomic,strong) IBOutlet UITextField * mNameField;
@property (nonatomic,strong) IBOutlet UITextField * mFromWhereField;
@property (nonatomic,strong) IBOutlet UITextField * mToWhereField;


@property (nonatomic,strong) IBOutlet UITextField * mStartTimeField;
@property (nonatomic,strong) IBOutlet UITextField * mEndTimeField;

@property (nonatomic) bool mIsOnCreate; 
-(IBAction) clickToToggle:(id)sender;

-(IBAction)clickToSave:(id)sender;
-(IBAction)clickToDelete:(id)sender;

@property (nonatomic,strong) RouteSettingObj * mObj;
- (IBAction)textFieldDidBeginEditing:(UITextField *)aTextField;
@property (nonatomic,strong) UIActionSheet * pickerViewPopup;
@property (nonatomic,strong) UIDatePicker * pickerView;
@property (nonatomic,strong) UITextField * mFocusTextField;


@property (nonatomic,strong) IBOutlet UITextField * mFromSearchField;
@property (nonatomic,strong) IBOutlet UIButton * mFromSearchBtn;
@property (nonatomic,strong) ComboBox * mFromCityComboBox;
@property (nonatomic,strong) IBOutlet UIView * mFromCityComboBoxView;
@property (nonatomic,strong) NSMutableArray * mFromXoapObjArray;
-(IBAction)clickToFromSearch:(id)sender;

@property (nonatomic,strong) IBOutlet UITextField * mToSearchField;
@property (nonatomic,strong) IBOutlet UIButton * mToSearchBtn;
@property (nonatomic,strong) ComboBox * mToCityComboBox;
@property (nonatomic,strong) IBOutlet UIView * mToCityComboBoxView;
@property (nonatomic,strong) NSMutableArray * mToXoapObjArray;
-(IBAction)clickToToSearch:(id)sender;

@property (nonatomic,strong) ParseHelper * mParseHelper;
@property (nonatomic,strong) CoreDataHelper * mCoreDataHelper;


@property (nonatomic, strong) NSMutableArray *mFilteredListContent;
@property (nonatomic, strong) UISearchDisplayController	*mSearchDisplayController;
@property (nonatomic, strong) UISearchBar * mSearchBar;

-(IBAction) clickToInputTextField:(id)sender;
@property (nonatomic,strong) UITextField * mTmpTextField;

@end
