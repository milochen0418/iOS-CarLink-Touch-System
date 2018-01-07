//
//  UIEvent+Synthesize.m
//  helloworld
//
//  Created by Milo Chen on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIEvent+Synthesize.h"
#import "GSEventProxy.h"

@implementation UIEvent (Synthesize)
- (id)initWithTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:touch.window];
    GSEventProxy *gsEventProxy = [[GSEventProxy alloc] init];
    int offset = 100;
    gsEventProxy->x1 = location.x+offset;
    gsEventProxy->y1 = location.y+offset;
    gsEventProxy->x2 = location.x+offset;
    gsEventProxy->y2 = location.y+offset;
    gsEventProxy->x3 = location.x+offset;
    gsEventProxy->y3 = location.y+offset;
    gsEventProxy->sizeX = 1.0;
    gsEventProxy->sizeY = 1.0;
    gsEventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
    gsEventProxy->type = 3001;    
    
    //
    // On SDK versions 3.0 and greater, we need to reallocate as a
    // UITouchesEvent.
    //
//    Class touchesEventClass = objc_getClass("UITouchesEvent");
    Class touchesEventClass = objc_getClass("UITouchesEvent");
    if (touchesEventClass && ![[self class] isEqual:touchesEventClass])
    {
//        [self release];
        self = [touchesEventClass alloc];
    }
    
    self = [self _initWithEvent:gsEventProxy touches:[NSSet setWithObject:touch]];
    if (self != nil)
    {
    }
    return self;
}
@end
