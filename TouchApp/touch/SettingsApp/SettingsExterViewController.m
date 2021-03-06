//
//  ExterViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsExterViewController.h"
#import "GlobalVars.h"
@implementation SettingsExterViewController


-(IBAction)clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    if([vars.interNav topViewController] == vars.mSettingsIVC) 
    {
        [vars.interNav popViewControllerAnimated:YES];
        [vars.exterNav popViewControllerAnimated:YES];
    } 
    else if ([vars.interNav topViewController] == vars.mSpeedCameraSettingsIVC ) 
    {
        [vars.interNav popViewControllerAnimated:YES];        
    } 
    else if ([vars.interNav topViewController] == vars.mMediaSettingsIVC ) 
    {
        [vars.interNav popViewControllerAnimated:YES];        
    }
    else if ([vars.interNav topViewController] == vars.mTrafficSettingsIVC ) 
    {
        [vars.interNav popViewControllerAnimated:YES];        
    }
    else if ([vars.interNav topViewController] == vars.mWeatherSettingsIVC ) 
    {
        [vars.interNav popViewControllerAnimated:YES];        
    }
    
    
}
-(SettingsExterViewController*) init {
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
