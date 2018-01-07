//
//  SettingsManager.h
//  touch
//
//  Created by Milo Chen on 11/29/12.
//
//

#import <Foundation/Foundation.h>
@class WeatherSettingManager;
@class SpeedCameraSettingManager;
@interface SettingsManager : NSObject
+(SettingsManager*) sharedInstance;
@property (nonatomic,strong) WeatherSettingManager * mWeatherSettingManager;
@property (nonatomic,strong) SpeedCameraSettingManager * mSpeedCameraSettingManager;
@end

@interface WeatherSettingManager : NSObject
{
    NSString *mEntityName;
    BOOL _mIsSelectC; //show temperature as C
    NSString * _mCurCityName; //e.g. Corona, CA
    NSString * _mLocId; //e.g. USSC0140
    
    int _mSelectedItemIdx;
    int _mItemsCount;

}

@property (nonatomic,strong) NSString * mCurCityName;
@property (nonatomic,strong) NSString * mLocId;
@property (nonatomic) BOOL mIsSelectC;
@property (nonatomic) int mSelectedItemIdx;
@property (nonatomic) int mItemsCount;

+(WeatherSettingManager*) sharedInstance;
@end


@interface SpeedCameraSettingManager : NSObject
+(SpeedCameraSettingManager*) sharedInstance;
@end
