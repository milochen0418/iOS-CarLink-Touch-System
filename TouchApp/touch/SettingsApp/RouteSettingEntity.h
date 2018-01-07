//
//  RouteSettingEntity.h
//  touch
//
//  Created by Milo Chen on 11/25/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RouteSettingEntity : NSManagedObject

@property (nonatomic, retain) NSString * mEncodedPolyline;
@property (nonatomic, retain) NSString * mEndTime;
@property (nonatomic, retain) NSString * mFromWhere;
@property (nonatomic, retain) NSNumber * mIsFri;
@property (nonatomic, retain) NSNumber * mIsMon;
@property (nonatomic, retain) NSNumber * mIsSat;
@property (nonatomic, retain) NSNumber * mIsSun;
@property (nonatomic, retain) NSNumber * mIsThu;
@property (nonatomic, retain) NSNumber * mIsTue;
@property (nonatomic, retain) NSNumber * mIsWed;
@property (nonatomic, retain) NSString * mName;
@property (nonatomic, retain) NSString * mStartTime;
@property (nonatomic, retain) NSString * mToWhere;
@property (nonatomic, retain) NSNumber * mIsEnable;

@end
