//
//  GlobalVars.m
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalVars.h"


@implementation GlobalVars

@synthesize exterNav;
@synthesize interNav;
@synthesize mEVC;
@synthesize mWeatherEVC,mWeatherIVC;
@synthesize mSpeedCameraEVC;
@synthesize mAppDelegate;
@synthesize mAppsListIVC, mAppsListEVC;
@synthesize mAppInstallationIVC,mAppInstallationEVC;
@synthesize mSettingsIVC,mSettingsEVC;
@synthesize mWeatherSettingsIVC;
@synthesize mWeatherSettingsListIVC;
@synthesize mSpeedCameraSettingsIVC;
@synthesize mMediaSettingsIVC;
@synthesize mTrafficSettingsIVC;
@synthesize mPVC;
@synthesize mHiddenHelpVC;
@synthesize mDebugPanelVC;
@synthesize mTrafficEVC;
@synthesize mEditCameraAddViewIVC;
@synthesize mRouteSettingIVC;

//variable for speed camera
@synthesize mMaxIdleSec,mSafeDistance,mCurCameraLimitNum,mMinCameraLimitNum,mDefaultCameraLimitNum;
@synthesize mAddCameraAlertVC;
@synthesize mCameraOkAlertVC;


@synthesize mIsNetworkConnected;

static GlobalVars* staticGlobalVars = nil;
+ (GlobalVars*) sharedInstance {

    if(staticGlobalVars == nil) {
        staticGlobalVars = [[GlobalVars alloc]init];
#ifdef REDIRECT_LOG_FILE
        [staticGlobalVars redirectNSLogToDocumentFolder];
#endif 
        
    }
    return staticGlobalVars;
}


- (void) NSLogTo: (NSString*) log 
{
//    NSLog(@"%@",log);
//    NSString* str = [NSString stringWithFormat:@"%@\n%@", mLogTextView.text, log];
    if(self.mDebugPanelVC != nil) {
        [self.mDebugPanelVC addLog:log];
    }
    
    //    if(mLogTextView != nil) 
    //    {
    //        NSString* str = [NSString stringWithFormat:@"%@\n%@", mLogTextView.text, log];    
    //        mLogTextView.text = str;
    //    }
}


- (void)redirectNSLogToDocumentFolder{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}



-(NSDictionary*) getSettingsDict {
    NSLog(@"getSettingsDict");
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
    NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
    NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *writeFinalPath = [documentsDirectoryPath stringByAppendingPathComponent:@"Root.plist"];
    NSDictionary *settingsDict = nil;     
    settingsDict = [NSDictionary dictionaryWithContentsOfFile:writeFinalPath];
    if(settingsDict == nil ) {
        settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
    }
    return settingsDict;
}



-(void) setSettingsDict:(NSDictionary*)settingsDict {
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *writeFinalPath = [documentsDirectoryPath stringByAppendingPathComponent:@"Root.plist"];
    NSString *cachesDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    if(cachesDirectoryPath==nil)cachesDirectoryPath=@"";    
    [settingsDict writeToFile:writeFinalPath atomically:YES];
}




@end
