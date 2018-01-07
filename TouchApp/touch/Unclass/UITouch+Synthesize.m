//
//  UITouch+Synthesize.m
//  helloworld
//
//  Created by Milo Chen on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITouch+Synthesize.h"

@interface UITouch () {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
    // ivars declarations removed in 6.0
    NSTimeInterval  _timestamp;
    UITouchPhase    _phase;
    UITouchPhase    _savedPhase;
    NSUInteger      _tapCount;
    
    UIWindow        *_window;
    UIView          *_view;
    UIView          *_gestureView;
    UIView          *_warpedIntoView;
    NSMutableArray  *_gestureRecognizers;
    NSMutableArray  *_forwardingRecord;
    
    CGPoint         _locationInWindow;
    CGPoint         _previousLocationInWindow;
    UInt8           _pathIndex;
    UInt8           _pathIdentity;
    float           _pathMajorRadius;
    struct {
        unsigned int _firstTouchForView:1;
        unsigned int _isTap:1;
        unsigned int _isDelayed:1;
        unsigned int _sentTouchesEnded:1;
        unsigned int _abandonForwardingRecord:1;
    } _touchFlags;
#endif
}
@end

@implementation UITouch (Synthesize)

- (id)initInView:(UIView *)view
{
    self = [super init];
    if (self != nil)
    {
        CGRect frameInWindow;
        if ([view isKindOfClass:[UIWindow class]])
        {
            frameInWindow = view.frame;
        }
        else
        {
            frameInWindow =
            [view.window convertRect:view.frame fromView:view.superview];
        }
        
        _tapCount = 1;
        NSLog(@"x=%g, y=%g, w=%g, h=%g", frameInWindow.origin.x, frameInWindow.origin.y, frameInWindow.size.width, frameInWindow.size.height);
        
        _locationInWindow =
        CGPointMake(
                    frameInWindow.origin.x + 0.8 * frameInWindow.size.width,
                    frameInWindow.origin.y + 0.8 * frameInWindow.size.height);
        _previousLocationInWindow = _locationInWindow;
        
        UIView *target = [view.window hitTest:_locationInWindow withEvent:nil];
//        _view = [target retain];
//        _window = [view.window retain];
        _view = target;
        _window = view.window;
        
        _phase = UITouchPhaseBegan;
        _touchFlags._firstTouchForView = 1;
        _touchFlags._isTap = 1;
        _timestamp = [NSDate timeIntervalSinceReferenceDate];
    }
    return self;
}


- (id)initInVC:(UIViewController*)vc withX:(double)posX andY:(double)posY;
{
    UIView *view = vc.view;
    
    self = [super init];
    if (self != nil)
    {
        CGRect frameInWindow;
        if ([view isKindOfClass:[UIWindow class]])
        {
            frameInWindow = view.frame;
        }
        else
        {
            frameInWindow =
            [view.window convertRect:view.frame fromView:view.superview];
        }
        
        _tapCount = 1;
        NSLog(@"x=%g, y=%g, w=%g, h=%g", frameInWindow.origin.x, frameInWindow.origin.y, frameInWindow.size.width, frameInWindow.size.height);
        
        _locationInWindow =
//        CGPointMake(
//                    frameInWindow.origin.x + 0.8 * frameInWindow.size.width,
//                    frameInWindow.origin.y + 0.8 * frameInWindow.size.height);
        
        CGPointMake(
                    frameInWindow.origin.x + posX,
                    frameInWindow.origin.y + posY);
        
        
        _previousLocationInWindow = _locationInWindow;
        
        UIView *target = [view.window hitTest:_locationInWindow withEvent:nil];
        //        _view = [target retain];
        //        _window = [view.window retain];
        _view = target;
        _window = view.window;
        
        
        _phase = UITouchPhaseBegan;
        _touchFlags._firstTouchForView = 1;
        _touchFlags._isTap = 1;
        _timestamp = [NSDate timeIntervalSinceReferenceDate];
    }
    return self;
}





- (void)changeToPhase:(UITouchPhase)phase
{
    _phase = phase;
    _timestamp = [NSDate timeIntervalSinceReferenceDate];
}


- (void)setPhase:(UITouchPhase)phase
{
    _phase = phase;
    _timestamp = [NSDate timeIntervalSinceReferenceDate];
}


@end
