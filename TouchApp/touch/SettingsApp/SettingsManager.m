//
//  SettingsManager.m
//  touch
//
//  Created by Milo Chen on 11/29/12.
//
//

#import "SettingsManager.h"
#import "CoreDataHelper.h"
@implementation SettingsManager

@synthesize mSpeedCameraSettingManager,mWeatherSettingManager;


-(void) initSettingsManager
{
    mWeatherSettingManager = [WeatherSettingManager sharedInstance];
    mSpeedCameraSettingManager = [SpeedCameraSettingManager sharedInstance];
}

+(SettingsManager*) sharedInstance
{
    static SettingsManager * staticInstance = nil;
    if(staticInstance == nil)
    {
        staticInstance = [[SettingsManager alloc] init];
        [staticInstance initSettingsManager];
    }
    return staticInstance;
}
@end

@implementation WeatherSettingManager

@synthesize mIsSelectC = _mIsSelectC;
-(BOOL) mIsSelectC {
    NSLog(@"mIsSelectC getter return value = %d", _mIsSelectC);
    return _mIsSelectC;
}
-(void)setMIsSelectC:(BOOL)newValue {
    NSLog(@"mIsSelectC setter with value = %d", newValue);
    _mIsSelectC = newValue;
    [self writeSetting];
}

@synthesize mCurCityName = _mCurCityName;
-(NSString*) mCurCityName{
    NSLog(@"mCurCityName getter return value = %@", _mCurCityName);
    return _mCurCityName;
}
-(void)setMCurCityName:(NSString*)newValue{
    NSLog(@"mCurCityName setter with value = %@", newValue);
    _mCurCityName = newValue;
    [self writeSetting];
}

@synthesize mLocId = _mLocId;
-(NSString*) mLocId{
    NSLog(@"mLocId getter return value = %@", _mLocId);
    return _mLocId;
}

-(void)setMLocId:(NSString*)newValue{
    NSLog(@"mLocId setter with value = %@", newValue);
    _mLocId = newValue;
    [self writeSetting];
}

@synthesize mSelectedItemIdx = _mSelectedItemIdx;
-(int) mSelectedItemIdx {
    NSLog(@"mSelectedItemIdx getter return value = %d", _mSelectedItemIdx);
    return _mSelectedItemIdx;
}
-(void)setMSelectedItemIdx:(int)newValue {
    NSLog(@"mIsSelectC setter with value = %d", newValue);
    _mSelectedItemIdx = newValue;
    [self writeSetting];    
}


@synthesize mItemsCount = _mItemsCount;
-(int) mItemCount {
    NSLog(@"mItemsCount getter return value = %d", _mItemsCount);
    return _mItemsCount;
}
-(void)setMItemsCountIdx:(int)newValue {
    NSLog(@"mItemsCount setter with value = %d", newValue);
    _mItemsCount = newValue;
    [self writeSetting];
}


-(void) readSetting
{
    if(mEntityName == nil) return;
    CoreDataHelper * mCoreDataHelper = [CoreDataHelper sharedInstance];

    NSDictionary *memDict;
    memDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"Corona, CA",@"mCurCityName",
            @"USCA0252",@"mLocId",
            @"0",@"mIsSelectC",
//            @"1",@"mItemsCount",
//            @"0",@"mSelectedItemIdx",
             @"0",@"mItemsCount",
             @"-1",@"mSelectedItemIdx",
            nil];
    
    NSString * locId = nil;
    NSString * curCityName = nil; 
    NSString * isSelectC = nil;
    NSString * itemsCount = nil;
    NSString * selectedItemIdx = nil;
    
    _mLocId = [memDict valueForKey:@"mLocId"];
    _mCurCityName = [memDict valueForKey:@"mCurCityName"];
    _mIsSelectC = (BOOL)[[memDict valueForKey:@"mIsSelectC"] intValue];
    _mItemsCount = [[memDict valueForKey:@"mItemsCount"] intValue];
    _mSelectedItemIdx = [[memDict valueForKey:@"mSelectedItemIdx"] intValue];
    
    NSDictionary *readDict = [mCoreDataHelper readSettingDict:mEntityName];
    
    if(readDict != nil)
    {
        locId = [readDict valueForKey:@"mLocId"];
        curCityName = [readDict valueForKey:@"mCurCityName"];
        isSelectC = [readDict valueForKey:@"mIsSelectC"];
        itemsCount = [readDict valueForKey:@"mItemsCount"];
        selectedItemIdx = [readDict valueForKey:@"mSelectedItemIdx"];
        
        if(locId != nil) _mLocId = locId;
        if(curCityName != nil) _mCurCityName = curCityName;
        if(isSelectC != nil) _mIsSelectC = (BOOL)[isSelectC intValue];
        if(itemsCount != nil) _mItemsCount = [itemsCount intValue];
        if(selectedItemIdx != nil) _mSelectedItemIdx = [selectedItemIdx intValue];
    }    
}


-(BOOL) writeSetting
{
    if(mEntityName == nil) return NO;
    NSDictionary * dict;
    NSString * curCityName = _mCurCityName;
    NSString * locId = _mLocId;
    NSString * isSelectC = [NSString stringWithFormat:@"%d",(int)_mIsSelectC];
    NSString * itemsCount = [NSString stringWithFormat:@"%d", _mItemsCount];
    NSString * selectedItemIdx = [NSString stringWithFormat:@"%d", _mSelectedItemIdx];
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            curCityName, @"mCurCityName",
            locId,@"mLocId",
            isSelectC,@"mIsSelectC",
            itemsCount,@"mItemsCount",
            selectedItemIdx,@"mSelectedItemIdx",
            nil];
    CoreDataHelper * mCoreDataHelper = [CoreDataHelper sharedInstance];
    if(![mCoreDataHelper writeSettingDict:mEntityName withDict:dict])
    {
        NSLog(@"WeatherSettingEntity writeSettingDict error");
        return NO;
    }
    else {
        return YES;
    }
}


-(void) initSetting
{
    mEntityName = @"WeatherSettingEntity";
    [self readSetting];    
}

+(WeatherSettingManager*) sharedInstance
{
    static WeatherSettingManager * staticInstance = nil;
    if(staticInstance == nil)
    {
        staticInstance = [[WeatherSettingManager alloc] init];
        [staticInstance initSetting];
    }
    return staticInstance;
}


@end



@implementation SpeedCameraSettingManager
-(void) initSetting
{
    
}

+(SpeedCameraSettingManager*) sharedInstance
{
    static SpeedCameraSettingManager * staticInstance = nil;
    if(staticInstance == nil)
    {
        staticInstance = [[SpeedCameraSettingManager alloc] init];
        [staticInstance initSetting];
    }
    return staticInstance;
}
@end

