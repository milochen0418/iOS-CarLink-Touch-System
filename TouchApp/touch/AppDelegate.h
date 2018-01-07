//
//  AppDelegate.h
//  touch
//
//  Created by Milo Chen on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import "Reachability.h"

@class ViewController;
@class PanelViewCotnroller;

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSStreamDelegate,UINavigationControllerDelegate> {
    //support EAAccessory
    EAAccessory *mRosenAccessory;
    EASession *mSession;
    
    //variables for implement sendHexStr
    NSMutableData * mWriteData;
    
    UILabel * mRosenLbl;
    
    //support PanelViewController;
    PanelViewCotnroller *mPVC;
    NSTimer *mIdleTimer;
    int mTimeOutCnt;
    UIScreen *mMainUIScreen;
    
    
    
    //for IS_HIDDEN_TOUCH_COMMAND_WORK
    UIButton *mHiddenCommandTopLeftBtn;
    UIButton *mHiddenCommandTopRightBtn;
    UIButton *mHiddenCommandBottomLeftBtn;
    UIButton *mHiddenCommandBottomRightBtn;
    NSString *mTouchCmdsStr;
    
    UIButton *mDbgMouseBtn;
    
}
@property (strong, nonatomic) Reachability * mReachability;



//functions for implement sendHexStr
- (void)_writeData;
- (void)writeData:(NSData *)data;
@property (nonatomic,strong) NSMutableData * mWriteData;
- (void)sendHexStr:(NSString*)hexStr;


@property (nonatomic,strong) UIButton * mDbgMouseBtn;


@property (nonatomic,strong) NSString* mTouchCmdsStr;
-(void) hiddenTouchCommand:(NSString*)cmdStr;

@property (nonatomic,strong) UIButton *mHiddenCommandTopLeftBtn;
@property (nonatomic,strong) UIButton *mHiddenCommandTopRightBtn;
@property (nonatomic,strong) UIButton *mHiddenCommandBottomLeftBtn;
@property (nonatomic,strong) UIButton *mHiddenCommandBottomRightBtn;
-(IBAction)clickHiddenTouchCommand:(id)sender ;


@property (nonatomic,strong) UILabel * mRosenLbl;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;


//support PanelViewController
@property (nonatomic,strong) PanelViewCotnroller *mPVC;
@property (nonatomic,strong) NSTimer * mIdleTimer;
@property (nonatomic) int mTimeOutCnt;
@property (nonatomic,strong) UIScreen *mMainUIScreen;
- (void) timeOutRecount;



//ExternalAccessory
@property (nonatomic,strong) EAAccessory * mRosenAccessory;
@property (nonatomic,strong) EASession *mSession;
- (void) initRosenExternalAccessory;
- (void) deinitRosenExternalAccessory;
- (EAAccessory*) getRosenAccessory;
- (void)accessoryDidDisconnect:(NSNotification *)notification;
- (void)accessoryDidConnect:(NSNotification *)notification;
- (void) restartRosenSession;
- (BOOL) openRosenSession;
- (void) closeRosenSession;
- (void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode;
- (void) parseInputStream;
- (NSString*) showBufAsStr:(uint8_t*)buf withSize:(int)size;
- (void) parseExtDispByBuf:(uint8_t*)buf withSize:(int)size;
- (void)batteryLevelDidChange:(NSNotification *)notification;
- (void)batteryStateDidChange:(NSNotification *)notification;
- (void)performTouchInVC:(UIViewController *)vc withX:(double)posX andY:(double)posY;
- (void)performTouchInExternalViewControllerWithX:(double)posX andY:(double)posY;


- (void)sendDoubleBeep;
- (void)sendSingleBeep;


-(void) parse0x00StatusByBuf:(uint8_t*)buf withSize:(int)size;

+(NSString *) getHostName;
+(NSString *) getWeatherApiUrl;
+(NSString *) getTrafficApiUrl;



-(IBAction)resend0x84SingleBeep:(id)sender ;
-(IBAction)resend0x84DoubleBeep:(id)sender ;

@property (nonatomic) BOOL mIsExtTouchIn200ms;
-(IBAction) cancelExtTouchIn200msFlag:(id)sender;
-(void) notifyExterNavAnimatedStatus:(BOOL)isAnimated;
@property (nonatomic) BOOL mIsExterNavOnAnimated;

@end
