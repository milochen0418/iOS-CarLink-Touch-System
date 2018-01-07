//
//  NSOperationQueue+SharedQueue.m
//  helloworld.testNSOperation
//
//  Created by Milo Chen on 11/15/12.
//
//

#import "NSOperationQueue+SharedQueue.h"

@implementation NSOperationQueue (SharedQueue)
+(NSOperationQueue*)sharedOperationQueue;
{
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}


+(NSOperationQueue*)sharedOperationInternetAutocompleteQueue;
{
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}

@end
