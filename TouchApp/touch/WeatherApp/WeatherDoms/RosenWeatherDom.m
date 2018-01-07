//
//  RosenWeatherDom.m
//  helloworld
//
//  Created by Milo Chen on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RosenWeatherDom.h"

@implementation RosenWeatherDom
@synthesize mDay1,mDay2,mDay3,mDay4,mDay5,mToday;
-(RosenWeatherDom*) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

-(NSString *) description {
    NSString * str = @"{\n";
    str = [NSString stringWithFormat:@"\t%@mToday = %@\n",str,mToday];
    str = [NSString stringWithFormat:@"\t%@mDay1 = %@\n",str,mDay1];    
    str = [NSString stringWithFormat:@"\t%@mDay2 = %@\n",str,mDay2];    
    str = [NSString stringWithFormat:@"\t%@mDay3 = %@\n",str,mDay3];    
    str = [NSString stringWithFormat:@"\t%@mDay4 = %@\n",str,mDay4];    
    str = [NSString stringWithFormat:@"\t%@mDay5 = %@\n",str,mDay5];        
    str = [NSString stringWithFormat:@"%@\n}\n",str];
    return str;    
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
    int day = 0;
    NSLog(@"didStartElement with elementName = %@ attr = %@", elementName, attributeDict);
    if ([elementName isEqualToString:@"now"]) 
    {
        day = -1;
    } 
    else if([elementName isEqualToString:@"d1"]) {
        day = 1;  
    }
    else if([elementName isEqualToString:@"d2"]) {
        day = 2;
    }
    else if([elementName isEqualToString:@"d3"]) {
        day = 3;
    }
    else if([elementName isEqualToString:@"d4"]) {
        day = 4;
    }
    else if([elementName isEqualToString:@"d5"]) {
        day = 5;
    }
    
    if( day >=1) {
        RosenDayWeather * mTmpDay = [[RosenDayWeather alloc]init];
        mTmpDay.mWeekDay = (NSString*)[attributeDict valueForKey:@"t"];
        mTmpDay.mMonthDay = (NSString*)[attributeDict valueForKey:@"d"];
        mTmpDay.mHighTmp = (NSString*)[attributeDict valueForKey:@"hi"];
        mTmpDay.mLowTmp = (NSString*)[attributeDict valueForKey:@"lo"];
        mTmpDay.mIcon = (NSString*)[attributeDict valueForKey:@"icon"];
        switch(day){
            case 1:
                mDay1 = mTmpDay;
                break;
            case 2:
                mDay2 = mTmpDay;
                break;
            case 3:
                mDay3 = mTmpDay;
                break;
            case 4:
                mDay4 = mTmpDay;
                break;
            case 5:
                mDay5 = mTmpDay;
                break;
        }
    }
    else if(day == -1)  //day is now day
    {
        RosenTodayWeather * mTmpToday = [[RosenTodayWeather alloc]init];
        mTmpToday.mCurTmp = (NSString*)[attributeDict valueForKey:@"tmp"];
        mTmpToday.mFeelLikeTmp = (NSString*)[attributeDict valueForKey:@"flik"];
        mTmpToday.mHighTmp = (NSString*)[attributeDict valueForKey:@"hi"];
        mTmpToday.mLowTmp = (NSString*)[attributeDict valueForKey:@"lo"];
        mTmpToday.mIcon = (NSString*)[attributeDict valueForKey:@"icon"];  
        mTmpToday.mText = (NSString*)[attributeDict valueForKey:@"text"];
        mTmpToday.mPrecipitation = (NSString*)[attributeDict valueForKey:@"ppcp"];
        mTmpToday.mHumidityTmp = (NSString*)[attributeDict valueForKey:@"hmid"];
        mTmpToday.mWindSpeed = (NSString*)[attributeDict valueForKey:@"winds"];
        mTmpToday.mWindDegree = (NSString*)[attributeDict valueForKey:@"windd"];
        mTmpToday.mWindDirection = (NSString*)[attributeDict valueForKey:@"windt"];
        mTmpToday.mSunRise = (NSString*)[attributeDict valueForKey:@"sunr"];
        mTmpToday.mSunSet = (NSString*)[attributeDict valueForKey:@"suns"];
        self.mToday = mTmpToday;
    }
    
    
}

//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
//    mTmpLoc.mName = string;
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
//    NSLog(@"didEndElement with elementName = %@", elementName);
//    
//    if ([elementName isEqualToString:@"loc"]) {     
//        [self.mLocArray addObject:mTmpLoc];
//        mTmpLoc = nil;
//    }
}


@end

@implementation RosenDayWeather
@synthesize mWeekDay,mMonthDay,mHighTmp,mLowTmp,mIcon;
-(RosenDayWeather*) init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

-(NSString *) description {
    NSString * str = @"\t{\n";
    
    str = [NSString stringWithFormat:@"\t\t%@mWeekDay = %@\n",str,mWeekDay];
    str = [NSString stringWithFormat:@"\t\t%@mMonthDay = %@\n",str,mMonthDay];
    str = [NSString stringWithFormat:@"\t\t%@mHighTmp = %@\n",str,mHighTmp];
    str = [NSString stringWithFormat:@"\t\t%@mLowTmp = %@\n",str,mLowTmp];
    str = [NSString stringWithFormat:@"\t\t%@mIcon = %@\n",str,mIcon];
    
    str = [NSString stringWithFormat:@"\t%@\n}\n",str];
    return str;

}

@end

@implementation RosenTodayWeather
@synthesize mIcon,mLowTmp,mHighTmp,mCurTmp,mSunSet,mSunRise,mWindSpeed,mWindDegree,mFeelLikeTmp,mHumidityTmp,
mPrecipitation,mWindDirection,mText;

-(RosenTodayWeather*) init {
    self = [super init];
    if(self) {
        
        
        
        
    }
    return self;
}

-(NSString *) description {
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
@end
