//
//  CLLocation+Bearing.m
//  helloworld
//
//  Created by Milo Chen on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CLLocation+Bearing.h"
#import <CoreLocation/CoreLocation.h>
@implementation CLLocation (Bearing)
-(double) bearingToLocation:(CLLocation *) destinationLocation {
    return [self distanceFromLocation:destinationLocation]/1000;
}
@end
