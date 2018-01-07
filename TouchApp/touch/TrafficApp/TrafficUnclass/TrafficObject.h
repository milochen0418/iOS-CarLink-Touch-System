//
//  TrafficObject.h
//  touch
//
//  Created by Milo Chen on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParseHelper;

#import "RoadwaySignId.h"


@interface TrafficObject : NSObject {
    
}

+(NSMutableArray*) getTrafficObjectArrayFromIncidentUrlStr: (NSString*)urlStr;


//ROADWAY ID/DESCRIPTION TYPE="NTCSA"
@property (nonatomic,strong) NSString *mRoadwayDesc;

//POINT ID/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) NSString *mPointDesc;

//TRAFFIC_ITEM_TYPE_DESC
@property (nonatomic,strong) NSString *mTrafficItemTypeDesc;

//START_TIME
@property (nonatomic,strong) NSString *mStartTime;

//END_TIME
@property (nonatomic,strong) NSString *mEndTime;

//CRITICALITY/DESCRIPTION
@property (nonatomic,strong) NSString *mCriticalityDesc;

//ALERTC/DESCRIPTION
@property (nonatomic,strong) NSString *mAlertcDesc;

//ROADWAY ID/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) NSString *mRoadwayLocalDesc;

//POINT ID/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) NSString *mPointLocalDesc;

//DIRECTION/DESCRIPTION TYPE="LOCAL"
@property (nonatomic,strong) NSString *mDirectionLocalDesc;

//GEOLOC/ORIGIN/LATITUDE
@property (nonatomic,strong) NSString *mLat;

//GEOLOC/ORIGIN/LONGITUDE
@property (nonatomic,strong) NSString *mLng;

//TRAFFIC_ITEM_DESCRIPTION TYPE="desc"
@property (nonatomic,strong) NSString *mTrafficItemDesc;

@property (nonatomic,strong) ParseHelper * mParseHelper;
//e.g. if mRoadwayDesc == SR-67 then mRoadwaySignId is SR
//so we can get correct UIImage for the sign  
@property (nonatomic,strong) RoadwaySignId * mRoadwaySignId;


-(UIImage*) getRoadwaySignImg;
+(UIImage*) getRoadwaySignImgFromId:(RoadwaySignId*)roadwaySignId;

//e.g. presume mTrafficSignId <- mTrafficItemTypeDesc
////so we can get correct UIImage for the sign
@property (nonatomic,strong) NSString * mTrafficSignId;
-(UIImage*) getTrafficSignImg;
+(UIImage*) getTrafficSignImgFromId:(NSString*)trafficSignId;


-(TrafficObject*) init;
-(void) reloadObjWidget;
-(void) loadObjWidget;

-(BOOL) isInWorkTime;

@end


