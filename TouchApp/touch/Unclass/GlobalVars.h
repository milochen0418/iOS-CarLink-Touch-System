//
//  GlobalVars.h
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "XOAPWhereDom.h"
#import "RosenWeatherDom.h"
#import "VIDEOkit.h"
#import "WeatherInterViewController.h"
#import "WeatherExterViewController.h"
#import "ViewController.h"
#import "ExterViewController.h"
#import "AppDelegate.h"
#import "UIEvent+Synthesize.h"
#import "UITouch+Synthesize.h"
#import "GSEventProxy.h"

#import "SpeedCameraExterViewController.h"
#import "AppsListInterViewController.h"
#import "AppsListExterViewController.h"
#import "AppInstallationInterViewController.h"
#import "AppInstallationExterViewController.h"
#import "iToast.h"
#import "ComboBox.h"

#import "SettingsInterViewController.h"
#import "SettingsExterViewController.h"

#import "WeatherSettingsViewController.h"
#import "SpeedCameraSettingsViewController.h"
#import "MediaSettingsViewController.h"
#import "TrafficSettingsViewController.h"
#import "PanelViewCotnroller.h"
#import "HiddenHelpViewCotnroller.h"
#import "DebugPanelViewCotnroller.h"
#import "DAAutoTextView.h"

#import "EditCameraAddViewController.h"
#import "TrafficExterViewController.h"
#import "AddCameraAlertViewController.h"
#import "CameraOkAlertViewController.h"
#import "RouteSettingViewController.h"

#import "WeatherSettingsListViewController.h"


#define DISPLAY_OFFSET_X (10.0f)
#define DISPLAY_OFFSET_Y (6.0f)
#define DISPLAY_WIDTH (828.0f)
#define DISPLAY_HEIGHT (472.0f)
#define TOUCH_X_MAX (65535.0f)
#define TOUCH_Y_MAX (65535.0f)


#define DBG
//#define REDIRECT_LOG_FILE
#define NSLogGenOut(fmt,...) [[GlobalVars sharedInstance] NSLogTo: [NSString stringWithFormat:fmt,##__VA_ARGS__]]
#ifdef DBG
#define NSLogOut(fmt,...) NSLogGenOut((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define NSLogOut(fmt,...) NSLogGenOut(fmt,##__VA_ARGS__);
#endif


#define PRESUME_MCU_CONNECT_12V (NO) //sometime MCU has no power, we need enforce this variable to presume the envionrmnet has 12V when there is  no 12V connect to MCU
#define IS_HIDDEN_TOUCH_COMMAND_WORK (NO)

#define IS_NEED_PLUG_UNPLUG_BTN (NO)

#define IS_SHOW_MAP (NO)

@interface GlobalVars : NSObject {
    DebugPanelViewCotnroller * mDebugPanelVC;
    HiddenHelpViewCotnroller * mHiddenHelpVC;
    PanelViewCotnroller * mPVC;
    UINavigationController * exterNav;
    ExterViewController * mEVC;
    UINavigationController * interNav;
    WeatherInterViewController * mWeatherIVC;
    WeatherExterViewController * mWeatherEVC;
    SpeedCameraExterViewController * mSpeedCameraEVC;
    AppsListInterViewController * mAppsListIVC;
    AppsListExterViewController * mAppsListEVC;
    AppInstallationInterViewController * mAppInstallationIVC;
    AppInstallationExterViewController * mAppInstallationEVC;    
 
    SettingsInterViewController * mSettingsIVC;
    SettingsExterViewController * mSettingsEVC;
    WeatherSettingsViewController * mWeatherSettingsIVC;
    SpeedCameraSettingsViewController *mSpeedCameraSettingsIVC;
    MediaSettingsViewController * mMediaSettingsIVC;
    TrafficSettingsViewController * mTrafficSettingsIVC;
    RouteSettingViewController * mRouteSettingIVC;
    
    TrafficExterViewController * mTrafficEVC;
    EditCameraAddViewController * mEditCameraAddViewIVC;
    AddCameraAlertViewController * mAddCameraAlertVC;
    CameraOkAlertViewController * mCameraOkAlertVC;
    AppDelegate *mAppDelegate;
    

    //variable for SpeedCamera App
    double mSafeDistance;
    int mDefaultCameraLimitNum;
    int mMinCameraLimitNum;
    int mCurCameraLimitNum;
    double mMaxIdleSec; 

}

@property (nonatomic) BOOL  mIsNetworkConnected;

//variable for SpeedCamera App
@property (nonatomic,strong) AddCameraAlertViewController * mAddCameraAlertVC;
@property (nonatomic) double mSafeDistance;
@property (nonatomic) int mDefaultCameraLimitNum;
@property (nonatomic) int mMinCameraLimitNum;
@property (atomic) int mCurCameraLimitNum;
@property (nonatomic) double mMaxIdleSec;


@property (nonatomic,strong) CameraOkAlertViewController * mCameraOkAlertVC;
@property (nonatomic,strong) EditCameraAddViewController * mEditCameraAddViewIVC;
@property (nonatomic,strong) TrafficExterViewController * mTrafficEVC;
@property (nonatomic,strong) DebugPanelViewCotnroller * mDebugPanelVC;
@property (nonatomic,strong) HiddenHelpViewCotnroller * mHiddenHelpVC;
@property (nonatomic,strong) PanelViewCotnroller * mPVC;
@property (nonatomic,strong) TrafficSettingsViewController * mTrafficSettingsIVC;
@property (nonatomic,strong) MediaSettingsViewController * mMediaSettingsIVC;
@property (nonatomic,strong) SpeedCameraSettingsViewController * mSpeedCameraSettingsIVC;
@property (nonatomic,strong) WeatherSettingsViewController * mWeatherSettingsIVC;
@property (nonatomic,strong) WeatherSettingsListViewController * mWeatherSettingsListIVC;


@property (nonatomic,strong) RouteSettingViewController * mRouteSettingIVC;
@property (nonatomic,strong) SettingsInterViewController * mSettingsIVC;
@property (nonatomic,strong) SettingsExterViewController * mSettingsEVC;
-(NSDictionary*) getSettingsDict ;
-(void) setSettingsDict:(NSDictionary*)settingsDict; 


@property (nonatomic,strong) AppInstallationInterViewController * mAppInstallationIVC;
@property (nonatomic,strong) AppInstallationExterViewController * mAppInstallationEVC;    

@property (nonatomic,strong) AppsListInterViewController * mAppsListIVC;
@property (nonatomic,strong) AppsListExterViewController * mAppsListEVC;

@property (nonatomic,strong) AppDelegate *mAppDelegate;
@property (nonatomic,strong) SpeedCameraExterViewController * mSpeedCameraEVC;    

@property (nonatomic,strong) WeatherInterViewController * mWeatherIVC;
@property (nonatomic,strong) WeatherExterViewController * mWeatherEVC;


@property (nonatomic,strong) UINavigationController * interNav;
@property (nonatomic,strong) UINavigationController * exterNav;
@property (nonatomic,strong) ExterViewController * mEVC;


+ (GlobalVars*) sharedInstance;
- (void) NSLogTo: (NSString*) log;
- (void)redirectNSLogToDocumentFolder;



@end
