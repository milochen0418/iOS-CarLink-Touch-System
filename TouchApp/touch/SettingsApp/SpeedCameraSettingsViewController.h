//
//  ViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComboBoxDelegate.h"

@class ComboBox;

@interface SpeedCameraSettingsViewController:UIViewController<UITextFieldDelegate, ComboBoxDelegate>
{
    UILabel *mRosenLbl;
    UITextView * mDbgTextView;

}
-(IBAction)sliderToChangeSpeedDetectRate:(id)sender ;
-(IBAction) clickToMarkerFilterModeChange:(id)sender ;
-(IBAction) switchAudiableWarning:(id)sender;
-(IBAction) switchVisualWarning:(id)sender;

@property (nonatomic,strong) IBOutlet UILabel * mRateLbl;

-(IBAction) clickToBack:(id)sender;
@property (nonatomic,strong) IBOutlet UILabel *mRosenLbl;
@property (nonatomic,strong) IBOutlet UITextView * mDbgTextView;

@property (nonatomic,strong) IBOutlet UISegmentedControl * mDownloadDataOfCountrySeg;
-(IBAction) clickToSelectDownloadCountryData:(id)sender;

@end
