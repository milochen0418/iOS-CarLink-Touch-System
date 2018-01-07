//
//  UINavigationController+ExternalDisplay.m
//  touch
//
//  Created by Milo Chen on 11/21/12.
//
//

#import "UINavigationController+ExternalDisplay.h"
#import "AppDelegate.h"
@implementation UINavigationController (ExternalDisplay)
-(void)pushExterViewController:(UIViewController*)evc animated:(BOOL)isAnimated
{
    [self pushViewController:evc animated:isAnimated];
    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate ;
    [dele notifyExterNavAnimatedStatus:YES];
    [self performSelector:@selector(delayToSetAnimatedStatusLow:) withObject:nil afterDelay:0.75];
}


-(IBAction)delayToSetAnimatedStatusLow:(id)sender
{
    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate ;
    [dele notifyExterNavAnimatedStatus:NO];
}

-(void) popExterViewControllerAnimated:(BOOL)isAnimated {
    [self popViewControllerAnimated:isAnimated];
    AppDelegate * dele = (AppDelegate*)[UIApplication sharedApplication].delegate ;
    [dele notifyExterNavAnimatedStatus:YES];
    [self performSelector:@selector(delayToSetAnimatedStatusLow:) withObject:nil afterDelay:0.75];
}
@end
