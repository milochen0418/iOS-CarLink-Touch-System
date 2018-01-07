//
//  MyAnnotation.m
//  helloworld
//
//  Created by Milo Chen on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
@synthesize myTitle,mySubTitle,myCoordinate;

@synthesize mUnsortedMarkerIdx;
@synthesize mSortedMarkerIdx;
@synthesize mHighChanceMarkerIdx;
@synthesize mFocusCameraId;



- (CLLocationCoordinate2D)coordinate;
{
    return self.myCoordinate;
}

- (NSString *)title
{
    return self.myTitle;
}

- (NSString *)subtitle
{
    return self.mySubTitle;
}
@end
