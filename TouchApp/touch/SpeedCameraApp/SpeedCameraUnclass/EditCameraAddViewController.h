//
//  ViewController.h
//  helloworld.testCustomDialog
//
//  Created by Milo Chen on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class ComboBox;
@interface EditCameraAddViewController : UIViewController <UIAlertViewDelegate> 
{
    ComboBox * mSpeedComboBox;
    ComboBox * mTypeComboBox;
    ComboBox * mDirTypeComboBox;
    ComboBox * mDirectionComboBox;

    UIView * mSpeedComboBoxView;
    UIView * mTypeComboBoxView;
    UIView * mDirTypeComboBoxView;
    UIView * mDirectionComboBoxView;
    
    NSString *mCurLngStr;
    NSString *mCurLatStr;
    NSString *mCurHeading;
    NSString *mApiKey;
    
    NSMutableArray * mTypeArray;
    NSMutableArray * mDirTypeArray;
    NSMutableArray * mDirectionArray;
    
    UISegmentedControl * mTypeSeg;
    UISegmentedControl * mDirTypeSeg;
    UISegmentedControl * mDirectionSeg;    
    UISegmentedControl * mSpeedSeg;
}


@property (nonatomic,strong) IBOutlet UISegmentedControl * mTypeSeg;
@property (nonatomic,strong) IBOutlet UISegmentedControl * mDirTypeSeg;
@property (nonatomic,strong) IBOutlet UISegmentedControl * mDirectionSeg;
@property (nonatomic,strong) IBOutlet UISegmentedControl * mSpeedSeg;


@property (nonatomic,strong) NSMutableArray * mTypeArray;
@property (nonatomic,strong) NSMutableArray * mDirTypeArray;
@property (nonatomic,strong) NSMutableArray * mDirectionArray;

@property (nonatomic,strong) NSString *mCurLngStr;
@property (nonatomic,strong) NSString *mCurLatStr;
@property (nonatomic,strong) NSString *mCurHeading;
@property (nonatomic,strong) NSString *mApiKey;

@property (nonatomic,weak) AppDelegate *mAppDelegate;
@property (nonatomic,strong) IBOutlet UIView * mSpeedComboBoxView;
@property (nonatomic,strong) IBOutlet UIView * mTypeComboBoxView;
@property (nonatomic,strong) IBOutlet UIView * mDirTypeComboBoxView;
@property (nonatomic,strong) IBOutlet UIView * mDirectionComboBoxView;

@property (nonatomic,strong) ComboBox * mSpeedComboBox;
@property (nonatomic,strong) ComboBox * mTypeComboBox;
@property (nonatomic,strong) ComboBox * mDirTypeComboBox;
@property (nonatomic,strong) ComboBox * mDirectionComboBox;

-(IBAction)clickToCancelEdit :(id)sender;
-(IBAction)clickToSubmitEdit :(id)sender;
-(IBAction)clickToOpenComboBox:(id)sender;
-(IBAction)clickToBack:(id)sender;
-(NSString*) makeUrlFromEditSettingWithLng:(NSString*)lngStr andLat:(NSString*)latStr withApiKey:(NSString*)apiKey; 

@end
