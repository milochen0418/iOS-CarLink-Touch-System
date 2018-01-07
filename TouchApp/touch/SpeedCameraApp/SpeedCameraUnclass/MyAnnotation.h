//
//  MyAnnotation.h
//  helloworld
//
//  Created by Milo Chen on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D myCoordinate;
    NSString *myTitle;
    NSString *mySubTitle;
    int mUnsortedMarkerIdx;
    int mSortedMarkerIdx;
    int mHighChanceMarkerIdx;
    NSString *mFocusCameraId;
}

@property (nonatomic) CLLocationCoordinate2D myCoordinate;
@property (nonatomic,strong) NSString * myTitle;
@property (nonatomic,strong) NSString * mySubTitle;
@property (nonatomic) int mUnsortedMarkerIdx;
@property (nonatomic) int mSortedMarkerIdx;
@property (nonatomic) int mHighChanceMarkerIdx;
@property (nonatomic,strong) NSString* mFocusCameraId;



@end
