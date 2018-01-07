//
//  ExterViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class ParseHelper;
@interface ExterViewController : UIViewController {

    
    //Speed Camera Widget
    UILabel * mDistAndDirLbl;
    UILabel * mCameraTypeLbl;
    UILabel * mAddrLbl;
    UILabel * mSpeedLimitLbl;
    
    //Weather Widget
    UILabel * mTmpLbl;
    UILabel * mLoTmpLbl;
    UILabel * mHiTmpLbl;
    UIImageView * mTodayWeatherImgView;
    bool mIsSelectC;
    NSString * mCurCityName;
    NSString * mLocId;
    

    
    //Traffic Widget
    NSMutableArray * mTrafficWidgetObjs;
    UILabel * mRoadwayAndDirLbl;
    UILabel * mTrafficItemTypeDescLbl;
    UIImageView * mTrafficSignImgView;
    UIImageView * mRoadwaySignImgView;
    
//    UILabel * mTrafficWidgetLbl1;
//    UILabel * mTrafficWidgetLbl2;
//    UILabel * mTrafficWidgetLbl3;
    
    //SpeedCamera and Gps applciation
    CLGeocoder * mGeocoder;
    CLLocationManager * mLocationManager;
    CLLocation * mGpsCLLocation;
    CLLocation * mReverseGeocodeGpsLocation;
    UIImageView * mTypeImg;
    BOOL mIsInitWeatherWidget;
    
    
}
@property (nonatomic,strong) IBOutlet UILabel * mNoTrafficIncidentLbl;
@property (nonatomic,strong) IBOutlet UILabel * mNoCameraDetectedLbl;
@property (nonatomic) BOOL mIsInitWeatherWidget;
@property (nonatomic,strong) ParseHelper * mParseHelper;
@property (nonatomic,strong) IBOutlet UIImageView * mTypeImg;

@property (nonatomic,strong) IBOutlet UIImageView * mTrafficSignImgView;
@property (nonatomic,strong) IBOutlet UIImageView * mRoadwaySignImgView;



//Traffic Widget
@property (nonatomic,strong) IBOutlet UILabel * mRoadwayAndDirLbl;
@property (nonatomic,strong) IBOutlet UILabel * mTrafficItemTypeDescLbl;
@property (nonatomic,strong) NSMutableArray * mTrafficWidgetObjs;

@property (nonatomic,strong) IBOutlet UILabel * mTmpLbl;
@property (nonatomic,strong) IBOutlet UILabel * mLoTmpLbl;
@property (nonatomic,strong) IBOutlet UILabel * mHiTmpLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mTodayWeatherImgView;
@property (nonatomic) bool mIsSelectC;     
@property (nonatomic,strong) NSString * mCurCityName;
@property (nonatomic,strong) NSString * mLocId;

//Speed Camera Widget
@property (nonatomic,strong) IBOutlet UILabel * mDistAndDirLbl;
@property (nonatomic,strong) IBOutlet UILabel * mCameraTypeLbl;
@property (nonatomic,strong) IBOutlet UILabel * mAddrLbl;
@property (nonatomic,strong) IBOutlet UILabel * mSpeedLimitLbl;

@property (nonatomic,strong) IBOutlet UIView *mContentView;

@property (nonatomic,strong) IBOutlet UIImageView * mSpdLimitBg;
-(IBAction)clickToLaunchWeather:(id)sender;
-(IBAction)clickToLaunchSpeedCamera:(id)sender;
-(IBAction)clickToLaunchCarMediaCenter:(id)sender;
-(IBAction)clickToLaunchTraffic:(id)sender;

-(IBAction)clickToLaunchTraffic1:(id)sender;
-(IBAction)clickToLaunchTraffic2:(id)sender;
-(IBAction)clickToLaunchTraffic3:(id)sender;

-(IBAction)clickToShowPrevApp:(id)sender;
-(IBAction)clickToShowNextApp:(id)sender;

-(IBAction)clickToLaunchApp1:(id)sender;
-(IBAction)clickToLaunchApp2:(id)sender;
-(IBAction)clickToLaunchApp3:(id)sender;
-(IBAction)clickToLaunchApp4:(id)sender;

-(void) initTrafficObjForWidget;
-(IBAction)clickToTestInitTrafficObjForWidget:(id)sender;
-(void)readWeatherSettingsAndShow;

-(IBAction) initWeatherWidget:(id)sender;
-(IBAction) initTrafficWidget:(id)sender;

-(void) refreshSpeedCameraWidget ;

-(IBAction)fiveMinuteRequeryIncident:(id)sender;


@property (nonatomic,strong) IBOutlet UILabel * mRoadwayNumLbl;
@end
