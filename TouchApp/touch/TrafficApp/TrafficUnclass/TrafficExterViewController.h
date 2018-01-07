//
//  WeatherExterViewController.h
//  touch
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalVars.h"
#import "ParseHelper.h"
@class RouteSettingObj;
@class Waypoint;
@interface TrafficExterViewController : UIViewController
{

    NSMutableArray * mTrafficObjs;
    int mTrafficIdx;
    
    NSMutableArray * mIncidentXmlUrls;//(type NSString*)
}
@property (nonatomic,strong) NSMutableArray * mIncidentXmlUrls;//(type NSString*)

@property (nonatomic,strong) IBOutlet UILabel * mRoadwayAndDirLbl;
@property (nonatomic,strong) IBOutlet UIImageView * mTrafficSignImgView;
@property (nonatomic,strong) IBOutlet UIImageView * mRoadwaySignImgView;

@property (nonatomic,strong) ParseHelper * mParseHelper;


@property (nonatomic,strong) NSMutableArray * mTrafficObjs;
@property (nonatomic) int mTrafficIdx;
@property (nonatomic,strong) NSOperationQueue *mQueue;

-(IBAction)clickToNextTrafficItem:(id)sender;
-(IBAction)clickToPrevTrafficItem:(id)sender;

@property (nonatomic,strong) IBOutlet UILabel * mPageLbl;

//ROADWAY ID/DESCRIPTION TYPE="NTCSA"
@property (nonatomic,strong) IBOutlet UILabel *mRoadwayDescLbl;

//POINT ID/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) IBOutlet UILabel *mPointDescLbl;

//TRAFFIC_ITEM_TYPE_DESC
@property (nonatomic,strong) IBOutlet UILabel *mTrafficItemTypeDescLbl;

//START_TIME
@property (nonatomic,strong) IBOutlet UILabel *mStartTimeLbl;

//END_TIME
@property (nonatomic,strong) IBOutlet UILabel *mEndTimeLbl;

//CRITICALITY/DESCRIPTION
@property (nonatomic,strong) IBOutlet UILabel *mCriticalityDescLbl;

//ALERTC/DESCRIPTION
@property (nonatomic,strong) IBOutlet UILabel *mAlertcDescLbl;

//ROADWAY ID/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) IBOutlet UILabel *mRoadwayLocalDescLbl;

//POINT ID/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) IBOutlet UILabel *mPointLocalDescLbl;

//DIRECTION/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) IBOutlet UILabel *mDirectionLocalDescLbl;

//GEOLOC/ORIGIN/LATITUDE
@property (nonatomic,strong) IBOutlet UILabel *mLatLbl;

//GEOLOC/ORIGIN/LONGITUDE
@property (nonatomic,strong) IBOutlet UILabel *mLngLbl;

//TRAFFIC_ITEM_DESCRIPTION TYPE="desc"
@property (nonatomic,strong) IBOutlet UILabel *mTrafficItemDescLbl;



-(IBAction)clickToShowTrafficFlowBox:(id)sender;
-(IBAction)clickToHideTrafficFlowBox:(id)sender;
-(IBAction)clickToBack:(id)sender;

@property (nonatomic) BOOL mIsNeedToResetIncidentData;


@property (nonatomic,strong) IBOutlet UIView * mTrafficFlowBoxView;
@property (nonatomic,strong) IBOutlet UIImageView * mNokiaMapImgView;
@property (nonatomic,strong) IBOutlet UIImageView * mTrafficLineImgView;

-(void) checkToDataReset ;
-(IBAction) fiveMinuteRequeryIncident : (id)sender;

@property (nonatomic,strong) IBOutlet UILabel * mRoadwayNumLbl;
-(BOOL)nowTimeNeededTrafficObj:(RouteSettingObj*)obj;

-(void) initIncidentXmlUrlsFromTrafficSetting ;
-(void) initTrafficObjsFromIncidentXmlUrls;



-(IBAction) backupAndRefreshGui:(id)sender;

@property (nonatomic) BOOL mIsCoreDataUsed;

@end


//@interface Waypoint : NSObject {}
//@property (nonatomic,strong) NSString * lat;
//@property (nonatomic,strong) NSString * lng;
//@end

