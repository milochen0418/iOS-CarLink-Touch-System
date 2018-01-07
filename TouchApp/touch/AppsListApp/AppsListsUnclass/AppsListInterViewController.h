//
//  ViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalVars.h"

#import "AppObject.h"
#import "AppInstallationInterViewController.h"

@interface AppsListInterViewController:UIViewController
{
    BOOL mIsOnPushVC;

    UILabel *mAppNameLbl;
    UILabel *mAppNameLbl1;
    UILabel *mAppNameLbl2;
    UILabel *mAppNameLbl3;    
    UILabel *mAppNameLbl4;
    UILabel *mAppNameLbl5;
    UILabel *mAppNameLbl6;    
    UILabel *mAppNameLbl7;
    UILabel *mAppNameLbl8;
    UILabel *mAppNameLbl9;    
    UILabel *mAppNameLbla;
    UILabel *mAppNameLblb;
    UILabel *mAppNameLblc;    
    
    UIImageView * mAppIconImgView;
    UIImageView * mAppIconImgView1;
    UIImageView * mAppIconImgView2;
    UIImageView * mAppIconImgView3;    
    UIImageView * mAppIconImgView4;
    UIImageView * mAppIconImgView5;
    UIImageView * mAppIconImgView6;    
    UIImageView * mAppIconImgView7;
    UIImageView * mAppIconImgView8;
    UIImageView * mAppIconImgView9;    
    UIImageView * mAppIconImgViewa;
    UIImageView * mAppIconImgViewb;
    UIImageView * mAppIconImgViewc;    
    
    UIButton * mBlueLed; //light to denote that apps is in sys.
    UIButton * mBlueLed1;
    UIButton * mBlueLed2;
    UIButton * mBlueLed3;
    UIButton * mBlueLed4;
    UIButton * mBlueLed5;
    UIButton * mBlueLed6;
    UIButton * mBlueLed7;
    UIButton * mBlueLed8;
    UIButton * mBlueLed9;
    UIButton * mBlueLeda;
    UIButton * mBlueLedb;
    UIButton * mBlueLedc;

    
    AppObject *mAppObj;
    AppObject *mAppObj1;
    AppObject *mAppObj2;
    AppObject *mAppObj3;
    AppObject *mAppObj4;
    AppObject *mAppObj5;
    AppObject *mAppObj6;    
    AppObject *mAppObj7;
    AppObject *mAppObj8;
    AppObject *mAppObj9;    
    AppObject *mAppObja;
    AppObject *mAppObjb;
    AppObject *mAppObjc;    
    
    NSMutableArray * mAppObjs;
    int mAppObjIdx;
    
    NSOperationQueue *mQueue;
    
    UIButton * mPrevPageBtn;
    UIButton * mNextPageBtn;
    UILabel *mPageLbl;
}
@property (nonatomic,strong) IBOutlet UILabel * mPageLbl;
@property (nonatomic,strong) IBOutlet UIButton * mPrevPageBtn;
@property (nonatomic,strong) IBOutlet UIButton * mNextPageBtn;

@property (nonatomic) BOOL mIsOnPushVC;
@property (nonatomic,strong) NSOperationQueue * mQueue;

-(void) initAppObjs ;
@property (nonatomic) int mAppObjIdx;
@property (nonatomic,strong) NSMutableArray * mAppObjs;
@property (nonatomic,strong) AppObject * mAppObj;

@property (nonatomic,strong) AppObject * mAppObj1;
@property (nonatomic,strong) AppObject * mAppObj2;
@property (nonatomic,strong) AppObject * mAppObj3;
@property (nonatomic,strong) AppObject * mAppObj4;
@property (nonatomic,strong) AppObject * mAppObj5;
@property (nonatomic,strong) AppObject * mAppObj6;
@property (nonatomic,strong) AppObject * mAppObj7;
@property (nonatomic,strong) AppObject * mAppObj8;
@property (nonatomic,strong) AppObject * mAppObj9;
@property (nonatomic,strong) AppObject * mAppObja;
@property (nonatomic,strong) AppObject * mAppObjb;
@property (nonatomic,strong) AppObject * mAppObjc;


-(void) cleanOperationAndAppList;

-(IBAction) clickToActionIt:(id)sender;
-(IBAction) clickToActionIt1:(id)sender;
-(IBAction) clickToActionIt2:(id)sender;
-(IBAction) clickToActionIt3:(id)sender;
-(IBAction) clickToActionIt4:(id)sender;
-(IBAction) clickToActionIt5:(id)sender;
-(IBAction) clickToActionIt6:(id)sender;
-(IBAction) clickToActionIt7:(id)sender;
-(IBAction) clickToActionIt8:(id)sender;
-(IBAction) clickToActionIt9:(id)sender;
-(IBAction) clickToActionIta:(id)sender;
-(IBAction) clickToActionItb:(id)sender;
-(IBAction) clickToActionItc:(id)sender;

@property (nonatomic,strong) IBOutlet UIButton * mBlueLed;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed1;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed2;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed3;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed4;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed5;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed6;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed7;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed8;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLed9;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLeda;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLedb;
@property (nonatomic,strong) IBOutlet UIButton * mBlueLedc;

@property (nonatomic,strong) IBOutlet UILabel *mRosenLbl;

@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView1;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView2;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView3;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView4;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView5;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView6;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView7;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView8;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView9;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgViewa;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgViewb;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgViewc;

@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl1;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl2;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl3;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl4;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl5;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl6;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl7;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl8;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl9;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbla;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLblb;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLblc;




-(IBAction) clickToBack:(id)sender;
-(IBAction) clickToLoadAppIcon:(id)sender;
-(NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr ;
-(IBAction)clickToNextAppObj:(id)sender;
-(IBAction)clickToPrevAppObj:(id)sender;
-(IBAction)performLoadAppInfo:(id)sender;


-(void) setItemWithNameLbl:(UILabel*)nameLbl andImgView:(UIImageView*)iconImgView andLed:(UIButton*)ledBtn withAppObj:(AppObject*)appObj;

-(IBAction)selSetItemWithNameLbl:(UILabel*)nameLbl andImgView:(UIImageView*)iconImgView andLed:(UIButton*)ledBtn withAppObj:(AppObject*)appObj;

-(void) operationSetItemWithNameLbl:(UILabel*)nameLbl andImgView:(UIImageView*)iconImgView andLed:(UIButton*)ledBtn withAppObj:(AppObject*)appObj;


-(NSMutableArray*) extractStrArrayBySameTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr ;
-(NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr;
-(NSString*) stringByRemovingNewLinesAndWhitespace:(NSString*)str;
-(NSString*) getXmlStringFromUrlStr:(NSString*)urlStr;
-(NSString*) extractValueBetweenTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr;

@end
