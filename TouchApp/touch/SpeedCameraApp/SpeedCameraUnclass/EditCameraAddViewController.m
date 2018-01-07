//
//  ViewController.m
//  helloworld.testCustomDialog
//
//  Created by Milo Chen on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditCameraAddViewController.h"
#import "GlobalVars.h"

@interface EditCameraAddViewController ()

@end


@implementation EditCameraAddViewController
@synthesize mAppDelegate;
@synthesize mTypeComboBoxView,mSpeedComboBoxView,mDirectionComboBoxView,mDirTypeComboBoxView;
@synthesize mSpeedComboBox,mTypeComboBox,mDirectionComboBox,mDirTypeComboBox;
@synthesize mApiKey,mCurLatStr,mCurLngStr,mCurHeading;


@synthesize mDirectionSeg,mDirTypeSeg,mTypeSeg,mSpeedSeg;
@synthesize mDirectionArray,mDirTypeArray,mTypeArray;


-(IBAction)clickToCancelEdit:(id)sender {
    NSLog(@"clickToCancelEdit");
    
    [mSpeedComboBox cancelPicker];
    [mTypeComboBox cancelPicker];
    [mDirTypeComboBox cancelPicker];
    [mDirectionComboBox cancelPicker];
    
    GlobalVars *vars = [GlobalVars sharedInstance];
    
//    [vars.interNav popViewControllerAnimated:YES];
    
    
    if(self == [vars.interNav topViewController]) {
        [vars.interNav popViewControllerAnimated:YES];  
    }
    else 
    {
        [vars.exterNav popExterViewControllerAnimated:YES];
    }    
}

-(IBAction)clickToSubmitEdit:(id)sender {
    
    NSLog(@"clickToSubmitEdit");
    
    [mSpeedComboBox cancelPicker];
    [mTypeComboBox cancelPicker];
    [mDirTypeComboBox cancelPicker];
    [mDirectionComboBox cancelPicker];
    
    
    NSString * urlStr = @"";
    NSString* keyApi =@"c934f220074cbc9ad267ad6b813dd203";    
    NSString * latStr = @"11.001001";
    NSString * lngStr = @"-11.002032";
    latStr = self.mCurLatStr;
    lngStr = self.mCurLngStr;
    
//    urlStr = [self makeUrlFromEditSettingWithLng:@"11.001001" andLat:@"-11.002032" withApiKey:keyApi];
    urlStr = [self makeUrlFromEditSettingWithLng:lngStr andLat:latStr withApiKey:keyApi];
    
    NSLog(@"urlStr = %@", urlStr);
    GlobalVars *vars = [GlobalVars sharedInstance];

    if(self == [vars.interNav topViewController]) {
    
        [vars.interNav popViewControllerAnimated:YES];  
    }
    else 
    {
        [vars.exterNav popExterViewControllerAnimated:YES];
    }
//    [vars.interNav popViewControllerAnimated:YES];

    
    
    //[vars.mIVC addCameraInComplicatedInFinalProcessWithUrl:urlStr];
    [vars.mSpeedCameraEVC addCameraInComplicatedInFinalProcessWithUrl:urlStr];
}

-(NSString*) makeUrlFromEditSettingWithLng:(NSString*)lngStr andLat:(NSString*)latStr withApiKey:(NSString*)apiKey; 

{
//    int typeVal = [mTypeComboBox getSelectedIdx]+1;
    int typeVal = mTypeSeg.selectedSegmentIndex+1;
    //int dirTypeVal = [mDirTypeComboBox getSelectedIdx];
    int dirTypeVal = mDirTypeSeg.selectedSegmentIndex;
//    int directionVal = [mDirectionComboBox getSelectedIdx]*45;
    int directionVal = mDirectionSeg.selectedSegmentIndex * 45;
    
//    int speedVal = [mSpeedComboBox getSelectedIdx];
    int speedVal = 30+ mSpeedSeg.selectedSegmentIndex * 10;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://speedcamerapoi.com/api.class?key=%@&action=add&lat=%@&lng=%@&type=%d&speed=%d&kmph=1&dirtype=%d&dir=%d&country=US&uname=anonymous",apiKey,latStr,lngStr,typeVal,speedVal,dirTypeVal,directionVal];
    return urlStr;
}

-(IBAction)clickToOpenComboBox:(id)sender {
//    mTypeComboBox 

//    [mTypeComboBox performSelector:@selector(showPicker:) withObject:nil];

// - (IBAction)showPicker:(id)sender {   
    [mTypeComboBox performShowPicker];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    NSMutableArray * tmpArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    
    mSpeedComboBox = [[ComboBox alloc]init];
    mTypeComboBox = [[ComboBox alloc]init];
    mDirTypeComboBox = [[ComboBox alloc]init];
    mDirectionComboBox = [[ComboBox alloc]init];
    
    GlobalVars * vars = [GlobalVars sharedInstance];
    if([vars.exterNav topViewController] == self) {
        mSpeedComboBox.mIsSupportExternalView = YES;
        mTypeComboBox.mIsSupportExternalView = YES;
        mDirTypeComboBox.mIsSupportExternalView = YES;
        mDirectionComboBox.mIsSupportExternalView = YES;
    }
        
    [mSpeedComboBox setContainer:mSpeedComboBoxView withComboData:tmpArray andDefaultSelectedIdx:0];
    [mTypeComboBox setContainer:mTypeComboBoxView withComboData:tmpArray andDefaultSelectedIdx:1];
    [mDirTypeComboBox setContainer:mDirTypeComboBoxView withComboData:tmpArray andDefaultSelectedIdx:2];    
    [mDirectionComboBox setContainer:mDirectionComboBoxView withComboData:tmpArray andDefaultSelectedIdx:3]; 


    
//    NSMutableArray * typeArray = [NSMutableArray arrayWithObjects:
//                                  @"Fixed Speed Camera",  //set 1 to network , default 1
//                                  @"Combined Redlight+Fixed speed camera",  //set 2 to network
//                                  @"Redlight camera", //set idx+1 to network
//                                  @"Average speed camera", //...
//                                  @"Mobile radar/speedtrap", //set idx+1 to network
//                                  nil]; //need send idx+1 to network
    
    NSMutableArray * typeArray = [NSMutableArray arrayWithObjects:
                                  @"Fixed Speed Camera",
                                  @"Combined Speed + Redlight Camera",
                                  @"Redlight Camera",
                                  @"Average Speed Camera",
                                  @"Mobile/SpeedTrap/Radar",
                                  @"SchoolZone"
                                  ,nil]; //need send idx+1 to network
    
    self.mTypeArray = typeArray;

    
    
    NSMutableArray * dirTypeArray = [NSMutableArray arrayWithObjects:
                                  @"All Direction 360",  //default 0 , set 0 to network
                                  @"One Direction",  // set 1 to network
                                  @"Dual Direction", // set 2 to network
                                     nil];//need send idx to network
    self.mDirectionArray = dirTypeArray;
    
                            
   //东E east 西W west 南S south 北N north    
    NSMutableArray * directionArray = [NSMutableArray arrayWithObjects:
        @"N",
        @"NE",
        @"E",
        @"SE",
        @"S",
        @"SW",
        @"W", 
        @"NW",
        nil];
    self.mDirectionArray = directionArray;
    
    
    
    int directionArrayDefaultIdx = 0;
    NSString * headingStr = self.mCurHeading;
//    NSString * dirStr = @"N";
    double headingVal = [headingStr doubleValue];
    int headingInt = (int)headingVal;
    headingInt = (int)((headingInt + 360 ) % 360);
    if(headingInt >= 360-22 || headingInt < 0+23 ) directionArrayDefaultIdx=0;
    if(headingInt >= 0+23 || headingInt < 45+23 ) directionArrayDefaultIdx=1;
    if(headingInt >= 45+23 || headingInt < 90+23) directionArrayDefaultIdx=2;
    if(headingInt >= 90+23 || headingInt < 135+23) directionArrayDefaultIdx=3;
    if(headingInt >= 135+23 || headingInt < 180+23) directionArrayDefaultIdx=4;
    if(headingInt >= 180+23 || headingInt < 225+23) directionArrayDefaultIdx=5;
    if(headingInt >= 225+23 || headingInt < 270+23) directionArrayDefaultIdx=6;
    if(headingInt >= 270+23 || headingInt < 315+23) directionArrayDefaultIdx=7;
    
    
    
    //need to send 45*idx to network
    
    NSMutableArray * speedArray = [NSMutableArray arrayWithCapacity:1];
    int idx;
    for(idx =0;idx<121;idx++) {
        [speedArray addObject:[NSString stringWithFormat:@"%d km/h",idx]];
    } //need send idx to network
    
    [mSpeedComboBox changeComboData:speedArray withDefaultSelectedIdx:0];
    [mTypeComboBox changeComboData:typeArray withDefaultSelectedIdx:0];
    [mDirTypeComboBox changeComboData:dirTypeArray withDefaultSelectedIdx:0];
//    [mDirectionComboBox changeComboData:directionArray withDefaultSelectedIdx:0];
    
    [mDirectionComboBox changeComboData:directionArray withDefaultSelectedIdx:directionArrayDefaultIdx];
    
    mSpeedSeg.selectedSegmentIndex = 0;
    mTypeSeg.selectedSegmentIndex = 0;
    mDirTypeSeg.selectedSegmentIndex = 0;
    mDirectionSeg.selectedSegmentIndex = directionArrayDefaultIdx;
//

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) return NO;
    return YES;
}


@end
