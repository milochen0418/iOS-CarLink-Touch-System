//
//  NSOperationQueue+SharedQueue.h
//  helloworld.testNSOperation
//
//  Created by Milo Chen on 11/15/12.
//
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (SharedQueue)
+(NSOperationQueue*)sharedOperationQueue;
+(NSOperationQueue*)sharedOperationInternetAutocompleteQueue;

@end
