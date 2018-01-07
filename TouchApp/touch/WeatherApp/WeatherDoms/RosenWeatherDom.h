//
//  RosenWeatherDom.h
//  helloworld
//
//  Created by Milo Chen on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RosenTodayWeather;
@class RosenDayWeather;

@interface RosenWeatherDom : NSObject <NSXMLParserDelegate> { 
    RosenTodayWeather * mToday;
    RosenDayWeather * mDay1;
    RosenDayWeather * mDay2;
    RosenDayWeather * mDay3;
    RosenDayWeather * mDay4;
    RosenDayWeather * mDay5;    
}

@property (nonatomic,strong) RosenTodayWeather *mToday;
@property (nonatomic,strong) RosenDayWeather *mDay1;
@property (nonatomic,strong) RosenDayWeather *mDay2;
@property (nonatomic,strong) RosenDayWeather *mDay3;
@property (nonatomic,strong) RosenDayWeather *mDay4;
@property (nonatomic,strong) RosenDayWeather *mDay5;

-(NSString *) description;



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict ;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string ;
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName ;


@end


@interface RosenTodayWeather : NSObject {
    NSString * mCurTmp;  //tmp
    NSString * mHighTmp; //hi
    NSString * mLowTmp; //lo
    NSString * mFeelLikeTmp; //flik
    NSString * mHumidityTmp; //hmid
    NSString * mPrecipitation; //ppcp
    NSString * mWindSpeed; //winds
    NSString * mWindDegree; //windt
    NSString * mWindDirection; //windd
    NSString * mIcon; //icon
    NSString * mText; //text
    NSString * mSunRise; //sunr
    NSString * mSunSet; //suns
}

-(NSString *) description;

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

@end



@interface RosenDayWeather : NSObject {
    NSString * mWeekDay; //t
    NSString * mMonthDay; //d
    NSString * mHighTmp; //hi
    NSString * mLowTmp; //lo
    NSString * mIcon; //icon
}

-(NSString *) description;
@property(nonatomic,strong) NSString * mWeekDay; //t
@property(nonatomic,strong) NSString * mMonthDay; //d
@property(nonatomic,strong) NSString * mHighTmp; //hi
@property(nonatomic,strong) NSString * mLowTmp; //lo
@property(nonatomic,strong) NSString * mIcon; //icon

@end
