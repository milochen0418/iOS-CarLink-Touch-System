//
//  ViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalVars.h"

#import "XOAPWhereDom.h"
#import "RosenWeatherDom.h"
#import "ComboBoxDelegate.h"
#import "ParseHelper.h"
#import "WeatherObj.h"

@class ComboBox;

@interface WeatherSettingsViewController:UIViewController<UITextFieldDelegate,NSURLConnectionDelegate,NSXMLParserDelegate, ComboBoxDelegate,
UIActionSheetDelegate,UISearchDisplayDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

{
    ComboBox * mCityComboBox;
    UIView * mCityComboBoxView;

    UITextField * mSearchField;
    UIButton * mSearchBtn;
    UITableView * mSelectedTableView;
    
    
    NSURLConnection *mConnection;    
    NSMutableData *mTempDownloadData;
    int mExpectedLength;
    NSString * mWeatherURL; // a url for query weather.com to get weather id
    NSString * mRosenWeatherURL; //a url for query weather status from rosenapp
    
    NSXMLParser * mParser;        
    XOAPWhereDom * mXOAPWhereDom;
    RosenWeatherDom * mRosenWeatherDom;
    
    
    NSString * mQueryWeatherId;
    UILabel * mLocIdLbl;
    
    int mParsingAction;
    
    
    UILabel * mSelectedCity;
    
    UISegmentedControl * mFCSegCtrl;
    UITextView * mDbgTextView;
    bool mIsSelectC;     
    NSString * mCurCityName;
    NSString * mLocId;
    
    UILabel *mReceivedURL;
    
    
}





@property (nonatomic,strong) ParseHelper *mParseHelper;
//-(NSDictionary*) getSettingsDict; 
//-(void) setSettingsDict:(NSDictionary*)settingsDict; 

@property (nonatomic,strong) ComboBox * mCityComboBox;
@property (nonatomic,strong) IBOutlet UIView * mCityComboBoxView;




-(IBAction) clickToBack:(id)sender;
@property (nonatomic,strong) IBOutlet UILabel *mReceivedURL;

-(void)writeSettings;
-(void)readSettings;



@property (nonatomic,strong) NSString * mCurCityName;
@property (nonatomic,strong) IBOutlet UITextView * mDbgTextView;
-(IBAction)clickToSelFC:(id)sender;
@property (nonatomic,strong) IBOutlet UISegmentedControl * mFCSegCtrl;



@property (nonatomic,strong) IBOutlet UIButton * mQueryWeatherBtn;
@property (nonatomic,strong) IBOutlet UILabel * mSelectedCity;

@property (nonatomic) bool mIsSelectC;

-(void) refreshWeatherGui;

#define PARSE_XOAP_WHERE_DOM 1
#define PARSE_ROSEN_WEATHER_DOM 2
@property (nonatomic) int mParsingAction;
@property (nonatomic,strong) NSString * mLocId;
@property (nonatomic,strong) RosenWeatherDom * mRosenWeatherDom;
@property (nonatomic,strong) NSString * mRosenWeatherURL;
@property (nonatomic,strong) IBOutlet UILabel * mLocIdLbl;
@property (nonatomic,strong) IBOutlet UITableView * mSelectedTableView;
@property (nonatomic,strong) IBOutlet UIButton * mSearchBtn; 
@property (nonatomic,strong) IBOutlet UITextField * mSearchField;


@property (nonatomic,strong) NSURLConnection *mConnection;
@property (nonatomic,strong) NSMutableData *mTempDownloadData;
@property (nonatomic) int mExpectedLength;
@property (nonatomic,strong) NSString * mWeatherURL;
@property (nonatomic,strong) NSXMLParser * mParser;        
@property (nonatomic,strong) XOAPWhereDom * mXOAPWhereDom;

-(void) refreshData;
-(IBAction)clickToSearch:(id)sender;
-(void) getRosenWeather ;


@property (nonatomic) BOOL mIsOnCreate;
@property (nonatomic,strong) WeatherObj *mObj;
-(IBAction)clickToSave:(id)sender;
-(IBAction)clickToDelete:(id)sender;


@property (nonatomic, strong) NSMutableArray *mFilteredListContent;
@property (nonatomic, strong) UISearchDisplayController	*mSearchDisplayController;
@property (nonatomic, strong) UISearchBar * mSearchBar;
-(IBAction) clickToInputTextField:(id)sender;
@property (nonatomic,strong) UITextField * mTmpTextField;

@end
