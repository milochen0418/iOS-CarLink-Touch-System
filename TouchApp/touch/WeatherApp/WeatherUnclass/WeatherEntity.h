//
//  WeatherEntity.h
//  touch
//
//  Created by Milo Chen on 12/10/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherEntity : NSManagedObject

@property (nonatomic, retain) NSString * m1HighTmp;
@property (nonatomic, retain) NSString * m1Icon;
@property (nonatomic, retain) NSString * m1LowTmp;
@property (nonatomic, retain) NSString * m1MonthDay;
@property (nonatomic, retain) NSString * m1WeekDay;
@property (nonatomic, retain) NSString * m2HighTmp;
@property (nonatomic, retain) NSString * m2Icon;
@property (nonatomic, retain) NSString * m2LowTmp;
@property (nonatomic, retain) NSString * m2MonthDay;
@property (nonatomic, retain) NSString * m2WeekDay;
@property (nonatomic, retain) NSString * m3HighTmp;
@property (nonatomic, retain) NSString * m3Icon;
@property (nonatomic, retain) NSString * m3LowTmp;
@property (nonatomic, retain) NSString * m3MonthDay;
@property (nonatomic, retain) NSString * m3WeekDay;
@property (nonatomic, retain) NSString * m4HighTmp;
@property (nonatomic, retain) NSString * m4Icon;
@property (nonatomic, retain) NSString * m4LowTmp;
@property (nonatomic, retain) NSString * m4MonthDay;
@property (nonatomic, retain) NSString * m4WeekDay;
@property (nonatomic, retain) NSString * m5HighTmp;
@property (nonatomic, retain) NSString * m5Icon;
@property (nonatomic, retain) NSString * m5LowTmp;
@property (nonatomic, retain) NSString * m5MonthDay;
@property (nonatomic, retain) NSString * m5WeekDay;
@property (nonatomic, retain) NSString * mCurTmp;
@property (nonatomic, retain) NSString * mFeelLikeTmp;
@property (nonatomic, retain) NSString * mHighTmp;
@property (nonatomic, retain) NSString * mHumidityTmp;
@property (nonatomic, retain) NSString * mIcon;
@property (nonatomic, retain) NSNumber * mId;
@property (nonatomic, retain) NSString * mLowTmp;
@property (nonatomic, retain) NSString * mName;
@property (nonatomic, retain) NSString * mPrecipitation;
@property (nonatomic, retain) NSString * mSunRise;
@property (nonatomic, retain) NSString * mSunSet;
@property (nonatomic, retain) NSString * mText;
@property (nonatomic, retain) NSNumber * mTimeInterval;
@property (nonatomic, retain) NSString * mType;
@property (nonatomic, retain) NSString * mWeatherId;
@property (nonatomic, retain) NSString * mWindDegree;
@property (nonatomic, retain) NSString * mWindDirection;
@property (nonatomic, retain) NSString * mWindSpeed;
@property (nonatomic, retain) NSString * mCurCityName;
@property (nonatomic, retain) NSString * mLocId;
@property (nonatomic, retain) NSString * mIsSelectC;

@end
