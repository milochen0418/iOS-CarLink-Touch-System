//
//  PanelViewCotnroller.h
//  helloworld
//
//  Created by Milo Chen on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IS_OPEN_MUSIC_VIDEO_CMD_TEST NO

#import "MTPopupWindow.h"


@interface PanelViewCotnroller : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSTimeInterval mOldClickUpBtnTime;
    NSTimeInterval mOldClickDownBtnTime;
    
    UILabel * mVersionLbl;
    UIButton * mScreenBlackBtn;

    UILabel * mPowerStatusLbl;    
    
    UIImageView * mUnPluggedImageView;
    UIImageView * mPluggedImageView;
    UIImageView * mPluggedLogoImageView;
    UIImageView * mPluggedInYourDeviceImageView;
//    UITableView * mTableView;
//    UITextView * mTableView;
    UIView * mSubView;
    

    NSTimer * mLazyTblAnimTimer;
    int mLazyTblAnimTimeOutCnt;
    
    UILabel * mNowPlayingLbl; //show Now Playing word
    UILabel * mNowPlayingItemLbl;//show name of Item that now playing
    BOOL  mIsPluggingNow;
    

    
    //IS_OPEN_MUSIC_VIDEO_CMD_TEST
    UIView * mMusicVideoCmdView;
    UIButton * mMusicVideoCmdViewToggleBtn;
    UISlider * mSet2ndCatetorySlider;
    UISlider * mSetBBTrackNumSlider;
    UILabel * mSendByteStrLbl;
    uint8_t m2ndCatetoryVal;
    uint8_t mBBTrackNumVal;
    
    UISlider * mDbgMouseXSlider;
    UISlider * mDbgMouseYSlider;    
    
    
    UIButton *mSettingsBtn;
    UIButton *mAppsBtn;
    
//    UIView * mTestPopupView;
    int mPopupWindowId;
    
}

@property (nonatomic,strong)IBOutlet UIView * mDbgControlPanel;
@property (nonatomic,strong)IBOutlet UIButton* mPlugBtn;
@property (nonatomic,strong)IBOutlet UIButton* mUnplugBtn;

@property (nonatomic) int mPopupWindowId;


-(IBAction)openPopup:(id)sender;
//@property (nonatomic,strong) IBOutlet UIView * mTestPopupView;

-(IBAction) testBeep:(id)sender;

-(IBAction) resend0x83Action:(id)sender ;


@property (nonatomic,strong) IBOutlet UIButton *mSettingsBtn;
@property (nonatomic,strong) IBOutlet UIButton *mAppsBtn;

-(void) changeBtnIntoBlk:(UIButton*)btn ;

@property (nonatomic,strong) IBOutlet UISlider * mDbgMouseXSlider;
@property (nonatomic,strong) IBOutlet UISlider * mDbgMouseYSlider;
-(IBAction)slideToChangeDbgMouseX:(id)sender;
-(IBAction)slideToChangeDbgMouseY:(id)sender;

-(IBAction)clickToUnplug:(id)sender;
-(IBAction)clickToPlug:(id)sender;

-(IBAction) performScreenBlackBtnHidden:(id)sender;

//IS_OPEN_MUSIC_VIDEO_CMD_TEST
@property (nonatomic,strong) IBOutlet UIView * mMusicVideoCmdView;
@property (nonatomic,strong) IBOutlet UIButton * mMusicVideoCmdViewToggleBtn;
@property (nonatomic) uint8_t m2ndCatetoryVal;
@property (nonatomic) uint8_t mBBTrackNumVal;
@property (nonatomic,strong) IBOutlet UISlider * mSet2ndCatetorySlider;
@property (nonatomic,strong) IBOutlet UISlider * mSetBBTrackNumSlider;
@property (nonatomic,strong) IBOutlet UILabel * mSendByteStrLbl;
-(IBAction)clickToTogglemMusicVideoCmdView:(id)sender;
-(IBAction)slideToSet2ndCatetory:(id)sender;
-(IBAction)slideToSetBBTrackNum:(id)sender;
-(void) sendTestHexStr;
-(IBAction) playThirdMovie:(id)sender;
-(void) playDRMwithCategory:(uint8_t)categoryByte secondCategoryByte:(uint8_t)secondCatetoryByte withTrackNumber:(uint16_t)trackNumber;



@property (nonatomic) NSTimeInterval mOldClickUpBtnTime;
@property (nonatomic) NSTimeInterval mOldClickDownBtnTime;



@property (nonatomic,strong) IBOutlet UILabel * mVersionLbl;
@property (nonatomic, strong) NSTimer * mLazyTblAnimTimer;
@property (nonatomic) int mLazyTblAnimTimeOutCnt;



@property (nonatomic, strong) IBOutlet UIView * mSubView;


@property (nonatomic) BOOL mIsPluggingNow;
-(void) setScreenBlack:(BOOL)isBlack animated:(BOOL)animated ;

-(void) setPluggingNow;
-(void) setUnPluggedNow;

-(void) refreshListItems;
-(void) lazyTblAnimTimerTimeOut:(NSNotification *) notification;


-(IBAction) clickToOpenSettings:(id)sender;
-(IBAction) clickToOpenApps:(id)sender;

@property (nonatomic,strong) IBOutlet UIButton * mScreenBlackBtn;

@property (nonatomic,strong) IBOutlet UIImageView *mUnPluggedImageView;
@property (nonatomic,strong) IBOutlet UIImageView *mPluggedImageView;
@property (nonatomic,strong) IBOutlet UIImageView * mPluggedLogoImageView;
@property (nonatomic,strong) IBOutlet UIImageView * mPluggedInYourDeviceImageView;

-(IBAction)clickToLaunchWeather:(id)sender;
-(IBAction)clickToLaunchSpeedCamera:(id)sender;
-(IBAction)clickToLaunchCarMediaCenter:(id)sender;
-(IBAction)clickToLaunchTraffic:(id)sender;
-(IBAction)clickToBackInExternal:(id)sender;

-(IBAction)clickToMouseClick:(id)sender;


- (IBAction)sendSingleBeep:(id)sender;


@property (nonatomic,strong) IBOutlet UILabel * mNetworkConnStatusLbl;
@end
