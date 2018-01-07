//
//  TrafficIncidentEntity.h
//  touch
//
//  Created by Milo Chen on 11/13/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TrafficIncidentEntity : NSManagedObject

@property (nonatomic, retain) NSString * mAlertcDesc;
@property (nonatomic, retain) NSString * mCriticalityDesc;
@property (nonatomic, retain) NSString * mDirectionLocalDesc;
@property (nonatomic, retain) NSString * mEndTime;
@property (nonatomic, retain) NSString * mLat;

@property (nonatomic, retain) NSString * mLng;
@property (nonatomic, retain) NSString * mPointDesc;
@property (nonatomic, retain) NSString * mPointLocalDesc;
@property (nonatomic, retain) NSString * mRoadwayDesc;
@property (nonatomic, retain) NSString * mRoadwayLocalDesc;

@property (nonatomic, retain) NSString * mStartTime;
@property (nonatomic, retain) NSString * mTrafficItemDesc;
@property (nonatomic, retain) NSString * mTrafficItemTypeDesc;
@property (nonatomic, retain) NSString * mTrafficSignId;

@end
