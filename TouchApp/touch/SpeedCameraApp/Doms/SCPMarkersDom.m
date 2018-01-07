//
//  SCPMarkersDom.m
//  helloworld
//
//  Created by Milo Chen on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCPMarkersDom.h"
#import "AddedItem.h"
#import "CameraItem.h"
#import "DeletedItem.h"
#import "DownloadedItem.h"
#import "ConfirmedItem.h"

@implementation SCPMarkersDom
@synthesize mMarkerArray ,mTmpMarker;
@synthesize mSortedMarkerArray;
@synthesize mFilteredMarkerArray;
@synthesize mHighChanceMarker;
@synthesize mHighChanceMarkerIdx;

-(SCPMarkersDom*) init {
    self = [super init];
    if(self) {
        self.mMarkerArray = [NSMutableArray arrayWithCapacity:1];
        self.mFilteredMarkerArray = [NSMutableArray arrayWithCapacity:1];
        self.mHighChanceMarker = nil;
        self.mHighChanceMarkerIdx = -1;
        
    }
    return self;
}
-(void) addMarkerToRelativeArray:(SCPMarker*)marker {
    [mMarkerArray addObject:marker];
    [mFilteredMarkerArray addObject:marker];
}

-(void) cleanAllData {
    if(mTmpMarker != nil) {
        mTmpMarker = nil;
    }
    if(mHighChanceMarker != nil) {
        mHighChanceMarker =nil;
    }
    
    if(mMarkerArray != nil) {
        [mMarkerArray removeAllObjects];
        mMarkerArray = nil;
    }   
    if(mFilteredMarkerArray != nil) {
        [mFilteredMarkerArray removeAllObjects];
        mFilteredMarkerArray = nil;
    }
}




-(void) figureOutAllDynamicDataWithCarLoc:(CLLocation*)carLoc withFreewayModeOn:(BOOL)isFreewayModeOn withFilterSpeedRate:(double)filterSpeedRate
{
    if( carLoc== nil ) return;
    if(mMarkerArray == nil ) return;
    if([mMarkerArray count] <= 0) return;
    
    int idx;
    for(idx = 0; idx < [mMarkerArray count]; idx++) 
    {
        SCPMarker *marker = (SCPMarker*)[mMarkerArray objectAtIndex:idx];
        [marker figureOutDynamicWithCarLog:carLoc];
        
        marker = (SCPMarker*)[self.mFilteredMarkerArray objectAtIndex:idx];
        [marker figureOutDynamicWithCarLog:carLoc];
        
    }
    
    [self sortMakerArrayForHighChanceWithCalLoc:carLoc withFreewayMode:isFreewayModeOn];
    [self decideWarningMarkerWithCarLoc:carLoc withFilterSpeedRate:filterSpeedRate];
    
}


-(void) decideWarningMarkerWithCarLoc:(CLLocation*)carLoc withFilterSpeedRate:(double)filterSpeedRate{
    int idx;
    if(mSortedMarkerArray == nil) {
        mHighChanceMarker = nil;
        mHighChanceMarkerIdx = -1;
        return;
    }
    
    int carHeading = (int)[carLoc course];
    double carSpeed = ([carLoc speed]*3600/1000);
    double carFilterSpeed = carSpeed * filterSpeedRate;
    
    
    mHighChanceMarkerIdx = -1;
    mHighChanceMarker = nil;
    for (idx = 0; idx  < [mSortedMarkerArray count]; idx++)
    {
        SCPMarker * marker = [mSortedMarkerArray objectAtIndex:idx];
        int cameraDirType = [marker.mDirType intValue];
        int cameraDirection = [marker.mDirection intValue];
        
        double speed = (double)[marker.mSpeed doubleValue];
        
        switch( cameraDirType ) {
            case 0: //full direction camera;
                if(speed <= 0 || carFilterSpeed > speed) {
                    mHighChanceMarkerIdx = idx;
                    mHighChanceMarker = marker;

                }
                break;
            case 1: //single direction camera
                if((abs(carHeading - cameraDirection) % 360) < 45) 
                {
                    if(speed <= 0 || carFilterSpeed > speed) {
                        mHighChanceMarkerIdx = idx;
                        mHighChanceMarker = marker;
                        
                    }
                }
                break;
            case 2: //bidirection camera
                if(
                   (abs(carHeading - cameraDirection)%360) < 45  || 
                   (abs(  ((carHeading+180)%360) - cameraDirection)%360) < 45  )
                {
                    if(speed <= 0 || carFilterSpeed > speed) {
                        mHighChanceMarkerIdx = idx;
                        mHighChanceMarker = marker;
                    }
                }
                break;
        }
        if(mHighChanceMarkerIdx != -1 && mHighChanceMarker != nil) {
//            NSLog(@"carFilterSpeed = %g", carFilterSpeed);
//            NSLog(@"mHighChanceMarker = %@", mHighChanceMarker);
            break;  //break to exit for-loop for mSortedMarkerArray
        }
    }

    
}




//presume this function is alwyas called by figureOutAllDynamicDataWithCarLoc
-(void) sortMakerArrayForHighChanceWithCalLoc:(CLLocation*)carLoc withFreewayMode:(BOOL)isFreewayModeOn{
    if(mMarkerArray == nil) return;
    if([mMarkerArray count ]<= 0) return;
//    if(((SCPMarker*)[mMarkerArray objectAtIndex:0]).mDynamicDistance
    
    NSSortDescriptor * sortBy = 
    [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES 
    comparator:^(id obj1, id obj2)
    {
        SCPMarker * mk1 = (SCPMarker*)obj1;
        SCPMarker * mk2 = (SCPMarker*)obj2;
        
        if(mk1.mDynamicDistance < mk2.mDynamicDistance ) 
        {
            return NSOrderedAscending;
        }
        else if(mk1.mDynamicDistance > mk2.mDynamicDistance) 
        {
            return NSOrderedDescending;
        }
        else 
        {
            return NSOrderedSame;    
        }
    }];

    
    NSString * condRange = [NSString stringWithFormat:@"(mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d)"];
    
    NSString * argumStr = [NSString stringWithFormat:@"%@",condRange];

    NSPredicate * predicate = nil;
    
    NSPredicate * predicateForFreewayMode = [NSPredicate predicateWithFormat:
        @"((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d)) OR \
          ((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d)) OR \
          ((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d)) OR \
          ((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d))", 
            1.0f, -30,30, 
            0.3f, -60,60,
            0.5f, -45,45,
            0.03f, -90,90
        ];
    NSPredicate * predicateForStreetMode = [NSPredicate predicateWithFormat:
        @"((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d)) OR \
          ((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d)) OR \
          ((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d)) OR \
          ((mDynamicDistance < %g) AND (mDynamicMarkerAtAngle > %d) AND (mDynamicMarkerAtAngle < %d))", 
//            0.3f, -179,179, 
//            0.5f, -135,135,
//            0.8f, -90,90,
//            1.0f, -60,60
                                            1.0f, -179,179, 
                                            0.5f, -135,135,
                                            0.8f, -90,90,
                                            1.0f, -60,60
                                            
        ];
    
    if(isFreewayModeOn==YES) 
    {
        predicate = predicateForFreewayMode;
    } 
    else 
    {
        predicate = predicateForStreetMode;
    }
    
    
    [mFilteredMarkerArray filterUsingPredicate:predicate];

    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortBy, nil];
    
    mSortedMarkerArray = [mFilteredMarkerArray sortedArrayUsingDescriptors:sortDescriptors];
    
}



-(NSString*) description {

    if(mMarkerArray == nil ) 
    {
        return @"mMarkerArray is nil";
    } 
    else if([mMarkerArray count] == 0 ) 
    {
        return  @"[mMarkerArray count] == 0 ";
    } 
    else 
    {
        NSString * str = @"";
        int idx;
        for ( idx = 0; idx < [mMarkerArray count]; idx++ ) 
        {
            NSString * desc = @"";
            if(mMarkerArray != nil) {
                desc = [mMarkerArray description];
            } 
            else 
            {   
                desc = @"nil";
            }
            str = [NSString stringWithFormat:@"%@\n[%d]=%@", str,idx, desc];
        }
        return str;
    }
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
//    NSLog(@"didStartElement with elementName = %@ attr = %@", elementName, attributeDict);    
    if ([elementName isEqualToString:@"marker"]) 
    {
        if(mTmpMarker != nil) mTmpMarker = nil;
        mTmpMarker = [[SCPMarker alloc]init];
        mTmpMarker.mId = (NSString*)[attributeDict valueForKey:@"id"];
        mTmpMarker.mLat = (NSString*)[attributeDict valueForKey:@"lat"];
        mTmpMarker.mLng = (NSString*)[attributeDict valueForKey:@"lng"];
        mTmpMarker.mTypeVar = (NSString*)[attributeDict valueForKey:@"type_var"];
        mTmpMarker.mType = (NSString*)[attributeDict valueForKey:@"type"];
        mTmpMarker.mSpeed = (NSString*)[attributeDict valueForKey:@"speed"];
        mTmpMarker.mDirType = (NSString*)[attributeDict valueForKey:@"dirtype"];
        mTmpMarker.mDirection = (NSString*)[attributeDict valueForKey:@"direction"];
        mTmpMarker.mVotes = (NSString*)[attributeDict valueForKey:@"votes"];
        mTmpMarker.mStars = (NSString*)[attributeDict valueForKey:@"stars"];
        mTmpMarker.mDistance = (NSString*)[attributeDict valueForKey:@"distance"];
        [self addMarkerToRelativeArray:mTmpMarker];
    } 
}

//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {    
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
}


@end


@implementation SCPMarker

@synthesize mId,mLat,mLng,mType,mSpeed,mStars,mVotes,mDirType,mTypeVar,mDistance,mDirection;
@synthesize mDynamicCarHeading,mDynamicMarkerAtAngle,mDynamicDistance;


-(void)figureOutDynamicWithCarLog:(CLLocation*) carLoc {
    double lat = [self.mLat doubleValue];
    double lng = [self.mLng doubleValue];
    CLLocation *markerLoc = [[CLLocation alloc]initWithLatitude:lat longitude:lng];

    mDynamicDistance = [carLoc bearingToLocation:markerLoc];
//    int carHead = (int)[carLoc course];
    
    double x1 = carLoc.coordinate.longitude;
    double y1 = carLoc.coordinate.latitude;
    double x2 = lng;
    double y2 = lat;
    
    double difx = x2-x1;
    double dify = y2-y1;
    double r = sqrt( ((difx)*(difx) + (dify)*(dify)) );
    double angle = acos( ((difx)/r));
    angle = (angle*180.0f)/(M_PI);
    if(dify < 0) angle  =angle * -1 ; 
    if(angle < 0) angle = angle+360;
    int spdAngle = (int)angle;
    //For spdAngle variable. now the base angle=0 is indicate on right and anti-clockwise moving is positive angle moving.
    
    
    int carAngle = [carLoc course];
    carAngle = (carAngle+270)%360;
    carAngle = 360 - carAngle; //translate from clockwise to anti-clockwise
    //For carAngle variable. now the base carAngle=0 is indicate on right and anti-clockwise rotating is positive angle moving.
    
    
    int spdRelativeAngle = (spdAngle + 360 - carAngle) % 360; 
    //spdRelativeAngle is a spdAngle that relative to carAngle by presumming anti-clockwise rotating as postive angle and carAngle like as 0 degree.
    
    int spdRotatedAngle = 0; //when car anti-clockwise rotating the angle=spdRotatedAngle car direction will direct meet the SpeedCamera. so this is what we defined for spdRotatedAngle; but because some speedcamera's position will more easy to indicate by clockwise rotating, so we give a nagivative value to denote that the efficient way to indicate speed camera is to clock-wise rotate.
    
    if(spdRelativeAngle < 180) {
        spdRotatedAngle = spdRelativeAngle;
    } else {
        spdRotatedAngle = spdRelativeAngle - 360;
    }    
    self.mDynamicMarkerAtAngle = spdRotatedAngle;
}


-(NSString*) description {
    NSString * str = @"\t{\n";
    str = [NSString stringWithFormat:@"\t\t%@mId = %@\n",str,mId];
    str = [NSString stringWithFormat:@"\t\t%@mLat = %@\n",str,mLat];
    str = [NSString stringWithFormat:@"\t\t%@mLng = %@\n",str,mLng];
    str = [NSString stringWithFormat:@"\t\t%@mType = %@\n",str,mType];
    str = [NSString stringWithFormat:@"\t\t%@mSpeed = %@\n",str,mSpeed];
    str = [NSString stringWithFormat:@"\t\t%@mStars = %@\n",str,mStars];
    str = [NSString stringWithFormat:@"\t\t%@mVotes = %@\n",str,mVotes];
    str = [NSString stringWithFormat:@"\t\t%@mDirType = %@\n",str,mDirType];    
    str = [NSString stringWithFormat:@"\t\t%@mTypeVar = %@\n",str,mTypeVar];    
    str = [NSString stringWithFormat:@"\t\t%@mDistance = %@\n",str,mDistance];    
    str = [NSString stringWithFormat:@"\t\t%@mDirection = %@\n",str,mDirection];
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;
}



//0=All Directions, 1=Only direction of camera, 2=Both direction or camera+ opposite  direction   
-(int) getDirTypeInt {
    int val = [self.mDirType intValue];
    return val;
}

//East is 0 North is 90
-(int) getDirectionAngleInt {
    int val = [self.mDirection intValue];
    //input value is that 
    //north is angle=0  east is angle=90
    val = (val+270)%360;
    val = (360 - val)%360; //translate from clockwise to anti-clockwise
    return val;
}


@end
