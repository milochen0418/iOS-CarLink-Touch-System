//
//  SCPMarkersDom.h
//  helloworld
//
//  Created by Milo Chen on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CLLocation+Bearing.h"

@class SCPMarker;
@interface SCPMarkersDom : NSObject <NSXMLParserDelegate> {
    NSMutableArray * mMarkerArray;
    SCPMarker * mTmpMarker;
    NSArray * mSortedMarkerArray;
    NSMutableArray * mFilteredMarkerArray;
    SCPMarker * mHighChanceMarker;
    int mHighChanceMarkerIdx; //it's the index that indicate marker in mSortedMarkerArray if there is mHighChanceMarker in mSortedMarkerArray, -1 otherwise; 
    
//    NSMutableArray * mFilteredMarkerArray;
}
-(void) cleanAllData;
-(void) addMarkerToRelativeArray:(SCPMarker*)marker;

@property (nonatomic) int mHighChanceMarkerIdx;

-(void) sortMakerArrayForHighChanceWithCalLoc:(CLLocation*)carLoc withFreewayMode:(BOOL)isFreewayModeOn;
-(void) figureOutAllDynamicDataWithCarLoc:(CLLocation*)carLoc withFreewayModeOn:(BOOL)isFreewayModeOn withFilterSpeedRate:(double)filterSpeedRate;
-(void) decideWarningMarkerWithCarLoc:(CLLocation*)carLoc withFilterSpeedRate:(double)filterSpeedRate;




@property (nonatomic,strong) NSArray * mSortedMarkerArray;
@property (nonatomic,strong) NSMutableArray * mMarkerArray;
@property (nonatomic,strong) NSMutableArray * mFilteredMarkerArray;
@property (nonatomic,strong) SCPMarker * mHighChanceMarker;
@property (nonatomic,strong) SCPMarker * mTmpMarker;

-(NSString *) description;
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict ;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string ;
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName ;

@end


@interface SCPMarker : NSObject {
    NSString *mId;
    NSString *mLat;
    NSString *mLng;
    NSString *mTypeVar;
    NSString *mType;
    NSString *mSpeed;
    NSString *mDirType;
    NSString *mDirection;
    NSString *mVotes;
    NSString *mStars;
    NSString *mDistance;
    

    int mDynamicMarkerAtAngle;
    int mDynamicCarHeading;
    double mDynamicDistance;

    
}

@property (nonatomic) double mDynamicDistance;
@property (nonatomic) int mDynamicMarkerAtAngle; //angle from car to marker
@property (nonatomic) int mDynamicCarHeading; //only car's heading from gps data





-(NSString *) description;

-(int) getDirTypeInt; //0=All Directions, 1=Only direction of camera, 2=Both direction or camera+ opposite direction
-(int) getDirectionAngleInt; //return value is that East is zero, north = 90

-(void)figureOutDynamicWithCarLog:(CLLocation*)carLoc;


@property (nonatomic,strong) NSString *mId;
@property (nonatomic,strong) NSString *mLat;
@property (nonatomic,strong) NSString *mLng;
@property (nonatomic,strong) NSString *mTypeVar;
@property (nonatomic,strong) NSString *mType;
@property (nonatomic,strong) NSString *mSpeed;
@property (nonatomic,strong) NSString *mDirType;
@property (nonatomic,strong) NSString *mDirection;
@property (nonatomic,strong) NSString *mVotes;
@property (nonatomic,strong) NSString *mStars;
@property (nonatomic,strong) NSString *mDistance;
@end



