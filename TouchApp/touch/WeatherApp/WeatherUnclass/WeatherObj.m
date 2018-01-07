//
//  WeatherObj.m
//  touch
//
//  Created by Milo Chen on 11/26/12.
//
//

#import "WeatherObj.h"
#import "WeatherEntity.h"
#import "ParseHelper.h"

@implementation WeatherObj

@synthesize mCurCityName,mIsSelectC,mLocId;
@synthesize m1HighTmp,m1Icon,m1LowTmp,m1MonthDay,m1WeekDay;
@synthesize m2HighTmp,m2Icon,m2LowTmp,m2MonthDay,m2WeekDay;
@synthesize m3HighTmp,m3Icon,m3LowTmp,m3MonthDay,m3WeekDay;
@synthesize m4HighTmp,m4Icon,m4LowTmp,m4MonthDay,m4WeekDay;
@synthesize m5HighTmp,m5Icon,m5LowTmp,m5MonthDay,m5WeekDay;
@synthesize mCurTmp,mFeelLikeTmp,mHighTmp,mHumidityTmp,mIcon,mLowTmp,mPrecipitation,mSunRise,mSunSet,mText,mWindDegree,mWindDirection,mWindSpeed;
@synthesize mName,mTimeInterval,mType,mWeatherId;





-(NSString *) description {
    NSString * str = @"{\n";
    str = [NSString stringWithFormat:@"\t%@mToday = %@\n",str,[self descriptionToday]];
    str = [NSString stringWithFormat:@"\t%@mDay1 = %@\n",str,[self descriptionDay1]];
    str = [NSString stringWithFormat:@"\t%@mDay2 = %@\n",str,[self descriptionDay2]];
    str = [NSString stringWithFormat:@"\t%@mDay3 = %@\n",str,[self descriptionDay3]];
    str = [NSString stringWithFormat:@"\t%@mDay4 = %@\n",str,[self descriptionDay4]];
    str = [NSString stringWithFormat:@"\t%@mDay5 = %@\n",str,[self descriptionDay5]];
    str = [NSString stringWithFormat:@"%@\n}\n",str];
    return str;

}


-(NSString *) descriptionDay1 {
    NSString * str = @"\t{\n" ;
    str = [NSString stringWithFormat:@"\t\t%@mWeekDay = %@\n",str,m1WeekDay];
    str = [NSString stringWithFormat:@"\t\t%@mMonthDay = %@\n",str,m1MonthDay];
    str = [NSString stringWithFormat:@"\t\t%@mHighTmp = %@\n",str,m1HighTmp];
    str = [NSString stringWithFormat:@"\t\t%@mLowTmp = %@\n",str,m1LowTmp];
    str = [NSString stringWithFormat:@"\t\t%@mIcon = %@\n",str,m1Icon];
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;
}

-(NSString *) descriptionDay2 {
    NSString * str = @"\t{\n" ;
    str = [NSString stringWithFormat:@"\t\t%@mWeekDay = %@\n",str,m2WeekDay];
    str = [NSString stringWithFormat:@"\t\t%@mMonthDay = %@\n",str,m2MonthDay];
    str = [NSString stringWithFormat:@"\t\t%@mHighTmp = %@\n",str,m2HighTmp];
    str = [NSString stringWithFormat:@"\t\t%@mLowTmp = %@\n",str,m2LowTmp];
    str = [NSString stringWithFormat:@"\t\t%@mIcon = %@\n",str,m2Icon];
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;
}
-(NSString *) descriptionDay3 {
    NSString * str = @"\t{\n" ;
    str = [NSString stringWithFormat:@"\t\t%@mWeekDay = %@\n",str,m3WeekDay];
    str = [NSString stringWithFormat:@"\t\t%@mMonthDay = %@\n",str,m3MonthDay];
    str = [NSString stringWithFormat:@"\t\t%@mHighTmp = %@\n",str,m3HighTmp];
    str = [NSString stringWithFormat:@"\t\t%@mLowTmp = %@\n",str,m3LowTmp];
    str = [NSString stringWithFormat:@"\t\t%@mIcon = %@\n",str,m3Icon];
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;
}
-(NSString *) descriptionDay4 {
    NSString * str = @"\t{\n" ;
    str = [NSString stringWithFormat:@"\t\t%@mWeekDay = %@\n",str,m4WeekDay];
    str = [NSString stringWithFormat:@"\t\t%@mMonthDay = %@\n",str,m4MonthDay];
    str = [NSString stringWithFormat:@"\t\t%@mHighTmp = %@\n",str,m4HighTmp];
    str = [NSString stringWithFormat:@"\t\t%@mLowTmp = %@\n",str,m4LowTmp];
    str = [NSString stringWithFormat:@"\t\t%@mIcon = %@\n",str,m4Icon];
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;
}
-(NSString *) descriptionDay5 {
    NSString * str = @"\t{\n" ;
    str = [NSString stringWithFormat:@"\t\t%@mWeekDay = %@\n",str,m5WeekDay];
    str = [NSString stringWithFormat:@"\t\t%@mMonthDay = %@\n",str,m5MonthDay];
    str = [NSString stringWithFormat:@"\t\t%@mHighTmp = %@\n",str,m5HighTmp];
    str = [NSString stringWithFormat:@"\t\t%@mLowTmp = %@\n",str,m5LowTmp];
    str = [NSString stringWithFormat:@"\t\t%@mIcon = %@\n",str,m5Icon];
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;
}

-(NSString *) descriptionToday
{
    NSString * str = @"\t{\n";
    
    str = [NSString stringWithFormat:@"\t\t%@mCurTmp = %@\n",str,mCurTmp];
    str = [NSString stringWithFormat:@"\t\t%@mFeelLikeTmp = %@\n",str,mFeelLikeTmp];
    str = [NSString stringWithFormat:@"\t\t%@mHighTmp = %@\n",str,mHighTmp];
    str = [NSString stringWithFormat:@"\t\t%@mLowTmp = %@\n",str,mLowTmp];
    str = [NSString stringWithFormat:@"\t\t%@mIcon = %@\n",str,mIcon];
    
    str = [NSString stringWithFormat:@"\t\t%@mText = %@\n",str,mText];
    str = [NSString stringWithFormat:@"\t\t%@mPrecipitation = %@\n",str,mPrecipitation];
    str = [NSString stringWithFormat:@"\t\t%@mHumidityTmp = %@\n",str,mHumidityTmp];
    str = [NSString stringWithFormat:@"\t\t%@mWindSpeed = %@\n",str,mWindSpeed];
    str = [NSString stringWithFormat:@"\t\t%@mWindDegree = %@\n",str,mWindDegree];
    
    str = [NSString stringWithFormat:@"\t\t%@mWindDirection = %@\n",str,mWindDirection];
    str = [NSString stringWithFormat:@"\t\t%@mSunRise = %@\n",str,mSunRise];
    str = [NSString stringWithFormat:@"\t\t%@mSunSet = %@\n",str,mSunSet];
    
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;
}


- (id) init
{
    if (!(self = [super init])) return self;

    return self;
}





-(NSString*) makeRosenWeatherUrl {
    WeatherObj * wObj = self;
    ParseHelper * mParseHelper = [[ParseHelper alloc]init];
    
    NSString * newLocId = wObj.mCurCityName;
    newLocId = [mParseHelper extractValueByPattern:@"(.*?,.*?)(\\(|$)" inTxtStr:newLocId];
    newLocId = [newLocId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:newLocId];
    newLocId = encodedNewLocId;
    
    NSString * metric = @"1";
    BOOL bIsSelectC = NO;
    if(wObj.mIsSelectC != nil) bIsSelectC = (BOOL)[wObj.mIsSelectC intValue];
    if( bIsSelectC) metric = @"0";
    
    NSString * rosenWeatherURL = [NSString stringWithFormat:@"http://rosenapp.com/api.class?action=weather&loc_id=%@&metric=%@", newLocId, metric];
//    NSLog(@"rosenWeatherURL = %@", rosenWeatherURL);
    return rosenWeatherURL;
}



+(NSString*) makeRosenWeatherUrlFromSettingDataOnObj:(WeatherObj*)wObj {
    if(wObj == nil ) return nil;
    return [wObj makeRosenWeatherUrl];
}



-(void) setValuesByDownloadRunningData
{
    
    NSString * rosenWeatherURL = [self makeRosenWeatherUrl];
    if(rosenWeatherURL == nil)
    {
        NSLog(@"setValuesByDownloadRunningData failed");
        return;
    }
    
    WeatherObj * wObj = self;
    ParseHelper * mParseHelper = [[ParseHelper alloc] init];
    
    NSString *xmlStrTmp = [mParseHelper getXmlStringFromUrlStr:rosenWeatherURL];
    NSString *xmlStr = [mParseHelper stringByRemovingNewLinesAndWhitespace:xmlStrTmp];
    NSString * nowStr = [mParseHelper extractValueBetweenBeginStr:@"<now " andEndStr:@"/>" inTxtStr:xmlStr];
    NSString * d1Str = [mParseHelper extractValueBetweenBeginStr:@"<d1 " andEndStr:@"/>" inTxtStr:xmlStr];
    NSString * d2Str = [mParseHelper extractValueBetweenBeginStr:@"<d2 " andEndStr:@"/>" inTxtStr:xmlStr];
    NSString * d3Str = [mParseHelper extractValueBetweenBeginStr:@"<d3 " andEndStr:@"/>" inTxtStr:xmlStr];
    NSString * d4Str = [mParseHelper extractValueBetweenBeginStr:@"<d4 " andEndStr:@"/>" inTxtStr:xmlStr];
    NSString * d5Str = [mParseHelper extractValueBetweenBeginStr:@"<d5 " andEndStr:@"/>" inTxtStr:xmlStr];
    
    NSString * curTmp = [mParseHelper extractValueBetweenBeginStr:@"tmp=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * lowTmp = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * highTmp = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * iconNum = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * textStr = [mParseHelper extractValueBetweenBeginStr:@"text=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * hmidStr = [mParseHelper extractValueBetweenBeginStr:@"hmid=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * sunrStr = [mParseHelper extractValueBetweenBeginStr:@"sunr=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * sunsStr = [mParseHelper extractValueBetweenBeginStr:@"suns=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * windsStr = [mParseHelper extractValueBetweenBeginStr:@"winds=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * winddStr = [mParseHelper extractValueBetweenBeginStr:@"windd=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString * windtStr = [mParseHelper extractValueBetweenBeginStr:@"windt=\"" andEndStr:@"\"" inTxtStr:nowStr];
    NSString *ppcpStr = [mParseHelper extractValueBetweenBeginStr:@"ppcp=\"" andEndStr:@"\"" inTxtStr:nowStr];
    
    
    NSString * d1tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d1Str];
    NSString * d1hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d1Str];
    NSString * d1loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d1Str];
    NSString * d1iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d1Str];
    
    NSString * d2tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d2Str];
    NSString * d2hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d2Str];
    NSString * d2loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d2Str];
    NSString * d2iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d2Str];
    
    NSString * d3tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d3Str];
    NSString * d3hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d3Str];
    NSString * d3loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d3Str];
    NSString * d3iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d3Str];
    
    NSString * d4tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d4Str];
    NSString * d4hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d4Str];
    NSString * d4loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d4Str];
    NSString * d4iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d4Str];
    
    NSString * d5tStr = [mParseHelper extractValueBetweenBeginStr:@"t=\"" andEndStr:@"\"" inTxtStr:d5Str];
    NSString * d5hiStr = [mParseHelper extractValueBetweenBeginStr:@"hi=\"" andEndStr:@"\"" inTxtStr:d5Str];
    NSString * d5loStr = [mParseHelper extractValueBetweenBeginStr:@"lo=\"" andEndStr:@"\"" inTxtStr:d5Str];
    NSString * d5iconStr = [mParseHelper extractValueBetweenBeginStr:@"icon=\"" andEndStr:@"\"" inTxtStr:d5Str];
    
    
    wObj.mCurTmp = curTmp;
    wObj.mLowTmp = lowTmp;
    wObj.mHighTmp = highTmp;
    wObj.mIcon = iconNum;
    wObj.mText = textStr;
    wObj.mHumidityTmp = hmidStr;
    wObj.mSunRise = sunrStr;
    wObj.mSunSet = sunsStr;
    wObj.mPrecipitation = ppcpStr;
    
    wObj.mWindSpeed = windsStr;
    wObj.mWindDegree = winddStr;
    wObj.mWindDirection = windtStr;
    
    wObj.m1WeekDay = d1tStr;
    wObj.m1HighTmp = d1hiStr;
    wObj.m1LowTmp = d1loStr;
    wObj.m1Icon = d1iconStr;
    
    wObj.m2WeekDay = d2tStr;
    wObj.m2HighTmp = d2hiStr;
    wObj.m2LowTmp = d2loStr;
    wObj.m2Icon = d2iconStr;
    
    wObj.m3WeekDay = d3tStr;
    wObj.m3HighTmp = d3hiStr;
    wObj.m3LowTmp = d3loStr;
    wObj.m3Icon = d3iconStr;
    
    wObj.m4WeekDay = d4tStr;
    wObj.m4HighTmp = d4hiStr;
    wObj.m4LowTmp = d4loStr;
    wObj.m4Icon = d4iconStr;
    
    wObj.m5WeekDay = d5tStr;
    wObj.m5HighTmp = d5hiStr;
    wObj.m5LowTmp = d5loStr;
    wObj.m5Icon = d5iconStr;
}



-(void) setValuesFromSettingDataOnEntity:(WeatherEntity*)item {
    WeatherObj * obj = self;
    if(item == nil) return;
    obj.mCurCityName = item.mCurCityName;
    obj.mLocId = item.mLocId;
    obj.mIsSelectC = item.mIsSelectC;
    obj.mName = item.mName;
}

-(void) setValuesFromRunningDataOnEntity:(WeatherEntity*)item {
    WeatherObj * obj = self;
    if(item == nil) return;
    
    obj.m1HighTmp  =item.m1HighTmp;
    obj.m1LowTmp   =item.m1LowTmp;
    obj.m1Icon     =item.m1Icon;
    obj.m1MonthDay =item.m1MonthDay;
    obj.m1WeekDay  =item.m1WeekDay;
    
    obj.m2HighTmp  =item.m2HighTmp;
    obj.m2LowTmp   =item.m2LowTmp;
    obj.m2Icon     =item.m2Icon;
    obj.m2MonthDay =item.m2MonthDay;
    obj.m2WeekDay  =item.m2WeekDay;
    
    obj.m3HighTmp  =item.m3HighTmp;
    obj.m3LowTmp   =item.m3LowTmp;
    obj.m3Icon     =item.m3Icon;
    obj.m3MonthDay =item.m3MonthDay;
    obj.m3WeekDay  =item.m3WeekDay;
    
    obj.m4HighTmp  =item.m4HighTmp;
    obj.m4LowTmp   =item.m4LowTmp;
    obj.m4Icon     =item.m4Icon;
    obj.m4MonthDay =item.m4MonthDay;
    obj.m4WeekDay  =item.m4WeekDay;
    
    obj.m5HighTmp  =item.m5HighTmp;
    obj.m5LowTmp   =item.m5LowTmp;
    obj.m5Icon     =item.m5Icon;
    obj.m5MonthDay =item.m5MonthDay;
    obj.m5WeekDay  =item.m5WeekDay;
    
    obj.mCurTmp = item.mCurTmp;
    obj.mFeelLikeTmp = item.mFeelLikeTmp;
    obj.mHighTmp = item.mHighTmp;
    obj.mHumidityTmp = item.mHumidityTmp;
    obj.mIcon = item.mIcon;
    obj.mLowTmp = item.mLowTmp;
    obj.mName = item.mName;
    obj.mPrecipitation = item.mPrecipitation;
    obj.mSunRise = item.mSunRise;
    obj.mSunSet = item.mSunSet;
    obj.mText = item.mText;
    obj.mTimeInterval = [item.mTimeInterval intValue];
    obj.mType = item.mType;
    obj.mWeatherId = item.mWeatherId;
    obj.mWindDegree = item.mWindDegree;
    obj.mWindDirection = item.mWindDirection;
    obj.mWindSpeed = item.mWindSpeed;
    
}


+(void) copyValuesFromSettingDataOnObj:(WeatherObj*)obj ToEntity:(WeatherEntity*)item {
    if(item == nil || obj ==nil ) return;
    item.mCurCityName=obj.mCurCityName;
    item.mLocId = obj.mLocId;
    item.mName = obj.mName;
    item.mIsSelectC = obj.mIsSelectC;

}

+(void) copyValuesFromRunningDataOnObj:(WeatherObj*)obj ToEntity:(WeatherEntity*)item {
    if(item == nil || obj ==nil ) return;
    
    item.m1HighTmp  =obj.m1HighTmp;
    item.m1LowTmp   =obj.m1LowTmp;
    item.m1Icon     =obj.m1Icon;
    item.m1MonthDay =obj.m1MonthDay;
    item.m1WeekDay  =obj.m1WeekDay;
    
    item.m2HighTmp  =obj.m2HighTmp;
    item.m2LowTmp   =obj.m2LowTmp;
    item.m2Icon     =obj.m2Icon;
    item.m2MonthDay =obj.m2MonthDay;
    item.m2WeekDay  =obj.m2WeekDay;
    
    item.m3HighTmp  =obj.m3HighTmp;
    item.m3LowTmp   =obj.m3LowTmp;
    item.m3Icon     =obj.m3Icon;
    item.m3MonthDay =obj.m3MonthDay;
    item.m3WeekDay  =obj.m3WeekDay;
    
    item.m4HighTmp  =obj.m4HighTmp;
    item.m4LowTmp   =obj.m4LowTmp;
    item.m4Icon     =obj.m4Icon;
    item.m4MonthDay =obj.m4MonthDay;
    item.m4WeekDay  =obj.m4WeekDay;
    
    item.m5HighTmp  =obj.m5HighTmp;
    item.m5LowTmp   =obj.m5LowTmp;
    item.m5Icon     =obj.m5Icon;
    item.m5MonthDay =obj.m5MonthDay;
    item.m5WeekDay  =obj.m5WeekDay;
    
    item.mCurTmp = obj.mCurTmp;
    item.mFeelLikeTmp = obj.mFeelLikeTmp;
    item.mHighTmp = obj.mHighTmp;
    item.mHumidityTmp = obj.mHumidityTmp;
    item.mIcon = obj.mIcon;
    item.mLowTmp = obj.mLowTmp;
    item.mName = obj.mName;
    item.mPrecipitation = obj.mPrecipitation;
    item.mSunRise = obj.mSunRise;
    item.mSunSet = obj.mSunSet;
    item.mText = obj.mText;
    item.mTimeInterval = [NSNumber numberWithInt:obj.mTimeInterval];
    item.mType = obj.mType;
    item.mWeatherId = obj.mWeatherId;
    item.mWindDegree = obj.mWindDegree;
    item.mWindDirection = obj.mWindDirection;
    item.mWindSpeed = obj.mWindSpeed;
}

+(void) copyValuesFromSettingDataOnEntity:(WeatherEntity*)item ToObj:(WeatherObj*)obj {
    [obj setValuesFromSettingDataOnEntity:item];
}

+(void) copyValuesFromRunningDataOnEntity:(WeatherEntity*)item ToObj:(WeatherObj*)obj {
    [obj setValuesFromRunningDataOnEntity:item];
}



@end
