//
//  NSObject+SharedQueue.h
//  helloworld.testNSOperation
//
//  Created by Milo Chen on 11/15/12.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (SharedQueue)
-(void)performSelectorOnBackgroundQueue:(SEL)aSelector withObject:(id)anObject;
@end
