//
//  ViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize mRosenLbl;


-(IBAction)clickToLaunchSettings:(id)sender {
    GlobalVars * vars = [GlobalVars sharedInstance];
    [vars.interNav pushViewController:vars.mSettingsIVC animated:YES];
    [vars.exterNav pushViewController:vars.mSettingsEVC animated:YES];
}

-(IBAction)clickToAppsList:(id)sender {
    NSLog(@"clickToAppsList");
    
    [[[[iToast makeText:NSLocalizedString(@"Loading...", @"")] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
    
    GlobalVars * vars = [GlobalVars sharedInstance];
    [vars.interNav pushViewController:vars.mAppsListIVC animated:YES];
    [vars.exterNav pushViewController:vars.mAppsListEVC animated:YES];
}


-(IBAction)clickToLaunchWeather:(id)sender {
    NSLog(@"clickToLaunchWeather");    
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    [vars.interNav pushViewController:(UIViewController*)vars.mWeatherIVC animated:YES];
    [vars.exterNav pushViewController:(UIViewController*)vars.mWeatherEVC animated:YES];    
}

-(IBAction)clickToLaunchSpeedCamera:(id)sender {
    NSLog(@"clickToLaunchSpeedCamera");
    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.interNav pushViewController:(UIViewController*)vars.mSpeedCameraEVC animated:YES];    
    [vars.exterNav pushViewController:(UIViewController*)vars.mSpeedCameraEVC animated:YES];    
    
}

-(IBAction)clickToLaunchCarMediaCenter:(id)sender {
    NSLog(@"clickToLaunchCarMediaCenter");    
}
-(IBAction)clickToLaunchTraffic:(id)sender {
    NSLog(@"clickToLaunchTraffic");
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.exterNav pushViewController:(UIViewController*)vars.mTrafficEVC animated:YES];
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
    GlobalVars *vars = [GlobalVars sharedInstance];
//    vars.mAppDelegate.mRosenLbl.textColor = vars.mAppDelegate.viewController.mRosenLbl.textColor;
    
    self.navigationItem.backBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Home"] 
                                     style:UIBarButtonItemStyleBordered
                                    target: vars.mSettingsIVC
                                    action: @selector(clickToBack:)
     ];
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
//    vars.mAppDelegate.mRosenLbl.hidden = YES;
//    vars.mSpeedCameraIVC.mRosenLbl.hidden = YES;
//    vars.mAppDelegate.viewController.mRosenLbl.hidden = NO;

    //add for dirty

    vars.mAppDelegate.mPVC.view.hidden= NO;
    vars.interNav.navigationBarHidden = YES;    
}

- (void)viewWillDisappear:(BOOL)animated
{
    GlobalVars *vars = [GlobalVars sharedInstance];
    vars.interNav.navigationBarHidden = NO;
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

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll; // use what is appropriate for you.
}



@end
