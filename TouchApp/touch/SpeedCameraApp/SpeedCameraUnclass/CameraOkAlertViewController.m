//
//  ViewController.m
//  helloworld.testCustomDialog
//
//  Created by Milo Chen on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CameraOkAlertViewController.h"
#import "GlobalVars.h"

@interface CameraOkAlertViewController ()

@end


@implementation CameraOkAlertViewController

@synthesize mTitleLbl,mMessageTextView;

-(IBAction) clickToOk:(id)sender
{
    GlobalVars * vars = [GlobalVars sharedInstance];
    [MTPopupWindow closePopupWindow];
//    [vars.mSpeedCameraEVC clickToCancelAdd:nil];
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
