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

@interface MediaSettingsViewController:UIViewController<UITextFieldDelegate, ComboBoxDelegate>
{
    UITextView * mDbgTextView;
}


-(IBAction) clickToBack:(id)sender;
@property (nonatomic,strong) IBOutlet UITextView * mDbgTextView;

@end
