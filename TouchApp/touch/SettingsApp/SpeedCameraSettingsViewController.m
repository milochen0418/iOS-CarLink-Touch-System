//
//  ViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeedCameraSettingsViewController.h"
#import "GlobalVars.h"
#import "ComboBoxDelegate.h"
@implementation SpeedCameraSettingsViewController
@synthesize mRosenLbl;
@synthesize mDbgTextView;
@synthesize mDownloadDataOfCountrySeg;
@synthesize mRateLbl;

-(IBAction) switchAudiableWarning:(id)sender {
    UISwitch *sth = (UISwitch*)sender;
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mSpeedCameraEVC.mIsAudiableWarning = sth.on;

    
}
-(IBAction) switchVisualWarning:(id)sender {
    UISwitch *sth = (UISwitch*)sender;
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mSpeedCameraEVC.mIsVisualWarning = sth.on;
}

-(IBAction) clickToMarkerFilterModeChange:(id)sender {
    NSLog(@"clickToMarkerFilterModeChange");
    //    switch(self.mIsFreewayModeOn
    GlobalVars *vars  =[GlobalVars sharedInstance];
    UISegmentedControl * seg = (UISegmentedControl*) sender;
    vars.mSpeedCameraEVC.mMarkerFilterModeSeg.selectedSegmentIndex = seg.selectedSegmentIndex ;
    [vars.mSpeedCameraEVC clickToMarkerFilterModeChange:nil];
    
//    switch(self.mMarkerFilterModeSeg.selectedSegmentIndex) {
//        case 0://s street mode
//            self.mIsFreewayModeOn = NO;
//            NSLog(@"mIsFreewayModeOn = NO");
//            break;
//        case 1://f freeway mode
//            self.mIsFreewayModeOn = YES;
//            NSLog(@"mIsFreewayModeOn = YES");
//            break;
//    }
//    
//    [self performSelector:@selector(clickToParseMarkers:) withObject:nil];
    
}

-(IBAction)sliderToChangeSpeedDetectRate:(id)sender {
    NSLog(@"sliderToChangeSpeedDetectRate");
    GlobalVars *vars = [GlobalVars sharedInstance];
    UISlider * slider = (UISlider*) sender;
    CGFloat val = [slider value];
    vars.mSpeedCameraEVC.mSpeedDetectRate = (double)(1.0f + val * 0.3f);
    //mSpeedDetectRate = (double)(1.0f + val * 0.3f);
    NSLog(@"vars.mSpeedCameraEVC.mSpeedDetectRate = %g", vars.mSpeedCameraEVC.mSpeedDetectRate);
    mRateLbl.text = [NSString stringWithFormat:@"%d%%", (int)((vars.mSpeedCameraEVC.mSpeedDetectRate+0.005f)*100)];
    
}



-(IBAction) clickToSelectDownloadCountryData:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    NSLog(@"clickToSelectDownloadCountryData");
    switch(self.mDownloadDataOfCountrySeg.selectedSegmentIndex)
    {
        case 0: //US seelect country as USA
            vars.mSpeedCameraEVC.mIsDownloadCountryTW = NO;
            vars.mSpeedCameraEVC.mIsNeedToDownloadLastestLocalData = YES;
            break;
        case 1: //TW select country as Taiwan
            vars.mSpeedCameraEVC.mIsDownloadCountryTW = YES;
            vars.mSpeedCameraEVC.mIsNeedToDownloadLastestLocalData = YES;
            break;
        case 2: //UK select country as English
            break;
        case 3: //CA select country as Canada
            break;
    }
}


-(IBAction) clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav popViewControllerAnimated:YES];
//    [vars.exterNav popViewControllerAnimated:YES];    
    
}



- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
	[aTextField resignFirstResponder];
 	return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Set SpeedCamera";
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.mAppDelegate.mRosenLbl.hidden = YES;
    self.mRosenLbl.hidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
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



@end
