//
//  NSObject+SharedQueue.m
//  helloworld.testNSOperation
//
//  Created by Milo Chen on 11/15/12.
//
//

#import "NSOperationQueue+SharedQueue.h"
#import "NSObject+SharedQueue.h"

@implementation NSObject (SharedQueue)

-(void)performSelectorOnBackgroundQueue:(SEL)aSelector withObject:(id)anObject;
{
    NSOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                  selector:aSelector
                                                                    object:anObject];
    [[NSOperationQueue sharedOperationQueue] addOperation:operation];
//    [operation release];
    operation = nil;
}

@end
