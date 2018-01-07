//
//  ExterViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExterViewController.h"
#import "GlobalVars.h"
#import "SCPMarkersDom.h"
//#import "TrafficObjForWidget.h"
#import "ParseHelper.h"
#import "AppDelegate.h"
#import "RoadwaySignId.h"
#import "TrafficObject.h"
#import "WeatherEntity.h"
#import "WeatherObj.h"

@implementation ExterViewController

@synthesize mRoadwayNumLbl;


@synthesize mTrafficSignImgView, mRoadwaySignImgView;


@synthesize mAddrLbl,mDistAndDirLbl,mCameraTypeLbl;
@synthesize mHiTmpLbl,mLoTmpLbl,mTmpLbl,mTodayWeatherImgView;

//@synthesize mTrafficWidgetLbl1,mTrafficWidgetLbl2,mTrafficWidgetLbl3;
@synthesize mRoadwayAndDirLbl,mTrafficItemTypeDescLbl;

@synthesize mLocId,mIsSelectC,mCurCityName;

@synthesize mTrafficWidgetObjs;
@synthesize mContentView;
@synthesize mTypeImg;
@synthesize mParseHelper;
@synthesize mIsInitWeatherWidget;

@synthesize mSpdLimitBg;
@synthesize mSpeedLimitLbl;
@synthesize mNoCameraDetectedLbl;
@synthesize mNoTrafficIncidentLbl;


-(void)viewDidAppear:(BOOL)animated 
{
    
    //readWeatherSettingsAndShow
    self.mIsInitWeatherWidget = NO;
    
    GlobalVars * vars = [GlobalVars sharedInstance];
    SCPMarker * widgetMarker = vars.mSpeedCameraEVC.mWidgetMarker;
    [vars.mSpeedCameraEVC applicationGUIEnter];
    
    if(widgetMarker != nil ) 
    {
        mDistAndDirLbl.text = [SpeedCameraExterViewController getDisAndDirFormatStr:widgetMarker];
        
        mCameraTypeLbl.text  = [vars.mSpeedCameraEVC getShortNameByType:widgetMarker.mType];

        if(vars.mSpeedCameraEVC.mCLPlacemark != nil) {
            mAddrLbl.text = [NSString stringWithFormat:@"%@",vars.mSpeedCameraEVC.mCLPlacemark.thoroughfare];
        }
        mSpeedLimitLbl.text = vars.mSpeedCameraEVC.mSpdLimitLbl.text;
    }
    else 
    {
        //mDistAndDirLbl.text = @"Loading...";
        mDistAndDirLbl.text = @"";
        mCameraTypeLbl.text = @"";
        mAddrLbl.text = @"";
        mSpeedLimitLbl.text = @"";
    }
   [self refreshWidgets];
    
    
    if(! mIsInitWeatherWidget) {
        [vars.mEVC readWeatherSettingsAndShow];
        mIsInitWeatherWidget = YES;
    }
    
    //[vars.mAppDelegate notifyExterNavAnimatedStatus:NO];
}



-(ExterViewController*) init 
{
    self = [super init];
    if(self) {
        
    }
    return self;
}



-(IBAction)clickToLaunchWeather:(id)sender 
{
    
    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.interNav pushViewController:vars.mWeatherIVC animated:YES];
    //[self notifyExterNavAnimatedStatus:YES];
//    [vars.mAppDelegate notifyExterNavAnimatedStatus:YES];
    
    [vars.exterNav pushExterViewController:vars.mWeatherEVC animated:YES];
    vars.mWeatherEVC.mIsNeedToResetWeatherData = YES;
    
    //[vars.exterNav pushViewController:vars.mWeatherEVC animated:NO];

    [vars.mSpeedCameraEVC applicationGUILeave];
    
    
    //[vars.mPVC sendSingleBeep:nil];
    
}



-(IBAction)clickToLaunchSpeedCamera:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.exterNav pushExterViewController:vars.mSpeedCameraEVC animated:YES];
//    [vars.mSpeedCameraEVC applicationGUIEnter];
    
}

-(IBAction)clickToLaunchCarMediaCenter:(id)sender 
{
//    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.interNav pushViewController:vars.mWeatherIVC animated:YES];
//    [vars.exterNav pushViewController:vars.mWeatherEVC animated:YES];
    
}

-(IBAction)clickToLaunchTraffic:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.interNav pushViewController:vars.mWeatherIVC animated:YES];
    [vars.exterNav pushExterViewController:vars.mTrafficEVC animated:YES];
    [vars.mSpeedCameraEVC applicationGUILeave];
    
}

-(IBAction)clickToLaunchTraffic1:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mTrafficEVC.mTrafficIdx = 0;
    [vars.exterNav pushExterViewController:vars.mTrafficEVC animated:YES];
    [vars.mSpeedCameraEVC applicationGUILeave];    
}

-(IBAction)clickToLaunchTraffic2:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mTrafficEVC.mTrafficIdx = 1;
    [vars.exterNav pushExterViewController:vars.mTrafficEVC animated:YES];
    [vars.mSpeedCameraEVC applicationGUILeave];
}

-(IBAction)clickToLaunchTraffic3:(id)sender 
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mTrafficEVC.mTrafficIdx = 2;
    [vars.exterNav pushExterViewController:vars.mTrafficEVC animated:YES];
    [vars.mSpeedCameraEVC applicationGUILeave];
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

-(IBAction) oneHourToRefreshWeather:(id)sender  {
    [self readWeatherSettingsAndShow];
    [self performSelector:@selector(oneHourToRefreshWeather:) withObject:nil afterDelay:3600];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.mRoadwayAndDirLbl.text = @"";
    self.mTrafficItemTypeDescLbl.text = @"";
    
    GlobalVars * vars = [GlobalVars sharedInstance];
    
    //init traffic route obj array in memory from the data in core data 
    vars.mTrafficEVC.mIsNeedToResetIncidentData = YES;
    [vars.mTrafficSettingsIVC view];
    [vars.mTrafficSettingsIVC replaceCoreDataToObjArray];
    
    mRoadwayNumLbl.text = @"";
    mRoadwayAndDirLbl.text = @"";
    mTrafficItemTypeDescLbl.text = @"";
    mTrafficSignImgView.image = nil;
    mRoadwaySignImgView.image = nil;
    
    mTmpLbl.text = @"Loading";
    mHiTmpLbl.text=@"";
    mLoTmpLbl.text=@"";
    [self refreshWidgets];
//    [self performSelector:@selector(oneHourToRefreshWeather:) withObject:nil afterDelay:3600];
//    [self performSelector:@selector(fiveMinuteRequeryIncident:) withObject:nil afterDelay:300];
    
    
    
}

-(IBAction)fiveMinuteRequeryIncident:(id)sender {
//    GlobalVars *vars =[GlobalVars sharedInstance];
//    vars.mTrafficEVC.mIsNeedToResetIncidentData = YES;
//    [vars.mTrafficSettingsIVC view];
//    [vars.mTrafficSettingsIVC replaceCoreDataToObjArray];
    
    [self clickToTestInitTrafficObjForWidget:nil];
    
    [self performSelector:@selector(fiveMinuteRequeryIncident:) withObject:nil afterDelay:300];
}


-(void) refreshWidgets 
{
    NSLog(@"refreshWidget");
    GlobalVars *vars = [GlobalVars sharedInstance];    
    [self performSelector:@selector(initAppLaunchIcons:) withObject:nil afterDelay:0.5];    
    [self addChildViewController:vars.mSpeedCameraEVC];
    [mContentView addSubview:vars.mSpeedCameraEVC.view];

}


-(IBAction) initAppLaunchIcons:(id)sender 
{
    //[self performSelector:@selector(performLoadAppInfo:) withObject:nil afterDelay:0.5];    
//    [self performLoadAppInfo:nil];
    
    [self performSelector:@selector(initWeatherWidget:) withObject:nil afterDelay:0.5];    
}


-(IBAction) initWeatherWidget:(id)sender 
{
    if(mIsInitWeatherWidget == NO) 
    {
        mIsInitWeatherWidget = YES;
        [self readWeatherSettingsAndShow];
        [self performSelector:@selector(initTrafficWidget:) withObject:nil afterDelay:0.5];
    }
    else {
        [self performSelector:@selector(initTrafficWidget:) withObject:nil afterDelay:0.5];    
    }
}


-(IBAction) initTrafficWidget:(id)sender 
{
    [self clickToTestInitTrafficObjForWidget:nil];
    [self performSelector:@selector(initSpeedCameraWidget:) withObject:nil afterDelay:0.5];
}


-(IBAction) initSpeedCameraWidget:(id)sender {
    NSLog(@"initSpeedCameraWidget");
    GlobalVars * vars = [GlobalVars sharedInstance];
    SCPMarker * widgetMarker = vars.mSpeedCameraEVC.mWidgetMarker;
    if(widgetMarker != nil ) 
    {
        self.mNoCameraDetectedLbl.hidden = YES;
        
        mDistAndDirLbl.text = [SpeedCameraExterViewController getDisAndDirFormatStr:widgetMarker];
        
        mCameraTypeLbl.text  = [vars.mSpeedCameraEVC getShortNameByType:widgetMarker.mType];        
        if(vars.mSpeedCameraEVC.mCLPlacemark != nil) 
        {
            if(vars.mSpeedCameraEVC.mCLPlacemark.subThoroughfare == nil) {
                mAddrLbl.text = [NSString stringWithFormat:@"%@",vars.mSpeedCameraEVC.mCLPlacemark.thoroughfare];
            }
            else 
            {
                mAddrLbl.text = [NSString stringWithFormat:@"%@ %@",vars.mSpeedCameraEVC.mCLPlacemark.subThoroughfare, vars.mSpeedCameraEVC.mCLPlacemark.thoroughfare];
            }
        }

        int cameraTypeInt = [vars.mSpeedCameraEVC getIntegerValueByType:widgetMarker.mType];
        if(cameraTypeInt == 3)  //Redlight
        { 
//            self.mSpeedLimitLbl.hidden = YES;
//            self.mSpdLimitBg.hidden = YES;
            self.mSpeedLimitLbl.hidden = NO;
            self.mSpdLimitBg.hidden = NO;
            self.mSpeedLimitLbl.text = @"0";
            
        }
        else {
            self.mSpeedLimitLbl.hidden = NO;
            self.mSpdLimitBg.hidden = NO;
        }

    }
    else 
    {
//        mDistAndDirLbl.text = @"Loading...";
//        mDistAndDirLbl.text = @"no camera";        
        mDistAndDirLbl.text = @"";
        mCameraTypeLbl.text = @"";
        mAddrLbl.text = @"";
    }
}

//the fucntion will be called by SpeedCamera
-(void) refreshSpeedCameraWidget {
//    NSLog(@"refreshSpeedCameraWidget");
    GlobalVars * vars = [GlobalVars sharedInstance];
    SCPMarker * widgetMarker = vars.mSpeedCameraEVC.mWidgetMarker;
    if(widgetMarker != nil ) 
    {
        mDistAndDirLbl.text = [SpeedCameraExterViewController getDisAndDirFormatStr:widgetMarker];
        mCameraTypeLbl.text  = [vars.mSpeedCameraEVC getShortNameByType:widgetMarker.mType];        
        mSpeedLimitLbl.text = vars.mSpeedCameraEVC.mSpdLimitLbl.text;
        
        
        
        if(vars.mSpeedCameraEVC.mCLPlacemark != nil) {
            mAddrLbl.text = [NSString stringWithFormat:@"%@",vars.mSpeedCameraEVC.mCLPlacemark.thoroughfare];
            //e.g. for throughfare
            // Roosevelt Road Section 5 Lane 150
        }

        
        
        NSString * imageName = [vars.mSpeedCameraEVC getTypeImageNameByType:widgetMarker.mType];
//        NSLog(@"imageName = %@",imageName);
        self.mTypeImg.hidden = YES;
        if(imageName != nil) {
            self.mTypeImg.image = [UIImage imageNamed:imageName];
            self.mTypeImg.hidden = NO;
        }
    }
    else 
    {
        mDistAndDirLbl.text = @"no camera";
        mCameraTypeLbl.text = @"";
        mAddrLbl.text = @"";
    }
    
    
    int cameraTypeInt = [vars.mSpeedCameraEVC getIntegerValueByType:widgetMarker.mType];
    if(cameraTypeInt == 3)  //Redlight
    { 
//        self.mSpeedLimitLbl.hidden = YES;
//        self.mSpdLimitBg.hidden = YES;
        self.mSpeedLimitLbl.hidden = NO;
        self.mSpdLimitBg.hidden = NO;
        self.mSpeedLimitLbl.text = @"0";
        
    }
    else {
        self.mSpeedLimitLbl.hidden = NO;
        self.mSpdLimitBg.hidden = NO;
    }

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






- (NSString *)stringByConvertingHTMLToPlainText:(NSString*)txt {
    
	// Pool
    //	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	// Character sets
	NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
	// Scan and find all tags
    //	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:txt.length];
    //	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	NSScanner *scanner = [[NSScanner alloc] initWithString:txt];    
	[scanner setCharactersToBeSkipped:nil];
	[scanner setCaseSensitive:YES];
	NSString *str = nil, *tagName = nil;
	BOOL dontReplaceTagWithSpace = NO;
	do {
        
		// Scan up to the start of a tag or whitespace
		if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
			[result appendString:str];
			str = nil; // reset
		}
        
		// Check if we've stopped at a tag/comment or whitespace
		if ([scanner scanString:@"<" intoString:NULL]) {
            
			// Stopped at a comment or tag
			if ([scanner scanString:@"!--" intoString:NULL]) {
                
				// Comment
				[scanner scanUpToString:@"-->" intoString:NULL]; 
				[scanner scanString:@"-->" intoString:NULL];
                
			} else {
                
				// Tag - remove and replace with space unless it's
				// a closing inline tag then dont replace with a space
				if ([scanner scanString:@"/" intoString:NULL]) {
                    
					// Closing tag - replace with space unless it's inline
					tagName = nil; dontReplaceTagWithSpace = NO;
					if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
						tagName = [tagName lowercaseString];
						dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
												   [tagName isEqualToString:@"b"] ||
												   [tagName isEqualToString:@"i"] ||
												   [tagName isEqualToString:@"q"] ||
												   [tagName isEqualToString:@"span"] ||
												   [tagName isEqualToString:@"em"] ||
												   [tagName isEqualToString:@"strong"] ||
												   [tagName isEqualToString:@"cite"] ||
												   [tagName isEqualToString:@"abbr"] ||
												   [tagName isEqualToString:@"acronym"] ||
												   [tagName isEqualToString:@"label"]);
					}
                    
					// Replace tag with string unless it was an inline
					if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
                    
				}
                
				// Scan past tag
				[scanner scanUpToString:@">" intoString:NULL];
				[scanner scanString:@">" intoString:NULL];
                
			}
            
		} else {
            
			// Stopped at whitespace - replace all whitespace and newlines with a space
			if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
				if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
			}
            
		}
        
	} while (![scanner isAtEnd]);
    
	// Cleanup
    //	[scanner release];
    scanner = nil;
    
	// Decode HTML entities and return
    //	NSString *retString = [[result stringByDecodingHTMLEntities] retain];
    
    //need to check this function again by milo
 	//NSString *retString = [result stringByDecodingHTMLEntities];
    NSString *retString = result;
    
    //	[result release];
    result = nil;
    
	// Drain
    //	[pool drain];
    
	// Return
    //	return [retString autorelease];
    return retString;
    
}



-(NSMutableArray*) extractStrArrayBySameTwoTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    NSString *loadData = xmlStr;
    NSString *pattern = [NSString stringWithFormat:@"<%@>(.+?)</%@>", tagName,tagName];      
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
    if(mParseHelper == nil) mParseHelper = [[ParseHelper alloc]init];
    return [mParseHelper extractValueBetweenBeginStr:beginStr andEndStr:endStr inTxtStr:txtStr];
    
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
    if([match isEqualToString:@""]) 
    {
        return nil;
    }
    return match;
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


-(IBAction)clickToTestInitTrafficObjForWidget:(id)sender 
{
    
    NSLog(@"[start] clickToTestInitTrafficObjForWidget");
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mTrafficEVC.mIsNeedToResetIncidentData = YES;
    [vars.mTrafficEVC checkToDataReset];
    
//    [self initTrafficObjForWidget];
    
    //TrafficObjForWidget *obj1 = [mTrafficWidgetObjs objectAtIndex:0];
    NSMutableArray * objs = [vars.mTrafficEVC mTrafficObjs]; 
    if(objs == nil  || [objs count] <= 0) 
    {
        //mNoCameraDetectedLbl.hidden = NO;
        mNoTrafficIncidentLbl.hidden = NO;
        
        mRoadwayNumLbl.text = @"";
        mRoadwayAndDirLbl.text = @"";
        mTrafficItemTypeDescLbl.text = @"";
        mTrafficSignImgView.image = nil;
        mRoadwaySignImgView.image = nil;
        
        
        return;
    }
    mNoTrafficIncidentLbl.hidden = YES;
    
    
    TrafficObject * obj1 = (TrafficObject*)[objs objectAtIndex:0];
    
//    TrafficObjForWidget *obj2 = [mTrafficWidgetObjs objectAtIndex:1];
//    TrafficObjForWidget *obj3 = [mTrafficWidgetObjs objectAtIndex:2];
    
//    obj1.mTrafficSignId

    
    NSLog(@"%@",[NSString stringWithFormat:@"%@,%@", obj1.mTrafficItemTypeDesc,obj1.mStartTime]);
    
//    self.mRoadwayAndDirLbl.text = [NSString stringWithFormat:@"%@ - %@", obj1.mRoadwayDesc, obj1.mDirectionLocalDesc];
    if(obj1.mRoadwayDesc == nil ) 
    {
        self.mRoadwayAndDirLbl.text = @"";
    }
    else if(obj1.mDirectionLocalDesc == nil) {
        self.mRoadwayAndDirLbl.text = [NSString stringWithFormat:@"%@", obj1.mRoadwayDesc];
        
    } else {
        self.mRoadwayAndDirLbl.text = [NSString stringWithFormat:@"%@ - %@", obj1.mRoadwayDesc, obj1.mDirectionLocalDesc];        
    }
    
    
    self.mTrafficItemTypeDescLbl.text = obj1.mTrafficItemTypeDesc;
    self.mRoadwaySignImgView.image = [obj1 getRoadwaySignImg];
    NSString * imgType = obj1.mRoadwaySignId.mRoadImgType;
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
    mRoadwayNumLbl.text = obj1.mRoadwaySignId.mRoadwayNumber;
    
    
    self.mTrafficSignImgView.image = [obj1 getTrafficSignImg];
    
//    self.mTrafficWidgetLbl1.text = [NSString stringWithFormat:@"%@,%@", obj1.mRoadwayDesc,obj1.mPointDesc];
//    self.mTrafficWidgetLbl2.text = [NSString stringWithFormat:@"%@,%@", obj2.mRoadwayDesc,obj2.mPointDesc];
//    self.mTrafficWidgetLbl3.text = [NSString stringWithFormat:@"%@,%@", obj3.mRoadwayDesc,obj3.mPointDesc];
    
    NSLog(@"[end] clickToTestInitTrafficObjForWidget");
}




-(void) initTrafficObjForWidget 
{
//    
////    mAppObjs = [NSMutableArray arrayWithCapacity:1];
//    mTrafficWidgetObjs = [NSMutableArray arrayWithCapacity:1];
// 
////    NSString *xmlStrTmp = [self getXmlStringFromUrlStr:@"http://192.168.0.105/RosenTouch/TrafficApp/incident.xml"];
//    NSString *xmlStrTmp = [self getXmlStringFromUrlStr:[NSString stringWithFormat:@"http://%@/RosenTouch/TrafficApp/incident.xml", [AppDelegate getHostName]]];
//    
//    NSString *xmlStr = [self stringByRemovingNewLinesAndWhitespace:xmlStrTmp];
////    NSLog(@"xmlStr = %@", xmlStr);
//    NSString *trafficItemsVal = [self extractValueBetweenTag:@"TRAFFIC_ITEMS" inXmlStr:xmlStr];
//    
////    NSLog(@"trafficItemsVal = %@",trafficItemsVal);
//    
////        mTrafficWidgetObjs
//    
////    NSMutableArray *arr = [self extractStrArrayBySameTag:@"TRAFFIC_ITEM" inXmlStr:trafficItemsVal];
//    NSMutableArray *arr = [self extractStrArrayBySameTwoTag:@"TRAFFIC_ITEM" inXmlStr:trafficItemsVal];    
////    NSLog(@"extract arr = %@ with count=%d",arr, [arr count]);
//    if(arr != nil && [arr count]>0){
//        int idx;
//        for(idx = 0; idx < [arr count]; idx++ ) 
//        {
//            NSString * str = [arr objectAtIndex:idx];
//            NSString * trafficItemTypeDesc = [self extractValueBetweenTag:@"TRAFFIC_ITEM_TYPE_DESC" inXmlStr:str];
//            NSString * startTime = [self extractValueBetweenTag:@"START_TIME" inXmlStr:str];
//            NSString * endTime = [self extractValueBetweenTag:@"END_TIME" inXmlStr:str];
//            
//            NSString * roadwayStr = [self extractValueBetweenBeginStr:@"<ROADWAY ID=\"" andEndStr:@"</ROADWAY>" inTxtStr:str];
//            NSString * pointStr = [self extractValueBetweenBeginStr:@"<POINT ID=\"" andEndStr:@"</POINT>" inTxtStr:str];
//            NSString * roadwayDesc = [self extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"NTCSA\">" andEndStr:@"</DESCRIPTION>" inTxtStr:roadwayStr];
//            roadwayDesc = [self extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:roadwayDesc];
//            
//            NSString * pointDesc = [self extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"LOCAL\">" andEndStr:@"</DESCRIPTION>" inTxtStr:pointStr];
//            pointDesc = [self extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:pointDesc];
//            
//            
//            NSString * directionLocalDesc = [self extractValueBetweenTag:@"LOCATION" inXmlStr:str];
//            directionLocalDesc = [self extractValueBetweenTag:@"DEFINED" inXmlStr:directionLocalDesc];
//            directionLocalDesc = [self extractValueBetweenTag:@"ORIGIN" inXmlStr:directionLocalDesc];
//            directionLocalDesc = [self extractValueBetweenTag:@"DIRECTION" inXmlStr:directionLocalDesc];
//            directionLocalDesc = [self extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"LOCAL\">" andEndStr:@"</DESCRIPTION>" inTxtStr:directionLocalDesc];
//            //if(directionLocalDesc == nil) directionLocalDesc = @"no direction local desc";
//            if(directionLocalDesc == nil) directionLocalDesc = @"";
//            if(mParseHelper == nil ) {
//                mParseHelper = [[ParseHelper alloc]init ];
//            }
//            directionLocalDesc = [mParseHelper extractValueByPattern:@"(.+?)bound" inTxtStr:directionLocalDesc];
//
////            NSLog(@"TRAFFIC_ITEM_TYPE_DESC=%@, START_TIME=%@, END_TIME=%@", trafficItemTypeDesc, startTime, endTime);
//            
//
//
//            TrafficObjForWidget * obj = [[TrafficObjForWidget alloc]init ];
//            obj.mDirectionLocalDesc = directionLocalDesc;
//            obj.mTrafficItemTypeDesc = trafficItemTypeDesc;
//            obj.mStartTime = startTime;
//            obj.mEndTime = endTime;
//            obj.mPointDesc = pointDesc;
//            obj.mRoadwayDesc = roadwayDesc;
//            if(obj.mPointDesc== nil ) obj.mPointDesc = @"no roadway";
//            if(obj.mRoadwayDesc == nil) obj.mRoadwayDesc = @"no point";
//            NSLog(@"RoadwayDesc=%@ ,PointDesc = %@", obj.mRoadwayDesc, obj.mPointDesc);            
//            [mTrafficWidgetObjs addObject:obj];
//        }
//    }    
////    mAppObjIdx = 0;
////    mAppObj = [mAppObjs objectAtIndex:mAppObjIdx];  
    
    
}















-(void)readWeatherSettingsAndShow
{    
    NSLog(@"readWeatherSettingsAndShow");

    
    if(mParseHelper == nil ) mParseHelper = [[ParseHelper alloc] init];
    
    NSLog(@"readWeatherSettingsAndShow");        

    NSString * getXoapLocId;
    NSString * getXoapLocCityName;
    bool getIsSelectedC;
    
    SettingsManager *mgr = [SettingsManager sharedInstance];
    WeatherSettingManager * wMgr = mgr.mWeatherSettingManager;
    getIsSelectedC = wMgr.mIsSelectC;
    getXoapLocId = wMgr.mLocId;
    getXoapLocCityName = wMgr.mCurCityName;
    
    self.mIsSelectC = getIsSelectedC;
    self.mLocId = getXoapLocId;    
    self.mCurCityName = getXoapLocCityName; 

    NSString * newLocId = self.mCurCityName;
    newLocId = [mParseHelper extractValueByPattern:@"(.*?,.*?)(\\(|$)" inTxtStr:newLocId];    
    newLocId = [newLocId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:newLocId];
    newLocId = encodedNewLocId;

    
    NSString * metric = @"1";
    if( self.mIsSelectC) metric = @"0";
    
    NSString * rosenWeatherURL = [NSString stringWithFormat:@"http://rosenapp.com/api.class?action=weather&loc_id=%@&metric=%@", newLocId, metric];
    
    BOOL isWidgetDataUseItemInCoreData = NO;
    WeatherObj * wObj;
    
    if(wMgr.mItemsCount > 0 ) {
        isWidgetDataUseItemInCoreData = YES;
        int idx = wMgr.mSelectedItemIdx;
        if(idx > wMgr.mItemsCount || idx < 0)  {
            int idx =wMgr.mItemsCount - 1;
            wMgr.mSelectedItemIdx = idx;
        }

        CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];

        WeatherEntity* item = (WeatherEntity*)[theCoreDataHelper readItem:@"WeatherEntity" withIdx:idx];
        wObj = [[WeatherObj alloc] init];
        [wObj setValuesFromSettingDataOnEntity:item];
        [wObj setValuesFromRunningDataOnEntity:item];
        dispatch_async(dispatch_get_main_queue(),^{
            mTmpLbl.text = wObj.mCurTmp;
            mHiTmpLbl.text = wObj.mHighTmp;
            mLoTmpLbl.text = wObj.mLowTmp;
        });

        
        getIsSelectedC = wMgr.mIsSelectC;
        getXoapLocId = wMgr.mLocId;
        getXoapLocCityName = wMgr.mCurCityName;
        
        self.mIsSelectC = getIsSelectedC;
        self.mLocId = getXoapLocId;
        self.mCurCityName = getXoapLocCityName;
        
        
        
        NSString * newLocId = self.mCurCityName;
        newLocId = [mParseHelper extractValueByPattern:@"(.*?,.*?)(\\(|$)" inTxtStr:newLocId];
        newLocId = [newLocId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
        NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:newLocId];
        newLocId = encodedNewLocId;
        NSString * metric = @"1";
        if( self.mIsSelectC) metric = @"0";
        rosenWeatherURL = [NSString stringWithFormat:@"http://rosenapp.com/api.class?action=weather&loc_id=%@&metric=%@", newLocId, metric];
    }
    
    
    NSLog(@"rosenWeatherURL = %@", rosenWeatherURL);
    
    __block NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{

        NSString * curTmp;
        NSString * lowTmp;
        NSString * highTmp;
        NSString * iconNum;
        
        GlobalVars *vars = [GlobalVars sharedInstance];
        
        if(isWidgetDataUseItemInCoreData == YES) {
            NSDate * now = [NSDate date];
            int curTime = [now timeIntervalSince1970];
            if(curTime - wObj.mTimeInterval > 3600) {
//            if(curTime - wObj.mTimeInterval > 3600 && NO) {
                [wObj setValuesByDownloadRunningData];
                wObj.mTimeInterval = curTime;

                int idx = [SettingsManager sharedInstance].mWeatherSettingManager.mSelectedItemIdx;
                EditItemCallback callback = ^(NSManagedObject *theItem)
                {
                    WeatherEntity * item = (WeatherEntity*) theItem;
                    [WeatherObj copyValuesFromRunningDataOnObj:wObj ToEntity:item];
                    [WeatherObj copyValuesFromSettingDataOnObj:wObj ToEntity:item];
                    
                    item.mId = [NSNumber numberWithInt:idx];
                };
                
                NSString * entityName = @"WeatherEntity";
                CoreDataHelper * theCoreDataHelper = [CoreDataHelper sharedInstance];
                [theCoreDataHelper editItemAndSave:entityName withIdx:idx withBlock:callback];
                vars.mWeatherEVC.mIsNeedToResetWeatherData = YES;
            }
            curTmp = wObj.mCurTmp;
            lowTmp = wObj.mLowTmp;
            highTmp = wObj.mHighTmp;
            iconNum = wObj.mIcon;
            
        }
        else {
            
            
            NSString *xmlStrTmp = [self getXmlStringFromUrlStr:rosenWeatherURL];
            NSString *xmlStr = [self stringByRemovingNewLinesAndWhitespace:xmlStrTmp];
            
            NSString * nowStr = [mParseHelper extractValueBetweenBeginStr:@"<now " andEndStr:@"/>" inTxtStr:xmlStr];
            curTmp = [mParseHelper extractValueBetweenBeginStr:@"tmp=\"" andEndStr:@"\"" inTxtStr:nowStr];
            lowTmp = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:nowStr];
            highTmp = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:nowStr];
            iconNum = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:nowStr];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            mTmpLbl.text = @"";
            mHiTmpLbl.text = @"";
            mLoTmpLbl.text = @"";
            if(curTmp != nil) mTmpLbl.text = [NSString stringWithFormat:@"%@°", curTmp];
            if(highTmp != nil)mHiTmpLbl.text = [NSString stringWithFormat:@"%@°", highTmp];
            if(lowTmp != nil) mLoTmpLbl.text = [NSString stringWithFormat:@"%@°", lowTmp];
            mTodayWeatherImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", iconNum]];
        });
    }];
    
    [[NSOperationQueue sharedOperationQueue] addOperation:operation];

    
    
}







- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void) makeLocationServiceWorking
{
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






@end
