//
//  CLLocation+Bearing.h
//  helloworld
//
//  Created by Milo Chen on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocation (Bearing)
-(double) bearingToLocation:(CLLocation *) destinationLocation;
@end
