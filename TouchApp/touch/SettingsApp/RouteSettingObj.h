//
//  RouteSettingObj.h
//  touch
//
//  Created by Milo Chen on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParseHelper.h"
@class Waypoint;

@interface RouteSettingObj : NSObject{}
@property (nonatomic,strong) NSString *mName;
@property (nonatomic,strong) NSString *mFromWhere;
@property (nonatomic,strong) NSString *mToWhere;
@property (nonatomic,strong) NSString *mStartTime;
@property (nonatomic,strong) NSString *mEndTime;
@property (nonatomic) bool mIsMon;
@property (nonatomic) bool mIsTue;
@property (nonatomic) bool mIsWed;
@property (nonatomic) bool mIsThu;
@property (nonatomic) bool mIsFri;
@property (nonatomic) bool mIsSat;
@property (nonatomic) bool mIsSun;
@property (nonatomic) bool mIsEnable;
+(NSString*) getPolylineFrom:(NSString*)fromWhere toWhere:(NSString*)toWhere;
+(NSMutableArray*) decodePolyline:(NSString *)encodedPoints ; //return Waypoint array
+(NSString*) getIncidentUrlStrByPolylineArray:(NSMutableArray*)polylineArray;
@property (nonatomic,strong) NSString* mEncodedPolyline;
-(BOOL) isInWorkTime;


@end

@interface Waypoint : NSObject {}
@property (nonatomic,strong) NSString * lat;
@property (nonatomic,strong) NSString * lng;
@end
