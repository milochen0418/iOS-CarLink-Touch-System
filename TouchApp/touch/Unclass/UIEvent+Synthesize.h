//
//  UIEvent+Synthesize.h
//  helloworld
//
//  Created by Milo Chen on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSEventProxy.h"
@interface UIEvent (Synthesize)
- (id)_initWithEvent:(GSEventProxy *)fp8 touches:(id)fp12;
- (id)initWithTouch:(UITouch *)touch;


@end
