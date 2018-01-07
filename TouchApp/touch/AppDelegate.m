//
//  AppDelegate.m
//  touch
//
//  Created by Milo Chen on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "GlobalVars.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize mRosenLbl;
@synthesize mSession,mRosenAccessory;
@synthesize mWriteData;

@synthesize mPVC,mIdleTimer,mTimeOutCnt,mMainUIScreen;

@synthesize mHiddenCommandTopLeftBtn,mHiddenCommandTopRightBtn,mHiddenCommandBottomLeftBtn,mHiddenCommandBottomRightBtn;
@synthesize mTouchCmdsStr;

@synthesize mDbgMouseBtn;

@synthesize mReachability;

@synthesize mIsExtTouchIn200ms;

@synthesize mIsExterNavOnAnimated;

#define ACCESSORY_NAME @"RosenLink"
//#define PROTOCOL_NAME @"com.rosenapp.RosenLink"
#define PROTOCOL_NAME @"com.rosenapp.RosenTouch"
//#define PROTOCOL_NAME @"com.rosenapp.touch"



-(IBAction) cancelExtTouchIn200msFlag:(id)sender {
    mIsExtTouchIn200ms = NO;
}


+(NSString*) getHostName {
//    return @"192.168.0.105";
      return @"www.rosenapp.com";  
}








- (void)sendHexStr:(NSString*) hexStr;
{
    //    NSString * textStr = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x", 0x33, 0x55, 0x02,0xff,0x02];
    
    //    NSString * textStr = hexStr;
    NSString * textStr = @"55";
    textStr = [textStr stringByAppendingString:hexStr];
    
    NSLogOut(@"send textStr = %@", textStr);
    NSLog(@"send textStr = %@", textStr);
    
    const char *buf = [textStr UTF8String];
    //    const char *buf = [textStr cString];
    NSMutableData *data = [NSMutableData data];
    if (buf)
    {
        uint32_t len = strlen(buf);
        
        char singleNumberString[3] = {'\0', '\0', '\0'};
        uint32_t singleNumber = 0;
        for(uint32_t i = 0 ; i < len; i+=2)
        {
            if ( ((i+1) < len) && isxdigit(buf[i]) && (isxdigit(buf[i+1])) )
            {
                singleNumberString[0] = buf[i];
                singleNumberString[1] = buf[i + 1];
                sscanf(singleNumberString, "%x", &singleNumber);
                uint8_t tmp = (uint8_t)(singleNumber & 0x000000FF);
                [data appendBytes:(void *)(&tmp) length:1];
            }
            else
            {
                break;
            }
        }
        
        //        [[EADSessionController sharedController] writeData:data];
        [self writeData:data];
    }
}

- (void)writeData:(NSData *)data
{
    if (mWriteData == nil) {
        mWriteData = [[NSMutableData alloc] init];
    }
    [mWriteData appendData:data];
    [self _writeData];
}


- (void)_writeData
{
    while (([[mSession outputStream] hasSpaceAvailable]) && ([mWriteData length] > 0))
    {
        NSInteger bytesWritten = [[mSession outputStream] write:[mWriteData bytes] maxLength:[mWriteData length]];
        if (bytesWritten == -1)
        {
            NSLog(@"write error");
            break;
        }
        else if (bytesWritten > 0)
        {
            [mWriteData replaceBytesInRange:NSMakeRange(0, bytesWritten) withBytes:NULL length:0];
        }
    }
}


-(IBAction)handleNetworkChange:(NSNotification *)sender {
    GlobalVars *vars =[GlobalVars sharedInstance];
    NetworkStatus remoteHostStatus = [self.mReachability currentReachabilityStatus];
    NSOperationQueue * queue = [NSOperationQueue sharedOperationQueue];
    if (remoteHostStatus == NotReachable)
    {
        [queue setSuspended:YES];
        NSString *str =@"handleNetworkChange => queue setSuspended:YES";
        NSLog(@"%@",str);
//         self.viewController.mTextView.text = str;
        vars.mIsNetworkConnected = NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mPVC.mNetworkConnStatusLbl.text = @"Disconnected";
        });
    }
    else
    {
        [queue setSuspended:NO];
        NSString *str =@"handleNetworkChange => queue setSuspended:NO";
        NSLog(@"%@",str);
//        self.viewController.mTextView.text = str;
        vars.mIsNetworkConnected = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.mPVC.mNetworkConnStatusLbl.text = @"Connected";
        });
        
    }
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    SettingsManager * setmgr = [SettingsManager sharedInstance];
    WeatherSettingManager * wMgr = setmgr.mWeatherSettingManager;
    NSLog(@"start getter/setter test");
    BOOL readIsSelectC = wMgr.mIsSelectC;
    if(readIsSelectC) {
        wMgr.mIsSelectC = NO;
    }else {
        wMgr.mIsSelectC = YES;
    }
    readIsSelectC = wMgr.mIsSelectC;
    if(readIsSelectC) {
        wMgr.mIsSelectC = NO;
    }else {
        wMgr.mIsSelectC = YES;
    }
    NSLog(@"end getter/setter test");
    
    GlobalVars * vars = [GlobalVars sharedInstance];
    vars.mAppDelegate = self;    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    
    //    vars.mSpeedCameraEVC = [[SpeedCameraExterViewController alloc]init];
    vars.mSpeedCameraEVC = [[SpeedCameraExterViewController alloc] initWithNibName:@"SpeedCameraExterViewController" bundle:nil];
    
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    vars.mEVC  = [[ExterViewController alloc] init];
    
    vars.interNav = [[UINavigationController alloc] initWithRootViewController:self.viewController];

    
    
    
    vars.exterNav = [[UINavigationController alloc] initWithRootViewController:vars.mEVC];
    vars.exterNav.delegate = self;

    
    //change process sequence
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //VIDEOkit init setting
    [VIDEOkit sharedInstance];
    [VIDEOkit startupWithDelegate:vars.interNav];
    
    
    mDbgMouseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    mDbgMouseBtn.alpha = 0.5;
    [mDbgMouseBtn setFrame:CGRectMake(35-10,12-10,20,20)];
    [mDbgMouseBtn setTitle:@"" forState:UIControlStateNormal];
    [vars.exterNav.view addSubview:mDbgMouseBtn];
    
    
    
    //[self.view addSubview:uiButton];
    
    vars.mWeatherIVC = [[WeatherInterViewController alloc]init];
    vars.mWeatherEVC = [[WeatherExterViewController alloc]init];
    
    
    vars.mAppsListIVC = [[AppsListInterViewController alloc]init];
    vars.mAppsListEVC = [[AppsListExterViewController alloc]init];
    vars.mAppInstallationIVC = [[AppInstallationInterViewController alloc]init];
    vars.mAppInstallationEVC = [[AppInstallationExterViewController alloc]init];
    vars.mSettingsIVC = [[SettingsInterViewController alloc]init];
    vars.mSettingsEVC = [[SettingsExterViewController alloc]init];
    vars.mWeatherSettingsIVC = [[WeatherSettingsViewController alloc]init];
    
    vars.mWeatherSettingsListIVC = [[WeatherSettingsListViewController alloc] init];
    
    vars.mSpeedCameraSettingsIVC = [[SpeedCameraSettingsViewController alloc]init];
    vars.mTrafficSettingsIVC = [[TrafficSettingsViewController alloc]init];
    vars.mMediaSettingsIVC = [[MediaSettingsViewController alloc]init];
    
    vars.mTrafficEVC = [[TrafficExterViewController alloc]init];
    vars.mEditCameraAddViewIVC = [[EditCameraAddViewController alloc] init];
    vars.mAddCameraAlertVC = [[AddCameraAlertViewController alloc] init];
    vars.mCameraOkAlertVC = [[CameraOkAlertViewController alloc] init];
    vars.mRouteSettingIVC = [[RouteSettingViewController alloc]init];
    
//    vars.mEditCameraAddViewIVC.view.transform = CGAffineTransformMakeScale(1.0,1.0);
    
    [vars.exterNav navigationBar].hidden = YES;
    [vars.interNav navigationBar].hidden = NO;
    
    mRosenLbl = [[UILabel alloc]initWithFrame:CGRectMake(20.0f, 7.0f, 125.0f, 42.0f)];
    mRosenLbl.text = @"ROSEN";
    mRosenLbl.font = [UIFont boldSystemFontOfSize:35.0f];
    mRosenLbl.backgroundColor = [UIColor clearColor];
    mRosenLbl.hidden = YES;
    [vars.interNav.view addSubview:mRosenLbl];
    self.window.rootViewController = vars.interNav;
    
    
    self.mPVC = [[PanelViewCotnroller alloc] init];
    [self.window.rootViewController.view addSubview:mPVC.view];

    
    //Reachability
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    self.mReachability=[Reachability reachabilityWithHostName:@"www.google.com"];
    [self.mReachability startNotifier];
    
    
    vars.mDebugPanelVC = [[DebugPanelViewCotnroller alloc] init];
    [self.window.rootViewController.view addSubview:vars.mDebugPanelVC.view];
    vars.mDebugPanelVC.view.hidden = YES;    
    
    
    vars.mHiddenHelpVC = [[HiddenHelpViewCotnroller alloc] init];
    [self.window.rootViewController.view addSubview:vars.mHiddenHelpVC.view];
    vars.mHiddenHelpVC.view.hidden = YES;
    if(IS_HIDDEN_TOUCH_COMMAND_WORK) 
    {
        mHiddenCommandTopLeftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mHiddenCommandTopRightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mHiddenCommandBottomLeftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        mHiddenCommandBottomRightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        int maxWidth=320;
        int maxHeight=480;
        int touchSize=40;
        
        [mHiddenCommandTopLeftBtn setFrame:CGRectMake(0,0,touchSize,touchSize)];
        [mHiddenCommandTopLeftBtn setTitle:@"TL" forState:UIControlStateNormal];
        [mHiddenCommandTopLeftBtn addTarget:self action:@selector(clickHiddenTouchCommand:) forControlEvents:UIControlEventTouchUpInside];
        mHiddenCommandTopLeftBtn.alpha=0.2f;
        
        [mHiddenCommandTopRightBtn setFrame:CGRectMake(maxWidth-touchSize,0,touchSize,touchSize)];
        [mHiddenCommandTopRightBtn setTitle:@"TR" forState:UIControlStateNormal];
        [mHiddenCommandTopRightBtn addTarget:self action:@selector(clickHiddenTouchCommand:) forControlEvents:UIControlEventTouchUpInside];
        mHiddenCommandTopRightBtn.alpha = 0.2f;
        
        [mHiddenCommandBottomLeftBtn setFrame:CGRectMake(0,maxHeight-touchSize,touchSize,touchSize)];
        [mHiddenCommandBottomLeftBtn setTitle:@"BL" forState:UIControlStateNormal];
        [mHiddenCommandBottomLeftBtn addTarget:self action:@selector(clickHiddenTouchCommand:) forControlEvents:UIControlEventTouchUpInside];
        mHiddenCommandBottomLeftBtn.alpha = 0.2f;
        
        [mHiddenCommandBottomRightBtn setFrame:CGRectMake(maxWidth - touchSize,maxHeight-touchSize,touchSize,touchSize)];
        [mHiddenCommandBottomRightBtn setTitle:@"BR" forState:UIControlStateNormal];
        [mHiddenCommandBottomRightBtn addTarget:self action:@selector(clickHiddenTouchCommand:) forControlEvents:UIControlEventTouchUpInside];
        mHiddenCommandBottomRightBtn.alpha = 0.2f;
        
        [self.window.rootViewController.view addSubview:mHiddenCommandTopLeftBtn];
        [self.window.rootViewController.view addSubview:mHiddenCommandTopRightBtn];        
        [self.window.rootViewController.view addSubview:mHiddenCommandBottomLeftBtn];
        [self.window.rootViewController.view addSubview:mHiddenCommandBottomRightBtn];
    }
    
    
    
//    self.mPVC.view.hidden = YES;
//    self.window.rootViewController = vars.mSpeedCameraEVC;

    
    //change follow video process in behind by milo
//    [self.window makeKeyAndVisible];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//
//    //VIDEOkit init setting
//    [VIDEOkit sharedInstance];
//    [VIDEOkit startupWithDelegate:vars.interNav];

    
    
    //ExternalAccessory
    [self initRosenExternalAccessory];
    
    
    mIdleTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(idleTimerTimeOut) userInfo:nil repeats:YES];
    [self.mPVC.mScreenBlackBtn addTarget:self action:@selector(touchScreenBlackBtn:) forControlEvents:UIControlEventTouchUpInside];     
    mMainUIScreen = [UIScreen mainScreen];
    return YES;
    
}

-(void) hiddenTouchCommand:(NSString*)cmdStr {
    //< is mean Show
    //> is mean Hide
    //please refer to HiddenHelpViewController.xib
    GlobalVars *vars =[GlobalVars sharedInstance];
    if([cmdStr isEqualToString:@"^>"])
    {
        vars.mHiddenHelpVC.view.hidden = YES;
    }
    else if ([cmdStr isEqualToString:@"^<"])
    {
        vars.mHiddenHelpVC.view.hidden = NO;
        [vars.mHiddenHelpVC initDefaultValue];
    }
    else if([cmdStr isEqualToString:@"^^>"])
    {
        self.mPVC.view.hidden = YES;
    }
    else if([cmdStr isEqualToString:@"^^<"])
    {
        self.mPVC.view.hidden = NO;
    }
    else if([cmdStr isEqualToString:@"^^^>"])
    {
        vars.mDebugPanelVC.view.hidden = YES;
        NSLog(@"DebugPanelVC hide");
    }
    else if([cmdStr isEqualToString:@"^^^<"]) 
    {
        vars.mDebugPanelVC.view.hidden = NO;
        [vars.mDebugPanelVC initDefaultValue];
        NSLog(@"DebugPanelVC show");        
    }
    mTouchCmdsStr=@"";
}


-(IBAction)clickHiddenTouchCommand:(id)sender {
//    GlobalVars *vars  =[GlobalVars sharedInstance];
    
    if(mTouchCmdsStr==nil)mTouchCmdsStr = @"";
    if(sender == mHiddenCommandTopRightBtn) 
    {
        mTouchCmdsStr = [mTouchCmdsStr stringByAppendingString:@"^"];
    }
    else if(sender == mHiddenCommandBottomLeftBtn) 
    {

        mTouchCmdsStr = [mTouchCmdsStr stringByAppendingString:@"<"];        
    }
    else if(sender == mHiddenCommandBottomRightBtn) 
    {
        mTouchCmdsStr = [mTouchCmdsStr stringByAppendingString:@">"];        
    }
    else if(sender == mHiddenCommandTopLeftBtn) 
    {
        [self hiddenTouchCommand:mTouchCmdsStr];
        mTouchCmdsStr=@"";
    }
}



-(void) initRosenExternalAccessory {
    if(nil ==[self getRosenAccessory]) 
    {
        NSLogOut("Disconnect");
        [self.mPVC setUnPluggedNow];
    } else {
        NSLogOut("Disconnect");
        [self.mPVC setPluggingNow];
        [self restartRosenSession];
    }    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidConnect:) name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accessoryDidDisconnect:) name:EAAccessoryDidDisconnectNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    //    [[NSNotificationCenter defaultCenter]
    //     addObserver:self
    //     selector:@selector(batteryLevelUpdate)
    //     name:UIDeviceBatteryLevelDidChangeNotification
    //     object:nil];  
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryLevelDidChange:)
                                                 name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryStateDidChange:)
                                                 name:UIDeviceBatteryStateDidChangeNotification object:nil];    
}



-(void)deinitRosenExternalAccessory {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:EAAccessoryDidDisconnectNotification object:nil];    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryLevelDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceBatteryStateDidChangeNotification object:nil];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:NO];    
}



- (void)batteryLevelDidChange:(NSNotification *)notification
{
    float batteryLevel = [UIDevice currentDevice].batteryLevel;
    if (batteryLevel < 0.0)
    {
        NSLogOut(@"Unknown");
        [self setPowerStatusStr: @"Unknown Level"];
    }
    else {
        NSNumber *levelObj = [NSNumber numberWithFloat:batteryLevel];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
        [numberFormatter setMaximumFractionDigits:1];        
        NSString *str =  [numberFormatter stringFromNumber:levelObj];
        NSLogOut(@"%@",str);
    }
}


- (void)batteryStateDidChange:(NSNotification *)notification
{
    switch ([UIDevice currentDevice].batteryState) {
        case UIDeviceBatteryStateUnknown:
        {
            NSLogOut(@"Unknown");
            [self setPowerStatusStr:@"BatteryState Unknown" ];
            break;
        }
        case UIDeviceBatteryStateUnplugged:
        {
            NSLogOut(@"Unplugged");
            [self setPowerStatusStr:@"BatteryState Unplugged"];
            break;
        }
        case UIDeviceBatteryStateCharging:
        {
            NSLogOut(@"Charging");
            [self setPowerStatusStr:@"BatteryState Charging"];
            break;
        }
        case UIDeviceBatteryStateFull:
        {
            NSLogOut(@"Full");
            [self setPowerStatusStr:@"BatteryState Full"];
            break;
        }
    }
    NSLogOut(@"");
}

- (void)accessoryDidDisconnect:(NSNotification *)notification 
{
    NSLogOut(@"[notify] accessoryDidDisconnect");        
    NSLogOut("SetIdleTimerDisabled NO when detect accessory Did Disconnect");

    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [self performSelector:@selector(batteryStateDidChange:) withObject:nil];
    
    
    //check the connection for the RESiOS accessory in com.rosenapp.helloworld protocol
    EAAccessory *disconnectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    
//    if(![[disconnectedAccessory name] isEqualToString:ACCESSORY_NAME]) return;    
    for (NSString* protocolString in [disconnectedAccessory protocolStrings]) {
        
        if([protocolString isEqualToString:PROTOCOL_NAME]){        
            mRosenAccessory = nil;
            //            [GlobalVars sharedInstance].mHelloViewController.mDisConnLbl.text = @"disconnect";
            //            [GlobalVars sharedInstance].mHelloViewController.mConnLbl.text = @"";
            
            NSLogOut(@"[CONN STATUS] disconnect");
        }
    }
    

    NSLogOut("Disconnected");
    [self.mPVC setUnPluggedNow];
}


-(IBAction) actionToRestartRosenSession:(id)sender {
    [self restartRosenSession];
}





- (void)accessoryDidConnect:(NSNotification *)notification 
{
    NSLogOut(@"[notify] accessoryDidConnect");        
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [self performSelector:@selector(batteryStateDidChange:) withObject:nil];
    
    EAAccessory *connectedAccessory = [[notification userInfo] objectForKey:EAAccessoryKey];
    for (NSString* protocolString in [connectedAccessory protocolStrings])
    {
        if([protocolString isEqualToString:PROTOCOL_NAME])
        {
            mRosenAccessory = connectedAccessory;
            NSLogOut(@"[CONN STATUS] connect");
            [self restartRosenSession];
            //add by milo 
            [self.mPVC setPluggingNow];
            return;
        }
    }
    
    NSLogOut("Connected");
    //[self.mPVC setPluggingNow];
    [self.mPVC setUnPluggedNow];
    NSLogOut("There is no protocol for %@ on %@ currently",PROTOCOL_NAME, ACCESSORY_NAME);
}

-(void) restartRosenSession {
    NSLogOut(@"[enter] restartSoesnSession");    
    @try
    {
        if([self openRosenSession]) {
            NSLogOut(@"OK to open rosen session");
        } else  {
            NSLogOut(@"failed to open rosen session");
        }
    }
    @catch( NSException* exception)
    {
        UIAlertView *unavailableAlert = 
        [[UIAlertView alloc]
         initWithTitle:[exception name] message:[exception description] delegate:nil cancelButtonTitle:@"That's a good idea" otherButtonTitles:nil];
        [unavailableAlert show];
        unavailableAlert = nil;
    }
    @finally
    {
        NSLogOut(@"@finally for exception");
    }
    NSLogOut(@"[leave] restartSoesnSession");
}


-(BOOL) openRosenSession
{
    NSLogOut("[enter] openRosenSession");
    
    if(mSession != nil ) {
        [self closeRosenSession];
    } 
    else if (mRosenAccessory != nil) 
    {
        mRosenAccessory = nil;
    }
    
    if(mSession != nil) 
    {
        NSLogOut("[leave] openRosenSession ,it's failed since session cannnot be closed at the first");
        return NO; 
    }
    
    
    if([self getRosenAccessory] != nil) {
        NSLogOut(@"show Rosen Accessory 's protocol strings")        
        for (NSString* protocolString in [mRosenAccessory protocolStrings]){
            NSLogOut(@"%@", protocolString);
        }        
        mSession = [[EASession alloc] initWithAccessory:mRosenAccessory forProtocol:PROTOCOL_NAME];        
    } else {
        NSLogOut(@"[self getRosenAccessory] == nil");
        NSLogOut("[leave] openRosenSession, it's failed when open getRosenAccessory");
        return NO;
    }
    
    if(nil == mSession) 
    {
        NSLogOut("[leave] openRosenSession ,it's failed when open session");                
        return NO;        
    } 
    else 
    {

        [[mSession inputStream] setDelegate:self];
        [[mSession inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[mSession inputStream] open];
        
        [[mSession outputStream] setDelegate:self];
        [[mSession outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]  forMode:NSDefaultRunLoopMode];
        [[mSession outputStream] open];
        NSLogOut("[OK] openRosenSession ,it's OK to open session");
        
        [self showTopMenu] ;
        
    }
    
    NSLogOut("@[leave] openRosenSession");        
    return YES;
}


-(void) closeRosenSession 
{
    NSLogOut(@"[enter] closeRosenSession");
    if(nil != mSession) 
    {
        NSLogOut(@"nil != mSession, so to close it");    
        [[mSession inputStream] close];
        [[mSession inputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [[mSession inputStream] setDelegate:nil];
        [[mSession outputStream] close];
        [[mSession outputStream] removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [[mSession outputStream] setDelegate:nil];
        
        [mSession setIsAccessibilityElement:NO];
        mSession = nil;
        //        [mRosenAccessory release];
        mRosenAccessory = nil;
    }
    NSLogOut(@"[leave] closeRosenSession");
}


-(EAAccessory*) getRosenAccessory 
{
    NSLogOut(@"[enter]getRosenAccessory()");
    if(mRosenAccessory != nil) return mRosenAccessory;
    NSArray * accessoryArray = [[NSMutableArray alloc] initWithArray:[[EAAccessoryManager sharedAccessoryManager] connectedAccessories]];
    if([accessoryArray count] <= 0) {
        NSLogOut(@"[leave]getRosenAccessory & return nil because no any Accessory");
        return nil; 
    }
    
    for (EAAccessory * selAccessory in accessoryArray) 
    {
        NSString *accessoryName =[selAccessory name ];
        //        if([accessoryName isEqualToString:@"RESiOS"]) 
//        if([accessoryName isEqualToString:ACCESSORY_NAME])         
        if(YES)
        {
            if([selAccessory protocolStrings] <=0 ) return nil;    
            for (NSString *protocolString in [selAccessory protocolStrings]) {
                //                if([protocolString isEqualToString:@"com.rosenapp.helloworld"]) {
                if([protocolString isEqualToString:PROTOCOL_NAME]) {                
                    mRosenAccessory = selAccessory;
                    //                    [accessoryArray release];
                    accessoryArray = nil;
                    NSLogOut(@"[leave]getRosenAccessory & return mRosenAccessory");
                    return mRosenAccessory;
                }
            }
        }
        //        [accessoryArray release];
        accessoryArray = nil;
    }
    NSLogOut(@"[leave]getRosenAccessory & return nil");
    return nil;
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode) {
        case NSStreamEventNone:
            break;
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable:
            
            NSLogOut("read stream for NSStreamEventHasBytesAvailable");
            [self parseInputStream]; 
            break;
        case NSStreamEventHasSpaceAvailable:
            //            [self _writeData];
            //please refer helloworld.testEADemo for knowing how to send data.
            break;
        case NSStreamEventErrorOccurred:
            break;
        case NSStreamEventEndEncountered:
            break;
        default:
            break;
    }
}

-(void) parseExtDispByBuf:(uint8_t*)buf withSize:(int)size {
    

//    int bytesRead = size;
//    NSString *str = @"";
    
    if(buf == nil || size <= 0 || size < 7) return;
    
    
    
//    [self resend0x84SingleBeep:nil];
    
    uint8_t xHighVal = buf[2];
    uint8_t xLowVal = buf[3];
    uint8_t yHighVal = buf[4];
    uint8_t yLowVal = buf[5];
    
    uint8_t touchEventType = buf[6];
    uint16_t xVal = xHighVal*256 + xLowVal;
    uint16_t yVal = yHighVal*256 + yLowVal;
    
    
    
    
    
    
    
    int convertPosX = (int)(DISPLAY_OFFSET_X + xVal * ((DISPLAY_WIDTH)/TOUCH_X_MAX)); 
    int convertPosY = (int)(DISPLAY_OFFSET_Y + yVal * ((DISPLAY_HEIGHT)/TOUCH_Y_MAX));
    
    double displayOffsetX = DISPLAY_OFFSET_X;
    double displayOffsetY = DISPLAY_OFFSET_Y;
    double displayWidth = DISPLAY_WIDTH;
    double displayHeight = DISPLAY_HEIGHT;
    double touchXmax = TOUCH_X_MAX;
    double touchYmax = TOUCH_Y_MAX;
    
    
    //432*768 is 9:16
    
//    ViewController *vc = self.viewController;
    
//    vc.mRecvXLbl.text = [NSString stringWithFormat:@"%d",(int)xVal];
//    vc.mRecvYLbl.text = [NSString stringWithFormat:@"%d",(int)yVal];
    
    //    xVal = 35.0f + xVal * ((830.0f-35.0f)/800.0f);
    //    yVal = 12.0f + yVal * ((464.0f-12.0f)/480.0f);
    
//    xVal = 35.0f + xVal * ((830.0f-35.0f)/791.0f);
//    yVal = 12.0f + yVal * ((464.0f-12.0f)/467.0f);
    xVal = displayOffsetX + xVal * ((displayWidth)/touchXmax);
    yVal = displayOffsetY + yVal * ((displayHeight)/touchYmax);
    
    
    
    
    
//    vc.mTranXLbl.text = [NSString stringWithFormat:@"%d",(int)xVal];
//    vc.mTranYLbl.text = [NSString stringWithFormat:@"%d",(int)yVal];
    
    
    //432 ... 768  is 9:16
    
    //    if(touchEventType == 3 ) {
    
    
    //    if(   (self.viewController.mIsT0Detect && touchEventType == 0x00)
    //       || (self.viewController.mIsT3Detect && touchEventType == 0x03)
    //       ) {    
    
    //        if(   (touchEventType == 0x00)
    //           || (touchEventType == 0x03)
    //           ) {
    
//    if(self.viewController.mIsT0Detect && touchEventType == 0x00) { 
    if(touchEventType == 0x00) {             
        NSLogOut(@"Receive Touch Event Start as (x=%d,y=%d) with size=%d", xVal,yVal,size);
        //    [_viewController performTouchInVC:_viewController withX:(double)(xVal*1.0f+0.01f) andY:(double)(yVal*1.0f+0.01f)];
//        [_viewController performTouchInVC:evc withX:(double)(xVal) andY:(double)(yVal)];                
//        [_viewController performTouchInVC:evc withX:(double)(xVal) andY:(double)(yVal)];
        
        if(mIsExtTouchIn200ms == NO && mIsExterNavOnAnimated == NO) {
            
            [self performTouchInExternalViewControllerWithX:xVal andY:yVal];
            [self sendSingleBeep];
            mIsExtTouchIn200ms = YES;
            [self performSelector:@selector(cancelExtTouchIn200msFlag:) withObject:nil afterDelay:0.2];
        }
    }
    else {
        
    }
    
    //    int idx = 0; 
    //    for (idx = 0; idx < size;idx++ ) {
    //        uint8_t data = buf[idx];
    //        str = [str stringByAppendingFormat:@"[%d]=0x%02X ", idx,data];
    //        
    //    }
    //    return str;
}

-(NSString*) showBufAsStr:(uint8_t*)buf withSize:(int)size {
//    int bytesRead = size;
    NSString *str = @"";
    if(buf == nil || size <= 0) return str;
    int idx = 0; 
    for (idx = 0; idx < size;idx++ ) {
        uint8_t data = buf[idx];
        str = [str stringByAppendingFormat:@"[%d]=0x%02X ", idx,data];
        
    }
    return str;
}


-(IBAction) resend0x83Action:(id)sender 
{
    //dirty code for show status bar up
    //AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    int m0x83ActionsRequest = 0;
    
    //    if([mRequestAudioPathSwitch isOn]){
    if(NO){
        m0x83ActionsRequest = m0x83ActionsRequest | 0x01;
    }
    else 
    {
        m0x83ActionsRequest = ~(~m0x83ActionsRequest| 0x01);
    }
    
//    if([mShowTopBottomOverlaySwitch isOn]){
    if(YES){
        m0x83ActionsRequest = m0x83ActionsRequest | 0x04;
    }
    else 
    {
        m0x83ActionsRequest = ~(~m0x83ActionsRequest| 0x04);
    }    
    
    //    NSString * str = [NSString stringWithFormat:@"%02x%02x", 0x83, m0x83ActionsRequest];
    NSString * str = [NSString stringWithFormat:@"%02x%02x%02x", 0x83, m0x83ActionsRequest,0x00];
    //[dele sendHexStr:str];        
    [self sendHexStr:str];
}


- (void) parseInputStream {
    NSLogOut("[enter] parseInputStream");
#define EAD_INPUT_BUFFER_SIZE 128
    uint8_t buf[EAD_INPUT_BUFFER_SIZE];
//    uint8_t copyBuf[EAD_INPUT_BUFFER_SIZE];
    

    
    
    if(mSession == nil ) {
        NSLogOut("mSession == nil so will leave");
    } 
    else 
    {
        @try {        
            while ([[mSession inputStream] hasBytesAvailable])
            {
                
                NSInteger bytesRead = [[mSession inputStream] read:buf maxLength:EAD_INPUT_BUFFER_SIZE];
                uint8_t status1; //used by 0x00 Cmd Status/Config 
                uint8_t status2; //used by 0x00 Cmd Status/Config 
//                GlobalVars *vars = [GlobalVars sharedInstance];
                
                if(bytesRead < 1) return;
                if(buf[0]!=0x55) return;
                uint8_t * buf2 = &buf[1];
                
                
                switch(buf[1]) //Command ID
                {
                    case 0x00:
                        [self parse0x00StatusByBuf:buf2 withSize:bytesRead-1];
                        if(YES)break;
                        
                        
                        break;
                    case 0x01: //Command ID 0x01 for Remote Control Key
                        switch (buf[1]) {
                            case 0x01:NSLogOut("detect UP");break;
                            case 0x02:NSLogOut("detect DOWN");break;
                            case 0x03:NSLogOut("detect LEFT");break;
                            case 0x04:NSLogOut("detect RIGHT");break;
                            case 0x05:NSLogOut("detect Select");break;
                            case 0x06:NSLogOut("detect Back");break;
                            case 0x07:NSLogOut("detect Home");break;
                            case 0x08:NSLogOut("detect togglePlay/Pause");break;
                            case 0x09:NSLogOut("detect Play");break;
                            case 0x0A:NSLogOut("detect Pause");break;
                            case 0x0B:NSLogOut("detect Next");break;
                            case 0x0C:NSLogOut("detect Prev");break;
                            case 0x0D:NSLogOut("detect Fast Forward");break;
                            case 0x0E:NSLogOut("detect Rewind");break;
                            case 0x0F:NSLogOut("detect Stop");break;
                            case 0x10:NSLogOut("detect 0 key");break;
                            case 0x11:NSLogOut("detect 1 key");break;
                            case 0x12:NSLogOut("detect 2 key");break;
                            case 0x13:NSLogOut("detect 3 key");break;
                            case 0x14:NSLogOut("detect 4 key");break;
                            case 0x15:NSLogOut("detect 5 key");break;
                            case 0x16:NSLogOut("detect 6 key");break;
                            case 0x17:NSLogOut("detect 7 key");break;
                            case 0x18:NSLogOut("detect 8 key");break;
                            case 0x19:NSLogOut("detect 9 key");break;
                            default:
                                //NSLogOut("unknown data for Remote Control Key ... just detect [0]=0x%02X, [1]=0x%02X, [2]=0x%02X, [3]=0x%02X", buf[0],buf[1],buf[2],buf[3]);
                                NSLogOut("unknown data that detect %@",  [self showBufAsStr:buf withSize:bytesRead]);
                        }
                        break;
                        
                    case 0x02:
                        [self parseExtDispByBuf:buf2 withSize:bytesRead-1];                        
                        break;
                    default:
                        NSLogOut("unknown command data is  %@",  [self showBufAsStr:buf withSize:bytesRead]);
                        
                        break;
                } //switch
            } //while
        } 
        @catch (NSException *exception) {
            
        }
    }
    NSLogOut("[leave] parseInputStream");    
}


-(void) parse0x00StatusByBuf:(uint8_t*)buf withSize:(int)size 
{
    GlobalVars *vars =[GlobalVars sharedInstance];
    uint8_t status1;
    uint8_t status2;    
    status1 = buf[1];
    status2 = buf[2];
    
    
    if(status1 & 0x02)  //Power status on (bit1=1)
    {
        NSLogOut("detect Power");
        NSLogOut("SetIdleTimerDisabledYES when detect Power");
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        [vars.mPVC setPluggingNow];
        
        [self showTopMenu];
//        [self sendSingleBeep];
        
        
    } 
    else //Power status off (bit1=1)
    {            
        NSLogOut("detect No Power");
        NSLogOut("SetIdleTimerDisabled NO when detect No Power");
        if(PRESUME_MCU_CONNECT_12V) 
        {
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];      
        }
        else 
        {
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO]; 
        }
        [vars.mPVC setUnPluggedNow];
    }  
    if(status1 & 0x01)  //extending mode on (bit0=1)
    {
        //[ipvc notifyExtendingModeIsOn:YES];
    }
    else //extending mode off (bit0=0)
    {
        //[ipvc notifyExtendingModeIsOn:NO];                        
    }
}


- (void)performTouchInVC:(UIViewController *)vc withX:(double)posX andY:(double)posY
{
    NSLogOut("performTouchInVC(x=%g,y=%g)", posX,posY);
    //    UIView * view = vc.view;
    //    UITouch *touch = [[UITouch alloc] initInView:view];
    
//    GlobalVars *vars = [GlobalVars sharedInstance];
//    ExterViewController * evc = vars.mEVC;
    //evc.mPointerBtn.hidden = YES;
    //UIViewController * evc = vars.exterNav;
    
//    UIViewController *evc = vc;
    UITouch *touch = [[UITouch alloc] initInVC:vc withX:posX andY:posY];
    UIEvent *eventDown = [[UIEvent alloc] initWithTouch:touch];
    [touch.view touchesBegan:[eventDown allTouches] withEvent:eventDown];
    [touch setPhase:UITouchPhaseEnded];
    UIEvent *eventUp = [[UIEvent alloc] initWithTouch:touch];
    [touch.view touchesEnded:[eventUp allTouches] withEvent:eventUp];
    
//    evc.mPointerBtn.hidden = NO;    
}


- (void)performTouchInExternalViewControllerWithX:(double)posX andY:(double)posY
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    UIViewController * evc = vars.exterNav;
    

    [self performTouchInVC:evc withX:posX andY:posY];

}



- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    [[UIScreen mainScreen] setBrightness:0.5];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIScreen mainScreen] setBrightness:0.5];    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [mMainUIScreen setBrightness:0.5];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [UIApplication sharedApplication].idleTimerDisabled=YES;    
  
    [[UIScreen mainScreen] setBrightness:0.5];
    [self performSelector:@selector(batteryStateDidChange:) withObject:nil];
    [self timeOutRecount];    
    
    
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [self deinitRosenExternalAccessory];

    

}






//SleedMode

-(IBAction) touchScreenBlackBtn:(id)sender {
    //    if(sender == self.mPVC.mScreenBlackBtn) {
    mTimeOutCnt = 1;
    [self.mPVC setScreenBlack:YES animated:NO];
    [self.mPVC setScreenBlack:NO animated:YES];         
    //    } else {    
    //        [self timeOutRecount];
    //        mTimeOutCnt = 1;
    //        [self.mPVC setScreenBlack:NO animated:NO];        
    //    }
}


//-(void) setScreenBlack:(BOOL)isBlack: (BOOL)animated ;
- (void) idleTimerTimeOut {

//    GlobalVars *vars =[GlobalVars sharedInstance];
//    NSArray * vcArray = [vars.interNav viewControllers];
    
    if(mTimeOutCnt >= 10) {
        if(mTimeOutCnt == 10) 
        { 
            [self.mPVC setScreenBlack:YES animated:YES];
            [UIScreen mainScreen].brightness = 0.5; //don't let brigtness dark since iPhone's bug
            mTimeOutCnt = mTimeOutCnt + 1;
        }
        else 
        {
            
        }
    } 
    else 
    {
        if(mTimeOutCnt == 0 ) {
            [self.mPVC setScreenBlack:NO animated:NO]; 
        }
        mTimeOutCnt = mTimeOutCnt + 1;
        [UIScreen mainScreen].brightness = 0.5;
    }
}

- (void) timeOutRecount {
    mTimeOutCnt = 0;
}


- (void) setPowerStatusStr: (NSString*) str {
    NSLog(@"setPowerStatusStr as %@",str );
//    mPVC.mPowerStatusLbl.text = str;
//    GlobalVars *vars = [GlobalVars sharedInstance];
    //    vars.mMovieEPVC.mTimerBarLbl.text = str;
}


- (void)sendDoubleBeep {
    [self performSelector:@selector(resend0x84DoubleBeep:) withObject:nil afterDelay:0.5];
}

- (void)sendSingleBeep{
    [self performSelector:@selector(resend0x84SingleBeep:) withObject:nil afterDelay:0.5];
}

-(void) showTopMenu {
    [self performSelector:@selector(resend0x83Action:) withObject:nil afterDelay:0.5];
}




-(IBAction)resend0x84SingleBeep:(id)sender {
    //AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate;    
    //    NSString * str = [NSString stringWithFormat:@"%02x%02x", 0x84, 0x01];
    NSString * str = [NSString stringWithFormat:@"%02x%02x%02x", 0x84, 0x01,0x00];
    [self sendHexStr:str];            
}



-(IBAction)resend0x84DoubleBeep:(id)sender {
    //AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate;    
    //    NSString * str = [NSString stringWithFormat:@"%02x%02x", 0x84, 0x02];
    NSString * str = [NSString stringWithFormat:@"%02x%02x%02x", 0x84, 0x02,0x00];    
    [self sendHexStr:str];            
}



- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"didShowViewController with animate=%d", (int)animated);

}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"willShowViewController with animate=%d", (int)animated);

}



-(void) notifyExterNavAnimatedStatus:(BOOL)isAnimated
{
    if(isAnimated) {
//        NSLog(@"notifyExterNavAnimatedStatus is anmiated");
//        mIsExterNavOnAnimated = YES;
    }
    else {
//        NSLog(@"notifyExterNavAnimatedStatus is not animated");
//        mIsExterNavOnAnimated = NO;
    }
}



@end
