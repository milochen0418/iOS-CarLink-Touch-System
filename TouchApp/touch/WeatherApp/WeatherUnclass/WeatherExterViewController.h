//
//  WeatherExterViewController.h
//  touch
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalVars.h"
#import "RosenWeatherDom.h"
#import "XOAPWhereDom.h"
#import "ParseHelper.h"


@interface WeatherExterViewController : UIViewController <NSURLConnectionDelegate,NSXMLParserDelegate>{
    UILabel * mUrlLbl;

    UILabel * mWindDescriptionLbl;
    UILabel * mSunDescriptionLbl;

    UIImageView * mTodayImgView;
    
    UILabel * mD1WDLbl;
    UILabel * mD1HiLbl;
    UILabel * mD1LoLbl;
    UIImageView * mD1IconImgView;
    
    UILabel * mD2WDLbl;
    UILabel * mD2HiLbl;
    UILabel * mD2LoLbl;
    UIImageView * mD2IconImgView;

    UILabel * mD3WDLbl;
    UILabel * mD3HiLbl;
    UILabel * mD3LoLbl;
    UIImageView * mD3IconImgView;
    
    UILabel * mD4WDLbl;
    UILabel * mD4HiLbl;
    UILabel * mD4LoLbl;
    UIImageView * mD4IconImgView;

    UILabel * mD5WDLbl;
    UILabel * mD5HiLbl;
    UILabel * mD5LoLbl;
    UIImageView * mD5IconImgView;
    
    UILabel * mWeatherCity;
    UILabel * mCurTmpLbl;
    UILabel * mWeatherTextLbl;
    UILabel * mCurHiLoLbl;
    UILabel * mHmidAndPpcpLbl;

    UILabel * mHmidLbl;
    UILabel * mPpcpLbl;
    UILabel * mCurHiLbl;
    UILabel * mCurLoLbl;
    
    
}
@property (nonatomic,strong) ParseHelper * mParseHelper;
@property (nonatomic,strong) IBOutlet UILabel * mCurHiLbl;
@property (nonatomic,strong) IBOutlet UILabel * mCurLoLbl;

@property (nonatomic,strong) IBOutlet UILabel * mHmidLbl;
@property (nonatomic,strong) IBOutlet UILabel * mPpcpLbl;

-(void) refreshWeatherGui;

#define PARSE_XOAP_WHERE_DOM 1
#define PARSE_ROSEN_WEATHER_DOM 2
@property (nonatomic) int mParsingAction;
@property (nonatomic,strong) NSString * mLocId;
@property (nonatomic,strong) RosenWeatherDom * mRosenWeatherDom;
@property (nonatomic,strong) NSString * mRosenWeatherURL;
-(void)writeSettings;
-(void)readSettings;
@property (nonatomic,strong) NSString * mCurCityName;
@property (nonatomic) BOOL mIsSelectC;

@property (nonatomic,strong) NSURLConnection *mConnection;
@property (nonatomic,strong) NSMutableData *mTempDownloadData;
@property (nonatomic) int mExpectedLength;
@property (nonatomic,strong) NSString * mWeatherURL;
@property (nonatomic,strong) NSXMLParser * mParser;        
@property (nonatomic,strong) XOAPWhereDom * mXOAPWhereDom;

@property (nonatomic,strong) IBOutlet UILabel * mCityLbl;




-(IBAction)clickToBack:(id)sender;
@property (nonatomic,strong) IBOutlet UILabel * mWeatherCity;
@property (nonatomic,strong) IBOutlet UILabel * mCurTmpLbl;
@property (nonatomic,strong) IBOutlet UILabel * mWeatherTextLbl;
@property (nonatomic,strong) IBOutlet UILabel * mCurHiLoLbl;
@property (nonatomic,strong) IBOutlet UILabel * mHmidAndPpcpLbl;

@property (nonatomic,strong) IBOutlet UILabel * mUrlLbl; 


@property (nonatomic,strong) IBOutlet UILabel * mWindDescriptionLbl;
@property (nonatomic,strong) IBOutlet UILabel * mSunDescriptionLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mTodayImgView;

@property (nonatomic,strong) IBOutlet UILabel * mD1WDLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD1HiLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD1LoLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mD1IconImgView;

@property (nonatomic,strong) IBOutlet UILabel * mD2WDLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD2HiLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD2LoLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mD2IconImgView;

@property (nonatomic,strong) IBOutlet UILabel * mD3WDLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD3HiLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD3LoLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mD3IconImgView;

@property (nonatomic,strong) IBOutlet UILabel * mD4WDLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD4HiLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD4LoLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mD4IconImgView;

@property (nonatomic,strong) IBOutlet UILabel * mD5WDLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD5HiLbl;
@property (nonatomic,strong) IBOutlet UILabel * mD5LoLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mD5IconImgView;

@property (nonatomic) BOOL mHasInit;
-(IBAction) oneHourToRefreshWeather:(id)sender;

-(void) checkToDataReset;
-(void) recoverWeatherObjsFromCoreData;
-(void) backupWeatherObjsToCoreData;
@property (nonatomic) BOOL mIsCoreDataUsed;
@property (nonatomic,strong) NSMutableArray * mWeatherObjs;
@property (nonatomic) BOOL mIsNeedToResetWeatherData;

-(IBAction)clickToPrevWeatherItem:(id)sender;
-(IBAction)clickToNextWeatherItem:(id)sender;


@property (nonatomic,strong) IBOutlet UILabel * mPageLbl;

@end
