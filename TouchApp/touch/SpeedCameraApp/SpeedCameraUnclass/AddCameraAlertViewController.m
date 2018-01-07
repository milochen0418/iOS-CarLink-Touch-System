//
//  ViewController.m
//  helloworld.testCustomDialog
//
//  Created by Milo Chen on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCameraAlertViewController.h"
#import "GlobalVars.h"

@interface AddCameraAlertViewController ()

@end


@implementation AddCameraAlertViewController

-(IBAction) clickToCancel:(id)sender {
    GlobalVars * vars = [GlobalVars sharedInstance];
    [MTPopupWindow closePopupWindow];
    [vars.mSpeedCameraEVC clickToCancelAdd:nil];
}

-(IBAction) clickToSubmit:(id)sender {
    GlobalVars * vars = [GlobalVars sharedInstance];
    [MTPopupWindow closePopupWindow];
    [vars.mSpeedCameraEVC clickToSubmitAdd:nil];
}

-(IBAction) clickToEdit:(id)sender {
    GlobalVars * vars = [GlobalVars sharedInstance];
    [MTPopupWindow closePopupWindow];
    [vars.mSpeedCameraEVC clickToEditAdd:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
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
