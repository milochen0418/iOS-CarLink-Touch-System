//
//  UITouch+Synthesize.h
//  helloworld
//
//  Created by Milo Chen on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITouch (Synthesize)
- (id)initInVC:(UIViewController*)vc withX:(double)posX andY:(double)posY;
- (id)initInView:(UIView *)view;
- (void)changeToPhase:(UITouchPhase)phase;
- (void)setPhase:(UITouchPhase)phase;
@end
