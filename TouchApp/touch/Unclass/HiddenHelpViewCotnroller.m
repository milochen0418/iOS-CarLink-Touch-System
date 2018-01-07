//
//  PanelViewCotnroller.m
//  helloworld
//
//  Created by Milo Chen on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HiddenHelpViewCotnroller.h"
#import "GlobalVars.h"

@implementation HiddenHelpViewCotnroller

@synthesize mAlphaSlider;

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
    [self initDefaultValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) initDefaultValue 
{
    self.mAlphaSlider.value = 0.8f;
    self.view.alpha = 0.8f;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction) clickToShowPanelView :(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@"^^<"];
}
-(IBAction) clickToHidePanelView :(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@"^^>"];
}
-(IBAction) clickToShowLogPanel :(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@"^^^<"];    
}
-(IBAction) clickToHideLogPanel :(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@"^^^>"];
}
-(IBAction) clickToShowHiddenHelp :(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@"^<"];
    
}
-(IBAction) clickToHideHiddenHelp :(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@"^>"];    
}
-(IBAction) clickToHideAll:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@">"];        
}

-(IBAction) clickToShowDefault:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.mAppDelegate hiddenTouchCommand:@"<"];
}

-(IBAction) changeHiddenHelpViewAlpha:(id)sender {
    UISlider *slider = (UISlider*)sender;
    float value = slider.value;
    if(value <= 0.025f) value = 0.025f;
    if(value >= 1.0f) value= 1.0f;
    self.view.alpha = value;
    
}



@end
