//
//  TrafficObjForWidget.h
//  touch
//
//  Created by Milo Chen on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RoadwaySignId.h"
#import "TrafficObject.h"
@class ParseHelper;
//@interface TrafficObjForWidget : NSObject
@interface TrafficObjForWidget : TrafficObject
{
    
}
//
//@property (nonatomic,strong) NSString *mTrafficItemTypeDesc;
//@property (nonatomic,strong) NSString *mStartTime;
//@property (nonatomic,strong) NSString *mEndTime;
//
////ROADWAY ID/DESCRIPTION TYPE="NTCSA"
//@property (nonatomic,strong) NSString *mRoadwayDesc;
//
////DIRECTION/DESCRIPTION TYPE="LOCAL"
//@property (nonatomic,strong) NSString *mDirectionLocalDesc;
//
////POINT ID/DESCRIPTION TYPE="LOCAL"
//@property (nonatomic,strong) NSString *mPointDesc;
//
//
//@property (nonatomic,strong) ParseHelper * mParseHelper;
//
////e.g. if mRoadwayDesc == SR-67 then mRoadwaySignId is SR
////so we can get correct UIImage for the sign  
////@property (nonatomic,strong) NSString* mRoadwaySignId;
//@property (nonatomic,strong) RoadwaySignId* mRoadwaySignId;
//-(UIImage*) getRoadwaySignImg;
//+(UIImage*) getRoadwaySignImgFromId:(RoadwaySignId*)roadwaySignId;
//
////e.g. presume mTrafficSignId <- mTrafficItemTypeDesc
//////so we can get correct UIImage for the sign
//@property (nonatomic,strong) NSString * mTrafficSignId;
//-(UIImage*) getTrafficSignImg;
//+(UIImage*) getTrafficSignImgFromId:(NSString*)trafficSignId;
//

-(TrafficObjForWidget*) init;
//-(void) reloadObjWidget;
//-(void) loadObjWidget;
//
//-(UIImage*) getRoadwaySignImg ;

@end
