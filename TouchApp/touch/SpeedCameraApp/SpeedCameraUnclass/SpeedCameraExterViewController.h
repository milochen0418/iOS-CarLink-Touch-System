//
//  WeatherExterViewController.h
//  touch
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "SCPMarkersDom.h"
//#import "GlobalVars.h"

@class SCPMarker;

@interface SpeedCameraExterViewController : UIViewController<NSURLConnectionDelegate, NSXMLParserDelegate, CLLocationManagerDelegate, MKMapViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate>
{
    BOOL mIsUsingLocalImpl; 
    NSString * mFocusCameraId; //when you click add,confirm delete operation for camera
                               //it's working for the camera with the Id mFocusCameraId
    UILabel * mFocusCameraIdLbl;
    UILabel * mGpsCntNumLbl;
    
    //CoreData
    NSManagedObjectContext *mContext;
    NSFetchedResultsController *mFetchedResultsController;
    
    
    UIButton * mParseMarkersDomBtn;
    CLLocation * mLastestParsedLocation;
    CLLocation * mFarthestPrasedLocation;
    NSTimeInterval mLastestParsedTime;
    
    CLGeocoder * mGeocoder;
    CLLocationManager * mLocationManager;        
    CLLocation * mGpsCLLocation;
    CLLocation * mReverseGeocodeGpsLocation;
    
    NSString * mGpsLatitude;
    NSString * mGpsLongitude;
    NSString * mSpeedCameraSearchURL;
    NSString * mSpeedCameraApiKey;
    
    
    NSURLConnection *mConnection;
    NSMutableData *mTempDownloadData;
    int mExpectedLength;
    NSXMLParser * mParser;    
    
    UITextView * mDbgTextView;
    SCPMarkersDom * mSCPMarkersDom;
    
    UILabel * mLngValueLbl;
    UILabel * mLatValueLbl;
    UILabel * mSpdValueLbl;
    UILabel * mHdgValueLbl;
    
    bool mIsZoomToMap;
    
    NSMutableArray * mCurAnnotations;
    
    MKMapView * mRegionsMapView;
    UISegmentedControl * mShowMapSwitchSegCtrl;
    UIButton * mAddCameraBtn;
    UIButton * mDeleteCameraBtn;
    UIButton * mConfirmCameraBtn;
    UIButton * mModifyCameraBtn;
    UIWebView * mSPCLogWebView;
    
    UILabel * mRunDistLabel;
    UILabel * mIdleSecLabel;
    UILabel * mGpsIdleSecLbl;
    
    UILabel * mLimitNumLbl;
    UIButton *mZoomBtn;
    
    CLLocation * mNewLocation;
    BOOL mIsOnInternetProcess;
    UIButton * mUpdateBtn;
    
    int mGpsCnt;
    
    BOOL mIsRunningForground;
    int mIdleCnt;
    float mIdleCountingDelaySec;
    UIButton *mWarningLightBtn;
    UILabel * mWarningMarkerInfoLbl;
    UILabel * mAddressLbl;
    UISegmentedControl * mMarkerFilterModeSeg;
    BOOL mIsFreewayModeOn;
    
    UISlider * mSpeedDetectRateSlider;
    double mSpeedDetectRate; //setting storage from 100% to 130%;
    
    UISegmentedControl * mDownloadDataOfCountrySeg;
    BOOL mIsDownloadCountryTW;
    
    bool mIsNeedLayoutPortrait;
    NSString * mSettingUrlStr;
    
    
    SCPMarker * mWidgetMarker;
    
    UIImageView *mStar1Img;
    UIImageView *mStar2Img;
    UIImageView *mStar3Img;
    UIImageView *mStar4Img;
    UIImageView *mStar5Img;
    UIImageView *mTypeImg;
    
    UIButton * mExternalConfirmCameraBtn;
    UIButton * mExternalDeleteCameraBtn;
    UIButton * mExternalAddCameraBtn;
    
    int mIdleDoubleBeepCnt;
    UIImageView * mMapImgView;
    NSString * mMapImgUrlStr;
    
    UITextView * mShowCLPlacemarkerTextView;
    CLPlacemark * mCLPlacemark;
    UIImageView * mSpdLimitBg;
}


@property (nonatomic) BOOL mIsVisualWarning;
@property (nonatomic) BOOL mIsAudiableWarning;


@property (nonatomic,strong) IBOutlet UIImageView * mSpdLimitBg;


-(NSString*) getShortNameByType:(NSString*)type;
-(int) getIntegerValueByType:(NSString*)type;


@property (nonatomic,strong) IBOutlet UITextView * mShowCLPlacemarkerTextView;
@property (nonatomic,strong) CLPlacemark * mCLPlacemark;


-(NSString *)URLEncodedStringPipe:(NSStringEncoding)encoding inUrlStr:(NSString*)urlStr;
-(IBAction) clickToLoadInternetImg:(id)sender;
@property (nonatomic,strong) NSString * mMapImgUrlStr;
@property (nonatomic,strong) IBOutlet UIImageView * mMapImgView;


@property (nonatomic) int mIdleDoubleBeepCnt;
@property (nonatomic,strong) IBOutlet UIButton * mExternalConfirmCameraBtn;
@property (nonatomic,strong) IBOutlet UIButton * mExternalDeleteCameraBtn;
@property (nonatomic,strong) IBOutlet UIButton * mExternalAddCameraBtn;


@property (nonatomic,strong) IBOutlet UIImageView *mTypeImg;
@property (nonatomic,strong) IBOutlet UIImageView *mStar1Img;
@property (nonatomic,strong) IBOutlet UIImageView *mStar2Img;
@property (nonatomic,strong) IBOutlet UIImageView *mStar3Img;
@property (nonatomic,strong) IBOutlet UIImageView *mStar4Img;
@property (nonatomic,strong) IBOutlet UIImageView *mStar5Img;


@property (nonatomic,strong) SCPMarker * mWidgetMarker;


-(IBAction)clickToDownloadLastestLocalData:(id)sender ;

@property (nonatomic,strong) IBOutlet UILabel *mVotesNumLbl;
@property (nonatomic,strong) IBOutlet UILabel *mSpdLimitLbl;
@property (nonatomic,strong) IBOutlet UILabel *mDisAndDirLbl;
@property (nonatomic,strong) IBOutlet UILabel *mSpdCameraTypeLbl;
@property (nonatomic,strong) IBOutlet UILabel *mAbbrAddrLbl;

@property (nonatomic,strong) NSString * mSettingUrlStr;
@property (nonatomic) bool mIsNeedLayoutPortrait;
-(IBAction) clickToCancelAdd :(id)sender;
-(IBAction) clickToSubmitAdd :(id)sender;
-(IBAction) clickToEditAdd :(id)sender;

-(IBAction) addCameraInSimple :(id)sender;

@property (nonatomic,strong) IBOutlet UILabel * mFocusCameraIdLbl;
@property (nonatomic,strong) NSString* mFocusCameraId;



@property (nonatomic) BOOL mIsDownloadCountryTW;
@property (nonatomic,strong) IBOutlet UISegmentedControl * mDownloadDataOfCountrySeg;
-(IBAction) clickToSelectDownloadCountryData:(id)sender;

@property (nonatomic,strong) IBOutlet UISlider * mSpeedDetectRateSlider;
-(IBAction)sliderToChangeSpeedDetectRate:(id)sender;

-(IBAction) clickToMarkerFilterModeChange:(id)sender;
@property (nonatomic) double mSpeedDetectRate;
@property (nonatomic) BOOL mIsFreewayModeOn;
@property (nonatomic,strong) IBOutlet UISegmentedControl * mMarkerFilterModeSeg;
@property (nonatomic,strong) IBOutlet UILabel * mAddressLbl;
@property (nonatomic,strong) IBOutlet UIButton *mWarningLightBtn;
@property (nonatomic,strong) IBOutlet UILabel * mWarningMarkerInfoLbl;



-(void) applicationGUILeave;
-(void) applicationGUIEnter;

@property (nonatomic,strong) IBOutlet UILabel * mGpsIdleSecLbl;
@property (nonatomic) float mIdleCountingDelaySec;
@property (nonatomic) int mIdleCnt;
@property (nonatomic) BOOL mIsRunningForground;

@property (nonatomic) int mGpsCnt;
@property (nonatomic,strong) IBOutlet UILabel * mGpsCntNumLbl;
@property (nonatomic,strong) IBOutlet UIButton * mUpdateBtn;
@property (nonatomic) BOOL mIsUsingLocalImpl;



-(void) parseXmlToMarkersDomFromInternet;
-(void) makeMarkersDomFromLocalData;

@property (atomic) BOOL mIsOnInternetProcess;
@property (atomic,strong) IBOutlet UILabel * mLimitNumLbl;
@property (atomic,strong) CLLocation * mNewLocation;
-(IBAction)clickToZoom:(id)sender;
@property (nonatomic,strong) IBOutlet UIButton* mZoomBtn;


@property (nonatomic,strong) IBOutlet UILabel * mIdleSecLabel;
@property (nonatomic,strong) IBOutlet UILabel * mRunDistLabel;
@property (nonatomic,strong) CLLocation * mLastestParsedLocation;
@property (nonatomic,strong) CLLocation * mFarthestPrasedLocation;


-(void) testWebViewHTMLContent;
-(void) showDomOnWebViewHTMLContent;
@property (nonatomic,strong) IBOutlet UIWebView * mSPCLogWebView;

-(IBAction) clickToAddCamera:(id)sender;
-(IBAction) clickToDeleteCamera:(id)sender;
-(IBAction) clickToConfirmCamera:(id)sender;
-(IBAction) clickToModifyCamera:(id)sender;
@property (nonatomic,strong) IBOutlet UIButton * mAddCameraBtn;
@property (nonatomic,strong) IBOutlet UIButton * mDeleteCameraBtn;
@property (nonatomic,strong) IBOutlet UIButton * mConfirmCameraBtn;
@property (nonatomic,strong) IBOutlet UIButton * mModifyCameraBtn;

@property (nonatomic,strong) IBOutlet UISegmentedControl * mShowMapSwitchSegCtrl;
-(IBAction) clickToSelShowMap:(id)sender;

@property (nonatomic,strong) IBOutlet MKMapView * mRegionsMapView;
@property (nonatomic,strong) IBOutlet UILabel * mSpdValueLbl;
@property (nonatomic,strong) IBOutlet UILabel * mHdgValueLbl;


-(void) updateAnnotationsOfMapByMarkersDom;
-(void) updateAnnotationsOfMapByMarkersDomWithMap:(MKMapView*)mapView;

@property (nonatomic,strong) NSMutableArray * mCurAnnotations;
@property (nonatomic) bool mIsZoomToMap;
-(void) zoomLocationToMap; 
@property (nonatomic,strong) IBOutlet UILabel * mLngValueLbl;
@property (nonatomic,strong) IBOutlet UILabel * mLatValueLbl;


-(void) makeLocationServiceWorking;
@property (nonatomic,strong) NSURLConnection *mConnection;
@property (nonatomic,strong) NSMutableData *mTempDownloadData;
@property (nonatomic) int mExpectedLength;
@property (nonatomic,strong) NSXMLParser * mParser;    


@property (nonatomic,strong) IBOutlet UITextView * mDbgTextView;
@property (nonatomic,strong) IBOutlet UIButton * mParseMarkersDomBtn;
-(IBAction)clickToParseMarkers:(id)sender;


-(NSString*) makeSpeedCameraSearchURLByKey:(NSString*)key withLatitude:(NSString*)latitude andLongtitude:(NSString*)longtitude;

-(NSString*) makeSpeedCameraSearchURLByKey:(NSString*)key withLatitude:(NSString*)latitude andLongtitude:(NSString*)longtitude andLimit:(NSString*)limit;

@property (nonatomic,strong) CLGeocoder * mGeocoder;
@property (nonatomic,strong) CLLocationManager * mLocationManager;        
@property (nonatomic,strong) CLLocation * mGpsCLLocation;
@property (nonatomic,strong) NSString * mGpsLatitude;
@property (nonatomic,strong) NSString * mGpsLongitude;
@property (nonatomic,strong) NSString * mSpeedCameraSearchURL;
@property (nonatomic,strong) NSString * mSpeedCameraApiKey;


//-(void) decideWhetherParse;
-(void) restrictLimitWithFilterDistance:(double)filterDistance ;



-(void) decideWhetherParseXmlFromInternet;
-(void) decideWhetherBuildDomFromLocalData;
-(void) decideWhetherBuildDom;


//CoreData
@property (nonatomic,strong) NSManagedObjectContext *mContext;
@property (nonatomic,strong) NSFetchedResultsController *mFetchedResultsController;
-(void) initCoreData;

//SpeedCamera
-(void) clearAllCameraInDB;
-(void) clearAllDownloadedInDB;
//-(void) importToDBWithAllCameraStr:(NSString*)str;
-(void) importToDBWithAllCameraStrAsDownloadedItem:(NSString*)str;
-(void) combineDownloadedAndAddedToCameraItems;
-(void) makeFakeAddedItems;
-(void) deleteFakeAddedItems;
-(void) addCamera;
-(void) confirmCamera;
-(void) deleteCamera;
-(void) showAddedItemsId;
-(void) showDeletedItemsId;
-(void) showConfirmedItemsId;
-(void) showDownloadedItemsId;
-(void) showCameraItemsId;
@property (nonatomic,strong) SCPMarkersDom * mSCPMarkersDom;
-(IBAction)clickToDownloadLastestLocalData:(id)sender;
-(IBAction)clickToShowAddedItemsId;
-(IBAction)clickToShowDeletedItemsId;
-(IBAction)clickToShowConfirmedItemsId;
-(IBAction)clickToShowDownloadedItemsId;
-(IBAction)clickToShowCameraItemsId;

-(void) refreshGuiByMarkersDom;
-(void) clearAllCameraInDB;



-(NSString*) figureOutDistanceWithMarker:(SCPMarker*) marker;
-(NSString*) figureOutHeadingWithMarker:(SCPMarker*) marker;

-(void) showAngles;

-(IBAction)poolingTimeInvoked:(id)sender;
-(CLLocation*) getCarLocation;


-(IBAction) clickToAddCamera:(id)sender;
-(IBAction) clickToConfirmCamera:(id)sender;
-(IBAction) clickToDeleteCamera:(id)sender;


//UrlAndXmlFuncs
-(NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr inTxtStr:(NSString*)txtStr;
-(NSString*) extractValueBetweenTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr ;
-(NSString*) getXmlStringFromUrlStr:(NSString*)urlStr;



-(void) addCameraInComplicatedInFinalProcessWithUrl:(NSString*)settingUrlStr;
-(IBAction)delayToProcessingAddCameraInComplicated:(id)sender;


-(IBAction)clickToBack:(id)sender;

-(NSString*) getTypeImageNameByType:(NSString*)type ;
-(NSString*) getTypeIntegerByType:(NSString*)type;

//-(NSString*) getDisAndDirFormatStr:(NSString*)distStr andDirStr:(NSString*)dirStr;
-(NSString*)getDisAndDirFormatStr:(SCPMarker*)marker;
+(NSString*)getDisAndDirFormatStr:(SCPMarker*)marker;


@property (nonatomic,strong) IBOutlet UIView * mSpdCameraHelpBoxView;
-(IBAction)clickToHideSpdCameraHelpBox:(id)sender;
-(IBAction)clickToShowSpdCameraHelpBox:(id)sender;

@property (nonatomic) BOOL mIsSpeedTooSlowToShow;  


@property (nonatomic) BOOL mIsNeedToDownloadLastestLocalData;


@end
