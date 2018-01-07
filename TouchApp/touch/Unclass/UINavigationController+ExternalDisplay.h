//
//  UINavigationController+ExternalDisplay.h
//  touch
//
//  Created by Milo Chen on 11/21/12.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ExternalDisplay)
-(void)pushExterViewController:(UIViewController*)evc animated:(BOOL)isAnimated ;
-(void)popExterViewControllerAnimated:(BOOL)isAnimated ;

-(IBAction)delayToSetAnimatedStatusLow:(id)sender;
@end
