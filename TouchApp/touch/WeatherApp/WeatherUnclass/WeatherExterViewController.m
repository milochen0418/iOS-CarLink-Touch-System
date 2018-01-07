//
//  ExterViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeatherExterViewController.h"
#import "GlobalVars.h"
#import "WeatherObj.h"
#import "WeatherEntity.h"
#import "SettingsManager.h"

@implementation WeatherExterViewController
@synthesize mUrlLbl;
@synthesize mD1HiLbl,mD1LoLbl,mD1WDLbl,mD2HiLbl,mD2LoLbl,mD2WDLbl,mD3HiLbl,mD3LoLbl,mD3WDLbl,mD4HiLbl,mD4LoLbl,mD4WDLbl,mD5HiLbl,mD5LoLbl,mD5WDLbl,mTodayImgView,mD1IconImgView,mD2IconImgView,mD3IconImgView,mD4IconImgView,mD5IconImgView,mSunDescriptionLbl,mWindDescriptionLbl;
@synthesize mWeatherTextLbl,mHmidAndPpcpLbl,mWeatherCity,mCurHiLoLbl,mCurTmpLbl;


@synthesize mLocId,mIsSelectC,mCurCityName,mParsingAction,mRosenWeatherDom,mRosenWeatherURL;
@synthesize mParser,mConnection,mWeatherURL,mXOAPWhereDom,mExpectedLength,mTempDownloadData;
@synthesize mHmidLbl,mPpcpLbl;
@synthesize mCurHiLbl,mCurLoLbl;
@synthesize mCityLbl;
@synthesize mParseHelper;

@synthesize mIsCoreDataUsed;
@synthesize mWeatherObjs;
@synthesize mIsNeedToResetWeatherData;



@synthesize mHasInit;

@synthesize mPageLbl;

-(IBAction)clickToBack:(id)sender {
    NSLogOut("clickToBack is trigger by WeatherExterViewController");
    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.mAppDelegate notifyExterNavAnimatedStatus:YES];
    [vars.interNav popViewControllerAnimated:YES];
    [vars.exterNav popExterViewControllerAnimated:YES];
//    [vars.interNav popViewControllerAnimated:NO];
//    [vars.exterNav popViewControllerAnimated:NO];
}

-(WeatherExterViewController*) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    if(mXOAPWhereDom != nil) mXOAPWhereDom = nil;
//    mXOAPWhereDom = [[XOAPWhereDom alloc]init];
//    if(mRosenWeatherDom != nil) mRosenWeatherDom = nil;
//    mRosenWeatherDom = [[RosenWeatherDom alloc] init];
//    [self readSettings];
//    [self getRosenWeather];

    self.mUrlLbl.hidden = YES;
    
    [self cleanWeatherGui];
    [self initAndRefreshPage];
    
    [self performSelector:@selector(oneHourToRefreshWeather:) withObject:nil afterDelay:3600];
    
    self.mIsNeedToResetWeatherData = YES;
    
//    mPageLbl.text = @"";
    
}




-(IBAction) oneHourToRefreshWeather:(id)sender  {
//    [self readWeatherSettingsAndShow];
//    [self performSelector:@selector(oneHourToRefreshWeather:) withObject:nil afterDelay:3600];
    [self initAndRefreshPage];
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mEVC.mIsInitWeatherWidget = NO;
    //predict mEVC viewDidAppear will check mIsInitWeatherWidget and call function to refresh
    
    [self performSelector:@selector(oneHourToRefreshWeather:) withObject:nil afterDelay:3600];
}






- (void)viewDidAppear:(BOOL)animated {
//    [self initAndRefreshPage];
    [self checkToDataReset];
}


- (void) initAndRefreshPageInQueue {
    NSLog(@"initAndRefreshPageInQueue");
    if(mParseHelper == nil ) mParseHelper = [[ParseHelper alloc] init];
    
    NSString * getXoapLocId;
    NSString * getXoapLocCityName;
    bool getIsSelectedC;
    
    SettingsManager *mgr = [SettingsManager sharedInstance];
    WeatherSettingManager * wMgr = mgr.mWeatherSettingManager;
    
    getIsSelectedC = wMgr.mIsSelectC;
    getXoapLocId = wMgr.mLocId;
    getXoapLocCityName = wMgr.mCurCityName;
    
    
    self.mIsSelectC = getIsSelectedC;
    self.mLocId = getXoapLocId;
    self.mCurCityName = getXoapLocCityName;
    
    WeatherObj * wObj;
//    int itemsCount = wMgr.mItemsCount;
    
    if(wMgr.mItemsCount <= 0)
//    if(itemsCount <= 0)
    {
        wMgr.mSelectedItemIdx = -1;
        wObj = [[WeatherObj alloc]init];
        wObj.mIsSelectC = [NSString stringWithFormat:@"%d",(int)self.mIsSelectC];
        wObj.mLocId = self.mLocId;
        wObj.mCurCityName = self.mCurCityName;
        wObj.mTimeInterval = 0;
        dispatch_async(dispatch_get_main_queue(),^{
            mPageLbl.text = @"";
        });
    }
    else
    {
        if(wMgr.mSelectedItemIdx >= wMgr.mItemsCount) wMgr.mSelectedItemIdx = wMgr.mItemsCount - 1;
        dispatch_async(dispatch_get_main_queue(),^{
            mPageLbl.text = [NSString stringWithFormat:@"%d / %d",wMgr.mSelectedItemIdx+1,wMgr.mItemsCount];
        });
        
        if(self.mWeatherObjs == nil) {
            [self recoverWeatherObjsFromCoreData];
        }
        if(self.mWeatherObjs != nil) {
            wObj = [self.mWeatherObjs objectAtIndex:wMgr.mSelectedItemIdx];
            self.mIsSelectC = (BOOL)[wObj.mIsSelectC intValue];
            self.mLocId = wObj.mLocId;
            self.mCurCityName = wObj.mCurCityName;
            wMgr.mIsSelectC = (BOOL)[wObj.mIsSelectC intValue];
            wMgr.mLocId = wObj.mLocId;
            wMgr.mCurCityName = wObj.mCurCityName;
        }
        else {
            NSLog(@"mWeatherObjs still nil when initAndRefreshPageInQueue");
        }
    }
    [self loadDataForWeatherObj:wObj andRefreshGui:YES andSaveItemInCoreData:NO];
    
    return;
    
}



//-(void)loadDataForWeatherObjAndRefreshGui:(WeatherObj*)obj

-(void) loadDataForWeatherObj:(WeatherObj*)obj andRefreshGui:(BOOL)isRefreshGui andSaveItemInCoreData:(BOOL)isSaveItemInCoreData
{

    WeatherObj * wObj = obj;
    if(wObj == nil || wObj.mCurCityName == nil ) {
        NSLog(@"[failed]WeatherExterViewController loadDataForWeatherObj");
        return;
    }    
    
    NSString * newLocId = wObj.mCurCityName;
    newLocId = [mParseHelper extractValueByPattern:@"(.*?,.*?)(\\(|$)" inTxtStr:newLocId];
    newLocId = [newLocId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:newLocId];
    newLocId = encodedNewLocId;
    
    NSString * metric = @"1";
    BOOL bIsSelectC = NO;
    if(wObj.mIsSelectC != nil) bIsSelectC = (BOOL)[wObj.mIsSelectC intValue];
    if( bIsSelectC) metric = @"0";

    NSString * rosenWeatherURL = [NSString stringWithFormat:@"http://rosenapp.com/api.class?action=weather&loc_id=%@&metric=%@", newLocId, metric];
    NSLog(@"rosenWeatherURL = %@", rosenWeatherURL);
    
    
    int idx = [SettingsManager sharedInstance].mWeatherSettingManager.mSelectedItemIdx;
    
    
    EditItemCallback callback = ^(NSManagedObject *theItem)
    {
        WeatherEntity * item = (WeatherEntity*) theItem;
        [WeatherObj copyValuesFromRunningDataOnObj:obj ToEntity:item];
        [WeatherObj copyValuesFromSettingDataOnObj:obj ToEntity:item];
        item.mId = [NSNumber numberWithInt:idx];        
    };

    
    
    __block NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSString *xmlStrTmp = [mParseHelper getXmlStringFromUrlStr:rosenWeatherURL];
        NSString *xmlStr = [mParseHelper stringByRemovingNewLinesAndWhitespace:xmlStrTmp];
        NSString * nowStr = [mParseHelper extractValueBetweenBeginStr:@"<now " andEndStr:@"/>" inTxtStr:xmlStr];
        NSString * d1Str = [mParseHelper extractValueBetweenBeginStr:@"<d1 " andEndStr:@"/>" inTxtStr:xmlStr];
        NSString * d2Str = [mParseHelper extractValueBetweenBeginStr:@"<d2 " andEndStr:@"/>" inTxtStr:xmlStr];
        NSString * d3Str = [mParseHelper extractValueBetweenBeginStr:@"<d3 " andEndStr:@"/>" inTxtStr:xmlStr];
        NSString * d4Str = [mParseHelper extractValueBetweenBeginStr:@"<d4 " andEndStr:@"/>" inTxtStr:xmlStr];
        NSString * d5Str = [mParseHelper extractValueBetweenBeginStr:@"<d5 " andEndStr:@"/>" inTxtStr:xmlStr];
        
        NSString * curTmp = [mParseHelper extractValueBetweenBeginStr:@"tmp=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * lowTmp = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * highTmp = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * iconNum = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * textStr = [mParseHelper extractValueBetweenBeginStr:@"text=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * hmidStr = [mParseHelper extractValueBetweenBeginStr:@"hmid=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * sunrStr = [mParseHelper extractValueBetweenBeginStr:@"sunr=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * sunsStr = [mParseHelper extractValueBetweenBeginStr:@"suns=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * windsStr = [mParseHelper extractValueBetweenBeginStr:@"winds=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * winddStr = [mParseHelper extractValueBetweenBeginStr:@"windd=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString * windtStr = [mParseHelper extractValueBetweenBeginStr:@"windt=\"" andEndStr:@"\"" inTxtStr:nowStr];
        NSString *ppcpStr = [mParseHelper extractValueBetweenBeginStr:@"ppcp=\"" andEndStr:@"\"" inTxtStr:nowStr];
        
        
        NSString * d1tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d1Str];
        NSString * d1hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d1Str];
        NSString * d1loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d1Str];
        NSString * d1iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d1Str];
        
        NSString * d2tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d2Str];
        NSString * d2hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d2Str];
        NSString * d2loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d2Str];
        NSString * d2iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d2Str];
        
        NSString * d3tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d3Str];
        NSString * d3hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d3Str];
        NSString * d3loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d3Str];
        NSString * d3iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d3Str];
        
        NSString * d4tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d4Str];
        NSString * d4hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d4Str];
        NSString * d4loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d4Str];
        NSString * d4iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d4Str];
        
        NSString * d5tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d5Str];
        NSString * d5hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d5Str];
        NSString * d5loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d5Str];
        NSString * d5iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d5Str];
        
        
        wObj.mCurTmp = curTmp;
        wObj.mLowTmp = lowTmp;
        wObj.mHighTmp = highTmp;
        wObj.mIcon = iconNum;
        wObj.mText = textStr;
        wObj.mHumidityTmp = hmidStr;
        wObj.mSunRise = sunrStr;
        wObj.mSunSet = sunsStr;
        wObj.mPrecipitation = ppcpStr;
        
        wObj.mWindSpeed = windsStr;
        wObj.mWindDegree = winddStr;
        wObj.mWindDirection = windtStr;
        
        wObj.m1WeekDay = d1tStr;
        wObj.m1HighTmp = d1hiStr;
        wObj.m1LowTmp = d1loStr;
        wObj.m1Icon = d1iconStr;
        
        wObj.m2WeekDay = d2tStr;
        wObj.m2HighTmp = d2hiStr;
        wObj.m2LowTmp = d2loStr;
        wObj.m2Icon = d2iconStr;
        
        wObj.m3WeekDay = d3tStr;
        wObj.m3HighTmp = d3hiStr;
        wObj.m3LowTmp = d3loStr;
        wObj.m3Icon = d3iconStr;
        
        wObj.m4WeekDay = d4tStr;
        wObj.m4HighTmp = d4hiStr;
        wObj.m4LowTmp = d4loStr;
        wObj.m4Icon = d4iconStr;
        
        wObj.m5WeekDay = d5tStr;
        wObj.m5HighTmp = d5hiStr;
        wObj.m5LowTmp = d5loStr;
        wObj.m5Icon = d5iconStr;

        
        if(isRefreshGui && !isSaveItemInCoreData) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshWeatherObjToGui:wObj];
            });
        }
        
        if(isSaveItemInCoreData) {
            NSString * entityName = @"WeatherEntity";
            CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];
            [theCoreDataHelper editItemAndSave:entityName withIdx:idx withBlock:callback];
            self.mIsNeedToResetWeatherData = YES;
            mIsCoreDataUsed = NO; //because the caller of loadDataForWeatherObj are requestReloadIndexedWeatherObj, the function set mIsCoreDataUsed=YES
            [self checkToDataReset];
        }
    }];
    
    [[NSOperationQueue sharedOperationQueue] addOperation:operation];
    
}



-(void)cleanWeatherGui {
    
    self.mD1WDLbl.text = @"---";
    self.mD2WDLbl.text = @"---";
    self.mD3WDLbl.text = @"---";
    self.mD4WDLbl.text = @"---";
    self.mD5WDLbl.text = @"---";
    self.mD1HiLbl.text = @"--°";
    self.mD2HiLbl.text = @"--°";
    self.mD3HiLbl.text = @"--°";
    self.mD4HiLbl.text = @"--°";
    self.mD5HiLbl.text = @"--°";
    self.mD1LoLbl.text = @"--°";
    self.mD2LoLbl.text = @"--°";
    self.mD3LoLbl.text = @"--°";
    self.mD4LoLbl.text = @"--°";
    self.mD5LoLbl.text = @"--°";
    self.mD1IconImgView.image = [UIImage imageNamed:@"0.png"];
    self.mD2IconImgView.image = [UIImage imageNamed:@"0.png"];
    self.mD3IconImgView.image = [UIImage imageNamed:@"0.png"];
    self.mD4IconImgView.image = [UIImage imageNamed:@"0.png"];
    self.mD5IconImgView.image = [UIImage imageNamed:@"0.png"];
    self.mCurTmpLbl.text = @"--°";
    self.mCurLoLbl.text = @"--°";
    self.mCurHiLbl.text = @"--°";
    self.mHmidLbl.text = @"Humidity: --%% ";
    self.mWindDescriptionLbl.text = @"Wind -- at  --mph";
    self.mPpcpLbl.text = @"Chance of Rain: --%%";
    self.mSunDescriptionLbl.text = @"Sunrise --:-- Sunset --:--";

    self.mCityLbl.text = @"";
    self.mTodayImgView.image = [UIImage imageNamed:@"0.png"];
    
    WeatherSettingManager * wMgr = [SettingsManager sharedInstance].mWeatherSettingManager;
    if(wMgr.mItemsCount <= 0)
    {
        wMgr.mSelectedItemIdx = -1;
        dispatch_async(dispatch_get_main_queue(),^{
            mPageLbl.text = @"";

        });
    }
    else
    {
        if(wMgr.mSelectedItemIdx >= wMgr.mItemsCount) wMgr.mSelectedItemIdx = wMgr.mItemsCount - 1;
        dispatch_async(dispatch_get_main_queue(),^{
            mPageLbl.text = [NSString stringWithFormat:@"%d / %d",wMgr.mSelectedItemIdx+1,wMgr.mItemsCount];
        });
    }
    
}


-(void)refreshWeatherObjToGui:(WeatherObj*)wObj {

    if(wObj == nil) {
        
        [self cleanWeatherGui];
        return;
    }
    
    
    self.mCurCityName = wObj.mCurCityName;
    self.mIsSelectC = (BOOL)[wObj.mIsSelectC intValue];
    self.mLocId = wObj.mLocId;
    
    self.mD1WDLbl.text = wObj.m1WeekDay?wObj.m1WeekDay:@"---";
    self.mD2WDLbl.text = wObj.m2WeekDay?wObj.m2WeekDay:@"---";
    self.mD3WDLbl.text = wObj.m3WeekDay?wObj.m3WeekDay:@"---";
    self.mD4WDLbl.text = wObj.m4WeekDay?wObj.m4WeekDay:@"---";
    self.mD5WDLbl.text = wObj.m5WeekDay?wObj.m5WeekDay:@"---";
    self.mD1HiLbl.text = wObj.m1HighTmp?[NSString stringWithFormat:@"%@°",wObj.m1HighTmp]:@"--°";
    self.mD2HiLbl.text = wObj.m2HighTmp?[NSString stringWithFormat:@"%@°",wObj.m2HighTmp]:@"--°";
    self.mD3HiLbl.text = wObj.m3HighTmp?[NSString stringWithFormat:@"%@°",wObj.m3HighTmp]:@"--°";
    self.mD4HiLbl.text = wObj.m4HighTmp?[NSString stringWithFormat:@"%@°",wObj.m4HighTmp]:@"--°";
    self.mD5HiLbl.text = wObj.m5HighTmp?[NSString stringWithFormat:@"%@°",wObj.m5HighTmp]:@"--°";
    self.mD1LoLbl.text = wObj.m1LowTmp?[NSString stringWithFormat:@"%@°",wObj.m1LowTmp]:@"--°";
    self.mD2LoLbl.text = wObj.m2LowTmp?[NSString stringWithFormat:@"%@°",wObj.m2LowTmp]:@"--°";
    self.mD3LoLbl.text = wObj.m3LowTmp?[NSString stringWithFormat:@"%@°",wObj.m3LowTmp]:@"--°";
    self.mD4LoLbl.text = wObj.m4LowTmp?[NSString stringWithFormat:@"%@°",wObj.m4LowTmp]:@"--°";
    self.mD5LoLbl.text = wObj.m5LowTmp?[NSString stringWithFormat:@"%@°",wObj.m5LowTmp]:@"--°";
    self.mD1IconImgView.image = wObj.m1Icon?[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",wObj.m1Icon]]:[UIImage imageNamed:@"0.png"];
    self.mD2IconImgView.image = wObj.m2Icon?[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",wObj.m2Icon]]:[UIImage imageNamed:@"0.png"];
    self.mD3IconImgView.image = wObj.m3Icon?[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",wObj.m3Icon]]:[UIImage imageNamed:@"0.png"];
    self.mD4IconImgView.image = wObj.m4Icon?[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",wObj.m4Icon]]:[UIImage imageNamed:@"0.png"];
    self.mD5IconImgView.image = wObj.m5Icon?[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",wObj.m5Icon]]:[UIImage imageNamed:@"0.png"];
    

    self.mCurTmpLbl.text = wObj.mCurTmp?[NSString stringWithFormat:@"%@°",wObj.mCurTmp]:@"--°";
    self.mCurLoLbl.text = wObj.mLowTmp?[NSString stringWithFormat:@"%@°",wObj.mLowTmp]:@"--°";
    self.mCurHiLbl.text = wObj.mHighTmp?[NSString stringWithFormat:@"%@°",wObj.mHighTmp]:@"--°";
    
    self.mHmidLbl.text = @"Humidity: --%% ";
    self.mWindDescriptionLbl.text = @"Wind -- at  --mph";
    self.mPpcpLbl.text = @"Chance of Rain: --%%";
    self.mSunDescriptionLbl.text = @"Sunrise --:-- Sunset --:--";
    
    
    
    self.mHmidLbl.text = [NSString stringWithFormat:@"Humidity: %@%% ", wObj.mHumidityTmp?wObj.mHumidityTmp:@"--" ];
    self.mPpcpLbl.text = [NSString stringWithFormat:@"Chance of Rain: %@%%",wObj.mPrecipitation?wObj.mPrecipitation:@"--"];
    self.mWindDescriptionLbl.text = [NSString stringWithFormat:@"Wind %@ %@",wObj.mWindDirection?wObj.mWindDirection:@"-- at ",wObj.mWindSpeed?wObj.mWindSpeed:@""];
    self.mSunDescriptionLbl.text = [NSString stringWithFormat:@"Sunrise %@ Sunset %@", wObj.mSunRise?wObj.mSunRise:@"--:--",wObj.mSunSet?wObj.mSunSet:@"--:--"];
    self.mCurHiLoLbl.text = [NSString stringWithFormat:@"Hi %@°   Lo %@°",wObj.mHighTmp?wObj.mHighTmp:@"--",wObj.mLowTmp?wObj.mLowTmp:@"--"];
    self.mTodayImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",wObj.mIcon?wObj.mIcon:@"0"]];
    self.mWeatherCity.text = self.mCurCityName;
    self.mWeatherTextLbl.text = wObj.mText?wObj.mText:@"";
    
    
    
    
    
    NSString *reducedCityName = self.mCurCityName;
    //reducedCityName's purpose is fit the issue from Kevin's email
    //no need state or country
    NSString * reducedCityNameWithComma = [mParseHelper extractValueByPattern:@"(.+?)," inTxtStr:reducedCityName];
    if(reducedCityNameWithComma != nil && ![reducedCityNameWithComma isEqualToString:@""])
    {
        reducedCityName = reducedCityNameWithComma;
    }
    self.mCityLbl.text = reducedCityName;
    
    
    WeatherSettingManager * wMgr = [SettingsManager sharedInstance].mWeatherSettingManager;
    if(wMgr.mItemsCount <= 0)
        //    if(itemsCount <= 0)
    {
        wMgr.mSelectedItemIdx = -1;
        dispatch_async(dispatch_get_main_queue(),^{
            mPageLbl.text = @"";
        });
    }
    else
    {
        if(wMgr.mSelectedItemIdx >= wMgr.mItemsCount) wMgr.mSelectedItemIdx = wMgr.mItemsCount - 1;
        dispatch_async(dispatch_get_main_queue(),^{
            mPageLbl.text = [NSString stringWithFormat:@"%d / %d",wMgr.mSelectedItemIdx+1,wMgr.mItemsCount];
        });
    }
}


- (void) initAndRefreshPage
{
    __block NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [self readSettings];
        [self initAndRefreshPageInQueue];
    }];
    
    [[NSOperationQueue sharedOperationQueue] addOperation:operation];
    return;
    
//    if(mHasInit == YES) return;
//    mHasInit = YES;
//    if(mXOAPWhereDom != nil) mXOAPWhereDom = nil;
//    mXOAPWhereDom = [[XOAPWhereDom alloc]init];
//    if(mRosenWeatherDom != nil) mRosenWeatherDom = nil;
//    mRosenWeatherDom = [[RosenWeatherDom alloc] init];    
//    [self readSettings];
//    [self getRosenWeather];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)writeSettingsToMgr {
    NSLog(@"writeSettingsToMgr");
//    GlobalVars *vars = [GlobalVars sharedInstance];
    
    NSString * setXoapLocId = self.mLocId;
    NSString * setXoapLocCityName = self.mCurCityName;
    bool setIsSelectC = self.mIsSelectC;
    
    SettingsManager *mgr = [SettingsManager sharedInstance];
    WeatherSettingManager * wMgr = mgr.mWeatherSettingManager;
    wMgr.mLocId = setXoapLocId;
    wMgr.mCurCityName = setXoapLocCityName;
    wMgr.mIsSelectC = setIsSelectC;
}

-(void)readSettingsFromMgr {
    NSLog(@"readSettingsFromMgr");
    
    NSString * getXoapLocId;
    NSString * getXoapLocCityName;
    bool getIsSelectedC;
    
    SettingsManager *mgr = [SettingsManager sharedInstance];
    WeatherSettingManager * wMgr = mgr.mWeatherSettingManager;
    getIsSelectedC = wMgr.mIsSelectC;
    getXoapLocId = wMgr.mLocId;
    getXoapLocCityName = wMgr.mCurCityName;
    
    self.mIsSelectC = getIsSelectedC;
    self.mLocId = getXoapLocId;
    self.mCurCityName = getXoapLocCityName;
    
//    self.mLocIdLbl.text = getXoapLocId;
//    self.mSelectedCity.text = getXoapLocCityName;
    if(getIsSelectedC) {
//        self.mFCSegCtrl.selectedSegmentIndex = 1;
    }else {
//        self.mFCSegCtrl.selectedSegmentIndex = 0;
    }
}


-(void)writeSettings {
    NSLog(@"clickToWrite");
    [self writeSettingsToMgr];
    return;
    GlobalVars *vars = [GlobalVars sharedInstance];
    //    NSDictionary * settingsDict = [self getSettingsDict];
    NSDictionary * settingsDict = [vars getSettingsDict];  
    
    NSString * setXoapLocId = self.mLocId;
    NSString * setXoapLocCityName = self.mCurCityName;
    
    
    bool setIsSelectC = self.mIsSelectC; 
    
    [settingsDict setValue:setXoapLocId forKey:@"XoapLocId"];
    [settingsDict setValue:setXoapLocCityName forKey:@"XoapLocCityName"];
    [settingsDict setValue:[NSNumber numberWithBool:setIsSelectC] forKey:@"XoapIsSelectedC"];
    
    //    [self setSettingsDict:settingsDict];    
    [vars setSettingsDict:settingsDict];        
}




-(void)readSettings {

    if(mParseHelper == nil) mParseHelper = [[ParseHelper alloc]init];
    
    NSLog(@"clickToRead");
    [self readSettingsFromMgr];
    return;
    GlobalVars *vars = [GlobalVars sharedInstance];
    NSDictionary *settingsDict = [vars getSettingsDict];
    
    NSString * getXoapLocId = [settingsDict objectForKey:@"XoapLocId"];
    NSString * getXoapLocCityName = [settingsDict objectForKey:@"XoapLocCityName"];
    bool getIsSelectedC = [[settingsDict objectForKey:@"XoapIsSelectedC"] boolValue];
    
    self.mIsSelectC = getIsSelectedC;
    self.mLocId = getXoapLocId;    
    self.mLocId = @"Oakland,CA";
//    self.mLocId = getXoapLocCityName; //XoapLocCityName
//    NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:getXoapLocCityName];
//    self.mLocId = encodedNewLocId;
    
    
    NSLog(@"mLocId = %@", mLocId);
    NSLog(@"mLocId = %@", mLocId);
    NSLog(@"mLocId = %@", mLocId);
    NSLog(@"mLocId = %@", mLocId);
    NSLog(@"mLocId = %@", mLocId);
    NSLog(@"mLocId = %@", mLocId);
    
    
//    self.mLocId = getXoapLocCityName;
    
    self.mCurCityName = getXoapLocCityName;

    
//    self.mLocIdLbl.text = getXoapLocId;
//    self.mSelectedCity.text = getXoapLocCityName;
    
    if(getIsSelectedC) 
    {
//        self.mFCSegCtrl.selectedSegmentIndex = 1;
    }
    else 
    {
//        self.mFCSegCtrl.selectedSegmentIndex = 0;
    }
    
}





- (void) getRosenWeather {

    
    if(mParseHelper == nil) {
        mParseHelper = [[ParseHelper alloc]init];
    }
    
    [self writeSettings];
    mParsingAction = PARSE_ROSEN_WEATHER_DOM;
    if(mTempDownloadData != nil) {
        mTempDownloadData = nil;
    }
    mTempDownloadData = [NSMutableData alloc];
    
    NSString * metric = @"1";
    if( self.mIsSelectC) metric = @"0";
  
    
    NSString * newLocId = self.mCurCityName;
    newLocId = [mParseHelper extractValueByPattern:@"(.*?,.*?)(\\(|$)" inTxtStr:newLocId];
    newLocId = [newLocId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    
    NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:newLocId];
    newLocId = encodedNewLocId;
    mRosenWeatherURL = [NSString stringWithFormat:@"http://rosenapp.com/api.class?action=weather&loc_id=%@&metric=%@", newLocId, metric];
    
    
    GlobalVars *vars =[GlobalVars sharedInstance];
    vars.mWeatherEVC.mUrlLbl.text = mRosenWeatherURL;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:mRosenWeatherURL]];
    self.mConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}

//
//
//
//
-(void) refreshWeatherGui {
    GlobalVars *vars =[GlobalVars sharedInstance];
    if(mParseHelper == nil) {
        mParseHelper = [[ParseHelper alloc]init];
    }
    
    
    vars.mWeatherEVC.mCurTmpLbl.text = [NSString stringWithFormat:@"%@°", mRosenWeatherDom.mToday.mCurTmp];
    
    vars.mWeatherEVC.mWeatherTextLbl.text = mRosenWeatherDom.mToday.mText;
    
    vars.mWeatherEVC.mCurHiLoLbl.text = [NSString stringWithFormat:@"Hi %@°   Lo %@°",mRosenWeatherDom.mToday.mHighTmp, mRosenWeatherDom.mToday.mLowTmp];
    
    vars.mWeatherEVC.mCurHiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mToday.mHighTmp];
    vars.mWeatherEVC.mCurLoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mToday.mLowTmp];
    
    vars.mWeatherEVC.mHmidAndPpcpLbl.text = [NSString stringWithFormat:@"Humidity of %@%% and %@%% chance of rain", mRosenWeatherDom.mToday.mHumidityTmp ,mRosenWeatherDom.mToday.mPrecipitation];
    
    vars.mWeatherEVC.mHmidLbl.text = [NSString stringWithFormat:@"Humidity: %@%% ", mRosenWeatherDom.mToday.mHumidityTmp ];
    vars.mWeatherEVC.mPpcpLbl.text = [NSString stringWithFormat:@"Chance of Rain: %@%%",mRosenWeatherDom.mToday.mPrecipitation];
    
    vars.mWeatherEVC.mWeatherCity.text = self.mCurCityName;
    
    
    
    //    vars.mEVC.mSunDescriptionLbl.text = [NSString stringWithFormat:@"Sun rise at %@ Sunset at %@",mRosenWeatherDom.mToday.mSunRise, mRosenWeatherDom.mToday.mSunSet];
    
    vars.mWeatherEVC.mSunDescriptionLbl.text = [NSString stringWithFormat:@"Sunrise %@ Sunset %@", mRosenWeatherDom.mToday.mSunRise,mRosenWeatherDom.mToday.mSunSet];
    
    
    vars.mWeatherEVC.mTodayImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mToday.mIcon]];
    
//    vars.mWeatherEVC.mWindDescriptionLbl.text = [NSString stringWithFormat:@"Wind %@ at %@mph",mRosenWeatherDom.mToday.mWindDirection,mRosenWeatherDom.mToday.mWindSpeed];
    

    vars.mWeatherEVC.mWindDescriptionLbl.text = [NSString stringWithFormat:@"Wind %@ %@",mRosenWeatherDom.mToday.mWindDirection,mRosenWeatherDom.mToday.mWindSpeed];
    
    
    vars.mWeatherEVC.mD1WDLbl.text = mRosenWeatherDom.mDay1.mWeekDay;
    vars.mWeatherEVC.mD1HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay1.mHighTmp];
    vars.mWeatherEVC.mD1LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay1.mLowTmp];
    vars.mWeatherEVC.mD1IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay1.mIcon]];
    
    vars.mWeatherEVC.mD2WDLbl.text = mRosenWeatherDom.mDay2.mWeekDay;
    vars.mWeatherEVC.mD2HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay2.mHighTmp];
    vars.mWeatherEVC.mD2LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay2.mLowTmp];
    vars.mWeatherEVC.mD2IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay2.mIcon]];
    
    vars.mWeatherEVC.mD3WDLbl.text = mRosenWeatherDom.mDay3.mWeekDay;
    vars.mWeatherEVC.mD3HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay3.mHighTmp];
    vars.mWeatherEVC.mD3LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay3.mLowTmp];
    vars.mWeatherEVC.mD3IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay3.mIcon]];
    
    vars.mWeatherEVC.mD4WDLbl.text = mRosenWeatherDom.mDay4.mWeekDay;
    vars.mWeatherEVC.mD4HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay4.mHighTmp];
    vars.mWeatherEVC.mD4LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay4.mLowTmp];
    vars.mWeatherEVC.mD4IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay4.mIcon]];
    
    vars.mWeatherEVC.mD5WDLbl.text = mRosenWeatherDom.mDay5.mWeekDay;
    vars.mWeatherEVC.mD5HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay5.mHighTmp];
    vars.mWeatherEVC.mD5LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay5.mLowTmp];
    vars.mWeatherEVC.mD5IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay5.mIcon]];
    
//    vars.mWeatherEVC.mCityLbl.text = mCurCityName;
    
    NSString *reducedCityName = mCurCityName;
    //reducedCityName's purpose is fit the issue from Kevin's email
    //no need state or country
    NSString * reducedCityNameWithComma = [mParseHelper extractValueByPattern:@"(.+?)," inTxtStr:reducedCityName];
    

    if(reducedCityNameWithComma != nil && ![reducedCityNameWithComma isEqualToString:@""])
    {
        reducedCityName = reducedCityNameWithComma;
    }
    vars.mWeatherEVC.mCityLbl.text = reducedCityName;
    
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
    switch (mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            [self.mXOAPWhereDom parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            [self.mRosenWeatherDom parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
            break;
    }
}

//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    switch(mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            [self.mXOAPWhereDom parser:parser foundCharacters:string];            
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            [self.mRosenWeatherDom parser:parser foundCharacters:string];            
            break;
    }
    
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
    switch(mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            [self.mXOAPWhereDom parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName]; 
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            [self.mRosenWeatherDom parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName]; 
            break;
    }
}





//NSURLConnectionDelegate
-(void) connection:(NSURLConnection *)connection didReceiveData: (NSData *) incomingData
{ 
    NSLog(@"NSURLConnection didReceiveData");
    [mTempDownloadData appendData:incomingData];
}

//NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"NSURLConnection connectionDidFinishLoading");    
    NSString *loadData = [[NSMutableString alloc] initWithData:mTempDownloadData encoding:NSISOLatin1StringEncoding];
    NSLog(@"\n\n\n\nloadData = %@\n\n\n\n",loadData);
    //    return;
    
    
    if(mParser) {
        mParser = nil;
    }
    
    //mParser = [[NSXMLParser alloc] initWithData:mTempDownloadData];
    
    //    dataUsingEncoding:encoding allowLossyConversion:YES] 
    
    mParser = [[NSXMLParser alloc] initWithData:[loadData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
//    mDbgTextView.text = loadData;
    
    [mParser setDelegate:self];//(id<NSXMLParserDelegate>)
    [mParser setShouldResolveExternalEntities:YES];
    @try 
    {
        [mParser parse];
        
        NSError *err = [mParser parserError];
        NSLog(@"parser error = %@", err);
        
    }
    @catch( NSException *e) 
    {
        NSLog(@"Parsing Error");
        return;
    }
    
    
    switch (mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            NSLog(@"mXOAPWhereDom = %@",mXOAPWhereDom);    
            
            //here parsing ok
//            [self refreshComboBoxDataByWhereDom:mXOAPWhereDom];
            
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            NSLog(@"mRosenWeatherDom = %@",mRosenWeatherDom);
            [self refreshWeatherGui];
            break;
    }
    
//    [self refreshData];
    mTempDownloadData = nil;
    mConnection = nil;    
}





-(void) recoverWeatherObjsFromCoreData {
   
    if(mIsCoreDataUsed == YES) return;
    mIsCoreDataUsed = YES;
    
    CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];
    NSString *entityName = @"WeatherEntity";
    
    
    //NSMutableArray * coreItems = [theCoreDataHelper readItems:entityName];
    NSMutableArray * coreItems = [[CoreDataHelper sharedInstance] readItems:entityName];
@synchronized (coreItems) {
    if(coreItems != nil && [coreItems count] > 0 )
    {
        if(mWeatherObjs != nil ) {
            [mWeatherObjs removeAllObjects];
        }
        else {
            mWeatherObjs = [NSMutableArray arrayWithCapacity:1];
        }
        int idx;
        for (idx = 0; idx < [coreItems count]; idx++)
        {
            WeatherEntity * item = (WeatherEntity*)[coreItems objectAtIndex:idx];
            
            //WeatherObj * obj = [[WeatherObj alloc] init];
            WeatherObj * obj = (WeatherObj*)[[WeatherObj alloc]init];
            NSLog(@"obj = %@", obj);
            [obj setValuesFromSettingDataOnEntity:item];
            [obj setValuesFromRunningDataOnEntity:item];
                        
            //obj.mId = [NSNumber numberWithInt:idx];
            [mWeatherObjs addObject:obj];
            NSLog(@"obj = %@",obj);
        }
    }
}
    mIsCoreDataUsed = NO;
}



-(void) backupWeatherObjsToCoreData {
    if(mIsCoreDataUsed == YES) return;
    mIsCoreDataUsed = YES;
    
    CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];
    NSString *entityName = @"WeatherEntity";
    [theCoreDataHelper deleteAllItemsAndSave:entityName];
    if(mWeatherObjs != nil && [mWeatherObjs count]> 0)
    {
        int idx;
        for(idx = 0; idx < [mWeatherObjs count]; idx++)
        {
            WeatherObj * obj = [mWeatherObjs objectAtIndex:idx];
            EditItemCallback callback = ^(NSManagedObject *theItem)
            {
                WeatherEntity * item = (WeatherEntity*) theItem;
                [WeatherObj copyValuesFromRunningDataOnObj:obj ToEntity:item];
                [WeatherObj copyValuesFromSettingDataOnObj:obj ToEntity:item];
                //it's no copyValue from setting data on obj to item originally
                item.mId = [NSNumber numberWithInt:idx];
            };
            [theCoreDataHelper addItemAndSave:entityName withBlock:callback];
            

            

        }
    }
    mIsCoreDataUsed = NO;
}


-(void) checkToDataReset
{
    NSLog(@"WeatherExterViewController checkToDataReset");
    if(mIsNeedToResetWeatherData == NO) {
        return;
    }
    mIsNeedToResetWeatherData = NO;
    [self recoverWeatherObjsFromCoreData];
    
    WeatherObj * weatherObj;
    int objIdx = [SettingsManager sharedInstance].mWeatherSettingManager.mSelectedItemIdx;
    int objsCount = [SettingsManager sharedInstance].mWeatherSettingManager.mItemsCount;
    
    if(objIdx >= objsCount) {
        [SettingsManager sharedInstance].mWeatherSettingManager.mSelectedItemIdx = objsCount-1;
        objIdx = objsCount-1;
    }
    
    if(objIdx <0) {
        NSLog(@"WeatherExterViewController checkToDataReset meet no data");
    
        [self cleanWeatherGui];
        return;
    }
    
    weatherObj = [mWeatherObjs objectAtIndex:objIdx];
    
    if(weatherObj.mTimeInterval == 0 ) {
        dispatch_async(dispatch_get_main_queue(),^{
            [self cleanWeatherGui];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(),^{
            [self refreshWeatherObjToGui:weatherObj];
        });
    }
    
    NSTimeInterval oldTimeInterval = weatherObj.mTimeInterval;
    NSDate * now = [NSDate date];
    NSTimeInterval curTimeInterval = [now timeIntervalSince1970];//The number of seconds from the reference date
    
//    if((curTimeInterval - oldTimeInterval) > 3600) {
//        [self performSelector:@selector(requestReloadIndexedWeatherObj:) withObject:nil afterDelay:0.2];
//    }
    
    if((curTimeInterval - oldTimeInterval) > 3600) {
        [self performSelector:@selector(requestReloadIndexedWeatherObj:) withObject:nil afterDelay:0.2];
        NSLog(@"(curTimeInterval - oldTimeInterval) > 3600");
    }
    else {
        NSLog(@"It's not (curTimeInterval - oldTimeInterval) > 3600");
    }
    
}

-(IBAction) requestReloadIndexedWeatherObj:(id)sender
{
    if(mIsCoreDataUsed == YES) return;
    mIsCoreDataUsed = YES;
//    CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];
    
//    NSString * entityName = @"WeatherEntity";
    int idx = [SettingsManager sharedInstance].mWeatherSettingManager.mSelectedItemIdx;
    WeatherObj * obj = [mWeatherObjs objectAtIndex:idx];
    NSDate * now = [NSDate date];
    obj.mTimeInterval = [now timeIntervalSince1970];
    [self loadDataForWeatherObj:obj andRefreshGui:YES andSaveItemInCoreData:YES];//remember set mIsCoreDataUsed to NO in this function
    return;
//    [theCoreDataHelper editItemAndSave:entityName withIdx:idx withBlock:callback];
//    mIsCoreDataUsed = NO;
//    
//    self.mIsNeedToResetWeatherData = YES;
//    [self checkToDataReset];
}


-(IBAction)clickToPrevWeatherItem:(id)sender
{
    NSLog(@"clickToPrevWeatherItem");
    if(mWeatherObjs == nil ) return;
    if([mWeatherObjs count] <= 0) return;
    WeatherSettingManager * wMgr = [SettingsManager sharedInstance].mWeatherSettingManager;
    int weatherIdx = wMgr.mSelectedItemIdx;
    if(weatherIdx <= 0 )return;
    

    weatherIdx = weatherIdx -1;
    wMgr.mSelectedItemIdx = weatherIdx;
    
    dispatch_async(dispatch_get_main_queue(),^{
        self.mPageLbl.text = [NSString stringWithFormat:@"%d / %d",wMgr.mSelectedItemIdx+1, wMgr.mItemsCount];
    });
    
    WeatherObj * wObj = [mWeatherObjs objectAtIndex:weatherIdx];
    [self refreshWeatherObjToGui:wObj];

    NSTimeInterval oldTimeInterval = wObj.mTimeInterval;
    NSDate * now = [NSDate date];
    NSTimeInterval curTimeInterval = [now timeIntervalSince1970];//The number of seconds from the reference date
    
    if((curTimeInterval - oldTimeInterval) > 3600) {
        [self performSelector:@selector(requestReloadIndexedWeatherObj:) withObject:nil afterDelay:0.2];
        NSLog(@"(curTimeInterval - oldTimeInterval) > 3600");
    }
    else {
        NSLog(@"It's not (curTimeInterval - oldTimeInterval) > 3600");
    }
}

-(IBAction)clickToNextWeatherItem:(id)sender
{
    NSLog(@"clickToNextWeatherItem");
    if(mWeatherObjs == nil ) return;
    if([mWeatherObjs count] <= 0) return;
    WeatherSettingManager * wMgr = [SettingsManager sharedInstance].mWeatherSettingManager;
    int weatherIdx = wMgr.mSelectedItemIdx;
    
    if(weatherIdx >= [mWeatherObjs count]-1) return;
    
    
    weatherIdx = weatherIdx + 1;

    
    wMgr.mSelectedItemIdx = weatherIdx;
    
    dispatch_async(dispatch_get_main_queue(),^{
        self.mPageLbl.text = [NSString stringWithFormat:@"%d / %d",wMgr.mSelectedItemIdx+1,wMgr.mItemsCount];
    });
    
    WeatherObj * wObj = [mWeatherObjs objectAtIndex:weatherIdx];
    [self refreshWeatherObjToGui:wObj];
    
    
    NSTimeInterval oldTimeInterval = wObj.mTimeInterval;
    NSDate * now = [NSDate date];
    NSTimeInterval curTimeInterval = [now timeIntervalSince1970];//The number of seconds from the reference date
    
//    if((curTimeInterval - oldTimeInterval) > 3600) {
//        [self performSelector:@selector(requestReloadIndexedWeatherObj:) withObject:nil afterDelay:0.2];
//    }
    if((curTimeInterval - oldTimeInterval) > 3600) {
        wObj.mTimeInterval = curTimeInterval;
        
        [self performSelector:@selector(requestReloadIndexedWeatherObj:) withObject:nil afterDelay:0.2];
        NSLog(@"(curTimeInterval - oldTimeInterval) > 3600");
    }
    else {
        NSLog(@"It's not (curTimeInterval - oldTimeInterval) > 3600");
    }
}




@end
