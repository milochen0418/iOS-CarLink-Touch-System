#import "AppsListInterViewController.h"
#import "GlobalVars.h"

@implementation AppsListInterViewController






@synthesize mAppIconImgView;
@synthesize mAppNameLbl;
@synthesize mBlueLed;
@synthesize mAppObj;
@synthesize mAppObjs;
@synthesize mAppObjIdx;

@synthesize mAppObj1,mAppObj2,mAppObj3,mBlueLed1,mBlueLed2,mBlueLed3,mAppNameLbl1,mAppNameLbl2,mAppNameLbl3,mAppIconImgView1,mAppIconImgView2,mAppIconImgView3;
@synthesize mAppObj4,mAppObj5,mAppObj6,mAppObj7,mAppObj8,mAppObj9,mAppObja,mAppObjb,mAppObjc;
@synthesize mAppIconImgView4,mAppIconImgView5,mAppIconImgView6,mAppIconImgView7,mAppIconImgView8,mAppIconImgView9,mAppIconImgViewa,mAppIconImgViewb,mAppIconImgViewc;
@synthesize mAppNameLbl4,mAppNameLbl5,mAppNameLbl6,mAppNameLbl7,mAppNameLbl8,mAppNameLbl9,mAppNameLbla,mAppNameLblb,mAppNameLblc;


@synthesize mQueue;

@synthesize mBlueLed4,mBlueLed5,mBlueLed6,mBlueLed7,mBlueLed8,mBlueLed9,mBlueLeda,mBlueLedb,mBlueLedc,mRosenLbl,mIsOnPushVC;


@synthesize mPrevPageBtn,mNextPageBtn,mPageLbl;

-(void) setAppObjsForShowGui {
    int count = [mAppObjs count];
    int idx = mAppObjIdx;
    
    mPageLbl.text = [NSString stringWithFormat:@"%d / %d", (idx/12)+1,(count/12)+1];
    
    mAppObj1 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj2 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj3 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj4 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj5 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj6 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj7 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj8 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObj9 = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObja = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObjb = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    mAppObjc = (idx>=count)?nil:[mAppObjs objectAtIndex:idx++];
    
    
    
//    if(mAppObjIdx+1 >= count) {
//        mAppObj2 = [mAppObjs objectAtIndex:0];
//        mAppObj3 = [mAppObjs objectAtIndex:1];
//    }
//    else if(mAppObjIdx+2 >= count)
//    {
//        mAppObj2 = [mAppObjs objectAtIndex:(mAppObjIdx+1)];
//        mAppObj3 = [mAppObjs objectAtIndex:0];
//    } 
//    else 
//    {
//        mAppObj2 = [mAppObjs objectAtIndex:(mAppObjIdx+1)];
//        mAppObj3 = [mAppObjs objectAtIndex:(mAppObjIdx+2)];        
//    }
}


-(IBAction)clickToNextAppObj:(id)sender {
    int count = [mAppObjs count];
    NSLog(@"count = %d", count);
    if(mAppObjIdx + 12 >= count) {
//        mAppObjIdx = 0;
    }
    else 
    {
        mAppObjIdx = mAppObjIdx + 12;
    }
//    mAppObj = [mAppObjs objectAtIndex:mAppObjIdx];
    
    [self setAppObjsForShowGui];
    
    [self performSelector:@selector(clickToLoadAppIcon:) withObject:nil];
}

-(IBAction)clickToPrevAppObj:(id)sender {
//    int count = [mAppObjs count];
    if(mAppObjIdx - 1 < 0) {
//        mAppObjIdx = count-1;
    }
    else {
        mAppObjIdx = mAppObjIdx - 12;
    }
//    mAppObj = [mAppObjs objectAtIndex:mAppObjIdx];
    [self setAppObjsForShowGui];
    
    [self performSelector:@selector(clickToLoadAppIcon:) withObject:nil];    
}

-(IBAction) clickToActionIt:(id)sender {
//    if(mAppObj != nil) {
//        [mAppObj actionIt];
//    }
    GlobalVars *vars = [GlobalVars sharedInstance];
    if([mAppObj isInstalled])
    {
        [mAppObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = mAppObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}


-(IBAction) clickToActionIt1:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj1; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}


-(IBAction) clickToActionIt2:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj2; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}



-(IBAction) clickToActionIt3:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj3; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionIt4:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj4; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionIt5:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj5; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionIt6:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj6; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionIt7:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj7; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionIt8:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj8; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionIt9:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObj9; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionIta:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObja; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionItb:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObjb; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}

-(IBAction) clickToActionItc:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    AppObject *appObj = mAppObjc; 
    if([appObj isInstalled])
    {
        [appObj actionIt];
    }
    else 
    {
        mIsOnPushVC = YES;
        vars.mAppInstallationIVC.mAppObj = appObj;
        [vars.interNav pushViewController:vars.mAppInstallationIVC animated:YES];
        [vars.exterNav pushViewController:vars.mAppInstallationEVC animated:YES];
    }    
}



-(IBAction) clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav popViewControllerAnimated:YES];
    [vars.exterNav popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    

    [self changeBtnIntoBlk:mPrevPageBtn];
    [self changeBtnIntoBlk:mNextPageBtn];
    [self initAppObjs];
//    [self performSelector:@selector(performLoadAppInfo:) withObject:nil]; 
    
    NSOperationQueue *queue = [NSOperationQueue new];
    mQueue = queue;
    
    
    [self setRoundedRetangular:self.mAppIconImgView1];
    [self setRoundedRetangular:self.mAppIconImgView2];
    [self setRoundedRetangular:self.mAppIconImgView3];
    [self setRoundedRetangular:self.mAppIconImgView4];
    [self setRoundedRetangular:self.mAppIconImgView5];
    [self setRoundedRetangular:self.mAppIconImgView6];
    [self setRoundedRetangular:self.mAppIconImgView7];
    [self setRoundedRetangular:self.mAppIconImgView8];
    [self setRoundedRetangular:self.mAppIconImgView9];
    [self setRoundedRetangular:self.mAppIconImgViewa];
    [self setRoundedRetangular:self.mAppIconImgViewb];
    [self setRoundedRetangular:self.mAppIconImgViewc];
    
    
    NSString* navTitle = @"Apps";
    self.navigationItem.backBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle:navTitle 
                                     style:UIBarButtonItemStyleBordered
                                    target: self
                                    action: @selector(clickToBack:)
     ];

    self.navigationItem.title = navTitle;
    
}
-(void) setRoundedRetangular:(UIImageView*) iconImgView {
#define kHeight 64
#define kRoundSize 10    
    iconImgView.layer.cornerRadius = kRoundSize;
    iconImgView.layer.masksToBounds = YES;
    [iconImgView.layer setShadowColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor];
    [iconImgView.layer setShadowOffset:CGSizeMake(0, 0)];
    [iconImgView.layer setShadowOpacity:1.0];
    [iconImgView.layer setShadowRadius:kRoundSize];
    
}


-(IBAction)performLoadAppInfo:(id)sender {
    
    [self operationSetItemWithNameLbl:mAppNameLbl1 andImgView:mAppIconImgView1 andLed:mBlueLed1 withAppObj:mAppObj1];
    [self operationSetItemWithNameLbl:mAppNameLbl2 andImgView:mAppIconImgView2 andLed:mBlueLed2 withAppObj:mAppObj2];
    [self operationSetItemWithNameLbl:mAppNameLbl3 andImgView:mAppIconImgView3 andLed:mBlueLed3 withAppObj:mAppObj3];
    [self operationSetItemWithNameLbl:mAppNameLbl4 andImgView:mAppIconImgView4 andLed:mBlueLed4 withAppObj:mAppObj4];
    [self operationSetItemWithNameLbl:mAppNameLbl5 andImgView:mAppIconImgView5 andLed:mBlueLed5 withAppObj:mAppObj5];
    [self operationSetItemWithNameLbl:mAppNameLbl6 andImgView:mAppIconImgView6 andLed:mBlueLed6 withAppObj:mAppObj6];
    [self operationSetItemWithNameLbl:mAppNameLbl7 andImgView:mAppIconImgView7 andLed:mBlueLed7 withAppObj:mAppObj7];
    [self operationSetItemWithNameLbl:mAppNameLbl8 andImgView:mAppIconImgView8 andLed:mBlueLed8 withAppObj:mAppObj8];
    [self operationSetItemWithNameLbl:mAppNameLbl9 andImgView:mAppIconImgView9 andLed:mBlueLed9 withAppObj:mAppObj9];
    [self operationSetItemWithNameLbl:mAppNameLbla andImgView:mAppIconImgViewa andLed:mBlueLeda withAppObj:mAppObja];
    [self operationSetItemWithNameLbl:mAppNameLblb andImgView:mAppIconImgViewb andLed:mBlueLedb withAppObj:mAppObjb];
    [self operationSetItemWithNameLbl:mAppNameLblc andImgView:mAppIconImgViewc andLed:mBlueLedc withAppObj:mAppObjc];

}


-(IBAction)selSetItemWithNameLbl:(UILabel*)nameLbl andImgView:(UIImageView*)iconImgView andLed:(UIButton*)ledBtn withAppObj:(AppObject*)appObj {
    [self setItemWithNameLbl:nameLbl andImgView:iconImgView andLed:ledBtn withAppObj:appObj];     
}

-(void) operationSetItemWithNameLbl:(UILabel*)nameLbl andImgView:(UIImageView*)iconImgView andLed:(UIButton*)ledBtn withAppObj:(AppObject*)appObj {
    
    if(appObj == nil ) {
        nameLbl.hidden = YES;
        iconImgView.hidden = YES;
        ledBtn.hidden = YES;
        return;
    } else {
//        nameLbl.hidden = NO;
        nameLbl.text = @"";
//        iconImgView.hidden = NO;
//        ledBtn.hidden = NO;        
    }
    
    NSOperationQueue * queue = mQueue;    
    NSMethodSignature * sig = nil;
    sig = [self  methodSignatureForSelector:@selector(selSetItemWithNameLbl:andImgView:andLed:withAppObj:)];    
    NSInvocation * invocationApp = [NSInvocation invocationWithMethodSignature:sig];
    [invocationApp setTarget:self];
    
    [invocationApp setSelector:@selector(selSetItemWithNameLbl:andImgView:andLed:withAppObj:)];    
    [invocationApp setArgument:&nameLbl atIndex:2];
    [invocationApp setArgument:&iconImgView atIndex:3];
    [invocationApp setArgument:&ledBtn atIndex:4];
    [invocationApp setArgument:&appObj atIndex:5];
    NSInvocationOperation *operationApp = [[NSInvocationOperation alloc] initWithInvocation:invocationApp];
    [queue addOperation:operationApp];
    operationApp = nil;
}


-(void) setItemWithNameLbl:(UILabel*)nameLbl andImgView:(UIImageView*)iconImgView andLed:(UIButton*)ledBtn withAppObj:(AppObject*)appObj
{    
    
    UIActivityIndicatorView * indActView = nil;
    UIView * appIconView = iconImgView;
    indActView = [[UIActivityIndicatorView alloc] init];        
    indActView.frame = appIconView.frame;
    indActView.transform = CGAffineTransformMakeScale(1, 1);
    indActView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleBottomMargin);
    indActView.hidesWhenStopped = YES;
    indActView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    
    dispatch_async(dispatch_get_main_queue(), ^{ 
        [appIconView.superview addSubview:indActView];
        [indActView startAnimating];
        appIconView.hidden = YES;
        ledBtn.hidden = YES;
    });
    
    [appObj loadAppIconAndName];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:appObj.mAppIconUrl]]];
    
    if([appObj isInstalled])
    {
        dispatch_async(dispatch_get_main_queue(), ^{ 
            ledBtn.highlighted = YES;
            ledBtn.hidden = NO;
        });
    }
    else 
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            ledBtn.highlighted = NO;
            ledBtn.hidden = NO;
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        nameLbl.text = appObj.mAppName;
        iconImgView.image = image;
        
        
        
        appIconView.hidden = NO;
        nameLbl.hidden = NO;
        
        appIconView.alpha = 0;
        [UIView animateWithDuration:0.1 animations:^{appIconView.alpha = 1.0;}];
        appIconView.layer.transform = CATransform3DMakeScale(0.5,0.5,1.0);
        
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = [NSArray arrayWithObjects:
                                  [NSNumber numberWithFloat:0.5],
                                  [NSNumber numberWithFloat:1.1],
                                  [NSNumber numberWithFloat:0.8],
                                  [NSNumber numberWithFloat:1.0], nil];
        bounceAnimation.duration = 0.3;
        bounceAnimation.removedOnCompletion = NO;
        [appIconView.layer addAnimation:bounceAnimation forKey:@"bounce"];
        appIconView.layer.transform = CATransform3DIdentity;
        
        [indActView stopAnimating];
        [indActView removeFromSuperview];
        
    });
    NSLog(@"mAppName = %@", appObj.mAppName);
    
}




-(void) initAppObjs {
    mAppObjs = [NSMutableArray arrayWithCapacity:1];
    AppObject * appObj;
    if(NO) {
        int idx;
        for (idx = 0 ; idx < 10 ; idx++ ) 
        {
            appObj = [[AppObject alloc] 
              initWithUrlScheme:@"fahrinfo-berlin://connection?to=friedrichstr&time=18:00" 
              andITuneUrl:@"http://itunes.apple.com/us/app/fahrinfo-berlin/id284971745?mt=8"];
            [mAppObjs addObject:appObj];
    
            appObj = [[AppObject alloc]
              initWithUrlScheme:@"pandorav2://createStation?musicId=R320985" 
              andITuneUrl:@"http://itunes.apple.com/us/app/pandora-radio/id284035177?mt=8"];
            [mAppObjs addObject:appObj];
    
            appObj = [[AppObject alloc]
              initWithUrlScheme:@"airports://weather?JFK,CDG,LEMG" 
              andITuneUrl:@"http://itunes.apple.com/app/airports/id299117180?mt=8"];
            [mAppObjs addObject:appObj];
    
            appObj = [[AppObject alloc]
              initWithUrlScheme:@"amb://sounds/305" 
              andITuneUrl:@"http://itunes.apple.com/app/ambiance/id285538312?mt=8"];
            [mAppObjs addObject:appObj];

            appObj = [[AppObject alloc]
              initWithUrlScheme:@"nflx://www.netflix.com/WiPlayer?movieid=70037510&trkid=1290709" 
              andITuneUrl:@"http://itunes.apple.com/us/app/netflix/id363590051?mt=8"];
            [mAppObjs addObject:appObj];
    
        }
    
        mAppObjIdx = 0;
        mAppObj = [mAppObjs objectAtIndex:mAppObjIdx];
    } 
    else //init AppObjects from internet .xml file 
    {
//        
//        NSString *urlStr = @"http://www.gogole.com";
//        urlStr = @"http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=add&lat=37.335072&lng=-122.032604&type=1";
//        urlStr = @"http://speedcamerapoi.com/api.class?key=c934f220074cbc9ad267ad6b813dd203&action=search&lat=37.335072&lng=-122.032604&limit=3";
//
        
//        NSString *xmlStrTmp = [self getXmlStringFromUrlStr:@"http://192.168.0.105/RosenTouch/AppsListApp/list.xml"];
        NSString *xmlStrTmp = [self getXmlStringFromUrlStr:[NSString stringWithFormat:@"http://%@/RosenTouch/AppsListApp/list.xml",[AppDelegate getHostName]]];

        

        
        NSString *xmlStr = [self stringByRemovingNewLinesAndWhitespace:xmlStrTmp];
        NSLog(@"xmlStr = %@", xmlStr);
        
        NSString *statusVal = [self extractValueBetweenTag:@"status" inXmlStr:xmlStr];
        //    NSString *idVal = [self extractValueBetweenTag:@"id" inXmlStr:xmlStr];
        NSString *appsVal = [self extractValueBetweenTag:@"apps" inXmlStr:xmlStr];
        
        
        NSLog(@"statusVal = %@", statusVal);
        //    NSLog(@"idVal = %@", idVal);
        
        NSMutableArray *arr = [self extractStrArrayBySameTag:@"app" inXmlStr:appsVal];
        if(arr != nil && [arr count]>0){
            int idx;
            for(idx = 0; idx < [arr count]; idx++ ) {
                NSString * str = [arr objectAtIndex:idx];
                //NSLog(@"item[%d]= %@",idx,str);
                NSString * urlschemeStr = [self extractValueBetweenBeginStr:@"urlscheme=\"" andEndStr:@"\"" inTxtStr:str]; 
                NSString * webpageurlStr = [self extractValueBetweenBeginStr:@"webpageurl=\"" andEndStr:@"\"" inTxtStr:str];
                NSLog(@"item[%d].urlschemeStr=%@",idx,urlschemeStr);  
                NSLog(@"item[%d].webpageurlStr=%@",idx,webpageurlStr);              
                
                appObj = [[AppObject alloc]
                          initWithUrlScheme:urlschemeStr
                          andITuneUrl:webpageurlStr];
                [mAppObjs addObject:appObj];
            }
        }
        
        mAppObjIdx = 0;
        mAppObj = [mAppObjs objectAtIndex:mAppObjIdx];        
    }
        
    [self setAppObjsForShowGui];
    
}


-(NSString*) getXmlStringFromUrlStr:(NSString*)urlStr {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];           
    [request setURL:[NSURL URLWithString:urlStr]];  
    [request setHTTPMethod:@"GET"];  
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    request = nil;
    NSString * loadData = [[NSMutableString alloc] initWithData:returnData encoding:NSISOLatin1StringEncoding];
    return loadData;
}


-(NSString*) extractValueBetweenTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    return [self 
            extractValueBetweenBeginStr:[NSString stringWithFormat:@"<%@>",tagName] 
            andEndStr:[NSString stringWithFormat:@"</%@>",tagName] 
            inTxtStr:xmlStr
            ];    
}


-(void) cleanOperationAndAppList {
 
    [mQueue cancelAllOperations];
    
    mBlueLed1.hidden = YES;
    mBlueLed2.hidden = YES;
    mBlueLed3.hidden = YES;
    mBlueLed4.hidden = YES;
    mBlueLed5.hidden = YES;
    mBlueLed6.hidden = YES;
    mBlueLed7.hidden = YES;
    mBlueLed8.hidden = YES;
    mBlueLed9.hidden = YES;
    mBlueLeda.hidden = YES;
    mBlueLedb.hidden = YES;
    mBlueLedc.hidden = YES;
    
    mAppNameLbl1.hidden = YES;
    mAppNameLbl2.hidden = YES;
    mAppNameLbl3.hidden = YES;
    mAppNameLbl4.hidden = YES;
    mAppNameLbl5.hidden = YES;
    mAppNameLbl6.hidden = YES;
    mAppNameLbl7.hidden = YES;
    mAppNameLbl8.hidden = YES;
    mAppNameLbl9.hidden = YES;
    mAppNameLbla.hidden = YES;
    mAppNameLblb.hidden = YES;
    mAppNameLblc.hidden = YES;
    
    mAppIconImgView1.hidden = YES;
    mAppIconImgView2.hidden = YES;
    mAppIconImgView3.hidden = YES;
    mAppIconImgView4.hidden = YES;
    mAppIconImgView5.hidden = YES;
    mAppIconImgView6.hidden = YES;
    mAppIconImgView7.hidden = YES;
    mAppIconImgView8.hidden = YES;
    mAppIconImgView9.hidden = YES;
    mAppIconImgViewa.hidden = YES;
    mAppIconImgViewb.hidden = YES;
    mAppIconImgViewc.hidden = YES;
    
}
-(IBAction) clickToLoadAppIcon:(id)sender {
    NSLog(@"clickToLoadAppIcon");
//    mAppObj = [mAppObjs objectAtIndex:mAppObjIdx];
    NSLog(@"mAppObjIdx = %d", mAppObjIdx);
    
    [self cleanOperationAndAppList];
    
    [self performSelector:@selector(performLoadAppInfo:) withObject:nil afterDelay:0.1];
    return; 
}






- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    mIsOnPushVC = NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    GlobalVars *vars = [GlobalVars sharedInstance];
    [self cleanOperationAndAppList];
    [self performSelector:@selector(performLoadAppInfo:) withObject:nil afterDelay:1]; 
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    GlobalVars * vars = [GlobalVars sharedInstance];
    if([vars.exterNav topViewController] == vars.mAppsListEVC && !mIsOnPushVC) {
        [vars.exterNav popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation  != UIInterfaceOrientationPortrait && interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }    
    return YES;    
}


-(NSMutableArray*) extractStrArrayBySameTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    NSString *loadData = xmlStr;
    NSString *pattern = [NSString stringWithFormat:@"<%@ (.+?)/>", tagName];      
    NSError * err;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionSearch
                                  error:&err];
    
    if(err!=nil) 
    {
        //        NSLog(@"err:%@",[err localizedDescription]);
        return nil;
    }
    
    
    NSArray * matches = [regex matchesInString:loadData options:0 range:NSMakeRange(0, loadData.length)];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
    
    
    for( NSTextCheckingResult * ntcr in matches) 
    {
        int captureIndex;
        for(captureIndex = 1; captureIndex < ntcr.numberOfRanges; captureIndex++) 
        {
            NSRange matchRange = [ntcr rangeAtIndex:captureIndex];
            NSString *match = [loadData substringWithRange:matchRange];
            [arr addObject:match];
        }
    }
    return arr;
}

-(NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr inTxtStr:(NSString*)txtStr;
{
    if(beginStr==nil || endStr ==nil || txtStr ==nil) return nil;
    
    NSString *pattern = [NSString stringWithFormat:@"%@(.+?)%@", beginStr, endStr];    
    NSError * err = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:
                                  NSRegularExpressionCaseInsensitive
                                  error:&err];
    if(err!=nil) {
        NSLog(@"extractValueBetweenBeginStr get err = %@", [err localizedDescription]);
        return nil;
    }
    
    //    return [[regex matchesInString:loadData options:NSCaseInsensitiveSearch range:NSMakeRange(0,[loadData length])] objectAtIndex:0];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:txtStr options:0 range:NSMakeRange(0, txtStr.length)];
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [txtStr substringWithRange:matchRange];
    if([match isEqualToString:@""]) {
        return nil;
    }
    return match;
    
}


- (NSString *)stringByRemovingNewLinesAndWhitespace:(NSString*)str {
	NSScanner *scanner = [[NSScanner alloc] initWithString:str];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *result = [[NSMutableString alloc] init];
	NSString *temp;
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                                      [NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	// Scan
	while (![scanner isAtEnd]) {
        
		// Get non new line or whitespace characters
		temp = nil;
		[scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
		if (temp) [result appendString:temp];
        
		// Replace with a space
		if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
			if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
				[result appendString:@" "];
		}
        
	}
    
	// Cleanup
    scanner = nil;
    
	// Return
	NSString *retString = [NSString stringWithString:result];
    result = nil;
	//[result release];
    
    return retString;
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


@end
