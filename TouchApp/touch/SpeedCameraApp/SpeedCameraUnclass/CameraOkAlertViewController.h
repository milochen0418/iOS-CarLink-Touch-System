//
//  ViewController.h
//  helloworld.testCustomDialog
//
//  Created by Milo Chen on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface CameraOkAlertViewController : UIViewController 
{
}

@property (nonatomic,strong) IBOutlet UILabel * mTitleLbl;
@property (nonatomic,strong) IBOutlet UITextView * mMessageTextView;

-(IBAction) clickToOk:(id)sender;



@end
