//
//  ViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVars.h"

@interface ViewController:UIViewController
{
    UILabel *mRosenLbl;
}
@property (nonatomic,strong) IBOutlet UILabel * mRosenLbl;


-(IBAction)clickToLaunchWeather:(id)sender;
-(IBAction)clickToLaunchSpeedCamera:(id)sender;
-(IBAction)clickToLaunchCarMediaCenter:(id)sender;
-(IBAction)clickToLaunchTraffic:(id)sender;
-(IBAction)clickToAppsList:(id)sender;
-(IBAction)clickToLaunchSettings:(id)sender;


@end
