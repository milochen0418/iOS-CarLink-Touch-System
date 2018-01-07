//
//  PanelViewCotnroller.m
//  helloworld
//
//  Created by Milo Chen on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PanelViewCotnroller.h"
#import "GlobalVars.h"
//#import "InterPageViewController.h"
//#import "NSTimer+Blocks.h"
@implementation PanelViewCotnroller
@synthesize mUnPluggedImageView,mScreenBlackBtn;
@synthesize mPluggedLogoImageView, mPluggedImageView;
@synthesize mSubView;
@synthesize mPluggedInYourDeviceImageView;
@synthesize mLazyTblAnimTimer, mLazyTblAnimTimeOutCnt;
@synthesize mVersionLbl;
@synthesize mIsPluggingNow;


@synthesize mOldClickUpBtnTime;
@synthesize mOldClickDownBtnTime;

@synthesize mDbgMouseXSlider,mDbgMouseYSlider;
@synthesize mAppsBtn,mSettingsBtn;
@synthesize mDbgControlPanel;


//IS_OPEN_MUSIC_VIDEO_CMD_TEST
@synthesize mMusicVideoCmdView,mMusicVideoCmdViewToggleBtn;
@synthesize mSet2ndCatetorySlider,mSetBBTrackNumSlider,mSendByteStrLbl,m2ndCatetoryVal,mBBTrackNumVal;

//@synthesize mTestPopupView;

@synthesize mPopupWindowId;

@synthesize mPlugBtn,mUnplugBtn;


@synthesize mNetworkConnStatusLbl;

-(IBAction)testBeep:(id)sender {
//    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication];
//    [dele resend0x84SingleBeep:nil];    
//    [self sendSingleBeep];
    [self performSelector:@selector(sendSingleBeep:) withObject:nil afterDelay:0.5];
}



-(IBAction)openPopup:(id)sender
{
//    [MTPopupWindow showWindowWithHTMLFile:@"testContent.html" insideView:self.view];
    GlobalVars *vars = [GlobalVars sharedInstance];
    UIViewController * vc = [vars.exterNav topViewController];
    
    mPopupWindowId = mPopupWindowId+1;
    int switchId = mPopupWindowId % 3;
        NSLog(@"switchId = %d, mPopupWindowId = %d", switchId,mPopupWindowId);
//    return;
    switch (switchId) {
        case 0:
            [MTPopupWindow showWindowWithHTMLFile:@"testContent.html" insideView:vc.view];            
            break;
        case 1:
            [MTPopupWindow showWindowWithView:vars.mAddCameraAlertVC.view insideView:vc.view];            
            break;
        case 2:
            [MTPopupWindow showWindowWithView:vars.mAppsListIVC.view insideView:vc.view];  
            break;
    }
}



-(IBAction)slideToChangeDbgMouseX:(id)sender {
    UISlider * slider = (UISlider*)sender;
    double x = mDbgMouseXSlider.value * 795 + 35.0f;
//    double y = mDbgMouseYSlider.value * 452 + 12.0f;
    double y = mDbgMouseYSlider.value * 452*2 + 12.0f;
    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIButton * dbgMouseBtn = dele.mDbgMouseBtn;
    dbgMouseBtn.frame = CGRectMake(x-10, y-10, 20, 20);
}

-(IBAction)slideToChangeDbgMouseY:(id)sender {
    double x = mDbgMouseXSlider.value * 795 + 35.0f;
//    double y = mDbgMouseYSlider.value * 452 + 12.0f;
    double y = mDbgMouseYSlider.value * 452*2 + 12.0f;    
    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIButton * dbgMouseBtn = dele.mDbgMouseBtn;
    dbgMouseBtn.frame = CGRectMake(x-10, y-10, 20, 20);
}

-(IBAction)clickToMouseClick:(id)sender 
{
    double x = mDbgMouseXSlider.value * 795 + 35.0f;
//    double y = mDbgMouseYSlider.value * 452 + 12.0f;
    double y = mDbgMouseYSlider.value * 452 *2 + 12.0f;    
    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    UIButton * dbgMouseBtn = dele.mDbgMouseBtn;
    
    dbgMouseBtn.hidden = YES;
    [dele performTouchInExternalViewControllerWithX:x andY:y];
    dbgMouseBtn.hidden = NO;
}


-(IBAction)clickToLaunchWeather:(id)sender 
{
    NSLog(@"clickToLaunchWeather");    
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav pushViewController:(UIViewController*)vars.mWeatherIVC animated:YES];    
    [vars.exterNav pushViewController:(UIViewController*)vars.mWeatherEVC animated:YES];    
}


-(IBAction)clickToLaunchSpeedCamera:(id)sender 
{
    NSLog(@"clickToLaunchSpeedCamera");
    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.interNav pushViewController:(UIViewController*)vars.mSpeedCameraIVC animated:YES];
    [vars.exterNav pushViewController:(UIViewController*)vars.mSpeedCameraEVC animated:YES];            
//    [vars.interNav pushViewController:(UIViewController*)vars.mSpeedCameraEVC animated:YES];        
}


-(IBAction)clickToLaunchCarMediaCenter:(id)sender 
{
    NSLog(@"clickToLaunchCarMediaCenter");    
}


-(IBAction)clickToLaunchTraffic:(id)sender 
{
    NSLog(@"clickToLaunchTraffic");        
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.exterNav pushViewController:(UIViewController*)vars.mTrafficEVC animated:YES];            
}

-(IBAction)clickToBackInExternal:(id)sender {
    NSLog(@"clickToBackInExternal");
    GlobalVars *vars = [GlobalVars sharedInstance];
    UIViewController * vc = [vars.exterNav topViewController];
    [vc performSelector:@selector(clickToBack:) withObject:nil];
}


-(IBAction)clickToUnplug:(id)sender {
    [self setUnPluggedNow];
}


-(IBAction)clickToPlug:(id)sender {
    [self setPluggingNow];
    //[self performSelector:@selector(resend0x83Action:) withObject:nil afterDelay:0.5];
}



-(IBAction)clickToTogglemMusicVideoCmdView:(id)sender {
    if(mMusicVideoCmdView.hidden == NO) {
        mMusicVideoCmdView.hidden = YES; 
    } else {
        mMusicVideoCmdView.hidden = NO;
    }
}


-(IBAction)slideToSet2ndCatetory:(id)sender {
    UISlider *slider = (UISlider*)sender;
    CGFloat val = [slider value]*10.0f;
    int intVal = (int)val;
    if(val >= 9.01f ) intVal = 9;
    if(val < 0.0001f) intVal = 0;
    m2ndCatetoryVal = intVal;
    mSendByteStrLbl.text = [NSString stringWithFormat:@"82 01 %02x 00 %02x", m2ndCatetoryVal,mBBTrackNumVal];
}


-(IBAction)slideToSetBBTrackNum:(id)sender {
    UISlider *slider = (UISlider*)sender;
    CGFloat val = [slider value]*10.0f;
    int intVal = (int)val;
    if(val >= 9.01f ) intVal = 9;
    if(val < 0.0001f) intVal = 0;
    mBBTrackNumVal = intVal;
    mSendByteStrLbl.text = [NSString stringWithFormat:@"82 01 %02x 00 %02x", m2ndCatetoryVal,mBBTrackNumVal];    
}

-(IBAction) sendSettingByteStr:(id)sender {
    [self playDRMwithCategory:0x01 secondCategoryByte:m2ndCatetoryVal withTrackNumber:(uint16_t)mBBTrackNumVal];    
}


-(IBAction) playThirdMovie:(id)sender {
//    [self sendTestHexStr];
    self.mMusicVideoCmdView.hidden = YES;
    [self playDRMwithCategory:0x00 secondCategoryByte:0xff withTrackNumber:0x0002];
}


-(IBAction)clickToSend_82_01_01_00_00:(id)sender {
    [self playDRMwithCategory:0x01 secondCategoryByte:0x00 withTrackNumber:0x0000];
}

-(IBAction)clickToSend_82_01_01_00_01:(id)sender {
    [self playDRMwithCategory:0x01 secondCategoryByte:0x00 withTrackNumber:0x0001];    
}

-(IBAction)clickToSend_82_01_01_01_00:(id)sender {
    [self playDRMwithCategory:0x01 secondCategoryByte:0x01 withTrackNumber:0x0000];
}

-(IBAction)clickToSend_82_01_01_01_01:(id)sender {
    [self playDRMwithCategory:0x01 secondCategoryByte:0x01 withTrackNumber:0x0001];
}




-(void) lazyTblAnimTimerTimeOut:(NSNotification *) notification 
{
    if(mLazyTblAnimTimeOutCnt >= 20 ) 
    {
        if(mLazyTblAnimTimer != nil) 
        {
            [mLazyTblAnimTimer invalidate];
            mLazyTblAnimTimer = nil;
        }

        [UIView beginAnimations:@"table-animation" context:nil];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationDuration:0.2];

        if(IS_NEED_PLUG_UNPLUG_BTN) {
            mSubView.alpha = 1.0; 
        }else {
            
            mSubView.hidden = YES;
        }

        [UIView commitAnimations];
        NSLog(@"mTableView.alpha = 1.0");
    }
    else 
    {
        mLazyTblAnimTimeOutCnt = mLazyTblAnimTimeOutCnt + 1;        
    }
}

-(void) startLazyTblAnimTimer {
    if(mLazyTblAnimTimer != nil) {
        return;
    }
    mLazyTblAnimTimeOutCnt = 0;
    mLazyTblAnimTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(lazyTblAnimTimerTimeOut:) userInfo:nil repeats:YES];
}
-(void) closeLazyTblAnimTimer {
    if(mLazyTblAnimTimer != nil) {
        [mLazyTblAnimTimer invalidate];
        mLazyTblAnimTimer = nil;
    }
    mLazyTblAnimTimeOutCnt = 0;
    
}




-(void) setPluggingNow 
{    
    mIsPluggingNow = YES;
    mPluggedLogoImageView.hidden = NO;    
    [UIView beginAnimations:@"box-animate" context:nil];
    [UIView setAnimationDuration:2];
    mUnPluggedImageView.alpha = 0.0;
    mPluggedInYourDeviceImageView.alpha=0.0;
    [self.mPluggedLogoImageView setFrame:CGRectMake(0,-50,320,460)];    
//mTableView.alpha = 1.0;
    
    [UIView commitAnimations];
    
    
    [self startLazyTblAnimTimer];
    
    mPowerStatusLbl.hidden = YES;
    mScreenBlackBtn.hidden = YES;
    mPluggedImageView.hidden = NO;
}


-(void) setUnPluggedNow 
{
    
//    [self setPluggingNow];
//    return; 
    
    
    mIsPluggingNow = NO;
    mPluggedLogoImageView.hidden = NO;
    [self closeLazyTblAnimTimer];
    [UIView beginAnimations:@"table-animation" context:nil];
    [UIView setAnimationDuration:0.1];
    mSubView.alpha = 0.0;

    
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:@"box-animate" context:nil];
    [UIView setAnimationDelay:0.1];
    [UIView setAnimationDuration:1];
    mUnPluggedImageView.alpha = 1.0;  
    mPluggedInYourDeviceImageView.alpha=1.0;
//    mTableView.alpha = 0.0;
//    [self.mPluggedLogoImageView setFrame:CGRectMake(100,100,100,100)];
    [self.mPluggedLogoImageView setFrame:CGRectMake(0,50,320,460)];    
    [UIView commitAnimations];
   
//    mUnPluggedImageView.hidden = NO;
//    mTableView.hidden = YES;    
    
    mPowerStatusLbl.hidden = YES;    
    mScreenBlackBtn.hidden = YES;
    mPluggedImageView.hidden = NO;

}


-(IBAction) resend0x83Action:(id)sender 
{
    //dirty code for show status bar up
    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
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
    [dele sendHexStr:str];        
    
}



-(IBAction) performScreenBlackBtnHidden:(id)sender {
    mScreenBlackBtn.hidden = YES;
}


-(void) setScreenBlack:(BOOL)isBlack animated:(BOOL)animated 
{
    if(animated) {
        if(isBlack) {
            mScreenBlackBtn.hidden = NO;
            mScreenBlackBtn.alpha = 0.75;            
            [UIView beginAnimations:@"backlight-off-animate" context:nil];
            [UIView setAnimationDuration:10.0];
            mScreenBlackBtn.alpha = 1.0;
            [UIView commitAnimations];
        } else {
            mScreenBlackBtn.hidden = NO;
//            mScreenBlackBtn.alpha = 1.0;
            mScreenBlackBtn.alpha = 0.9;
            [UIView beginAnimations:@"backlight-on-animate" context:nil];
            [UIView setAnimationDuration:3.0];
            mScreenBlackBtn.alpha = 0.0;
            //mScreenBlackBtn.hidden = YES;
            [UIView commitAnimations];
            
//            NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(performScreenBlackBtnHidden:) userInfo:nil repeats:NO];
            
        }
    } 
    else 
    {
        if(isBlack) {
            mScreenBlackBtn.hidden = NO;
        } else {
            mScreenBlackBtn.hidden = YES;
        }
    }
}

-(void) recountSleepMode {
    GlobalVars *vars = [GlobalVars sharedInstance];
    if(vars.mAppDelegate.mTimeOutCnt >= 10) {
        [self.mScreenBlackBtn sendActionsForControlEvents:UIControlEventTouchUpInside];      
    }
    else {
        [vars.mAppDelegate timeOutRecount];
    }
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
    [self changeBtnIntoBlk:mSettingsBtn];
    [self changeBtnIntoBlk:mAppsBtn];
    
//    [self performSelector:@selector(resend0x83Action:) withObject:nil afterDelay:5];
    if(!IS_NEED_PLUG_UNPLUG_BTN) {
        mUnplugBtn.hidden = YES;
        mPlugBtn.hidden = YES;
        mDbgControlPanel.hidden =YES;
    }
    else {
        mUnplugBtn.hidden = NO;
        mPlugBtn.hidden = NO;
        mDbgControlPanel.hidden =NO;
        
    }
    
//    changeBtnIntoBlk

    
    if(IS_OPEN_MUSIC_VIDEO_CMD_TEST) {
        self.mMusicVideoCmdView.hidden = NO;
        self.mMusicVideoCmdViewToggleBtn.hidden = NO;
    }
    else {
        self.mMusicVideoCmdView.hidden = YES;
        self.mMusicVideoCmdViewToggleBtn.hidden = YES;
    }
    
//    mTableView.backgroundColor = [UIColor clearColor];
    mSubView.alpha = 0.0; 

    
    NSString *shortVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];    
    NSString *showVerStr = [NSString stringWithFormat:@"ver %@(%@)",shortVersion, version ];
    mVersionLbl.text = showVerStr;
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mSubView = nil;    

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void) refreshListItems {
  
    //[self.mScreenBlackBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self recountSleepMode];    
//    [vars.mAppDelegate timeOutRecount];
    
    //GlobalVars *vars = [GlobalVars sharedInstance];  
}


-(IBAction) clickToOpenSettings:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav pushViewController:vars.mSettingsIVC animated:YES];
    [vars.exterNav pushViewController:vars.mSettingsEVC animated:YES];    
    vars.mAppDelegate.mPVC.view.hidden= YES;
}


-(IBAction) clickToOpenApps:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];    
    [vars.interNav pushViewController:vars.mAppsListIVC animated:YES];
    [vars.exterNav pushViewController:vars.mAppsListEVC animated:YES];    
    vars.mAppDelegate.mPVC.view.hidden= YES;    
}

-(void) changeBtnIntoBlk:(UIButton*)btn 
{
    //please makesure that button height is bigger than or equal to 48px
    //button is set as customType in .xib file
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    
    UIImage * blackImage = [[UIImage imageNamed:@"blk_button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21];
    
    [btn setBackgroundImage:blackImage forState:UIControlStateNormal];
	[btn setBackgroundImage:blackImage forState:UIControlStateDisabled];
	[btn setEnabled:YES];    
}


- (IBAction)sendSingleBeep:(id)sender{
    
    NSString * hexStr = [NSString stringWithFormat:@"%02x%02x%02x", 0x84, 0x01, 0x00];
    AppDelegate * dele = ((AppDelegate*)[UIApplication sharedApplication].delegate);
//    [dele performSelector:@selector(resend0x84SingleBeep:) withObject:nil afterDelay:0.5];
    [dele sendHexStr:hexStr];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{

    return UIInterfaceOrientationMaskAll; // use what is appropriate for you.
    
}


@end
