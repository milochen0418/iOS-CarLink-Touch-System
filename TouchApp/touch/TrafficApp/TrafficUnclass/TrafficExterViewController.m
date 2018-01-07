//
//  ExterViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrafficExterViewController.h"
#import "TrafficObject.h"
#import "TrafficObjForWidget.h"
#import "GlobalVars.h"

#import "RouteSettingViewController.h"
#import "TrafficSettingsViewController.h"

#import "RouteSettingObj.h"
#import "CoreDataHelper.h"
#import "TrafficIncidentEntity.h"

#import "NSObject+SharedQueue.h"
#import "NSOperationQueue+SharedQueue.h"


//@implementation Waypoint
//@synthesize lat,lng;
//@end


@implementation TrafficExterViewController

@synthesize mIncidentXmlUrls;
@synthesize mQueue;
@synthesize mPageLbl;
@synthesize mTrafficIdx,mTrafficObjs;
@synthesize mLatLbl,mLngLbl,mEndTimeLbl,mPointDescLbl,mStartTimeLbl,mAlertcDescLbl,mRoadwayDescLbl,mPointLocalDescLbl,mCriticalityDescLbl,mTrafficItemDescLbl,mRoadwayLocalDescLbl,mTrafficItemTypeDescLbl,mDirectionLocalDescLbl;

@synthesize mParseHelper;
@synthesize mTrafficSignImgView,mRoadwaySignImgView;
@synthesize mRoadwayAndDirLbl;
@synthesize mIsNeedToResetIncidentData;
@synthesize mNokiaMapImgView,mTrafficFlowBoxView,mTrafficLineImgView;
@synthesize mRoadwayNumLbl;
@synthesize mIsCoreDataUsed;

-(IBAction) fiveMinuteRequeryIncident : (id)sender
{    
    mIsNeedToResetIncidentData = YES;
    [self checkToDataReset];
    [self performSelector:@selector(fiveMinuteRequeryIncident:) withObject:nil afterDelay:300];
}


-(IBAction)clickToPrevTrafficItem:(id)sender 
{
    NSLog(@"clickToNextTrafficItem");
    if(mTrafficObjs == nil ) return;
    if([mTrafficObjs count] <= 0) return;
    if(self.mTrafficIdx <= 0 )return;
    self.mTrafficIdx = self.mTrafficIdx -1;
    [self refreshGui];
}

-(IBAction)clickToNextTrafficItem:(id)sender 
{
    NSLog(@"clickToPrevTrafficItem");    
    if(mTrafficObjs == nil ) return;
    if([mTrafficObjs count] <= 0) return;
    if(self.mTrafficIdx >= [mTrafficObjs count]-1) return;
    self.mTrafficIdx = self.mTrafficIdx + 1;
    [self refreshGui];
}


-(IBAction)clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.exterNav popExterViewControllerAnimated:YES];
}


-(TrafficExterViewController*) init {
    self = [super init];
    if(self) {
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

- (void)viewDidLoad
{
    NSLog(@"TrafficExterView Controller viewDidLoad");
    [super viewDidLoad];        
    self.mTrafficFlowBoxView.hidden = YES;
    [self.view addSubview:self.mTrafficFlowBoxView];
    mTrafficFlowBoxView.frame = CGRectMake(32, 12, 795, 452);
    
    self.mRoadwayAndDirLbl.text=@"";
    self.mRoadwayDescLbl.text=@"";
    self.mTrafficItemTypeDescLbl.text = @"";
    self.mTrafficItemDescLbl.text = @"";
    self.mStartTimeLbl.text = @"";
    self.mEndTimeLbl.text = @"";
    self.mPageLbl.text = @"0 / 0";
    //self.mRoadwayAndDirLbl.text = @"No Traffic Incidents Detected";
    self.mRoadwayAndDirLbl.text = @"No Traffic Incidents";
    self.mIsNeedToResetIncidentData = YES;
    [self checkToDataReset];
//    [self refreshGui];
    
    
    [self performSelector:@selector(fiveMinuteRequeryIncident:) withObject:nil afterDelay:300];
}


-(IBAction)clickToShowTrafficFlowBox:(id)sender {
    self.mTrafficFlowBoxView.hidden = NO;
    mNokiaMapImgView.image = nil;
    mTrafficLineImgView.image = nil;

    
//    double lng,lat;
////    mTrafficIdx
//    TrafficObject * obj = [mTrafficObjs objectAtIndex:mTrafficIdx];
//    lng = [obj.mLng doubleValue];
//    lat = [obj.mLat doubleValue];
//    mNokiaMapImgView.image = nil;
//    mTrafficLineImgView.image = nil;
//    [self showTileByLng:-117.5655556 andLat:33.8752778];    
//    [self showTileByLng:lng andLat:lat];
    [self performSelector:@selector(delayToShowTrafficFlow:) withObject:nil afterDelay:0.2];
}

-(IBAction)delayToShowTrafficFlow:(id)sender {
    double lng,lat;
    //    mTrafficIdx
    TrafficObject * obj = [mTrafficObjs objectAtIndex:mTrafficIdx];
    lng = [obj.mLng doubleValue];
    lat = [obj.mLat doubleValue];
    mNokiaMapImgView.image = nil;
    mTrafficLineImgView.image = nil;
    
    //    [self showTileByLng:-117.5655556 andLat:33.8752778];
    [self showTileByLng:lng andLat:lat];
}


-(IBAction)clickToHideTrafficFlowBox:(id)sender {
    self.mTrafficFlowBoxView.hidden = YES;
}

-(void) checkToDataReset  
{
    NSLog(@"TrafficExterViewController checkToDataReset");
    if(mIsNeedToResetIncidentData == NO) {
        NSLog(@"no data need to Reset");
        return;
    }
    mIncidentXmlUrls = nil;
    mIsNeedToResetIncidentData = NO;
    NSLog(@"there is some data need to Reset");
//    [self clickToTestGoogleApiDirection:nil];
    [self recoverTrafficObjsFromCoreData];
    [self refreshGui];
    [self performSelector:@selector(reloadTrafficObjByInternet:) withObject:self afterDelay:0.1];
}


-(IBAction) reloadTrafficObjByInternet :(id)sender {
    __block NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"sharedOperationQueue execute reloadTrafficObjByInternet");
        [self initIncidentXmlUrlsFromTrafficSetting];
        [self initTrafficObjsFromIncidentXmlUrls];
        //[self performSelector:@selector(backupAndRefreshGui:) withObject:nil afterDelay:0.1];
        //you cannot performSelector in block operation
        [self backupAndRefreshGui:nil];
        		
        
    }];			
    if(mQueue == nil) mQueue = [NSOperationQueue sharedOperationQueue];
    [mQueue addOperation:operation];
    
    
//    [self initIncidentXmlUrlsFromTrafficSetting];
//    [self initTrafficObjsFromIncidentXmlUrls];
//    [self backupTrafficObjsToCoreData];
//    [self refreshGui];
//    [self performSelector:@selector(backupAndRefreshGui:) withObject:nil afterDelay:0.1];
    
}


-(IBAction) backupAndRefreshGui:(id)sender
{
    NSLog(@"backupAndRefreshGui");
    
    [self backupTrafficObjsToCoreData];
    dispatch_async(dispatch_get_main_queue(),^{
        [self refreshGui];
    });
}


-(void)recoverTrafficObjsFromCoreData
{
    if(mIsCoreDataUsed == YES) return;
    mIsCoreDataUsed = YES;
    
    CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];
    NSString *entityName = @"TrafficIncidentEntity";


    NSMutableArray * coreItems = [theCoreDataHelper readItems:entityName];
@synchronized (coreItems) {
        

    
    if(coreItems != nil && [coreItems count] > 0 )
    {
        if(mTrafficObjs != nil ) {
            [mTrafficObjs removeAllObjects];
        }
        else {
            mTrafficObjs = [NSMutableArray arrayWithCapacity:1];
        }
        int idx;
        for (idx = 0; idx < [coreItems count]; idx++)
        {
            TrafficIncidentEntity * item = (TrafficIncidentEntity*)[coreItems objectAtIndex:idx];
            TrafficObject * obj = [[TrafficObject alloc]init];
            obj.mAlertcDesc = item.mAlertcDesc;
            obj.mCriticalityDesc = item.mCriticalityDesc;
            obj.mDirectionLocalDesc = item.mDirectionLocalDesc;
            obj.mEndTime = item.mEndTime;
            obj.mLat = item.mLat;
            obj.mLng = item.mLng;
            obj.mPointDesc = item.mPointDesc;
            obj.mPointLocalDesc = item.mPointLocalDesc;
            obj.mRoadwayDesc = item.mRoadwayDesc;
            obj.mRoadwayLocalDesc = item.mRoadwayLocalDesc;
            obj.mStartTime = item.mStartTime;
            obj.mTrafficItemDesc = item.mTrafficItemDesc;
            obj.mTrafficItemTypeDesc = item.mTrafficItemTypeDesc;
            obj.mTrafficSignId = item.mTrafficSignId;
            
            [mTrafficObjs addObject:obj];
        }
    }
}
    mIsCoreDataUsed = NO;
}


-(void)backupTrafficObjsToCoreData
{
    if(mIsCoreDataUsed == YES) return;
    mIsCoreDataUsed = YES;
    
    CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];
    NSString *entityName = @"TrafficIncidentEntity";
    [theCoreDataHelper deleteAllItemsAndSave:entityName];
    if(mTrafficObjs != nil && [mTrafficObjs count]> 0)
    {
        int idx;
        for(idx = 0; idx < [mTrafficObjs count]; idx++)
        {
            TrafficObject * obj = [mTrafficObjs objectAtIndex:idx];
            EditItemCallback callback = ^(NSManagedObject *theItem)
            {
                TrafficIncidentEntity * item = (TrafficIncidentEntity*) theItem;
                
                item.mAlertcDesc = obj.mAlertcDesc;
                item.mCriticalityDesc = obj.mCriticalityDesc;
                item.mDirectionLocalDesc = obj.mDirectionLocalDesc;
                item.mEndTime = obj.mEndTime;
                item.mLat = obj.mLat;
                item.mLng = obj.mLng;
                item.mPointDesc = obj.mPointDesc;
                item.mPointLocalDesc = obj.mPointLocalDesc;
                item.mRoadwayDesc = obj.mRoadwayDesc;
                item.mRoadwayLocalDesc = obj.mRoadwayLocalDesc;
                item.mStartTime = obj.mStartTime;
                item.mTrafficItemDesc = obj.mTrafficItemDesc;
                item.mTrafficItemTypeDesc = obj.mTrafficItemTypeDesc;
                item.mTrafficSignId = obj.mTrafficSignId;
            };
            [theCoreDataHelper addItemAndSave:entityName withBlock:callback];
        }
    }
    mIsCoreDataUsed = NO;
}





-(void) viewDidAppear:(BOOL)animated {
    [self checkToDataReset];
    //[self refreshGui];
}



-(void) refreshGui {
    NSLog(@"TrafficExterViewController refreshGui");
    if(mParseHelper == nil) 
    {
        mParseHelper = [[ParseHelper alloc]init];
    }
    
    BOOL isNoData = NO;
    if(self.mTrafficObjs == nil) isNoData = YES;;
    if([self.mTrafficObjs count]<=0 ) isNoData = YES;
    int idx = mTrafficIdx;
    
    NSLog(@"refresh with idx = %d", idx);
    if(idx > [mTrafficObjs count]) {
        idx = [mTrafficObjs count]-1;
        mTrafficIdx = idx;
    }
    
    if(isNoData) {
        mPageLbl.text = @"0 / 0";
        mRoadwayAndDirLbl.text =@"";
        mTrafficItemTypeDescLbl.text = @"No Traffic Incidents";
        mTrafficItemDescLbl.text = @"";
        mStartTimeLbl.text = @"";
        mEndTimeLbl.text = @"";
        mRoadwaySignImgView.image = nil;
        mTrafficSignImgView.image = nil;
        mRoadwayNumLbl.text = @"";
        return;
    }
    else {
        
    }
    
    TrafficObject * obj = [mTrafficObjs objectAtIndex:idx];
    if(obj == nil) return;
    
    self.mRoadwayLocalDescLbl.text = obj.mRoadwayLocalDesc;
    
    self.mRoadwaySignImgView.image = [obj getRoadwaySignImg];
    NSString * imgType = obj.mRoadwaySignId.mRoadImgType;
    if([imgType isEqualToString:@"freeway"]) {
        mRoadwayNumLbl.textColor = [UIColor whiteColor];
    }
    else if([imgType isEqualToString:@"highway"]){
        mRoadwayNumLbl.textColor = [UIColor blackColor];
    }
    else if([imgType isEqualToString:@"street"]) {
        mRoadwayNumLbl.textColor = [UIColor clearColor];
    }
    else {
        mRoadwayNumLbl.textColor = [UIColor clearColor];
    }
    mRoadwayNumLbl.text = obj.mRoadwaySignId.mRoadwayNumber;
    
    self.mTrafficSignImgView.image = [obj getTrafficSignImg];
    
    if(obj.mRoadwayDesc == nil ) 
    {
        self.mRoadwayAndDirLbl.text = @"";
    }
    else if(obj.mDirectionLocalDesc == nil) 
    {
        self.mRoadwayAndDirLbl.text = [NSString stringWithFormat:@"%@", obj.mRoadwayDesc];
        
    } 
    else 
    {
        self.mRoadwayAndDirLbl.text = [NSString stringWithFormat:@"%@ - %@", obj.mRoadwayDesc, obj.mDirectionLocalDesc];        
    }
    
    
    self.mRoadwayDescLbl.text = obj.mRoadwayDesc;    

//    NSString * extractStr = [mParseHelper extractValueByPattern:@"(.+?)-" inTxtStr:obj.mRoadwayDesc];    
//    if(extractStr == nil) 
//    {
//        self.mRoadwayDescLbl.text = obj.mRoadwayDesc;
//    }
//    else 
//    {
////        self.mRoadwayDescLbl.text = @"";
//        self.mRoadwayDescLbl.text = [NSString stringWithFormat:@"%@ -> %@", obj.mRoadwayDesc, extractStr];
//    }
    
    
    //obj.mRoadwayDesc;
    
    
    
    self.mPointDescLbl.text = obj.mPointDesc;
    self.mPointLocalDescLbl.text = obj.mPointLocalDesc;
    self.mTrafficItemDescLbl.text = obj.mTrafficItemDesc;
    
    self.mTrafficItemTypeDescLbl.text = obj.mTrafficItemTypeDesc;
    self.mStartTimeLbl.text = obj.mStartTime;
    self.mEndTimeLbl.text = obj.mEndTime;
    self.mCriticalityDescLbl.text = obj.mCriticalityDesc;
    self.mAlertcDescLbl.text = obj.mAlertcDesc;
    
    self.mDirectionLocalDescLbl.text = obj.mDirectionLocalDesc;
    self.mLatLbl.text = obj.mLat;
    self.mLngLbl.text = obj.mLng;
    
    if(mTrafficObjs != nil && [mTrafficObjs count] > 0 ) 
    {
        NSString * str = [NSString stringWithFormat:@"%d / %d", mTrafficIdx+1, [mTrafficObjs count]];
        //self.mPageLbl.text = [NSString stringWithFormat:@"%d / %d", mTrafficIdx+1, [mTrafficObjs count]];
        self.mPageLbl.text = str;
    
        NSLog(@"change mPageLbl to %@", str);
    }
    else 
    {
        self.mPageLbl.text= @"";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(BOOL) nowTimeNeededTrafficObj:(RouteSettingObj*)obj {
    if(obj== nil) return NO;
    if([obj isInWorkTime]) {
        return YES;
    }
    return NO;
}




-(void) initIncidentXmlUrlsFromTrafficSetting
{
    if(mParseHelper == nil) {
        mParseHelper = [[ParseHelper alloc] init];
    }
    
    NSString * origStr = @"";
    NSString * destStr = @"";
    
    origStr = @"San Diego, CA";
    destStr = @"Los Angeles, CA";
    GlobalVars *vars  = [GlobalVars sharedInstance];
    
    if(mIncidentXmlUrls != nil) [mIncidentXmlUrls removeAllObjects];
    
    [vars.mTrafficSettingsIVC replaceCoreDataToObjArray];
    
    if(vars.mTrafficSettingsIVC != nil)
    {
        if(vars.mTrafficSettingsIVC.mObjArray != nil && [vars.mTrafficSettingsIVC.mObjArray count]>0)
        {
            int objIdx;
            for (objIdx = 0; objIdx < [vars.mTrafficSettingsIVC.mObjArray count];objIdx++)
            {
                NSLog(@"objIdx = %d", objIdx);
                
                RouteSettingObj * obj = [vars.mTrafficSettingsIVC.mObjArray objectAtIndex:objIdx];
                
                if(obj!= nil && obj.mIsEnable == YES)
                {
                    NSLog(@"obj != nil");
                    if([self nowTimeNeededTrafficObj:obj]) {
                        NSLog(@"nowTimeNeededTrafficObj:obj");
                        if(obj.mToWhere != nil && obj.mFromWhere!=nil && ![obj.mToWhere isEqualToString:@""] && ![obj.mFromWhere isEqualToString:@""]) {
                            NSLog(@"destStr and origStr is set");
                            destStr = obj.mToWhere;
                            origStr = obj.mFromWhere;
                            
                            //NSString *encodedPolyline = [RouteSettingObj getPolylineFrom:origStr toWhere:destStr];
                            
                            NSString *encodedPolyline = nil;
                            if(obj.mEncodedPolyline!= nil )
                            {
                                encodedPolyline = obj.mEncodedPolyline;
                            }
                            else
                            {
                                encodedPolyline = [RouteSettingObj getPolylineFrom:origStr toWhere:destStr];
                            }
                            
                            
                            NSMutableArray * decodedPolyline = [RouteSettingObj decodePolyline:encodedPolyline];
                            NSString * urlStr = [RouteSettingObj getIncidentUrlStrByPolylineArray:decodedPolyline];
                            if(mIncidentXmlUrls == nil) {
                                mIncidentXmlUrls = [NSMutableArray arrayWithCapacity:1];
                            }
                            [mIncidentXmlUrls addObject:urlStr];
                            NSLog(@"query url = %@", urlStr);
                        }
                    }
                }
            }
        }
    }
    
    
}

//-(IBAction) clickToTestGoogleApiDirection:(id)sender {
//    
//    NSLog(@"TrafficExterViewController clickToTestGoogleApiDirection");
//    
//    
//    [self initIncidentXmlUrlsFromTrafficSetting];
//    if(mParseHelper == nil) {
//        mParseHelper = [[ParseHelper alloc] init];
//    }
//    
//    NSString * origStr = @"";
//    NSString * destStr = @"";
//    
//    origStr = @"San Diego, CA";
//    destStr = @"Los Angeles, CA";
//    GlobalVars *vars  = [GlobalVars sharedInstance];
//
//    if(mIncidentXmlUrls != nil) [mIncidentXmlUrls removeAllObjects];
//    
//    [vars.mTrafficSettingsIVC replaceCoreDataToObjArray];
//    
//    if(vars.mTrafficSettingsIVC != nil) 
//    {
//        if(vars.mTrafficSettingsIVC.mObjArray != nil && [vars.mTrafficSettingsIVC.mObjArray count]>0) 
//        {
//            int objIdx;
//            for (objIdx = 0; objIdx < [vars.mTrafficSettingsIVC.mObjArray count];objIdx++) 
//            {
//                NSLog(@"objIdx = %d", objIdx);
//                
//                RouteSettingObj * obj = [vars.mTrafficSettingsIVC.mObjArray objectAtIndex:objIdx];
//                
//                if(obj!= nil) 
//                {
//                    NSLog(@"obj != nil");
//                    if([self nowTimeNeededTrafficObj:obj]) {
//                        NSLog(@"nowTimeNeededTrafficObj:obj");
//                        if(obj.mToWhere != nil && obj.mFromWhere!=nil && ![obj.mToWhere isEqualToString:@""] && ![obj.mFromWhere isEqualToString:@""]) {
//                            NSLog(@"destStr and origStr is set");
//                            destStr = obj.mToWhere;
//                            origStr = obj.mFromWhere;
//                            
//                            //NSString *encodedPolyline = [RouteSettingObj getPolylineFrom:origStr toWhere:destStr];
//                            
//                            NSString *encodedPolyline = nil;
//                            if(obj.mEncodedPolyline!= nil ) {
//                                encodedPolyline = obj.mEncodedPolyline;
//                            }
//                            else {
//                                encodedPolyline = [RouteSettingObj getPolylineFrom:origStr toWhere:destStr];
//                            }
//                            
//                            
//                            NSMutableArray * decodedPolyline = [RouteSettingObj decodePolyline:encodedPolyline];
//                            NSString * urlStr = [RouteSettingObj getIncidentUrlStrByPolylineArray:decodedPolyline];
//                            if(mIncidentXmlUrls == nil) {
//                                mIncidentXmlUrls = [NSMutableArray arrayWithCapacity:1];
//                            }
//                            [mIncidentXmlUrls addObject:urlStr];
//                            NSLog(@"query url = %@", urlStr);
//                        }
//                    }
//                }
//            }
//        }
//    }
//
////    NSString *xmlStr2 = [mParseHelper getSyncXmlWithUrlStr:urlStr2];
////    NSLog(@"query xml = %@", xmlStr2);  
//    
//    
//}



-(void) initTrafficObjsFromIncidentXmlUrls
{
    if(mParseHelper == nil) {
        mParseHelper = [[ParseHelper alloc]init];
    }
    mTrafficObjs = [NSMutableArray arrayWithCapacity:1];

    NSString * tmpXmlUrlStr = [NSString stringWithFormat:@"http://%@/RosenTouch/TrafficApp/incident.xml", [AppDelegate getHostName]];
    if(mIncidentXmlUrls != nil)
    {
        int urlIdx;
        for (urlIdx = 0; urlIdx < [mIncidentXmlUrls count]; urlIdx++ ) 
        {
            NSString * incidentXmlUrl = [mIncidentXmlUrls objectAtIndex:urlIdx];
            tmpXmlUrlStr = incidentXmlUrl;
            NSMutableArray * objs = [TrafficObject getTrafficObjectArrayFromIncidentUrlStr:tmpXmlUrlStr];
            if(objs != nil) 
            {
                int objIdx;
                for(objIdx = 0; objIdx < [objs count]; objIdx++) 
                {
                    TrafficObject * obj = [objs objectAtIndex:objIdx];
                    [mTrafficObjs addObject:obj];
                }
            } 
        }        
    }
}




-(void) showTileWithX:(int)x Y:(int)y Z:(int)z 
{
    NSLog(@"(x,y,z) = (%d,%d,%d)", x,y,z);
    NSString * appId = @"GWwd-IsChXy_iDmur2VK";
    NSString * token = @"flQk_dpyaLAMgHQSjcJjlw";
//    UIImage * imageTrafficLine = [mParseHelper getSyncImageWithUrlStr:[NSString stringWithFormat:@"http://maps.st.nlp.nokia.com/traffic/6.0/tiles/%d/%d/%d/256/png32?time=150000&token=%@&app_id=%@&quadkey=12020330203211",z,x,y,token,appId]];
    NSString * imageTrafficLineUrl = [NSString stringWithFormat:@"http://maps.st.nlp.nokia.com/traffic/6.0/tiles/%d/%d/%d/256/png32?time=150000&token=%@&app_id=%@",z,x,y,token,appId];
//    UIImage * imageTrafficLine = [mParseHelper getSyncImageWithUrlStr:[NSString stringWithFormat:@"http://maps.st.nlp.nokia.com/traffic/6.0/tiles/%d/%d/%d/256/png32?time=150000&token=%@&app_id=%@",z,x,y,token,appId]];
    UIImage * imageTrafficLine = [mParseHelper getSyncImageWithUrlStr:imageTrafficLineUrl];
    
    NSLog(@"imageTrafficLineUrl = %@", imageTrafficLineUrl);
    
    UIImage * image2 = [mParseHelper getSyncImageWithUrlStr:[NSString stringWithFormat:@"https://mts0.google.com/vt/hl=he&src=api&x=%d&s=&y=%d&z=%d", x, y, z]];
    mTrafficLineImgView.image = imageTrafficLine;
    mNokiaMapImgView.image = image2;
}

-(void) showTileByLng:(float)lng andLat:(float)lat 
{
    //support z = 12 as default because z=12 is the only working value for google map
    
    int z = 12;
    double LNG_MAX = 360000;
    double LAT_MAX = 180000;
    
    int idx = 0;
    int x = 0;
    int y = 0;
    
    
    double curTmpLng = lng*1000 + 180000;
    
    double curTmpLat = lat;
    double angel = curTmpLat;
    double piAngel = M_PI * (angel / 180);
    
    NSLog(@"piAngel = %f", piAngel);
    double sinVal  = sin(piAngel);
    
    
    curTmpLat = sinVal * 90;
    NSLog(@"sinVal * 90 = %g", curTmpLat);
    
    if(curTmpLat<0)curTmpLat=curTmpLat+90;
    //    curTmpLat = (curTmpLat)*1000+90000;
    curTmpLat = curTmpLat * 1000;
    
    //0.188195945558    
    //0.188196111111
    
    double curLngMaxHalf = LNG_MAX / 2;
    double curLatMaxHalf = LAT_MAX / 2;
    
    for (idx = 0; idx < z; idx++) 
    {
        if(curTmpLng > curLngMaxHalf) {
            curTmpLng = curTmpLng - curLngMaxHalf;   
            x = x * 2 + 1;
        }
        else 
        {
            x = x * 2;
        }
        curLngMaxHalf = curLngMaxHalf / 2;
        
        
        if(curTmpLat > curLatMaxHalf) 
        {
            curTmpLat = curTmpLat - curLatMaxHalf;
            y = y * 2 + 1 ;
        }
        else 
        {
            y = y * 2 ;
        }
        curLatMaxHalf = curLatMaxHalf / 2;
    }
    
    
    y = [self convertToTileYByLat:lat andZ:z];
    [self showTileWithX:x Y:y Z:z];
    NSLog(@"");
}



-(int) convertToTileYByLat:(double)lat andZ:(int)z 
{
    double n = pow(2,z);
    double lat_rad = M_PI * (lat/180);    
    double tan_lat_rad = tan(lat_rad);
    double sec_lat_rad = 1/cos(lat_rad);
    double ln = log10((tan_lat_rad+sec_lat_rad))/M_LOG10E;
    double ln_div_pi = ln / M_PI;
    double retVal = ((1-ln_div_pi)/2) * n;
    return retVal;
}


@end
