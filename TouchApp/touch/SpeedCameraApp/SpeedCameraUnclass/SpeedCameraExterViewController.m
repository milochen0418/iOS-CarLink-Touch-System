//
//  ExterViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeedCameraExterViewController.h"
#import "GlobalVars.h"
#import "SCPMarkersDom.h"
#import "AddedItem.h"
#import "CameraItem.h"
#import "DeletedItem.h"
#import "DownloadedItem.h"
#import "ConfirmedItem.h"
#import "MyAnnotation.h"

@implementation SpeedCameraExterViewController


@synthesize mGpsCnt,mParser,mContext,mIdleCnt,mZoomBtn,mGeocoder,mUpdateBtn,mAddressLbl,mConnection,mDbgTextView,mGpsLatitude,mHdgValueLbl,mIsZoomToMap,mLatValueLbl,mLimitNumLbl,mLngValueLbl,mNewLocation,mSpdValueLbl,mAddCameraBtn,mGpsCntNumLbl,mGpsLongitude,mIdleSecLabel,mRunDistLabel,mFocusCameraId,mGpsCLLocation,mGpsIdleSecLbl,mSCPMarkersDom,mSettingUrlStr,mSPCLogWebView,mCurAnnotations,mExpectedLength,mRegionsMapView,mDeleteCameraBtn,mIsFreewayModeOn,mLocationManager,mModifyCameraBtn,mSpeedDetectRate,mWarningLightBtn,mConfirmCameraBtn,mFocusCameraIdLbl,mIsUsingLocalImpl,mTempDownloadData,mSpeedCameraApiKey,mIsRunningForground,mMarkerFilterModeSeg,mLastestParsedLocation,mDownloadDataOfCountrySeg,mFarthestPrasedLocation,mFetchedResultsController,mIdleCountingDelaySec,mIsDownloadCountryTW,mIsNeedLayoutPortrait,mIsOnInternetProcess,mParseMarkersDomBtn,mShowMapSwitchSegCtrl,mSpeedCameraSearchURL,mSpeedDetectRateSlider,mWarningMarkerInfoLbl;

@synthesize mAbbrAddrLbl,mDisAndDirLbl,mSpdCameraTypeLbl,mSpdLimitLbl,mVotesNumLbl;
@synthesize mWidgetMarker;
@synthesize mTypeImg,mStar1Img,mStar2Img,mStar3Img,mStar4Img,mStar5Img;
@synthesize mExternalAddCameraBtn,mExternalDeleteCameraBtn,mExternalConfirmCameraBtn;
@synthesize mIdleDoubleBeepCnt,mMapImgView,mMapImgUrlStr;
@synthesize mShowCLPlacemarkerTextView,mCLPlacemark;
@synthesize mSpdLimitBg;
@synthesize mSpdCameraHelpBoxView;
@synthesize mIsSpeedTooSlowToShow;

@synthesize mIsNeedToDownloadLastestLocalData;
@synthesize mIsAudiableWarning,mIsVisualWarning;


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


-(IBAction)clickToBack:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav popViewControllerAnimated:YES];
    [vars.exterNav popExterViewControllerAnimated:YES];
}


-(SpeedCameraExterViewController*) init 
{
    self = [super init];
    if(self) 
    {

    }
    return self;
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


-(void) viewDidAppear:(BOOL)animated {
    NSLog(@"SpeedCameraExterViewController viewDidAppear");

//    [self applicationGUIEnter];
    
    if(mIsNeedToDownloadLastestLocalData) {
        mIsNeedToDownloadLastestLocalData = NO;
        [self performSelector:@selector(clickToDownloadLastestLocalData:) withObject:nil afterDelay:1];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"SpeedCameraExterViewController viewWillDisappear");    
    [self viewDidDisappear:animated];
//    [self applicationGUILeave];    
}

-(IBAction)clickToHideSpdCameraHelpBox:(id)sender {
    self.mSpdCameraHelpBoxView.hidden = YES;
}
-(IBAction)clickToShowSpdCameraHelpBox:(id)sender {
    self.mSpdCameraHelpBoxView.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mSpdCameraHelpBoxView.hidden = YES;
    [self.view addSubview:self.mSpdCameraHelpBoxView];
    mSpdCameraHelpBoxView.frame = CGRectMake(32, 12, 795, 452);

    
    BOOL cleanEngineerHintGUI = YES;
    if(IS_SHOW_MAP) cleanEngineerHintGUI = NO;
    if(cleanEngineerHintGUI) {
        if(IS_SHOW_MAP)
        {
            self.mRegionsMapView.hidden = NO;
        }
        else
        {
            self.mRegionsMapView.hidden = YES;
        }
        self.mRegionsMapView.hidden = YES;
        self.mSpdCameraTypeLbl.text = @"";
        self.mDisAndDirLbl.text = @"";
        self.mSpdLimitLbl.text = @"";
        self.mAbbrAddrLbl.text = @"";
        self.mMapImgView.image = nil;
        self.mSpdLimitBg.hidden = YES;
        self.mVotesNumLbl.text = @"";
        self.mStar1Img.hidden = YES;
        self.mStar2Img.hidden = YES;
        self.mStar3Img.hidden = YES;
        self.mStar4Img.hidden = YES;
        self.mStar5Img.hidden = YES;
    }
    
    
    [self changeBtnIntoBlk:self.mExternalConfirmCameraBtn];
    [self changeBtnIntoBlk:self.mExternalDeleteCameraBtn];
    [self changeBtnIntoBlk:self.mExternalAddCameraBtn];
    self.mSpeedCameraApiKey = @"c934f220074cbc9ad267ad6b813dd203";
    
    if(self.mSCPMarkersDom != nil)
    {
        self.mSCPMarkersDom = nil;
    }
    
    self.mSCPMarkersDom = [[SCPMarkersDom alloc]init];
    
    [self initCoreData];
    mIsUsingLocalImpl = YES;
    
    //basic setting
    mSpeedDetectRate = 1.0f;    
    mIsFreewayModeOn = NO;
    mIsDownloadCountryTW = NO;
    mIsVisualWarning = YES;
    mIsAudiableWarning = YES;
    
    
    [self makeLocationServiceWorking];    
    [self showAngles];
    [self performSelector:@selector(clickToDownloadLastestLocalData:) withObject:nil afterDelay:2];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    return YES;
    return NO;
}





-(IBAction)clickToOpenAlert:(id)sender 
{
    NSString*  curCourseStr = mHdgValueLbl.text;
    double heading = [curCourseStr doubleValue];
    int headingInt = (int)heading;
    NSString * dirStr = @"N";
    headingInt = (headingInt + 360 ) % 360;
    if(headingInt >= 360-22 || headingInt < 0+23 ) dirStr = @"N";
    if(headingInt >= 0+23 || headingInt < 45+23 ) dirStr = @"NE";  
    if(headingInt >= 45+23 || headingInt < 90+23) dirStr = @"E";
    if(headingInt >= 90+23 || headingInt < 135+23) dirStr = @"SE";
    if(headingInt >= 135+23 || headingInt < 180+23) dirStr = @"S";
    if(headingInt >= 180+23 || headingInt < 225+23) dirStr = @"SW";
    if(headingInt >= 225+23 || headingInt < 270+23) dirStr = @"W";
    if(headingInt >= 270+23 || headingInt < 315+23) dirStr = @"NW";
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithFrame:CGRectMake(320,20,300,200)];
    [alert setTitle:@"Add Camera"];
    [alert setMessage:[NSString stringWithFormat:@"Speed:0kmh\n Heading:%@ \n Direction:all ",dirStr]];
    [alert setDelegate:self];
    [alert addButtonWithTitle:@"Cancel"];
    [alert addButtonWithTitle:@"Submit"];
    [alert addButtonWithTitle:@"Edit"];
//    [[UIAlertView alloc]
//     initWithTitle:@"Add Camera" 
//     message:[NSString stringWithFormat:@"Speed:0kmh\n Heading:%@ \n Direction:all ",dirStr]
//     delegate:self 
//     cancelButtonTitle:@"Cancel"  //buttonIndex = 0
//     otherButtonTitles:@"Submit", @"Edit", nil]; //buttonIndex = 1 , 2
    
    
    GlobalVars *vars = [GlobalVars sharedInstance];
    //UIViewController * vc = [vars.exterNav topViewController];
    
//    [alert setFrame:CGRectMake(320,20,300,200)];
//    [alert removeFromSuperview];
//    [alert displayLayer:vars.exterNav.view.layer];

    [vars.exterNav.view addSubview:alert.inputView];
    
    //[vc.view addSubview:alert];
    
    //[alert show];
    UIViewController * vc = [vars.exterNav topViewController];    
    [MTPopupWindow showWindowWithView:vars.mAddCameraAlertVC.view insideView:vc.view];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    NSLog(@"button idx = %d", buttonIndex);
    switch(buttonIndex) {
        case 0:
            [self performSelector:@selector(clickToCancelAdd:) withObject:nil];
            break;
        case 1:
            [self performSelector:@selector(clickToSubmitAdd:) withObject:nil];
            break;
        case 2:
            [self performSelector:@selector(clickToEditAdd:) withObject:nil];
            break;
    }
}


- (void)didPresentAlertView:(UIAlertView *)alertView 
{
    NSLog(@"didPresentAlertView");
    self.mIsNeedLayoutPortrait = YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSLog(@"didDismissWithButtonIndex");
    self.mIsNeedLayoutPortrait = NO;    
}

-(IBAction) clickToCancelAdd :(id)sender {
    NSLog(@"clickToCancelAdd");
}


-(IBAction) clickToSubmitAdd :(id)sender {
    NSLog(@"clickToSubmitAdd");  
    //addCameraInSimple
    [self performSelector:@selector(addCameraInSimple:) withObject:nil afterDelay:0.2];
}

-(IBAction) clickToEditAdd :(id)sender {
    NSLog(@"clickToEditAdd");  
    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.interNav pushViewController:vars.mEditCameraAddViewIVC animated:YES];
    
    
    [vars.exterNav pushExterViewController:vars.mEditCameraAddViewIVC animated:YES];
}




-(IBAction) addCameraInSimple :(id)sender
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    NSLog(@"addCameraInSimple");
    NSString * latStr=@"37.335072";
    NSString * lngStr=@"-122.032604";
    
    latStr = mGpsLatitude;
    lngStr = mGpsLongitude;
    NSString * idStr = @"10f0b";
    
    
    NSString * urlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=add&lat=%@&lng=%@&type=1", self.mSpeedCameraApiKey,latStr,lngStr];
    NSLog(@"[ADD ACTION] urlStr = %@", urlStr);
    
    
    NSString * xmlStr = [self getXmlStringFromUrlStr:urlStr];
    NSString * statusVal = [self extractValueBetweenTag:@"status" inXmlStr:xmlStr];
    NSString * idVal = [self extractValueBetweenTag:@"id" inXmlStr:xmlStr];
    NSLog(@"status=%@, id=%@", statusVal, idVal);
    if(idVal == nil || [idVal isEqualToString:@""])
    {
        idVal = idStr;
    }
    
    //test url is here http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=search&lat=37.335072&lng=-122.032604&limit=1;
    
    
    NSString * searchUrlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=search&lat=%@&lng=%@&limit=1", self.mSpeedCameraApiKey,latStr,lngStr];
    NSString * searchXmlStr = [self getXmlStringFromUrlStr:searchUrlStr];
    NSString * searchId = [self extractValueBetweenBeginStr:@"<marker id=\"" andEndStr:@"\" lat=" inTxtStr:searchXmlStr];
    NSString * searchLat = [self extractValueBetweenBeginStr:@" lat=\"" andEndStr:@"\" lng=" inTxtStr:searchXmlStr];
    NSString * searchLng = [self extractValueBetweenBeginStr:@" lng=\"" andEndStr:@"\" type_var=" inTxtStr:searchXmlStr];
    NSString * searchTypeVar = [self extractValueBetweenBeginStr:@" type_var=\"" andEndStr:@"\" type=" inTxtStr:searchXmlStr];
    NSString * searchType = [self extractValueBetweenBeginStr:@" type=\"" andEndStr:@"\" speed=" inTxtStr:searchXmlStr];
    NSString * searchSpeed = [self extractValueBetweenBeginStr:@" speed=\"" andEndStr:@"\" dirtype=" inTxtStr:searchXmlStr];
    NSString * searchDirType = [self extractValueBetweenBeginStr:@" dirtype=\"" andEndStr:@"\" direction=" inTxtStr:searchXmlStr];
    NSString * searchDirection = [self extractValueBetweenBeginStr:@" direction=\"" andEndStr:@"\" votes=" inTxtStr:searchXmlStr];
    NSString * searchVotes = [self extractValueBetweenBeginStr:@" votes=\"" andEndStr:@"\" stars=" inTxtStr:searchXmlStr];
    NSString * searchStars = [self extractValueBetweenBeginStr:@" stars=\"" andEndStr:@"\" distance=" inTxtStr:searchXmlStr];
    NSString * searchDistance = [self extractValueBetweenBeginStr:@" distance=\"" andEndStr:@"\"/>" inTxtStr:searchXmlStr];
    
    NSString * entityName = @"AddedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil) 
    {
        NSLog(@"%@s is (null", entityName);
        return;
    }
    
    
    int idx;
    BOOL isDataNotExistInItems = YES; 
    for(idx = 0 ; idx < [items count] ; idx++)
    {
        AddedItem * item = [items objectAtIndex:idx];
        if( [item.mId isEqualToString:searchId]) 
        {
            isDataNotExistInItems = NO;
            item.mDirection = searchDirection;
            //            item.mDirection = @"270";
            item.mDirtype = searchDirType;
            //            item.mDirtype = @"1";
            item.mLat = [NSNumber numberWithDouble:[searchLat doubleValue]];
            item.mLng = [NSNumber numberWithDouble:[searchLng doubleValue]];
            item.mSpeed = searchSpeed;
            //            item.mSpeed = @"50";            
            item.mStars = searchStars;
            item.mType = searchType;
            item.mVotes = searchVotes;
            NSLog(@"updated item is %@", item);
            
            UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Ever Add！",searchId] message:@"You ever add this new camera！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  

            //[tmp show];  
            [MTPopupWindow showCameraOkWindowWithTitle:[NSString stringWithFormat:@"%@ Ever Add！",searchId] andMessage:@"You ever add this new camera！" insideView:[vars.exterNav topViewController].view];
            
            tmp = nil;
        }
    }
    if(isDataNotExistInItems) 
    {
        AddedItem * item = (AddedItem*) [NSEntityDescription insertNewObjectForEntityForName:@"AddedItem" inManagedObjectContext:mContext];
        item.mId = searchId;
        item.mDirection = searchDirection;
        item.mDirtype = searchDirType;
        item.mLat = [NSNumber numberWithDouble:[searchLat doubleValue]];
        item.mLng = [NSNumber numberWithDouble:[searchLng doubleValue]];
        item.mSpeed = searchSpeed;
        item.mStars = searchStars;
        item.mType = searchType;      
        item.mVotes = searchVotes;
        NSLog(@"insert item is %@", item);
        
        UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:@"Add OK！" message:[NSString stringWithFormat:@"New Camera is Added OK！ and it's camera ID is %@", searchId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
        //[tmp show];
        [MTPopupWindow showCameraOkWindowWithTitle:@"Add OK！" andMessage:[NSString stringWithFormat:@"New Camera is Added OK！ and it's camera ID is %@", searchId] insideView:[vars.exterNav topViewController].view];
        
        tmp = nil;
    }
    
    NSLog(@"get search ID = %@", searchId);
    
    if(![mContext save:&error]) 
    {
        NSLog(@"save error");
    }
    
    [self combineDownloadedAndAddedToCameraItems];
    NSLog(@"complete to add speed camera proces on (lat=%@,lng=%@)", latStr,lngStr);
    
}


-(void) addCameraInComplicatedInFinalProcessWithUrl:(NSString*)settingUrlStr {
    mSettingUrlStr = settingUrlStr;
    [self performSelector:@selector(delayToProcessingAddCameraInComplicated:) withObject:nil afterDelay:2];
    
}

-(IBAction)delayToProcessingAddCameraInComplicated:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    NSString * urlStr = mSettingUrlStr;
    NSString * latStr = vars.mEditCameraAddViewIVC.mCurLatStr;
    NSString * lngStr = vars.mEditCameraAddViewIVC.mCurLngStr;
    NSString * idStr = @"10f0b";
    
    NSString * xmlStr = [self getXmlStringFromUrlStr:urlStr];
    NSString * statusVal = [self extractValueBetweenTag:@"status" inXmlStr:xmlStr];
    NSString * idVal = [self extractValueBetweenTag:@"id" inXmlStr:xmlStr];
    NSLog(@"status=%@, id=%@", statusVal, idVal);
    if(idVal == nil || [idVal isEqualToString:@""])
    {
        idVal = idStr;
    }
    
    //test url is here http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=search&lat=37.335072&lng=-122.032604&limit=1;
    
    
    NSString * searchUrlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=search&lat=%@&lng=%@&limit=1", self.mSpeedCameraApiKey,latStr,lngStr];
    NSString * searchXmlStr = [self getXmlStringFromUrlStr:searchUrlStr];
    NSString * searchId = [self extractValueBetweenBeginStr:@"<marker id=\"" andEndStr:@"\" lat=" inTxtStr:searchXmlStr];
    NSString * searchLat = [self extractValueBetweenBeginStr:@" lat=\"" andEndStr:@"\" lng=" inTxtStr:searchXmlStr];
    NSString * searchLng = [self extractValueBetweenBeginStr:@" lng=\"" andEndStr:@"\" type_var=" inTxtStr:searchXmlStr];
    NSString * searchTypeVar = [self extractValueBetweenBeginStr:@" type_var=\"" andEndStr:@"\" type=" inTxtStr:searchXmlStr];
    NSString * searchType = [self extractValueBetweenBeginStr:@" type=\"" andEndStr:@"\" speed=" inTxtStr:searchXmlStr];
    NSString * searchSpeed = [self extractValueBetweenBeginStr:@" speed=\"" andEndStr:@"\" dirtype=" inTxtStr:searchXmlStr];
    NSString * searchDirType = [self extractValueBetweenBeginStr:@" dirtype=\"" andEndStr:@"\" direction=" inTxtStr:searchXmlStr];
    NSString * searchDirection = [self extractValueBetweenBeginStr:@" direction=\"" andEndStr:@"\" votes=" inTxtStr:searchXmlStr];
    NSString * searchVotes = [self extractValueBetweenBeginStr:@" votes=\"" andEndStr:@"\" stars=" inTxtStr:searchXmlStr];
    NSString * searchStars = [self extractValueBetweenBeginStr:@" stars=\"" andEndStr:@"\" distance=" inTxtStr:searchXmlStr];
    NSString * searchDistance = [self extractValueBetweenBeginStr:@" distance=\"" andEndStr:@"\"/>" inTxtStr:searchXmlStr];
    
    NSString * entityName = @"AddedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil) 
    {
        NSLog(@"%@s is (null", entityName);
        return;
    }
    
    
    int idx;
    BOOL isDataNotExistInItems = YES; 
    for(idx = 0 ; idx < [items count] ; idx++)
    {
        AddedItem * item = [items objectAtIndex:idx];
        if( [item.mId isEqualToString:searchId]) 
        {
            isDataNotExistInItems = NO;
            item.mDirection = searchDirection;
            //            item.mDirection = @"270";
            item.mDirtype = searchDirType;
            //            item.mDirtype = @"1";
            item.mLat = [NSNumber numberWithDouble:[searchLat doubleValue]];
            item.mLng = [NSNumber numberWithDouble:[searchLng doubleValue]];
            item.mSpeed = searchSpeed;
            //            item.mSpeed = @"50";            
            item.mStars = searchStars;
            item.mType = searchType;
            item.mVotes = searchVotes;
            NSLog(@"updated item is %@", item);
            
            
            UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Ever Add！",searchId] message:@"You ever add this new camera！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
            //[tmp show];  
            [MTPopupWindow showCameraOkWindowWithTitle:[NSString stringWithFormat:@"%@ Ever Add！",searchId] andMessage:@"You ever add this new camera！" insideView:[vars.exterNav topViewController].view];
            
            //showCameraOkWindowWithTitle
            
            tmp = nil;
            
        }
    }
    
    if(isDataNotExistInItems) 
    {
        AddedItem * item = (AddedItem*) [NSEntityDescription insertNewObjectForEntityForName:@"AddedItem" inManagedObjectContext:mContext];
        item.mId = searchId;
        item.mDirection = searchDirection;
        item.mDirtype = searchDirType;
        item.mLat = [NSNumber numberWithDouble:[searchLat doubleValue]];
        item.mLng = [NSNumber numberWithDouble:[searchLng doubleValue]];
        item.mSpeed = searchSpeed;
        item.mStars = searchStars;
        item.mType = searchType;      
        item.mVotes = searchVotes;
        NSLog(@"insert item is %@", item);
        
        UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:@"Add OK！" message:[NSString stringWithFormat:@"New Camera is Added OK！ and it's camera ID is %@", searchId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
        //[tmp show];  
        
        [MTPopupWindow showCameraOkWindowWithTitle:@"Add OK!" andMessage:[NSString stringWithFormat:@"New Camera is Added OK！ and it's camera ID is %@", searchId]  insideView:[vars.exterNav topViewController].view];

        tmp = nil;
    }
    
    NSLog(@"get search ID = %@", searchId);
    
    if(![mContext save:&error]) 
    {
        NSLog(@"save error");
    }
    
    [self combineDownloadedAndAddedToCameraItems];
    NSLog(@"complete to add speed camera proces on (lat=%@,lng=%@)", latStr,lngStr);
    
    
}


-(void) addCamera {
    GlobalVars *vars = [GlobalVars sharedInstance];
    NSLog(@"addCamera");
    NSString * latStr=@"37.335072";
    NSString * lngStr=@"-122.032604";
    
    latStr = mGpsLatitude;
    lngStr = mGpsLongitude;
    
    NSString * idStr = @"10f0b";
    
    
    NSString * urlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=add&lat=%@&lng=%@&type=1", self.mSpeedCameraApiKey,latStr,lngStr];
    NSLog(@"[ADD ACTION] urlStr = %@", urlStr);
    
    
    vars.mEditCameraAddViewIVC.mCurHeading = self.mHdgValueLbl.text;
    vars.mEditCameraAddViewIVC.mCurLatStr = latStr;
    vars.mEditCameraAddViewIVC.mCurLngStr = lngStr;
    vars.mEditCameraAddViewIVC.mApiKey = mSpeedCameraApiKey;
    
    //    [self performclickToOpenAlert
    [self performSelector:@selector(clickToOpenAlert:) withObject:nil];
    return;
    
    NSString * xmlStr = [self getXmlStringFromUrlStr:urlStr];
    NSString * statusVal = [self extractValueBetweenTag:@"status" inXmlStr:xmlStr];
    NSString * idVal = [self extractValueBetweenTag:@"id" inXmlStr:xmlStr];
    NSLog(@"status=%@, id=%@", statusVal, idVal);
    if(idVal == nil || [idVal isEqualToString:@""])
    {
        idVal = idStr;
    }
    
    //test url is here http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=search&lat=37.335072&lng=-122.032604&limit=1;
    
    
    NSString * searchUrlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=search&lat=%@&lng=%@&limit=1", self.mSpeedCameraApiKey,latStr,lngStr];
    NSString * searchXmlStr = [self getXmlStringFromUrlStr:searchUrlStr];
    NSString * searchId = [self extractValueBetweenBeginStr:@"<marker id=\"" andEndStr:@"\" lat=" inTxtStr:searchXmlStr];
    NSString * searchLat = [self extractValueBetweenBeginStr:@" lat=\"" andEndStr:@"\" lng=" inTxtStr:searchXmlStr];
    NSString * searchLng = [self extractValueBetweenBeginStr:@" lng=\"" andEndStr:@"\" type_var=" inTxtStr:searchXmlStr];
    NSString * searchTypeVar = [self extractValueBetweenBeginStr:@" type_var=\"" andEndStr:@"\" type=" inTxtStr:searchXmlStr];
    NSString * searchType = [self extractValueBetweenBeginStr:@" type=\"" andEndStr:@"\" speed=" inTxtStr:searchXmlStr];
    NSString * searchSpeed = [self extractValueBetweenBeginStr:@" speed=\"" andEndStr:@"\" dirtype=" inTxtStr:searchXmlStr];
    NSString * searchDirType = [self extractValueBetweenBeginStr:@" dirtype=\"" andEndStr:@"\" direction=" inTxtStr:searchXmlStr];
    NSString * searchDirection = [self extractValueBetweenBeginStr:@" direction=\"" andEndStr:@"\" votes=" inTxtStr:searchXmlStr];
    NSString * searchVotes = [self extractValueBetweenBeginStr:@" votes=\"" andEndStr:@"\" stars=" inTxtStr:searchXmlStr];
    NSString * searchStars = [self extractValueBetweenBeginStr:@" stars=\"" andEndStr:@"\" distance=" inTxtStr:searchXmlStr];
    NSString * searchDistance = [self extractValueBetweenBeginStr:@" distance=\"" andEndStr:@"\"/>" inTxtStr:searchXmlStr];
    
    NSString * entityName = @"AddedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil) 
    {
        NSLog(@"%@s is (null", entityName);
        return;
    }
    
    
    int idx;
    BOOL isDataNotExistInItems = YES; 
    for(idx = 0 ; idx < [items count] ; idx++)
    {
        AddedItem * item = [items objectAtIndex:idx];
        if( [item.mId isEqualToString:searchId]) 
        {
            isDataNotExistInItems = NO;
            item.mDirection = searchDirection;
            //            item.mDirection = @"270";
            item.mDirtype = searchDirType;
            //            item.mDirtype = @"1";
            item.mLat = [NSNumber numberWithDouble:[searchLat doubleValue]];
            item.mLng = [NSNumber numberWithDouble:[searchLng doubleValue]];
            item.mSpeed = searchSpeed;
            //            item.mSpeed = @"50";            
            item.mStars = searchStars;
            item.mType = searchType;
            item.mVotes = searchVotes;
            NSLog(@"updated item is %@", item);
            
            
            UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Ever Add！",searchId] message:@"You ever add this new camera！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
            //[tmp show];  
            [MTPopupWindow showCameraOkWindowWithTitle:[NSString stringWithFormat:@"%@ Ever Add！",searchId] andMessage:@"You ever add this new camera！" insideView:[vars.exterNav topViewController].view];

            tmp = nil;
            
        }
    }
    if(isDataNotExistInItems) 
    {
        AddedItem * item = (AddedItem*) [NSEntityDescription insertNewObjectForEntityForName:@"AddedItem" inManagedObjectContext:mContext];
        item.mId = searchId;
        item.mDirection = searchDirection;
        item.mDirtype = searchDirType;
        item.mLat = [NSNumber numberWithDouble:[searchLat doubleValue]];
        item.mLng = [NSNumber numberWithDouble:[searchLng doubleValue]];
        item.mSpeed = searchSpeed;
        item.mStars = searchStars;
        item.mType = searchType;      
        item.mVotes = searchVotes;
        NSLog(@"insert item is %@", item);
        
        UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:@"Add OK！" message:[NSString stringWithFormat:@"New Camera is Added OK！ and it's camera ID is %@", searchId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
        //[tmp show];  
        [MTPopupWindow showCameraOkWindowWithTitle:@"Add OK！" andMessage:[NSString stringWithFormat:@"New Camera is Added OK！ and it's camera ID is %@", searchId] insideView:[vars.exterNav topViewController].view];

        tmp = nil;
    }
    
    NSLog(@"get search ID = %@", searchId);
    
    if(![mContext save:&error]) 
    {
        NSLog(@"save error");
    }
    
    [self combineDownloadedAndAddedToCameraItems];
    NSLog(@"complete to add speed camera proces on (lat=%@,lng=%@)", latStr,lngStr);
}

-(void) confirmCamera {
    NSLog(@"confirmCamera");
    NSString * latStr=@"37.335072";
    NSString * lngStr=@"-122.032604";
    NSString * idStr = @"10f0b";
    //http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=vote&lat=37.335072&lng=-122.032604   
    //http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=vote&id=10f0b
    
    
    
    if(mFocusCameraId!=nil) {
        idStr = mFocusCameraId;
    }
    
    NSString * urlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=vote&id=%@", self.mSpeedCameraApiKey,idStr];
    NSLog(@"[CONFIRM ACTION] urlStr = %@", urlStr);
    
    
    
    NSString * entityName = @"ConfirmedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil) 
    {
        NSLog(@"%@s is (null", entityName);
        return;
    }
    
    
    NSString * searchId = idStr;
    int idx;
    BOOL isDataNotExistInItems = YES; 
    for(idx = 0 ; idx < [items count] ; idx++)
    {
        ConfirmedItem * item = [items objectAtIndex:idx];
        if( [item.mId isEqualToString:searchId])
        {
            isDataNotExistInItems = NO;
            //            NSLog(@"confired item %@ had confirmed before", item);
            //            NSManagedObject *mgrobj = [items objectAtIndex:idx];
            //            [mContext deleteObject:mgrobj];
            UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Ever Confirm!",idStr] message:@"You ever confirm this camera！ It's mean that you cannot confirmed again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            //[tmp show];  
            GlobalVars *vars = [GlobalVars sharedInstance];
            [MTPopupWindow showCameraOkWindowWithTitle:[NSString stringWithFormat:@"%@ Ever Confirm!",idStr] andMessage:@"You ever confirm this camera！ It's mean that you cannot confirmed again" insideView:[vars.exterNav topViewController].view];

            tmp = nil;            
        }
    }
    if(isDataNotExistInItems) 
    {
        NSString * xmlStr = [self getXmlStringFromUrlStr:urlStr];
        NSString * statusVal = [self extractValueBetweenTag:@"status" inXmlStr:xmlStr];
        NSString * starsVal = [self extractValueBetweenTag:@"stars" inXmlStr:xmlStr];
        
        
        
        ConfirmedItem * item = (ConfirmedItem*) [NSEntityDescription insertNewObjectForEntityForName:@"ConfirmedItem" inManagedObjectContext:mContext];
        
        UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Confirm OK！" , mFocusCameraId] message:@"New Camera is Added OK！" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
        //[tmp show];  
        GlobalVars *vars = [GlobalVars sharedInstance];
        [MTPopupWindow showCameraOkWindowWithTitle:[NSString stringWithFormat:@"%@ Confirm OK！" , mFocusCameraId] andMessage:@"New Camera is Added OK！" insideView:[vars.exterNav topViewController].view];
        
        tmp = nil;
        
        
        
        item.mId = searchId;
        NSLog(@"insert item is %@ and with network status=%@ & stars=%@", item, statusVal, starsVal);
    }
    
    if(![mContext save:&error]) 
    {
        NSLog(@"save error");
    }
}

-(void) deleteCamera 
{
    NSLog(@"deleteCamera");
    NSLog(@"confirmCamera");
    NSString * latStr=@"37.335072";
    NSString * lngStr=@"-122.032604";
    NSString * idStr = @"10f0b";
    //http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=bury&lat=37.335072&lng=-122.032604   
    //http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=bury&id=10f0b
    
    if(mFocusCameraId!=nil) {
        idStr = mFocusCameraId;
    }
    
    
    NSString * urlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=bury&id=%@", self.mSpeedCameraApiKey,idStr];
    NSLog(@"[CONFIRM ACTION] urlStr = %@", urlStr);
    
    
    NSString * entityName = @"DeletedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil) 
    {
        NSLog(@"%@s is (null", entityName);
        return;
    }
    
    
    NSString * searchId = idStr;
    int idx;
    BOOL isDataNotExistInItems = YES; 
    for(idx = 0 ; idx < [items count] ; idx++)
    {
        DeletedItem * item = [items objectAtIndex:idx];
        if( [item.mId isEqualToString:searchId])
        {
            isDataNotExistInItems = NO;
            NSLog(@"deleted item %@ had deleted before", item);
            NSManagedObject *mgrobj = [items objectAtIndex:idx];
            [mContext deleteObject:mgrobj];
            UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Undelete OK！",idStr] message:@"You Undelete this camera OK" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
            //[tmp show];  
            GlobalVars *vars = [GlobalVars sharedInstance];
            [MTPopupWindow showCameraOkWindowWithTitle:[NSString stringWithFormat:@"%@ Undelete OK！",idStr] andMessage:@"You Undelete this camera OK" insideView:[vars.exterNav topViewController].view];

            
            tmp = nil;
            
        }
    }
    
    if(isDataNotExistInItems) 
    {
        NSString * xmlStr = [self getXmlStringFromUrlStr:urlStr];
        NSString * statusVal = [self extractValueBetweenTag:@"status" inXmlStr:xmlStr];
        NSString * starsVal = [self extractValueBetweenTag:@"stars" inXmlStr:xmlStr];
        
        DeletedItem * item = (DeletedItem*) [NSEntityDescription insertNewObjectForEntityForName:@"DeletedItem" inManagedObjectContext:mContext];
        item.mId = searchId;
        UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Delete OK！",idStr] message:@"You delete this camera OK" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[tmp show];  
        GlobalVars * vars = [GlobalVars sharedInstance];
        [MTPopupWindow showCameraOkWindowWithTitle:[NSString stringWithFormat:@"%@ Delete OK！",idStr] andMessage:@"You delete this camera OK" insideView:[vars.exterNav topViewController].view];
        
        tmp = nil;
        
        //        NSLog(@"insert item is %@ and with network status=%@ & stars=%@", item, statusVal, starsVal);
    }
    
    if(![mContext save:&error]) 
    {
        NSLog(@"save error");
    }
    
    
}



-(IBAction) clickToAddCamera:(id)sender {
    NSLog(@"clickToAddCamera");
    [self addCamera];
}
-(IBAction) clickToConfirmCamera:(id)sender {
    NSLog(@"clickToConfirmCamera");
    [self confirmCamera];
}
-(IBAction) clickToDeleteCamera:(id)sender {
    NSLog(@"clickToDeleteCamera");
    [self deleteCamera];
    //for solve issue from kevin
    [self makeMarkersDomFromLocalData];
    [self refreshGuiByMarkersDom];
    
    
}

-(IBAction)clickToModifyCamera:(id)sender {
    NSLog(@"clickToModifyCamera");
}


-(IBAction) clickToSelectDownloadCountryData:(id)sender {
    NSLog(@"clickToSelectDownloadCountryData");
    switch(self.mDownloadDataOfCountrySeg.selectedSegmentIndex) {
        case 0: //US seelect country as USA
            self.mIsDownloadCountryTW = NO;
            NSLog(@"self.mIsDownloadCountryTW = NO");
            break;
        case 1: //TW select country as Taiwan
            self.mIsDownloadCountryTW = YES;
            NSLog(@"self.mIsDownloadCountryTW = YES");
            break;
    }
    
    if(self.mIsDownloadCountryTW == NO) 
    {
        self.mUpdateBtn.titleLabel.text = @"update US";
    } 
    else 
    {
        self.mUpdateBtn.titleLabel.text = @"updateTW";
    }
    
    //[self performSelector:@selector(clickToParseMarkers:) withObject:nil];
    
}

-(IBAction)sliderToChangeSpeedDetectRate:(id)sender {
    NSLog(@"sliderToChangeSpeedDetectRate");
    UISlider * slider = (UISlider*) sender;
    CGFloat val = [slider value];
    mSpeedDetectRate = (double)(1.0f + val * 0.3f);
    NSLog(@"mSpeedDetectRate = %g", mSpeedDetectRate);
}


//UrlAndXmlFuncs
-(NSString*) getXmlStringFromUrlStr:(NSString*)urlStr {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];           
    [request setURL:[NSURL URLWithString:urlStr]];  
    [request setHTTPMethod:@"GET"];  
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    request = nil;
    NSString * loadData = [[NSMutableString alloc] initWithData:returnData encoding:NSISOLatin1StringEncoding];
    return loadData;
}

//UrlAndXmlFuncs
-(NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr inTxtStr:(NSString*)txtStr;

{
    NSString *loadData = txtStr;
    NSString *pattern = [NSString stringWithFormat:@"%@(.+)%@", beginStr, endStr];    
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:loadData options:0 range:NSMakeRange(0, loadData.length)];
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [loadData substringWithRange:matchRange];
    if([match isEqualToString:@""]) {
        return nil;
    }
    return match;
    
}

//UrlAndXmlFuncs
-(NSString*) extractValueBetweenTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    return [self 
            extractValueBetweenBeginStr:[NSString stringWithFormat:@"<%@>",tagName] 
            andEndStr:[NSString stringWithFormat:@"</%@>",tagName] 
            inTxtStr:xmlStr
            ];    
}



-(IBAction) clickToMarkerFilterModeChange:(id)sender {
    NSLog(@"clickToMarkerFilterModeChange");
    //    switch(self.mIsFreewayModeOn
    switch(self.mMarkerFilterModeSeg.selectedSegmentIndex) {
        case 0://s street mode
            self.mIsFreewayModeOn = NO;
            NSLog(@"mIsFreewayModeOn = NO");
            break;
        case 1://f freeway mode
            self.mIsFreewayModeOn = YES;
            NSLog(@"mIsFreewayModeOn = YES");            
            break;
    }
    
    [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
}

-(IBAction)clickToDownloadLastestLocalData:(id)sender {
    NSLog(@"clickToDownloadLastestLocalData");
    
    if(mIsOnInternetProcess) return;
    
    if(mIsUsingLocalImpl != YES) return;
    
    mIsOnInternetProcess = YES;
    if(mTempDownloadData!= nil) {
        mTempDownloadData = nil;
    }
    
    //    [self clearAllCameraInDB];
    [self clearAllDownloadedInDB];
    mTempDownloadData = [NSMutableData alloc];
    NSString * speedCameraTxtUS = @"http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=get&country=us&fileType=all&version=2";
    NSString * speedCameraTxtTW = @"http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=get&country=tw&fileType=all&version=2";
    
    NSString * speedCameraTxt = speedCameraTxtUS;
    if(mIsDownloadCountryTW) {
        speedCameraTxt = speedCameraTxtTW;        
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:speedCameraTxt]];    
    self.mConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
    NSLog(@"download data for %@", speedCameraTxt);
    
}

-(IBAction)clickToZoom:(id)sender {
    NSLog(@"clickToZoom");
    
	if (mNewLocation != nil ) 
    {
        
        GlobalVars *vars = [GlobalVars sharedInstance];
		MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(mNewLocation.coordinate, 3000.0, 3000.0);        
        //		[regionsMapView setRegion:userLocation animated:YES];
        

        //comment by milo 
//        if(vars.mEVC.mRegionsMapView != nil) {
//            [vars.mEVC.mRegionsMapView setRegion:userLocation animated:YES];
//            vars.mEVC.mRegionsMapView.showsUserLocation = YES;
//        }
        
        
        
        if(mRegionsMapView != nil ) {
            [self.mRegionsMapView setRegion:userLocation animated:YES];
            self.mRegionsMapView.showsUserLocation = YES;
        }
	}
}




#pragma mark - View lifecycle
-(IBAction) clickToSelShowMap:(id)sender {
    NSLog(@"clickToSelShowMap");
    switch(self.mShowMapSwitchSegCtrl.selectedSegmentIndex) {
        case 0: //Y
            self.mRegionsMapView.hidden = NO;
            self.mModifyCameraBtn.hidden = NO;
            self.mAddCameraBtn.hidden = NO;
            self.mConfirmCameraBtn.hidden = NO;
            self.mDeleteCameraBtn.hidden = NO;
            self.mSPCLogWebView.hidden = YES;
            break;
        case 1: //N
            self.mSPCLogWebView.hidden = NO;
            self.mRegionsMapView.hidden = YES;
            self.mModifyCameraBtn.hidden = YES;
            self.mAddCameraBtn.hidden = YES;
            self.mConfirmCameraBtn.hidden = YES;
            self.mDeleteCameraBtn.hidden = YES;
            break;
    }
}




-(void) testWebViewHTMLContent {
    NSString *showStr = @"";
    NSString *contentHeader = @"<html><meta name=\"viewport\" content=\"width=1024, user-scalable=yes initial scale=1.0\"/><head><style type=\"text/css\">\nbody {font-family:helvetica;}</style></head><body bgcolor=black><font color=white size=2>";
    NSString *contentTail = @"</font></body></html>";
    NSString *tableHeader = @"<table style=\"border: 7px none ; background-color:rgb(0, 0, 0);border-color:rgb(255,255,255)\" borderColor=white align=left border=0 cellpadding=5 cellspacing=5 frame=border rules=all>";
    
    NSString *tableColumnsHeader = [NSString stringWithFormat:@"<tr style=\"color:white\"><th>%@</th><th>%@</th><th>%@</th>", @"Col1", @"Col2", @"Col3"];
    NSString *tableSelectedRow = [NSString stringWithFormat:@"<tr style=\"color:red\"><td>%@</td><td>%@</td><td>%@</td>", @"Field1", @"Field2", @"Field3"];
    NSString *tableUnselectedRow = [NSString stringWithFormat:@"<tr style=\"color:gray\"><td>%@</td><td>%@</td><td>%@</td>", @"Field1", @"Field2", @"Field3"];
    NSString *tableTail = @"</table>";
    
    showStr = [showStr stringByAppendingString:contentHeader];
    showStr = [showStr stringByAppendingString:tableHeader];
    showStr = [showStr stringByAppendingString:tableColumnsHeader];
    showStr = [showStr stringByAppendingString:tableSelectedRow];
    showStr = [showStr stringByAppendingString:tableSelectedRow];
    showStr = [showStr stringByAppendingString:tableUnselectedRow];
    showStr = [showStr stringByAppendingString:tableUnselectedRow];
    showStr = [showStr stringByAppendingString:tableSelectedRow];
    showStr = [showStr stringByAppendingString:tableUnselectedRow];
    showStr = [showStr stringByAppendingString:tableUnselectedRow];    
    showStr = [showStr stringByAppendingString:tableUnselectedRow];
    showStr = [showStr stringByAppendingString:tableUnselectedRow];    
    showStr = [showStr stringByAppendingString:tableUnselectedRow];
    showStr = [showStr stringByAppendingString:tableUnselectedRow];    
    showStr = [showStr stringByAppendingString:tableSelectedRow];    
    showStr = [showStr stringByAppendingString:tableTail];
    showStr = [showStr stringByAppendingString:contentTail];    
    
    self.mSPCLogWebView.backgroundColor = [UIColor blackColor];
    self.mSPCLogWebView.scalesPageToFit = YES;
    self.mSPCLogWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    [self.mSPCLogWebView loadHTMLString:showStr baseURL:nil];
}



-(NSString *)URLEncodedStringPipe:(NSStringEncoding)encoding inUrlStr:(NSString*)urlStr{
    return (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)urlStr,NULL,(CFStringRef)@"|", CFStringConvertNSStringEncodingToEncoding(encoding));
}



-(void) downloadNewFocusCameraImg:(SCPMarker*)marker
{
    
    //    mMapImgUrlStr = @"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/1.png|40.182570,29.066870&sensor=false";
    
//    mMapImgUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/1.png|%@,%@&sensor=false",mGpsLatitude,mGpsLongitude];
    
    
    mMapImgUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/%@.png|%@,%@&sensor=false",[self getTypeIntegerByType:marker.mType], marker.mLat,marker.mLng];
    NSLog(@"downloadNewFocusCameraImge  marker.mType = %@", marker.mType);
    
//    mMapImgUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/%@.png|%@,%@&sensor=false",marker.mType,marker.mLat,marker.mLng];
    
    
    NSString * encodedStr = [self URLEncodedStringPipe:NSUTF8StringEncoding inUrlStr:mMapImgUrlStr];
    NSLog(@"encodedStr = %@", encodedStr);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];               
    
    
    [request setURL:[NSURL URLWithString:encodedStr]];
    [request setHTTPMethod:@"GET"];
    
    NSError * err = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    request = nil;
    if(err!= nil) 
    {
        NSLog(@"%@", [err localizedDescription]);
    }
    
    
    UIImage * image = [UIImage imageWithData:returnData];
    self.mMapImgView.image = image;
}



-(IBAction) clickToDownloadImage:(id)sender {
    
//    mMapImgUrlStr = @"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/1.png|40.182570,29.066870&sensor=false";
    
    mMapImgUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/1.png|%@,%@&sensor=false",mGpsLatitude,mGpsLongitude];
    
    
    NSString * encodedStr = [self URLEncodedStringPipe:NSUTF8StringEncoding inUrlStr:mMapImgUrlStr];
    NSLog(@"encodedStr = %@", encodedStr);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];               
    
    
    [request setURL:[NSURL URLWithString:encodedStr]];      
    [request setHTTPMethod:@"GET"];
    
    NSError * err = nil;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    request = nil;
    if(err!= nil) 
    {
        NSLog(@"%@", [err localizedDescription]);
    }
    
    
    UIImage * image = [UIImage imageWithData:returnData];
    self.mMapImgView.image = image;
}




-(IBAction) clickToLoadInternetImg:(id)sender {
    
    [self clickToDownloadImage:nil];
    return ; 
    NSLog(@"clickToLoadInternetImg start");     
    mMapImgUrlStr = @"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/1.png|40.182570,29.066870&sensor=false";
    NSString * encodedStr = [self URLEncodedStringPipe:NSUTF8StringEncoding inUrlStr:mMapImgUrlStr];
    
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];           
    [request setURL:[NSURL URLWithString:mMapImgUrlStr]];  
    [request setHTTPMethod:@"GET"];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    request = nil;
    
    UIImage * image = [UIImage imageWithData:returnData];
    self.mMapImgView.image = image;
    
    NSLog(@"clickToLoadInternetImg end");    
        
    

}


-(void) showDomOnWebViewHTMLContent 
{
    
    NSString *contentHeader = @"<html><meta name=\"viewport\" content=\"width=640, user-scalable=yes initial scale=1.0\"/><head><style type=\"text/css\">\nbody {font-family:helvetica;font-size:9px;}</style></head><body bgcolor=black><font color=white>";
    NSString *contentTail = @"</body></html>";
    NSString *tableHeader = @"<table style=\"border: 7px none ; background-color:rgb(0, 0, 0);border-color:rgb(255,255,255)\" borderColor=white align=left border=0 cellpadding=5 cellspacing=5 frame=border rules=all>";    
    NSString *tableTail = @"</table>";    
    
    //    NSString *tableColumnsHeader = [NSString stringWithFormat:@"<tr style=\"color:white\"><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th></tr>", @"idx", @"id", @"type", @"speed", @"latitude", @"longtitude", @"direction", @"distance"];
    
    NSString *tableColumnsHeader = [NSString stringWithFormat:@"<tr style=\"color:white\"><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th></tr>", @"idx", @"id", @"type", @"speed", @"dirtype", @"direction", @"direction", @"distance"];
    
    NSString *tableSelectedRowFmt =@"<tr style=\"color:red\"><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>";  
    NSString *tableUnselectedRowFmt =@"<tr style=\"color:white\"><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>";
    
    NSString *showStr = @"";
    showStr = [showStr stringByAppendingString:contentHeader];
    showStr = [showStr stringByAppendingString:tableHeader];
    showStr = [showStr stringByAppendingString:tableColumnsHeader];
    int idx;
    //    for ( idx = 0; idx<[self.mSCPMarkersDom.mMarkerArray count]; idx++) 
    for ( idx = 0; idx<[self.mSCPMarkersDom.mSortedMarkerArray count]; idx++)     
    {
        SCPMarker * marker = [self.mSCPMarkersDom.mSortedMarkerArray objectAtIndex:idx];
        NSString *idxStr = [NSString stringWithFormat:@"%d", idx];
        NSString *idStr = marker.mId;
        NSString *typeStr = marker.mType;
        NSString *speedStr = marker.mSpeed;
        NSString *latStr = marker.mLat;
        NSString *lngStr = marker.mLng;
        NSString *directionStr = [self figureOutHeadingWithMarker:marker];
        NSString *distanceStr = [self figureOutDistanceWithMarker:marker];
        
        NSString * dirType = marker.mDirType;
        NSString * dirVal = marker.mDirection;
        
        
        NSString *rowFmt = @"";
        
        //        if(idx==0) 
        if(idx==self.mSCPMarkersDom.mHighChanceMarkerIdx)  
        {
            rowFmt = tableSelectedRowFmt ;
            
            //add by milo for dynamic give value for mFocusCemeraId
            if([mFocusCameraId isEqualToString:marker.mId]) {
                
            }
            else {
                [self downloadNewFocusCameraImg:marker];
            }
            mFocusCameraId = marker.mId;
            [self notifyFocusCameraIdChangeWithMarker:marker];
            
        }
        else {
            rowFmt = tableUnselectedRowFmt;
        }
        
        //        NSString *rowStr = [NSString stringWithFormat:rowFmt, idxStr,idStr,typeStr,speedStr,latStr,lngStr,directionStr,distanceStr];
        NSString *rowStr = [NSString stringWithFormat:rowFmt, idxStr,idStr,typeStr,speedStr,dirType,dirVal,directionStr,distanceStr];        
        showStr = [showStr stringByAppendingString:rowStr];
    }
    
    showStr = [showStr stringByAppendingString:tableTail];
    showStr = [showStr stringByAppendingString:contentTail];    
    
    self.mSPCLogWebView.backgroundColor = [UIColor blackColor];
    self.mSPCLogWebView.scalesPageToFit = YES;
    self.mSPCLogWebView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.mSPCLogWebView loadHTMLString:showStr baseURL:nil];
    
}

-(IBAction) updateMapImgView:(id)sender {
    mMapImgUrlStr = @"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/1.png|40.182570,29.066870&sensor=false";
    NSURL * url = [NSURL URLWithString:mMapImgUrlStr];
    UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    self.mMapImgView.image = image;
    NSLog(@"updateMapImgView done");
    
}
//add by milo
-(void)notifyFocusCameraIdChangeWithMarker:(SCPMarker*)marker 
{

    GlobalVars *vars = [GlobalVars sharedInstance];
//    mMapImgUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?size=320x240&markers=icon:http://speedcamerapoi.com/1.png|40.182570,29.066870&sensor=false"];

//    [self performSelector:@selector(clickToDownloadImage:) withObject:nil afterDelay:0.2];
//    [self downloadNewFocusCameraImg:marker];
    
    
//   mMapImgView 
    self.mWidgetMarker = marker;

    self.mVotesNumLbl.text = marker.mVotes;
    int starNum =0;
    if(marker.mStars != nil && [marker.mStars length] == 1 )
    {
        starNum = [marker.mStars intValue];
    }
    
    mStar1Img.hidden = NO;
    mStar2Img.hidden = NO;
    mStar3Img.hidden = NO;
    mStar4Img.hidden = NO;
    mStar5Img.hidden = NO;
    
    mStar1Img.alpha = 0.3f;
    mStar2Img.alpha = 0.3f;
    mStar3Img.alpha = 0.3f;
    mStar4Img.alpha = 0.3f;
    mStar5Img.alpha = 0.3f;
    
    switch (starNum) 
    {
        case 5: mStar5Img.alpha =1.0f;            
        case 4: mStar4Img.alpha =1.0f;
        case 3: mStar3Img.alpha =1.0f;            
        case 2: mStar2Img.alpha =1.0f;            
        case 1: mStar1Img.alpha =1.0f;
            break;
    }
    
    
    self.mSpdLimitLbl.text = marker.mSpeed;

    int cameraTypeInt = [self getIntegerValueByType:marker.mType];
    if(cameraTypeInt == 3)  //Redlight
    { 
//        self.mSpdLimitLbl.hidden = YES;
//        self.mSpdLimitBg.hidden = YES;
        self.mSpdLimitLbl.hidden = NO;
        self.mSpdLimitBg.hidden = NO;
        self.mSpdLimitLbl.text = @"0";
        
    }
    else {
        self.mSpdLimitLbl.hidden = NO;
        self.mSpdLimitBg.hidden = NO;
    }
    
    
    
    
    self.mAbbrAddrLbl.text = self.mAddressLbl.text;
//    self.mSpdCameraTypeLbl.text = marker.mType;
    self.mSpdCameraTypeLbl.text = [self getShortNameByType:marker.mType];
    
    NSString * imageName = [self getTypeImageNameByType:marker.mType];
//    NSLog(@"imageName = %@",imageName);
    self.mTypeImg.hidden = YES;
    if(imageName != nil) {
        self.mTypeImg.image = [UIImage imageNamed:imageName];
        self.mTypeImg.hidden = NO;
    }

    
    
//    self.mDisAndDirLbl.text = [NSString stringWithFormat:@"%g, %@", marker.mDynamicDistance,marker.mDirection];
    self.mDisAndDirLbl.text = [self getDisAndDirFormatStr:marker];
    
                               
    //[NSString stringWithFormat:@"%g, %@", marker.mDynamicDistance,marker.mDirection];


    

    
//    GlobalVars *vars = [GlobalVars sharedInstance];
    UIViewController * topvc = [vars.exterNav topViewController];
    if(topvc == vars.mEVC) {
        vars.mEVC.mNoCameraDetectedLbl.hidden = YES;
        
        [vars.mEVC refreshSpeedCameraWidget];
    }
}

+(NSString*)getDisAndDirFormatStr:(SCPMarker*)marker {
    //mDisAndDirLbl.text
    NSString * distStr = [NSString stringWithFormat:@"%g", marker.mDynamicDistance];
    if([distStr length]>5){
        distStr = [distStr substringWithRange:NSMakeRange(0,3)];
    }
    
    NSString * dirIntStr = marker.mDirection;
    
    
    NSString*  curCourseStr = dirIntStr;
    double heading = [curCourseStr doubleValue];
    int headingInt = (int)heading;
    NSString * dirStr = @"N";
    headingInt = (headingInt + 360 ) % 360;
    if(headingInt >= 360-22 || headingInt < 0+23 ) dirStr = @"North";
    if(headingInt >= 0+23 || headingInt < 45+23 ) dirStr = @"North East";  
    if(headingInt >= 45+23 || headingInt < 90+23) dirStr = @"East";
    if(headingInt >= 90+23 || headingInt < 135+23) dirStr = @"South East";
    if(headingInt >= 135+23 || headingInt < 180+23) dirStr = @"South";
    if(headingInt >= 180+23 || headingInt < 225+23) dirStr = @"South West";
    if(headingInt >= 225+23 || headingInt < 270+23) dirStr = @"West ";
    if(headingInt >= 270+23 || headingInt < 315+23) dirStr = @"North West";
    
    
    return [NSString stringWithFormat:@"%@ %@km ", dirStr, distStr];
}

-(NSString*)getDisAndDirFormatStr:(SCPMarker*)marker {
    //mDisAndDirLbl.text
//    NSString * distStr = [NSString stringWithFormat:@"%g", marker.mDynamicDistance];
//    distStr = [distStr substringWithRange:NSMakeRange(0,6)];
//    NSString * dirStr = marker.mDirection;
//    return [NSString stringWithFormat:@"%@, %@", distStr,dirStr];    
    return [SpeedCameraExterViewController getDisAndDirFormatStr:marker];
}


-(CLLocation*) getCarLocation 
{
    if(mNewLocation != nil) 
    {
        return mNewLocation;
    } 
    else if(mLastestParsedLocation != nil)
    {
        return mLastestParsedLocation;
    }
    else 
    {
        return nil;
    }
}



-(NSString*) figureOutDistanceWithMarker:(SCPMarker*) marker {
    if(marker == nil) return @"dom failed";
    CLLocation *carLoc = nil;
    
    double dval = marker.mDynamicDistance;
    return [NSString stringWithFormat:@"%g", dval];
    
    carLoc = [self getCarLocation];
    if(carLoc == nil) return @"lose car loc";
    
    
    CLLocation * markerLoc = [[CLLocation alloc]initWithLatitude:[marker.mLat doubleValue] longitude:[marker.mLng doubleValue]];
    
    return [NSString stringWithFormat:@"%g",[carLoc bearingToLocation:markerLoc]];    
}


-(NSString*) figureOutHeadingWithMarker:(SCPMarker*) marker{
    if(marker == nil) return @"dom failed";
    CLLocation *carLoc = nil;
    carLoc = [self getCarLocation];
    if(carLoc == nil ) {
        return @"lose car loc";
    }
    
    
    int ival = marker.mDynamicMarkerAtAngle;
    return [NSString stringWithFormat:@"%d", ival];
    
    
    
    int carHead = (int)[carLoc course];
    int dirType = [marker.mDirType intValue];
    
    double x1 = carLoc.coordinate.longitude;
    double y1 = carLoc.coordinate.latitude;
    double x2 = [marker.mLng doubleValue];
    double y2 = [marker.mLat doubleValue];
    double difx = x2-x1;
    double dify = y2-y1;
    double r = sqrt( ((difx)*(difx) + (dify)*(dify)) );
    double angle = acos( ((difx)/r));
    angle = (angle*180.0f)/(M_PI);
    if(dify <0) angle  =angle * -1 ;
    if(angle< 0) angle = angle+360;
    int spdAngle = (int)angle;
    //For spdAngle variable. now the base angle=0 is indicate on right and anti-clockwise moving is positive angle moving.
    
    
    int carAngle = [carLoc course];
    carAngle = (carAngle+270)%360;
    carAngle = (360 - carAngle)%360; //translate from clockwise to anti-clockwise
    //For carAngle variable. now the base carAngle=0 is indicate on right and anti-clockwise rotating is positive angle moving.
    
    
    int spdRelativeAngle = (spdAngle + 360 - carAngle) % 360;
    //spdRelativeAngle is a spdAngle that relative to carAngle by presumming anti-clockwise rotating as postive angle and carAngle like as 0 degree.
    
    int spdRotatedAngle = 0; //when car anti-clockwise rotating the angle=spdRotatedAngle car direction will direct meet the SpeedCamera. so this is what we defined for spdRotatedAngle; but because some speedcamera's position will more easy to indicate by clockwise rotating, so we give a nagivative value to denote that the efficient way to indicate speed camera is to clock-wise rotate.
    
    
    if(spdRelativeAngle < 180) {
        spdRotatedAngle = spdRelativeAngle;
    } else {
        spdRotatedAngle = spdRelativeAngle -360;
    }
    
    return [NSString stringWithFormat:@"%d",spdRotatedAngle];  
}


-(void) zoomLocationToMap {
    mIsZoomToMap = true;
}


-(void) parseXmlToMarkersDomFromInternet {
    mIsOnInternetProcess = YES;
    NSLog(@"parseXmlToMarkersDomFromInternet");
    [self testWebViewHTMLContent];
    [self zoomLocationToMap ];
    
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    if(self.mSCPMarkersDom != nil) {
        [self.mSCPMarkersDom cleanAllData];
        self.mSCPMarkersDom = nil;
    }
    
    
    self.mSCPMarkersDom = [[SCPMarkersDom alloc]init];    
    if(mTempDownloadData != nil) {
        mTempDownloadData = nil;
    }
    mTempDownloadData = [NSMutableData alloc];
    
    if(mSpeedCameraApiKey == nil) {
        mSpeedCameraSearchURL = [self makeSpeedCameraSearchURLByKey:self.mSpeedCameraApiKey withLatitude:self.mGpsLatitude andLongtitude:self.mGpsLongitude andLimit:@"2"];
    }
    
    self.mSpeedCameraSearchURL = [self makeSpeedCameraSearchURLByKey:self.mSpeedCameraApiKey withLatitude:mGpsLatitude andLongtitude:mGpsLongitude andLimit:[NSString stringWithFormat:@"%d",vars.mCurCameraLimitNum]];
    
    
    NSLog(@"url = %@", mSpeedCameraSearchURL);
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:self.mSpeedCameraSearchURL]];
    self.mConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];    
}

-(IBAction)clickToParseMarkers:(id)sender {
    
    if(mIsUsingLocalImpl == YES) {
        [self makeMarkersDomFromLocalData];
        [self refreshGuiByMarkersDom];
        [self zoomLocationToMap];
    }
    else {
        [self parseXmlToMarkersDomFromInternet];
    }
    
    
    SCPMarker * marker = self.mSCPMarkersDom.mHighChanceMarker;
    if(marker != nil) {
        CLLocation * markerLoc = [[CLLocation alloc]initWithLatitude:[marker.mLat doubleValue] longitude:[marker.mLng doubleValue]];
        mReverseGeocodeGpsLocation = markerLoc;
        mWarningMarkerInfoLbl.text = [NSString stringWithFormat:@"(id,type,dirtype,heading)=(%@,%@,%@,%@)",marker.mId,marker.mType,marker.mDirType,marker.mDirection];
    } else {
        mReverseGeocodeGpsLocation = nil;
        mWarningMarkerInfoLbl.text = @"it's currently no high chance camera";
    }
    
    if(mReverseGeocodeGpsLocation == nil) {
        self.mAddressLbl.text = @"it's currently no high chance camera";
    }
    
    if(mReverseGeocodeGpsLocation != nil) {
        [mGeocoder reverseGeocodeLocation:mReverseGeocodeGpsLocation completionHandler:^(NSArray*placemarks, NSError *error) {
            //[mGeocoder reverseGeocodeLocation:mGpsCLLocation completionHandler:^(NSArray*placemarks, NSError *error) {
            if (error){
                NSLog(@"Geocode failed with error: %@", error);
                //[self displayError:error];
                return;
            }
            if(placemarks && placemarks.count > 0)
            {
                //do something
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                mCLPlacemark = topResult;
                
//                NSString *addressTxt = [NSString stringWithFormat:@"%@ %@,%@ %@",                                     [topResult subThoroughfare],[topResult thoroughfare],[topResult locality], [topResult administrativeArea]];
                NSString *addressTxt = [NSString stringWithFormat:@"%@,%@ %@",[topResult thoroughfare],[topResult locality], [topResult administrativeArea]];
                
                NSString * strOnTxtView = @"";
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"ISOcountryCode = %@\n",topResult.ISOcountryCode];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"country = %@\n",topResult.country];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"postalCode = %@\n", topResult.postalCode];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"administrativeArea = %@\n", topResult.administrativeArea];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"subAdministrativeArea = %@\n", topResult.subAdministrativeArea];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"locality = %@\n", topResult.locality];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"subLocality = %@\n", topResult.subLocality];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"thoroughfare = %@\n", topResult.thoroughfare];
                strOnTxtView = [strOnTxtView stringByAppendingFormat:@"subThoroughfare = %@\n", topResult.subThoroughfare];
                //self.mShowCLPlacemarkerTextView.text = strOnTxtView;
                
                
                
                //NSLog(@"%@", addressTxt);
                //mLocationLbl.text = addressTxt;
                self.mAddressLbl.text = addressTxt;
            }
        }];
    }
}


-(void) makeMarkersDomFromLocalData {
    //    NSLog(@"makeMarkersDomFromLocalData");
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"CameraItem" inManagedObjectContext:mContext];
    [request setEntity:entity];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mId" ascending:NO];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    double queryLat = [mGpsLatitude doubleValue];
    double queryLng = [mGpsLongitude doubleValue];
    double savediff = 0.01;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"(mLat > %g) AND (mLat < %g) AND (mLng > %g) AND (mLng < %g)", queryLat-savediff, queryLat+savediff, queryLng-savediff, queryLng+savediff];
    [request setPredicate:predicate];
    
    NSError * error = nil;
    NSMutableArray *mutableFetchResults = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults == nil) 
    {
        NSLog(@"mutableFetchResults is nil");
    }
    else 
    {
        if(mSCPMarkersDom != nil) {
            [mSCPMarkersDom cleanAllData];
            mSCPMarkersDom = nil;
        }
        mSCPMarkersDom = [[SCPMarkersDom alloc]init];
        
        
        //        NSLog(@"show mutableFetchResults start");
        int idx;
        for (idx = 0; idx < [mutableFetchResults count]; idx++) 
        {
            CameraItem * item = (CameraItem*)[mutableFetchResults objectAtIndex:idx];
            
            //            NSLog(@"item[%d] = %@", idx,item);
            //        NSLog(@"item[%d] = (id=%@,lng=%@,lat=%@,type=%@,speed=%@,dirtype=%@,direction=%@,votes=%@,stars=%@) ", idx, item.mId, item.mLng, item.mLat,item.mType,item.mSpeed,item.mDirtype,item.mDirection,item.mVotes,item.mStars);
            
            SCPMarker * marker = [[SCPMarker alloc]init];
            marker.mId = item.mId;
            
            marker.mLat = [NSString stringWithFormat:@"%@", item.mLat];
            //            marker.mLng = item.mLng;
            marker.mLng = [NSString stringWithFormat:@"%@", item.mLng];
            marker.mTypeVar = item.mType;
            marker.mType=@"";
            
            int typeInt = [item.mType intValue];
            switch(typeInt) {
                case 1: marker.mType=@"Fixed Speed Camera"; break;
                case 2: marker.mType=@"Combined Speed + Redlight Camera"; break;
                case 3: marker.mType=@"Redlight Camera"; break;
                case 4: marker.mType=@"Average Speed Camera"; break;
                case 5: marker.mType=@"Mobile/SpeedTrap/Radar"; break;
                case 6: marker.mType=@"SchoolZone"; break;                    
            }
            
            marker.mSpeed = item.mSpeed;
            marker.mDirType = item.mDirtype;
            marker.mDirection = item.mDirection;
            marker.mVotes = item.mVotes;
            marker.mStars = item.mStars;
            marker.mDistance = @"";
            [mSCPMarkersDom addMarkerToRelativeArray:marker];
            //            [mSCPMarkersDom.mMarkerArray addObject:marker];
            //            [mSCPMarkersDom.mFilteredMarkerArray addObject:marker];
            if(idx>20) break;
        }
        //        NSLog(@"show mutableFetchResults end");
        //        NSLog(@" dom = %@", mSCPMarkersDom);
    }
}



-(void) showAngles {
    NSLog(@"showAngles");
    double x0 = 0.0f;
    double y0 = 0.0f;
    double xs[] = {-1.0f, -1.0f, 0.0f, 1.0f, 1.0f,  1.0f,  0.0f, -1.0f};
    double ys[] = { 0.0f,  1.0f, 1.0f, 1.0f, 0.0f, -1.0f, -1.0f, -1.0f};
    
    int idx;
    for (idx=0;idx<8;idx++) {
        
        double x1 = x0;
        double y1 = y0;
        double x2 = xs[idx];
        double y2 = ys[idx];
        double difx = x2-x1;
        double dify = y2-y1;
        double r = sqrt( ((difx)*(difx) + (dify)*(dify)) );
        double angle = acos( ((difx)/r));
        angle = (angle*180.0f)/(M_PI);
        if(dify <0) angle  =angle * -1 ;
        if(angle< 0) angle = angle+360;
        NSLog(@"[idx=%d]->%@",idx, [NSString stringWithFormat:@"%g",angle]);
    }
}

-(NSString*) makeSpeedCameraSearchURLByKey:(NSString*)key withLatitude:(NSString*)latitude andLongtitude:(NSString*)longtitude {
    NSString * urlstr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=search&lat=%@&lng=%@",key,latitude,longtitude];
    return urlstr;
}

-(NSString*) makeSpeedCameraSearchURLByKey:(NSString*)key withLatitude:(NSString*)latitude andLongtitude:(NSString*)longtitude andLimit:(NSString*)limit {
    NSString * urlstr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=search&lat=%@&lng=%@&limit=%@",key,latitude,longtitude,limit];
    return urlstr;
}








//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
    [self.mSCPMarkersDom parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
}

//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    [self.mSCPMarkersDom parser:parser foundCharacters:string];            
    
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
    [self.mSCPMarkersDom parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName]; 
}


//NSURLConnectionDelegate
-(void) connection:(NSURLConnection *)connection didReceiveData: (NSData *) incomingData
{ 
    NSLog(@"NSURLConnection didReceiveData");
    [mTempDownloadData appendData:incomingData];
}

//NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{    
    GlobalVars *vars = [GlobalVars sharedInstance];
    NSString *loadData = nil;
    if(mIsUsingLocalImpl == YES) 
    {
        loadData = [[NSMutableString alloc] initWithData:mTempDownloadData encoding:NSUTF8StringEncoding];
        //        [self importToDBWithAllCameraStr:loadData];
        [self importToDBWithAllCameraStrAsDownloadedItem:loadData];
        [self makeFakeAddedItems];
        [self combineDownloadedAndAddedToCameraItems];
        [self deleteFakeAddedItems];
        mTempDownloadData = nil;
        mConnection = nil;
        //        mDbgTextView.text = loadData;
        
        mIsOnInternetProcess = NO;
        [self performSelector:@selector(clickToParseMarkers:) withObject:nil afterDelay:1];
        return; //change code from xml parsing to v2-us-allcamera.txt download
    }
    else 
    {
        loadData = [[NSMutableString alloc] initWithData:mTempDownloadData encoding:NSISOLatin1StringEncoding];
        mTempDownloadData = nil;
        mConnection = nil;
        
    }
    
    
    
    
    if(mParser) {
        mParser = nil;
    }
    
    //mParser = [[NSXMLParser alloc] initWithData:mTempDownloadData];
    
    //    dataUsingEncoding:encoding allowLossyConversion:YES] 
    
    mParser = [[NSXMLParser alloc] initWithData:[loadData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    mDbgTextView.text = loadData;    
    [mParser setDelegate:self];//(id<NSXMLParserDelegate>)
    [mParser setShouldResolveExternalEntities:YES];
    @try 
    {
        [mParser parse];
        
        NSError *err = [mParser parserError];
        NSLog(@"parser error = %@", err);
        
    }
    @catch( NSException *e) 
    {
        NSLog(@"Parsing Error");
        return;
    }
    
    
    //becayse farthest point is lastest parsed marker for the query, so we use the follow process to set farthest location.  
    if(self.mSCPMarkersDom != nil && self.mSCPMarkersDom.mMarkerArray != nil && [self.mSCPMarkersDom.mMarkerArray count] >= 1)
    {
        SCPMarker *marker = [self.mSCPMarkersDom.mMarkerArray objectAtIndex:[self.mSCPMarkersDom.mMarkerArray count]-1];        
        //CLLocationDegrees type is double in iOS5.0 implementation
        CLLocationDegrees lat = [marker.mLat doubleValue];
        CLLocationDegrees lng = [marker.mLng doubleValue];
        self.mFarthestPrasedLocation = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
    }
    
    
    
    //restrict the extend number after camera number is dynamic extending.
    if([self.mSCPMarkersDom.mMarkerArray count] > vars.mMinCameraLimitNum)  
    {
        NSLog(@"mMarkerArray count = %d before restrict", [self.mSCPMarkersDom.mMarkerArray count]);
        SCPMarker * queriedFarthestMarker =[self.mSCPMarkersDom.mMarkerArray objectAtIndex:[self.mSCPMarkersDom.mMarkerArray count]-1];
        
        double filterDistance = 1.5 * vars.mSafeDistance;
        //double filterDistance = vars.mSafeDistance;
        
        double queriedFarthestDistance = [queriedFarthestMarker.mDistance doubleValue]; 
        if(queriedFarthestDistance >= filterDistance) 
        {
            //            [self restrictLimitWithFilterDistance:filterDistance];
            NSMutableArray *array = mSCPMarkersDom.mMarkerArray;
            int idx;
            int idxWithMinimalFilterDistance; //find out the minimal marker that distance is larger than filter distance;
            idxWithMinimalFilterDistance = [array count]-1; //
            for(idx=[array count]-1;  idx >= vars.mMinCameraLimitNum ; idx--) 
            {
                SCPMarker * marker = (SCPMarker*)[array objectAtIndex:idx];
                if( [marker.mDistance doubleValue] > filterDistance) {
                    idxWithMinimalFilterDistance = idx;
                }
            }
            
            //remove all of marker whose distance is bigger than minimal filter distance
            for(idx=[array count]-1; idx>idxWithMinimalFilterDistance; idx--){
                SCPMarker* marker = [array objectAtIndex:idx];
                [array removeObject:marker];
            }
            
            SCPMarker *lastMarker = [self.mSCPMarkersDom.mMarkerArray objectAtIndex:[self.mSCPMarkersDom.mMarkerArray count]-1];
            
            CLLocationDegrees lat = [lastMarker.mLat doubleValue];
            CLLocationDegrees lng = [lastMarker.mLng doubleValue];
            self.mFarthestPrasedLocation = [[CLLocation alloc]initWithLatitude:lat longitude:lng];
            
        }
    }
    
    
    [self refreshGuiByMarkersDom];
    
    
    
    mLastestParsedTime = [[[NSDate alloc]init] timeIntervalSince1970];
    mIsOnInternetProcess = NO;
}


-(void) makeFakeAddedItems {
    NSLog(@"makeFakeAddedItems");
    
    NSArray * fakeIds = [NSArray arrayWithObjects:@"001",@"002",@"003", @"004", @"005", @"006", @"007", @"008", @"009", nil];
    
    int idx;
    for(idx = 0; idx<[fakeIds count]; idx++) {
        NSString * idStr = [fakeIds objectAtIndex:idx];
        if(idStr == nil) continue;
        AddedItem * item = (AddedItem*) [NSEntityDescription insertNewObjectForEntityForName:@"AddedItem" inManagedObjectContext:mContext];
        item.mId = idStr;
        item.mDirection=@"0";
        item.mLat = [NSNumber numberWithDouble:(double)(37.335072f+(idx*0.001f))];
        item.mLng = [NSNumber numberWithDouble:(double)(-122.032604f-((1+idx)*0.01f))];
        item.mSpeed = @"0";
        item.mStars = @"4";
        item.mType = @"1";
        item.mDirtype = @"0";
    }
    
       NSError * error;
    if(![mContext save:&error]) {
        NSLog(@"save error");
    }
}


-(void) deleteFakeAddedItems {
    NSLog(@"deletedFakeAddedItems");
    NSArray * fakeIds = [NSArray arrayWithObjects:@"001",@"002",@"003", @"004", @"005", @"006", @"007", @"008", @"009", nil];
    
    
    NSFetchRequest * requestAdded = [[NSFetchRequest alloc]init];
    NSEntityDescription * addedEntity = [NSEntityDescription entityForName:@"AddedItem" inManagedObjectContext:mContext];
    [requestAdded setEntity:addedEntity];
    NSError * addedError = nil;
    NSMutableArray * addedItems = [[mContext executeFetchRequest:requestAdded error:&addedError] mutableCopy];
    
    
    int idx;
    
    for(idx = 0; idx<[addedItems count];idx++)
    {
        AddedItem * item = [addedItems objectAtIndex:idx];
        
        int fakeIdx = 0;
        for(fakeIdx = 0 ; fakeIdx < [fakeIds count]; fakeIdx++) 
        {
            NSString * idStr = [fakeIds objectAtIndex:fakeIdx];
            //if([item.mId isEqualToString:@"001"])
            if([item.mId isEqualToString:idStr])
            {
                NSManagedObject *mgrobj = [addedItems objectAtIndex:idx];
                [mContext deleteObject:mgrobj];
                break;
            }
        }
    }
    
    NSError * error;
    if(![mContext save:&error]) {
        NSLog(@"save error");
    }
    
}



-(void)refreshGuiByMarkersDom 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    self.mLimitNumLbl.text = [NSString stringWithFormat:@"%d", [self.mSCPMarkersDom.mMarkerArray count]];
    vars.mCurCameraLimitNum = [self.mSCPMarkersDom.mMarkerArray count];
    
    CLLocation *carLoc = nil;
    carLoc = [self getCarLocation];
    
    
    //    [self.mSCPMarkersDom figureOutAllDynamicDataWithCarLoc:carLoc withFreewayModeOn:mIsFreewayModeOn];
    [self.mSCPMarkersDom figureOutAllDynamicDataWithCarLoc:carLoc withFreewayModeOn:mIsFreewayModeOn withFilterSpeedRate:self.mSpeedDetectRate];
    
    self.mLimitNumLbl.text = [NSString stringWithFormat:@"%d", [self.mSCPMarkersDom.mMarkerArray count]];
    vars.mCurCameraLimitNum = [self.mSCPMarkersDom.mMarkerArray count];
    
    [self showDomOnWebViewHTMLContent];   
    [self updateAnnotationsOfMapByMarkersDom]; 
    
}





//NSURLConnectionDelegate
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse
{  
    NSLog(@"NSURLConnection didReceiveResponse");
}
//NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"NSURLConnection didFailWithError");
    mConnection = nil;
}



//CoreData
-(void) initCoreData {    
    mFetchedResultsController.delegate = self;
    NSError *error;
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/speedcameraV3.sqlite"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error]) 
        NSLog(@"Error: %@", [error localizedFailureReason]);
    else
    {
        mContext = [[NSManagedObjectContext alloc] init];
        [mContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    }
}


//SpeedCamera
-(void) combineDownloadedAndAddedToCameraItems {
    [self clearAllCameraInDB];
    
    NSFetchRequest * requestDownloaded = [[NSFetchRequest alloc]init];
    NSEntityDescription * downloadedEntity = [NSEntityDescription entityForName:@"DownloadedItem" inManagedObjectContext:mContext];
    [requestDownloaded setEntity:downloadedEntity];
    NSError * downloadedError = nil;
    NSMutableArray * downloadedItems = [[mContext executeFetchRequest:requestDownloaded error:&downloadedError] mutableCopy];
    
    NSFetchRequest * requestAdded = [[NSFetchRequest alloc]init];
    NSEntityDescription * addedEntity = [NSEntityDescription entityForName:@"AddedItem" inManagedObjectContext:mContext];
    [requestAdded setEntity:addedEntity];
    NSError * addedError = nil;
    NSMutableArray * addedItems = [[mContext executeFetchRequest:requestAdded error:&addedError] mutableCopy];
    
    NSFetchRequest * requestCamera = [[NSFetchRequest alloc]init];
    NSEntityDescription * cameraEntity = [NSEntityDescription entityForName:@"CameraItem" inManagedObjectContext:mContext];
    [requestCamera setEntity:cameraEntity];
    NSError * cameraError = nil;
    NSMutableArray * cameraItems = [[mContext executeFetchRequest:requestCamera error:&cameraError] mutableCopy];
    
    int idx;
    for(idx = 0; idx < [downloadedItems count]; idx++ ) {
        DownloadedItem * downloadedItem = (DownloadedItem*)[downloadedItems objectAtIndex:idx];
        CameraItem *cameraItem = (CameraItem*) [NSEntityDescription insertNewObjectForEntityForName:@"CameraItem" inManagedObjectContext:mContext];
        cameraItem.mId = downloadedItem.mId;
        cameraItem.mLng = downloadedItem.mLng;
        cameraItem.mLat = downloadedItem.mLat;
        cameraItem.mType = downloadedItem.mType;
        cameraItem.mSpeed = downloadedItem.mSpeed;
        cameraItem.mDirtype = downloadedItem.mDirtype;
        cameraItem.mDirection = downloadedItem.mDirection;
        cameraItem.mVotes = downloadedItem.mVotes;
        cameraItem.mStars = downloadedItem.mStars;
    }
    
    if(addedItems != nil) 
    {
        for(idx=0;idx<[addedItems count];idx++) {
            AddedItem * addedItem = [addedItems objectAtIndex:idx];
            int downIdx;
            BOOL isThereSameOneInDownItems = NO;
            for(downIdx = 0; downIdx < [downloadedItems count]; downIdx++) {
                DownloadedItem * downItem = [downloadedItems objectAtIndex:downIdx];
                if([downItem.mId isEqualToString:addedItem.mId]) 
                {
                    NSManagedObject *mgrobj = [addedItems objectAtIndex:idx];
                    [mContext deleteObject:mgrobj];
                    isThereSameOneInDownItems = YES;
                    break;
                }
            }
            if(isThereSameOneInDownItems == NO) 
            {
                CameraItem *cameraItem = (CameraItem*) [NSEntityDescription insertNewObjectForEntityForName:@"CameraItem" inManagedObjectContext:mContext];
                cameraItem.mId = addedItem.mId;
                cameraItem.mLng = addedItem.mLng;
                cameraItem.mLat = addedItem.mLat;
                cameraItem.mType = addedItem.mType;
                cameraItem.mSpeed = addedItem.mSpeed;
                cameraItem.mDirtype = addedItem.mDirtype;
                cameraItem.mDirection = addedItem.mDirection;
                cameraItem.mVotes = addedItem.mVotes;
                cameraItem.mStars = addedItem.mStars;
            }
        }
    }
    
    NSError * error;
    if(![mContext save:&error]){
        NSLog(@"save error");
    }
    
}


-(IBAction)clickToShowAddedItemsId {
    NSLog(@"clickToShowAddedItemsId");
    [self showAddedItemsId];
}
-(IBAction)clickToShowDeletedItemsId {
    NSLog(@"clickToShowDeletedItemsId");
    [self showDeletedItemsId];
    
}
-(IBAction)clickToShowConfirmedItemsId {
    NSLog(@"clickToShowConfirmedItemsId");
    [self showConfirmedItemsId];
    
}
-(IBAction)clickToShowDownloadedItemsId {
    NSLog(@"clickToShowDownloadedItemsId");
    [self showDownloadedItemsId];
    
}
-(IBAction)clickToShowCameraItemsId {
    NSLog(@"clickToShowCameraItemsId");
    [self showCameraItemsId];
}



-(void) showAddedItemsId
{
    NSString * entityName = @"AddedItem";
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    
    NSError * error = nil;
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil ) {
        NSLog(@"%@s is (null)",entityName);
        return;
    }
    
    NSSortDescriptor * sortBy =
    [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES comparator:^(id obj1, id obj2) {return [((AddedItem*)obj1).mId compare:((AddedItem*)obj2).mId]; }];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
    NSArray * sortedItems = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    int idx;
    NSLog(@"show %@s with count=%d",entityName, [sortedItems count]);
    for(idx = 0; idx < [sortedItems count]; idx++ ) {
        AddedItem * item = [sortedItems objectAtIndex:idx];
        NSLog(@"%@s[%d].mId=%@",entityName,idx,item.mId);
    }
}


-(void) showDeletedItemsId 
{
    NSString * entityName = @"DeletedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil ) {
        NSLog(@"%@s is (null)",entityName);
        return;
    }
    
    NSSortDescriptor * sortBy =
    [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES comparator:^(id obj1, id obj2) {return [((DeletedItem*)obj1).mId compare:((DeletedItem*)obj2).mId]; }];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
    NSArray * sortedItems = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    int idx;
    NSLog(@"show %@s with count=%d",entityName, [sortedItems count]);
    for(idx = 0; idx < [sortedItems count]; idx++ ) {
        DeletedItem * item = [sortedItems objectAtIndex:idx];
        NSLog(@"%@s[%d].mId=%@",entityName,idx,item.mId);
    }
}


-(void) showConfirmedItemsId 
{
    NSLog(@"showConfirmedItemsId");
    NSString * entityName = @"ConfirmedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil ) {
        NSLog(@"%@s is (null)",entityName);
        return;
    }
    NSSortDescriptor * sortBy =
    [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES comparator:^(id obj1, id obj2) {return [((ConfirmedItem*)obj1).mId compare:((ConfirmedItem*)obj2).mId]; }];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
    NSArray * sortedItems = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    int idx;
    NSLog(@"show %@s with count=%d",entityName, [sortedItems count]);
    for(idx = 0; idx < [sortedItems count]; idx++ ) {
        ConfirmedItem * item = [sortedItems objectAtIndex:idx];
        NSLog(@"%@s[%d].mId=%@",entityName,idx,item.mId);
    }    
}


-(void) showDownloadedItemsId  
{
    NSString * entityName = @"DownloadedItem";
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil ) {
        NSLog(@"%@s is (null)",entityName);
        return;
    }
    NSSortDescriptor * sortBy =
    [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES comparator:^(id obj1, id obj2) {return [((DownloadedItem*)obj1).mId compare:((DownloadedItem*)obj2).mId]; }];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
    NSArray * sortedItems = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    int idx;
    NSLog(@"show %@s with count=%d",entityName, [sortedItems count]);
    for(idx = 0; idx < [sortedItems count]; idx++ ) {
        DownloadedItem * item = [sortedItems objectAtIndex:idx];
        NSLog(@"%@s[%d].mId=%@",entityName,idx,item.mId);
    }
}


-(void) showCameraItemsId 
{
    NSString * entityName = @"CameraItem";
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:mContext];
    [request setEntity:entity];
    NSError * error = nil;
    NSMutableArray * items = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    if(items == nil ) {
        NSLog(@"%@s is (null)",entityName);
        return;
    }
    
    NSSortDescriptor * sortBy =
    [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES comparator:^(id obj1, id obj2) {return [((CameraItem*)obj1).mId compare:((CameraItem*)obj2).mId]; }];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
    NSArray * sortedItems = [items sortedArrayUsingDescriptors:sortDescriptors];
    
    int idx;
    NSLog(@"show %@s with count=%d",entityName, [sortedItems count]);
    for(idx = 0; idx < [sortedItems count]; idx++ ) {
        CameraItem * item = [sortedItems objectAtIndex:idx];
        NSLog(@"%@s[%d].mId=%@",entityName,idx,item.mId);
    }
}

//SpeedCamera
-(void) importToDBWithAllCameraStrAsDownloadedItem:(NSString*)importStr {
    //    NSLog(@"importToDBWithAllCameraStr = %@", str);
    
    NSArray * array;
    array = [importStr componentsSeparatedByString:@"\n"];
    int rowIdx;
    for (rowIdx = 1; rowIdx < [array count]; rowIdx++ ) {
        NSString *listStr = (NSString*)[array objectAtIndex:rowIdx];
        
        NSArray * rowArray = [listStr componentsSeparatedByString:@","];
        
        NSString * idStr = [rowArray objectAtIndex:0] ;
        NSString * lngStr = [rowArray objectAtIndex:1];
        NSString * latStr = [rowArray objectAtIndex:2];
        NSString * typeStr = [rowArray objectAtIndex:3];
        NSString * speedStr = [rowArray objectAtIndex:4];
        NSString * dirtypeStr = [rowArray objectAtIndex:5];
        NSString * directionStr = [rowArray objectAtIndex:6];
        NSString * votesStr = [rowArray objectAtIndex:7];
        NSString * starsStr = [rowArray objectAtIndex:8];
        
        //        NSLog(@"id=%@,lng=%@,lat=%@,type=%@,spd=%@,dirtype=%@,dir=%@,votes=%@,stars=%@",idStr, lngStr,latStr,typeStr,speedStr, dirtypeStr, directionStr, votesStr,starsStr);
        
        
        DownloadedItem *item = (DownloadedItem*) [NSEntityDescription insertNewObjectForEntityForName:@"DownloadedItem" inManagedObjectContext:mContext];
        //        DownloadedCameraItem *item = (DownloadedCameraItem*) [NSEntityDescription insertNewObjectForEntityForName:@"DownloadedCameraItem" inManagedObjectContext:mContext];        
        item.mId = idStr;
        item.mLng = [NSNumber numberWithDouble:[lngStr doubleValue]];
        item.mLat = [NSNumber numberWithDouble:[latStr doubleValue]];
                item.mType = typeStr;
        //NSLog(@"typeStr = %@", typeStr);
        //item.mType = @"1";
        item.mSpeed = speedStr;
        item.mDirtype = dirtypeStr;
        item.mDirection = directionStr;
        item.mVotes = votesStr;
        item.mStars = starsStr;
    }
    
    NSError * error;
    if(![mContext save:&error]){
        NSLog(@"save error");
    }
    
}


-(void) restrictLimitWithFilterDistance:(double)filterDistance 
{
    int idx;
    GlobalVars * vars = [GlobalVars sharedInstance];
    SCPMarker *prevMarker = nil;
    while (1) 
    {
        SCPMarker *marker = nil;
        idx = [mSCPMarkersDom.mMarkerArray count]-1;
        if( (idx+1) <= vars.mMinCameraLimitNum) {
            break;
        }
        
        marker = [mSCPMarkersDom.mMarkerArray objectAtIndex:idx];
        if([marker.mDistance doubleValue] >= filterDistance) {
            [mSCPMarkersDom.mMarkerArray removeObject:marker];
            prevMarker = marker;
        }
        else 
        {
            if(prevMarker != nil) {
                [mSCPMarkersDom addMarkerToRelativeArray:prevMarker];
                //                [mSCPMarkersDom.mMarkerArray addObject:prevMarker];
                //                [mSCPMarkersDom.mFilteredMarkerArray addObject:prevMarker];
            }
            break;
        }
    }
}



-(void) makeLocationServiceWorking {
    NSLog(@"makeLocationServiceWorking");
    //the original function is extrace from viewDidLoad 
    mGeocoder = [[CLGeocoder alloc] init];
    mLocationManager = [[CLLocationManager alloc] init];
    [mLocationManager setDelegate:self];
    
    if([CLLocationManager headingAvailable]) {
        //[mLocationManager stopUpdatingHeading];
        [mLocationManager startUpdatingHeading];
    }
    
    if([CLLocationManager locationServicesEnabled]) 
    {
        //        [mLocationManager stopUpdatingLocation];
        
        mLocationManager.distanceFilter = .1f;  
        //the minimum distance = 0.1 meter a device must move horrizontally before an update event is generated.
        
        mLocationManager.purpose = @"This may be used to obtain your reverse geocoded address";
        [mLocationManager startUpdatingLocation];
    }    
}





-(void) decideWhetherParseXmlFromInternet 
{
    if(mIsOnInternetProcess) return;
    GlobalVars *vars = [GlobalVars sharedInstance];
    if(0.1 >= mLastestParsedTime ) { //it's mean that the data is never parsed
        [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
    } else {
        NSTimeInterval curTime = [[[NSDate alloc]init]timeIntervalSince1970];
        NSTimeInterval idleSec = curTime-mLastestParsedTime;
        mIdleSecLabel.text = [NSString stringWithFormat:@"%g", (vars.mMaxIdleSec - idleSec)];
        if( idleSec > vars.mMaxIdleSec) {
            [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
        }
    }
    
    //figure out whether to parse web data 
    if(mLastestParsedLocation == nil ) {
        mLastestParsedLocation = mNewLocation;        
        [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
    } 
    else 
    {
        if(mFarthestPrasedLocation != nil)
        {
            double safeDist = vars.mSafeDistance;
            double curRunningDist = [mLastestParsedLocation bearingToLocation:mNewLocation];
            double farthestParsedCameraDist = [mLastestParsedLocation bearingToLocation:mFarthestPrasedLocation];
            
            mRunDistLabel.text = [NSString stringWithFormat:@"%g km", (farthestParsedCameraDist- safeDist - curRunningDist)];
            
            
            if(safeDist > farthestParsedCameraDist) 
            {
                NSLog(@"safeDist[%g] > farthestParsedCameraDist[%g]", safeDist, farthestParsedCameraDist);
                //add limit Num For Camera and requery                
                vars.mCurCameraLimitNum = 20; //vars.mCurCameraLimitNum +20;
                
                [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
                //mLastestParsedLocation = mNewLocation;
            } 
            else if(curRunningDist > (farthestParsedCameraDist - safeDist))
            {
                NSLog(@"curRunningDist[%g] > (farthestParsedCameraDist[%g] - safeDist[%g])",curRunningDist, farthestParsedCameraDist, safeDist);
                //requery 
                mLastestParsedLocation = mNewLocation;
                [self performSelector:@selector(clickToParseMarkers:) withObject:nil];                
                mLastestParsedLocation = mNewLocation;                 
            }
        }
    }
    
}


-(void) decideWhetherBuildDom
{
    if(mIsUsingLocalImpl == YES) 
    {
        [self decideWhetherBuildDomFromLocalData];
    }
    else {
        [self decideWhetherParseXmlFromInternet];
    }
}


-(void) decideWhetherBuildDomFromLocalData 
{
    
    //    NSLog(@"decideWhetherBuildDomFromLocalData");
    if(mIsOnInternetProcess) return; //It's mean that the v2-us-allcamera.txt is downloading 
    GlobalVars *vars = [GlobalVars sharedInstance];
    if(mLastestParsedLocation == nil ) 
    {
        //        NSLog(@"mFarthestPrasedLocation == nil");
        mLastestParsedLocation = mNewLocation;
        mRunDistLabel.text = [NSString stringWithFormat:@"%g m", 0.0];
        [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
    }
    else 
    {
        //        NSLog(@"mNewLocation = %@, mLastestParsedLocation = %@", mNewLocation,mLastestParsedLocation);
        
        double curRunningDist = [mLastestParsedLocation bearingToLocation:mNewLocation];
        mRunDistLabel.text = [NSString stringWithFormat:@"%g m", 100-(curRunningDist*1000)];
        if(curRunningDist >= 0.1f)
        {
            mLastestParsedLocation = mNewLocation;
            [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
        }
    }
}




//CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    //NSLog(@"[enter]didUpdateToLocation enter");
    
    
    mIdleCnt = 0; //for configure time idle;
    
    
    mGpsCnt = mGpsCnt + 1;
    mGpsCntNumLbl.text = [NSString stringWithFormat:@"%d",mGpsCnt];
    
    mNewLocation = newLocation;
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    CLLocationCoordinate2D selectedCoordinate = [newLocation coordinate];
    
    mGpsCLLocation = newLocation;
    mGpsLatitude = [NSString stringWithFormat:@"%.6F", selectedCoordinate.latitude];
    mGpsLongitude = [NSString stringWithFormat:@"%.6F", selectedCoordinate.longitude];
    
    double kmhSpeed = newLocation.speed * (3600/1000);  //newLocation.speed is meter/sec
    
    if(kmhSpeed <= 15)
    {
        mIsSpeedTooSlowToShow = YES;
    }
    else
    {
        mIsSpeedTooSlowToShow = NO;
    }
    
    self.mLatValueLbl.text = [NSString stringWithFormat:@"%F", selectedCoordinate.latitude];
    self.mLngValueLbl.text = [NSString stringWithFormat:@"%F", selectedCoordinate.longitude];
    self.mSpdValueLbl.text = [NSString stringWithFormat:@"%.3F km/h", kmhSpeed]; 
    self.mHdgValueLbl.text = [NSString stringWithFormat:@"%.3F", newLocation.course];
    
    
    //    NSLog(@"mGpsLatitude=%@ mGpsLongitude=%@", mGpsLatitude, mGpsLongitude);
    
    
    
	if (oldLocation == nil || self.mIsZoomToMap) {
        self.mIsZoomToMap = false;
		MKCoordinateRegion userLocation = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 3000.0, 3000.0);        
        //comment by milo
//        if(vars.mEVC.mRegionsMapView != nil) {
//            [vars.mEVC.mRegionsMapView setRegion:userLocation animated:YES];
//            vars.mEVC.mRegionsMapView.showsUserLocation = YES;
//        }
        
        if(mRegionsMapView != nil ) {
            [self.mRegionsMapView setRegion:userLocation animated:YES];
            self.mRegionsMapView.showsUserLocation = YES;
        }
	}
    
    
    //    [self decideWhetherParse];
    [self decideWhetherBuildDom];
    [self showDomOnWebViewHTMLContent];
    
    //NSLog(@"[leave]didUpdateToLocation");    
}


//CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    //    //初始化方位  
    //    if ([fileLoader isKindOfClass:[TestLoader class]]) {  
    //        if (localDir == 0) {  
    //            baseDir = newHeading.magneticHeading;  
    //            localDir = newHeading.magneticHeading;  
    //        }  
    //    }  
    //    float newlocalDir = newHeading.magneticHeading;  
    //    //当变化超过一定范围，刷新标志显示  
    //    if (abs(newlocalDir - localDir) > FLASH_DEGREE) {  
    //        localDir = newlocalDir;  
    //        [self computer];  
    //    }  
    //    //更新指南针方向  
    //    [overlayView updateHeading:newHeading];  
    
}  

//方位变化的回调函数  
//CLLocationManagerDelegate
//- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {  
//    return YES;  
//}  

//CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Core location error!");
}




//MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    GlobalVars *vars = [GlobalVars sharedInstance];
    //    MKMapView * mapView = vars.mEVC.mRegionsMapView;
    MKMapView * mapView = theMapView;
    
    if ([annotation isKindOfClass:[MyAnnotation class]])
    {
        static NSString *MyAnnotationIdentifier = @"myAnnotation";
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:MyAnnotationIdentifier];
        MKPinAnnotationColor annotationColor = 0;
        MyAnnotation* myAnno = (MyAnnotation*)annotation;
        NSString * focusCameraId = myAnno.mFocusCameraId;
        
        if(myAnno.mSortedMarkerIdx == myAnno.mHighChanceMarkerIdx) 
        {
            annotationColor = MKPinAnnotationColorRed;
        }
        else if(myAnno.mSortedMarkerIdx < 0 ) 
        {
            annotationColor = MKPinAnnotationColorGreen;
        }
        else 
        {
            annotationColor = MKPinAnnotationColorPurple;
        } 
        
        //        NSLog(@"mFilteredMarkerIdx = %d, mHighChanceMarkerIdx = %d", myAnno.mFilteredMarkerIdx, self.mSCPMarkersDom.mHighChanceMarkerIdx);
        
        if (!pinView)
        {
            //            MKPinAnnotationView* myPinView = [[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:MyAnnotationIdentifier] autorelease];
            MKPinAnnotationView* myPinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:MyAnnotationIdentifier];      
            //            myPinView.pinColor = MKPinAnnotationColorPurple;
            //myPinView.pinColor = MKPinAnnotationColorGreen;
            myPinView.pinColor = annotationColor; 
            
            //myPinView.animatesDrop = YES;
            myPinView.animatesDrop = NO;
            myPinView.canShowCallout = YES;
            
            //UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            
            //            UIButton *confirmedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //            confirmedButton.frame = CGRectMake(0,0,100.0f, 50.0f);
            //            [confirmedButton setTitle:@"Confirmed" forState:UIControlStateNormal];            [confirmedButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            //            
            //            UIButton *deletedButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //            deletedButton.frame = CGRectMake(0,0,100.0f, 50.0f);
            //            [deletedButton setTitle:@"Deleted" forState:UIControlStateNormal];
            //            [deletedButton addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *focusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            focusButton.frame = CGRectMake(0,0,60.0f, 25.0f);
            [focusButton setTitle:@"Focus" forState:UIControlStateNormal];
            [focusButton addTarget:self action:@selector(focusButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            focusButton.tag = myAnno.mSortedMarkerIdx;
            
            myPinView.rightCalloutAccessoryView=focusButton;
            
            //            myPinView.rightCalloutAccessoryView=button;
            //            myPinView.leftCalloutAccessoryView=button;
            return myPinView;
        }else{
            pinView.pinColor = annotationColor; 
            
            UIButton *focusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //            focusButton.frame = CGRectMake(0,0,100.0f, 50.0f);
            focusButton.frame = CGRectMake(0,0,60.0f, 25.0f);
            [focusButton setTitle:@"Focus" forState:UIControlStateNormal];
            [focusButton addTarget:self action:@selector(focusButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
            focusButton.tag = myAnno.mSortedMarkerIdx;
            
            pinView.rightCalloutAccessoryView=focusButton;
            
            return pinView;
        }
    }
    return nil;
}

- (void)checkButtonTapped:(id)sender event:(id)event{  
    UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:@"Message！" message:@"Callout test" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];  
    
    
//    [tmp show];  
    GlobalVars * vars = [GlobalVars sharedInstance];
    [MTPopupWindow showCameraOkWindowWithTitle:@"Message！" andMessage:@"Callout test" insideView:[vars.exterNav topViewController].view];

    
    tmp = nil;
}   

- (void)focusButtonTapped:(id)sender event:(id)event{  
    int sortedMarkerIdx = ((UIButton*)sender).tag;
    NSString * focusCameraId = @"001";
    
    if(mSCPMarkersDom == nil || mSCPMarkersDom.mSortedMarkerArray == nil) return;
    if(sortedMarkerIdx >= [mSCPMarkersDom.mSortedMarkerArray count]) return;
    SCPMarker * marker = (SCPMarker*)[mSCPMarkersDom.mSortedMarkerArray objectAtIndex:sortedMarkerIdx];
    if(marker == nil) return;
    
    if(marker!=nil) 
    {
        focusCameraId = marker.mId;
        mFocusCameraId = focusCameraId;
        NSLog(@"mFocusCameraId=%@", focusCameraId);
        UIAlertView *tmp= [[UIAlertView alloc] initWithTitle:@"camera is focus！" message:[NSString stringWithFormat:@"focus camera ID is %@ press confirm or delete button in right-side panel",focusCameraId] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[tmp show];  
        GlobalVars *vars = [GlobalVars sharedInstance];
        [MTPopupWindow showCameraOkWindowWithTitle:@"camera is focus！" andMessage:[NSString stringWithFormat:@"focus camera ID is %@ press confirm or delete button in right-side panel",focusCameraId] insideView:[vars.exterNav topViewController].view];
        tmp = nil;
    }
}   


-(void) updateAnnotationsOfMapByMarkersDom {
    //    NSLog(@"updateAnnotationsOfMapByMarkersDom");
    GlobalVars *vars = [GlobalVars sharedInstance];

    //change by milo
//   MKMapView * mapView = vars.mEVC.mRegionsMapView;    
    MKMapView * mapView = nil;
    
    if(mapView ==nil && mRegionsMapView == nil) {
        return;
    }
    
    if(mapView != nil) 
    {
        if(mapView.delegate == nil) {
            mapView.delegate = self;
        }
    }
    
    if(mRegionsMapView != nil) {
        if(mRegionsMapView.delegate == nil) {
            mRegionsMapView.delegate = self;
        }
    }
    
    
    if(self.mCurAnnotations != nil) {
        if(mapView != nil) {
            [mapView removeAnnotations:self.mCurAnnotations];   
        }
        if(mRegionsMapView != nil) {
            [mRegionsMapView removeAnnotations:self.mCurAnnotations];
        }
        
        [mCurAnnotations removeAllObjects];
        mCurAnnotations = nil;
    }
    
    mCurAnnotations = [NSMutableArray arrayWithCapacity:1];
    int idx = 0;
    for ( idx = 0; idx<[self.mSCPMarkersDom.mMarkerArray count]; idx++) {    
        SCPMarker * marker = [self.mSCPMarkersDom.mMarkerArray objectAtIndex:idx];
        
        MyAnnotation *annotation = [[MyAnnotation alloc]init];
        CLLocationCoordinate2D coordinate;
        coordinate.longitude = (CLLocationDegrees)[marker.mLng doubleValue];
        coordinate.latitude = (CLLocationDegrees)[marker.mLat doubleValue];
        annotation.myCoordinate = coordinate;
        
        
        annotation.myTitle = [NSString stringWithFormat:@"[id=%@]", marker.mId];
        annotation.mySubTitle = [NSString stringWithFormat:@"type=%@ dist=%@", marker.mType, marker.mDistance]; 
        annotation.mFocusCameraId = marker.mId;
        
        annotation.mUnsortedMarkerIdx = idx;
        annotation.mSortedMarkerIdx = -2;
        if([mSCPMarkersDom.mSortedMarkerArray containsObject:marker]) {
            annotation.mSortedMarkerIdx = [mSCPMarkersDom.mSortedMarkerArray indexOfObject:marker];
        }
        
        
        annotation.mHighChanceMarkerIdx = self.mSCPMarkersDom.mHighChanceMarkerIdx;
        //NSLog(@"annotation = %@", annotation);
        
        [mCurAnnotations addObject:annotation];
    }
    if(mapView != nil) {
        [mapView addAnnotations:mCurAnnotations];
    }
    if(mRegionsMapView != nil) {
        [mRegionsMapView addAnnotations:mCurAnnotations];
    }
}


//SpeedCamera
-(void) clearAllCameraInDB {
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"CameraItem" inManagedObjectContext:mContext];
    [request setEntity:entity];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mId" ascending:NO];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError * error = nil;
    NSMutableArray *mutableFetchResults = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults == nil) 
    {
        NSLog(@"mutableFetchResults is nil");
    }
    else 
    {
        NSLog(@"delete mutableFetchResults start");
        int idx;
        for (idx = 0; idx < [mutableFetchResults count]; idx++) 
        {
            NSManagedObject * mgrobj = [mutableFetchResults objectAtIndex:idx];
            [mContext deleteObject:mgrobj];
        }
        NSLog(@"delete mutableFetchResults end");
    }
    if (![mContext save:&error]) NSLog(@"Error: %@", [error localizedFailureReason]);
}



//SpeedCamera
-(void) clearAllDownloadedInDB {
    NSFetchRequest * request = [[NSFetchRequest alloc]init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:@"DownloadedItem" inManagedObjectContext:mContext];
    [request setEntity:entity];
    
    NSSortDescriptor * sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"mId" ascending:NO];
    NSArray * sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError * error = nil;
    NSMutableArray *mutableFetchResults = [[mContext executeFetchRequest:request error:&error] mutableCopy];
    
    if(mutableFetchResults == nil) 
    {
        NSLog(@"mutableFetchResults is nil");
    }
    else 
    {
        NSLog(@"delete mutableFetchResults start");
        int idx;
        for (idx = 0; idx < [mutableFetchResults count]; idx++) 
        {
            NSManagedObject * mgrobj = [mutableFetchResults objectAtIndex:idx];
            
            [mContext deleteObject:mgrobj];
        }
        NSLog(@"delete mutableFetchResults end");
    }
    if (![mContext save:&error]) NSLog(@"Error: %@", [error localizedFailureReason]);
}



-(void) applicationGUILeave 
{
    NSLog(@"applicationGUILeave");    
    mIsRunningForground = NO;
    mIdleDoubleBeepCnt = 0; 
}

-(void) applicationGUIEnter {
    NSLog(@"applicationGUIEnter");
    mIdleCountingDelaySec = 1.0f;
    mIdleCnt = 0;
    mIdleDoubleBeepCnt = 0;
    
    if(mIsRunningForground == NO) 
    { 
        mIsRunningForground = YES;
        [self performSelector:@selector(poolingTimeInvoked:) withObject:nil afterDelay:mIdleCountingDelaySec];
    }
}



-(IBAction)poolingTimeInvoked:(id)sender 
{ 

    GlobalVars *vars = [GlobalVars sharedInstance];
    BOOL requestAudiableSound = NO;
    if(mIsRunningForground == YES) { 
        if(mSCPMarkersDom.mHighChanceMarker != nil && !mIsSpeedTooSlowToShow && mIsVisualWarning)
        {
            //NSLog(@"poolingTimeInvoked call for shine");
            if(self.mWarningLightBtn.highlighted ) 
            {
                //NSLog(@"poolingTimeInvoked call for light");
                self.mWarningLightBtn.highlighted = NO; 
                self.mTypeImg.hidden = NO;
                vars.mEVC.mTypeImg.hidden = NO;
            } else {
                //NSLog(@"poolingTimeInvoked call for dark");                
                self.mWarningLightBtn.highlighted = YES;
                self.mTypeImg.hidden = YES;
                vars.mEVC.mTypeImg.hidden = YES;                
            }
        }
        else 
        {
            //NSLog(@"poolingTimeInvoked call for not shine");            
            self.mWarningLightBtn.highlighted = NO;
            self.mTypeImg.hidden = NO;
            vars.mEVC.mTypeImg.hidden = NO;
        }

        if(mSCPMarkersDom.mHighChanceMarker != nil && !mIsSpeedTooSlowToShow)
        {
            requestAudiableSound = YES;
        }
        else {
            requestAudiableSound = NO;
        }
        
        
        mIdleCnt = mIdleCnt + 1;
        if(mIdleDoubleBeepCnt %5 ==0) {
            AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate ;
            
            if(mIsAudiableWarning) {
                if(requestAudiableSound){
                    [dele sendSingleBeep];
                }
            }
            
//            [dele sendDoubleBeep];
            
//              NSLog(@"sendDoubleBeep");
//        sendDoubleBeep
        }
        mIdleDoubleBeepCnt = mIdleDoubleBeepCnt + 1;        
        
        mGpsIdleSecLbl.text = [NSString stringWithFormat:@"%g",(double)(mIdleCnt * mIdleCountingDelaySec)];
        if(mIsDownloadCountryTW) {
            mUpdateBtn.titleLabel.text = @"updateTW";
        } 
        else 
        {
            mUpdateBtn.titleLabel.text = @"update US";
        }
        
        [self performSelector:@selector(poolingTimeInvoked:) withObject:nil afterDelay:mIdleCountingDelaySec];    
    }
}



-(NSString*) getTypeIntegerByType:(NSString*)type {
//    NSLog(@"getTypeIntegerByType enter");
    NSString * nameForEmpty = @"1";
    if(type == nil ) return nameForEmpty;
    if([type isEqualToString:@"Fixed Speed Camera"]) {
        return @"1";
    }
    else if([type isEqualToString:@"Combined Speed + Redlight Camera"]) {
        return @"2";
    }
    else if([type isEqualToString:@"Redlight Camera"]) {
        return @"3";
    }
    else if([type isEqualToString:@"Average Speed Camera"]) {
        return @"4";
    }
    else if([type isEqualToString:@"Mobile/SpeedTrap/Radar"]) {
        return @"5";
    }
    else if([type isEqualToString:@"SchoolZone"]) {
        return @"6";
    }
    else 
    {
        int val = [type intValue];
        switch(val) {
            case 1: return @"1";
            case 2: return @"2";
            case 3: return @"3";
            case 4: return @"4";
            case 5: return @"5";
            case 6: return @"6";
        }
    }
    return nameForEmpty;
}


-(NSString*) getTypeImageNameByType:(NSString*)type 
{
    NSString * nameForEmpty = @"type-speed.png";
    if(type == nil ) return nameForEmpty;
    if([type isEqualToString:@"Fixed Speed Camera"]) {
        //return @"type-speed.png";
        return @"j1012-bar-speed.png";
    }
    else if([type isEqualToString:@"Combined Speed + Redlight Camera"]) {
        //return @"type-redspeed.png";
        return @"j1012-bar-redspeed.png";
    }
    else if([type isEqualToString:@"Redlight Camera"]) {
        //return @"type-red.png";
        return @"j1012-bar-redlight.png";
    }
    else if([type isEqualToString:@"Average Speed Camera"]) {
        //return @"type-speed.png";
        return @"j1012-bar-speed.png";
    }
    else if([type isEqualToString:@"Mobile/SpeedTrap/Radar"]) {
        //return @"type-police.png";
        return @"j1012-bar-speedtrap.png";
    }
    else if([type isEqualToString:@"SchoolZone"]) {
        //return @"type-school.png";
        return @"j1012-bar-school.png";
    }
    else 
    {
        int val = [type intValue];
        switch(val) {
//            case 1: return @"type-speed.png";
//            case 2: return @"type-redspeed.png";
//            case 3: return @"type-red.png";
//            case 4: return @"type-speed.png";
//            case 5: return @"type-police.png";
//            case 6: return @"type-school.png";
            case 1: return @"j1012-bar-speed.png";
            case 2: return @"j1012-bar-redspeed.png";
            case 3: return @"j1012-bar-red.png";
            case 4: return @"j1012-bar-speed.png";
            case 5: return @"j1012-bar-police.png";
            case 6: return @"j1012-bar-school.png";
        }
    }
    return nameForEmpty;
}


//refer getTypeImageNameByType's coding method to process the issue 
//that one type which has two name

-(NSString*) getShortNameByType:(NSString*)type 
{
    NSString * nameForEmpty = @"Speed Camera";
    if(type == nil ) return nameForEmpty;
    if([type isEqualToString:@"Fixed Speed Camera"]) {
        return @"Speed Camera";
    }
    else if([type isEqualToString:@"Combined Speed + Redlight Camera"]) {
        return @"Red/Speed Camera";
    }
    else if([type isEqualToString:@"Redlight Camera"]) {
        return @"Redlight Camera";
    }
    else if([type isEqualToString:@"Average Speed Camera"]) {
        return @"Ave. Speed Camera";
    }
    else if([type isEqualToString:@"Mobile/SpeedTrap/Radar"]) {
        return @"Speed Trap";
    }
    else if([type isEqualToString:@"SchoolZone"]) {
        return @"School Zone";
    }
    else 
    {
        int val = [type intValue];
        switch(val) {
            case 1: return @"Speed Camera";
            case 2: return @"Red/Speed Camera";
            case 3: return @"Redlight Camera";
            case 4: return @"Ave. Speed Camera";
            case 5: return @"Speed Trap";
            case 6: return @"School Zone";
        }
    }
    return nameForEmpty;
}


-(int) getIntegerValueByType:(NSString*)type 
{
    int intForEmpty = 1;
//    NSString * nameForEmpty = @"type-speed.png";
    if(type == nil ) return intForEmpty;//nameForEmpty;
    if([type isEqualToString:@"Fixed Speed Camera"]) {
        //return @"type-speed.png";
        return 1;
    }
    else if([type isEqualToString:@"Combined Speed + Redlight Camera"]) {
        //return @"type-redspeed.png";
        return 2;
    }
    else if([type isEqualToString:@"Redlight Camera"]) {
        //return @"type-red.png";
        return 3;
    }
    else if([type isEqualToString:@"Average Speed Camera"]) {
        //return @"type-speed.png";
        return 4;
    }
    else if([type isEqualToString:@"Mobile/SpeedTrap/Radar"]) {
        //return @"type-police.png";
        return 5;
    }
    else if([type isEqualToString:@"SchoolZone"]) {
        //return @"type-school.png";
        return 6;
    }
    else 
    {
        int val = [type intValue];
        
//        switch(val) {
//            case 1: return @"type-speed.png";
//            case 2: return @"type-redspeed.png";
//            case 3: return @"type-red.png";
//            case 4: return @"type-speed.png";
//            case 5: return @"type-police.png";
//            case 6: return @"type-school.png";
//        }
        switch(val) {
            case 1: return 1;
            case 2: return 2;
            case 3: return 3;
            case 4: return 4;
            case 5: return 5;
            case 6: return 6;
        }
    }
    //return nameForEmpty;
    return intForEmpty;
}

@end
