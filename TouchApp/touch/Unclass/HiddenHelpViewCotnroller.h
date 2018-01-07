//
//  PanelViewCotnroller.h
//  helloworld
//
//  Created by Milo Chen on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface HiddenHelpViewCotnroller : UIViewController
{
    UISlider *mAlphaSlider;
    
}
@property (nonatomic,strong) IBOutlet UISlider *mAlphaSlider;
-(void) initDefaultValue;
-(IBAction) clickToShowPanelView :(id)sender;
-(IBAction) clickToHidePanelView :(id)sender;
-(IBAction) clickToShowLogPanel :(id)sender;
-(IBAction) clickToHideLogPanel :(id)sender;
-(IBAction) clickToShowHiddenHelp :(id)sender;
-(IBAction) clickToHideHiddenHelp :(id)sender;
-(IBAction) clickToHideAll:(id)sender;
-(IBAction) clickToShowDefault:(id)sender;
-(IBAction) changeHiddenHelpViewAlpha:(id)sender;


@end
