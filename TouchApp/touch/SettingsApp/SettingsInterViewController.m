//
//  ViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsInterViewController.h"
#import "GlobalVars.h"
#import "ActionTable.h"
@implementation SettingsInterViewController
@synthesize mRosenLbl;
@synthesize mDbgTextView;
@synthesize mTableView,mActTbl;
@synthesize mDontLeaveExternalView;

-(IBAction) clickToSetWeather:(id)sender {
    NSLog(@"clickToSetWeather");
    GlobalVars *vars = [GlobalVars sharedInstance];
//    [vars.interNav pushViewController:vars.mWeatherSettingsIVC animated:YES];
    [vars.interNav pushViewController:vars.mWeatherSettingsListIVC animated:YES];
}


-(IBAction) clickToSetSpeedCamera:(id)sender {
    NSLog(@"clickToSetSpeedCamera");
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav pushViewController:vars.mSpeedCameraSettingsIVC animated:YES];
}

-(IBAction) clickToSetMedia:(id)sender {
    NSLog(@"clickToSetMedia");
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav pushViewController:vars.mMediaSettingsIVC animated:YES];
}


-(IBAction) clickToSetTraffic:(id)sender {
    NSLog(@"clickToSetTraffic");
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav pushViewController:vars.mTrafficSettingsIVC animated:YES];
}


-(IBAction) clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav popViewControllerAnimated:YES];
    [vars.interNav popViewControllerAnimated:YES];
    [vars.exterNav popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(IBAction)clickTableCell:(id)sender {
    NSIndexPath * path = mActTbl.mDidSelectedIndexPath;
    int idx = path.row;
    mDontLeaveExternalView = YES;
    switch(idx) 
    {
    case 0:
            [self performSelector:@selector(clickToSetWeather:) withObject:nil];
        break;
    case 1:
            [self performSelector:@selector(clickToSetSpeedCamera:) withObject:nil];                        
        break;
//    case 2:
//            [self performSelector:@selector(clickToSetMedia:) withObject:nil];                         
//        break;
//    case 3:
        case 2:
            [self performSelector:@selector(clickToSetTraffic:) withObject:nil];                        
        break;
    default:
            mDontLeaveExternalView = NO;
        break;
    }
}


-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    GlobalVars * vars = [GlobalVars sharedInstance];
    if([vars.exterNav topViewController] == vars.mSettingsEVC && mDontLeaveExternalView == NO) {
        [vars.exterNav popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSMutableArray * mTableTexts = [NSMutableArray arrayWithObjects:@"Set Weather",@"Set SpeedCamera",@"Set Media",@"Set Traffic", nil];
    NSMutableArray * mTableTexts = [NSMutableArray arrayWithObjects:@"Set Weather",@"Set SpeedCamera",@"Set Traffic", nil];
    
    
    int idx;
    NSMutableArray * selStrs = [NSMutableArray arrayWithCapacity:1];
    SEL sele = @selector(clickTableCell:);
    for (idx = 0 ; idx < [mTableTexts count];idx++ ) 
    {
        [selStrs addObject:NSStringFromSelector(sele)];
    }
    
    mActTbl = [[ActionTable alloc]initWithPerformer:self andTable:mTableView andTextArray:mTableTexts andSelStrArray:selStrs];
    
    NSString* navTitle = @"Settings";        
    self.navigationItem.backBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Settings"] 
                                     style:UIBarButtonItemStyleBordered
                                    target: self
                                    action: @selector(clickToSetWeather:)
     ];
    
    navTitle = [NSString stringWithFormat:@"Settings"];
    self.navigationItem.title = navTitle;

    

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
//    GlobalVars *vars = [GlobalVars sharedInstance];
    mDontLeaveExternalView = NO;
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//	[super viewWillDisappear:animated];
//}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation  != UIInterfaceOrientationPortrait && interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) 
    {
        return NO;
    }    
    return YES;
}



@end

