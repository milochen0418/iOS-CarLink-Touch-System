//
//  ViewController.h
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GlobalVars.h"

#import "AppObject.h"

@interface AppInstallationInterViewController:UIViewController
{
//    UILabel *mRosenLbl;
 
    UILabel *mAppNameLbl;
    UIImageView * mAppIconImgView;
 
    UITextView * mAppDescTextView;
    AppObject *mAppObj;
 
    UIButton * mInstallItBtn;
 
}
@property (nonatomic,strong) IBOutlet UIButton * mInstallItBtn;
@property (nonatomic,strong) IBOutlet UITextView *mAppDescTextView;

@property (nonatomic) int mAppObjIdx;
@property (nonatomic,strong) AppObject * mAppObj;
@property (nonatomic,strong) IBOutlet UIImageView * mAppIconImgView;
@property (nonatomic,strong) IBOutlet UILabel * mAppNameLbl;
//@property (nonatomic,strong) IBOutlet UILabel *mRosenLbl;


-(IBAction)performLoadAppInfo:(id)sender;

@end
