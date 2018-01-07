//
//  WeatherObj.h
//  touch
//
//  Created by Milo Chen on 11/26/12.
//
//

#import <Foundation/Foundation.h>

@class WeatherEntity;
@interface WeatherObj : NSObject
{
    int mTimeInterval;
}
-(NSString *) description;


@property (nonatomic,strong) NSString * mCurCityName;
@property (nonatomic,strong) NSString * mLocId;
@property (nonatomic,strong) NSString * mIsSelectC;


@property (nonatomic,strong) NSString * mWeatherId;
@property (nonatomic,strong) NSString * mType;
@property (nonatomic,strong) NSString * mName;
@property (nonatomic) int mTimeInterval;


//Today
@property (nonatomic,strong) NSString * mCurTmp;  //tmp
@property (nonatomic,strong) NSString * mHighTmp; //hi
@property (nonatomic,strong) NSString * mLowTmp; //lo
@property (nonatomic,strong) NSString * mFeelLikeTmp; //flik
@property (nonatomic,strong) NSString * mHumidityTmp; //hmid
@property (nonatomic,strong) NSString * mPrecipitation; //ppcp
@property (nonatomic,strong) NSString * mWindSpeed; //winds
@property (nonatomic,strong) NSString * mWindDegree; //windt
@property (nonatomic,strong) NSString * mWindDirection; //windd
@property (nonatomic,strong) NSString * mIcon; //icon
@property (nonatomic,strong) NSString * mText; //text
@property (nonatomic,strong) NSString * mSunRise; //sunr
@property (nonatomic,strong) NSString * mSunSet; //suns


//day 1
@property(nonatomic,strong) NSString * m1WeekDay; //d1 t
@property(nonatomic,strong) NSString * m1MonthDay; //d1 d
@property(nonatomic,strong) NSString * m1HighTmp; //d1 hi
@property(nonatomic,strong) NSString * m1LowTmp; //d1 lo
@property(nonatomic,strong) NSString * m1Icon; //d1 icon

//day 2
@property(nonatomic,strong) NSString * m2WeekDay; //d2 t
@property(nonatomic,strong) NSString * m2MonthDay; //d2 d
@property(nonatomic,strong) NSString * m2HighTmp; //d2 hi
@property(nonatomic,strong) NSString * m2LowTmp; //d2 lo
@property(nonatomic,strong) NSString * m2Icon; //d2 icon

//day 3
@property(nonatomic,strong) NSString * m3WeekDay; //d3 t
@property(nonatomic,strong) NSString * m3MonthDay; //d3 d
@property(nonatomic,strong) NSString * m3HighTmp; //d3 hi
@property(nonatomic,strong) NSString * m3LowTmp; //d3 lo
@property(nonatomic,strong) NSString * m3Icon; //d3 icon

//day 4
@property(nonatomic,strong) NSString * m4WeekDay; //d4 t
@property(nonatomic,strong) NSString * m4MonthDay; //d4 d
@property(nonatomic,strong) NSString * m4HighTmp; //d4 hi
@property(nonatomic,strong) NSString * m4LowTmp; //d4 lo
@property(nonatomic,strong) NSString * m4Icon; //d4 icon

//day 5
@property(nonatomic,strong) NSString * m5WeekDay; //d5 t
@property(nonatomic,strong) NSString * m5MonthDay; //d5 d
@property(nonatomic,strong) NSString * m5HighTmp; //d5 hi
@property(nonatomic,strong) NSString * m5LowTmp; //d5 lo
@property(nonatomic,strong) NSString * m5Icon; //d5 icon

-(void) setValuesFromSettingDataOnEntity:(WeatherEntity*)item;
-(void) setValuesFromRunningDataOnEntity:(WeatherEntity*)item;
-(void) setValuesByDownloadRunningData;

-(NSString*) makeRosenWeatherUrl;

+(void) copyValuesFromSettingDataOnObj:(WeatherObj*)obj ToEntity:(WeatherEntity*)item;
+(void) copyValuesFromRunningDataOnObj:(WeatherObj*)obj ToEntity:(WeatherEntity*)item;
+(void) copyValuesFromSettingDataOnEntity:(WeatherEntity*)item ToObj:(WeatherObj*)obj;
+(void) copyValuesFromRunningDataOnEntity:(WeatherEntity*)item ToObj:(WeatherObj*)obj;
+(NSString*) makeRosenWeatherUrlFromSettingDataOnObj:(WeatherObj*)wObj;

@end
