//
//  RouteSettingObj.m
//  touch
//
//  Created by Milo Chen on 10/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteSettingObj.h"
#import "ParseHelper.h"


@implementation Waypoint
@synthesize lat,lng;
@end


@implementation RouteSettingObj 
@synthesize mName;
@synthesize mIsFri,mIsMon,mIsSat,mIsSun,mIsThu,mIsTue,mIsWed;
@synthesize mStartTime,mEndTime;
@synthesize mFromWhere,mToWhere;
@synthesize mEncodedPolyline;
@synthesize mIsEnable;


static ParseHelper * mParseHelper = nil;

- (id) init
{
    if (!(self = [super init])) return self;
    mName = @"";
    mFromWhere = @"";
    mToWhere = @"";
    mStartTime = @"";
    mEndTime = @"";
    mIsMon = YES;
    mIsTue = YES;
    mIsWed = YES;
    mIsThu = YES;
    mIsFri = YES;
    mIsSat = YES;    
    mIsSun = NO;
    mIsEnable = YES;
    return self;
}

static NSString * nokiaAppid = @"GWwd-IsChXy_iDmur2VK";
static NSString * nokiaToken = @"flQk_dpyaLAMgHQSjcJjlw";


+(NSString*) getPolylineFrom:(NSString*)fromWhere toWhere:(NSString*)toWhere 
{
    NSString * polylineStr = @"_tveFvahiV}@vCm@rBo@xBe@|A{AlF{AhF{AjF";
    NSURL * url = [NSURL URLWithString:@"http://rosenapp.com/api.class"];
    if(mParseHelper == nil) mParseHelper = [[ParseHelper alloc]init];
    if(toWhere == nil || fromWhere == nil) {
        return nil;
    }

    NSString * destStr = toWhere;
    NSString * origStr = fromWhere;
    NSDictionary *paramDict = [NSDictionary dictionaryWithObjectsAndKeys:destStr,@"to", origStr, @"from", @"route",@"action",nil];    
    
    url = [mParseHelper urlByAddingParameters:paramDict inURL:url];
    NSString *urlStr = [url absoluteString];
    
    NSString *xmlStr = [mParseHelper getSyncXmlWithUrlStr:urlStr];
    xmlStr = [mParseHelper stringByRemovingNewLinesAndWhitespace:xmlStr];
    
    polylineStr = [mParseHelper extractValueByPattern:@"<points>(.*?)</points>" inTxtStr:xmlStr];    
    polylineStr = [polylineStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return polylineStr;
}

+ (NSMutableArray *) decodePolyline:(NSString *)encodedPoints 
{
    NSString *escapedEncodedPoints = [encodedPoints stringByReplacingOccurrencesOfString:@"\\\\" withString:@"\\"];
    int len = [escapedEncodedPoints length];
    NSMutableArray *waypoints = [[NSMutableArray alloc] init];
    int index = 0;
    float lat = 0;
    float lng = 0;
    while (index < len) {
        char b;
        int shift = 0;
        int result = 0;
        do {
            b = [escapedEncodedPoints characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        
        float dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        
        shift = 0;
        result = 0;
        do {
            b = [escapedEncodedPoints characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        
        float dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        
        float finalLat = lat * 1e-5;
        float finalLong = lng * 1e-5;
        
        Waypoint * newPoint = [[Waypoint alloc] init];
        newPoint.lat = [[NSString alloc] initWithFormat:@"%f", finalLat];
        newPoint.lng = [[NSString alloc] initWithFormat:@"%f", finalLong];
        [waypoints addObject:newPoint];
        
        //[newPoint release];
        newPoint = nil;
    }
    return waypoints;
}


+(NSString*) getIncidentUrlStrByPolylineArray:(NSMutableArray*)polylineArray 
{
//    NSLog(@"getIncidentUrlStrByPolylineArray");
    NSString * corridor = @"";
    int idx;
    for ( idx = 0; idx < [polylineArray count]; idx++ ) {
        Waypoint * point = (Waypoint*)[polylineArray objectAtIndex:idx];
//        NSLog(@"(lat,lng)[%d]=(%@,%@)", idx, point.lat, point.lng);
        corridor = [corridor stringByAppendingFormat:@"%@,%@;",point.lat,point.lng];
    }
    corridor = [corridor stringByAppendingFormat:@"10000"];
    NSString * appid = @"GWwd-IsChXy_iDmur2VK";
    NSString * token = @"flQk_dpyaLAMgHQSjcJjlw";
    
//    NSString * appid = nokiaAppid;
//    NSString * token = nokiaToken;
    
    NSDictionary *paramDict2 = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", appid, @"app_id", corridor,@"corridor",nil];
    NSURL * url2 = [NSURL URLWithString:@"http://traffic.nlp.nokia.com/traffic/6.0/incidents.xml"];
    url2 = [mParseHelper urlByAddingParameters:paramDict2 inURL:url2];
    
    NSString *urlStr2 = [url2 absoluteString];
    return urlStr2;
}

-(BOOL) isInWorkTime
{
   // return YES;
    
    NSString * startTime = @"01:23:45";
    NSString * endTime = @"05:00:00";

    startTime = self.mStartTime;
    endTime = self.mEndTime;
    
    NSDate *today = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents * components = [gregorian components:unitFlags fromDate:today];
    NSLog(@"today info is day = %d, month = %d, year = %d weekday = %d, hour = %d, minute = %d, second = %d", components.day, components.month, components.year, components.weekday, components.hour, components.minute, components.second);
    
    int curWeekday = components.weekday;
    int curHour = components.hour;
    int curMinute = components.minute;
    int curSecond = components.second;
    
    BOOL isCurTimeBiggerThanStartTime = YES;
    BOOL isCurTimeSmallerThanEndTime = YES;
    BOOL isHitWeekday = NO;
    if(startTime != nil && ![startTime isEqual:@""])
    {
        int startHour = [[startTime substringWithRange:NSMakeRange(0,2)] intValue];
        int startMinute = [[startTime substringWithRange:NSMakeRange(3,2)] intValue];
        int startSecond = [[startTime substringWithRange:NSMakeRange(6,2)] intValue];
        if(startHour > curHour) {
            isCurTimeBiggerThanStartTime = NO;
        } else if(startHour == curHour && startMinute > curMinute) {
            isCurTimeBiggerThanStartTime = NO;
        } else if(startMinute  == curMinute && startSecond > curSecond) {
            isCurTimeBiggerThanStartTime = NO;
        }
    }
    
    if(endTime != nil && ![endTime isEqual:@""])
    {
        int endHour = [[endTime substringWithRange:NSMakeRange(0,2)] intValue];
        int endMinute = [[endTime substringWithRange:NSMakeRange(3,2)] intValue];
        int endSecond = [[endTime substringWithRange:NSMakeRange(6,2)] intValue];
        
        if( endHour < curHour) {
            isCurTimeSmallerThanEndTime = NO;
            NSLog(@"endHour < curHour");
        } else if(endHour == curHour && endMinute < curMinute) {
            isCurTimeSmallerThanEndTime = NO;
            NSLog(@"endMinute < curMinute");
        } else if(endMinute  == curMinute && endSecond < curSecond) {
            isCurTimeSmallerThanEndTime = NO;
            NSLog(@"endSecond < curSecond");
        }
    }
    
    if(isCurTimeBiggerThanStartTime) NSLog(@"cur time bigger than start time");
    if(isCurTimeSmallerThanEndTime) NSLog(@"cur time smaller then end time");
    
    switch (curWeekday)
    {
        case 2:
            if(self.mIsMon) isHitWeekday = YES;
            break;
        case 3:
            if(self.mIsTue) isHitWeekday = YES;
            break;
        case 4:
            if(self.mIsWed) isHitWeekday = YES;
            break;
        case 5:
            if(self.mIsThu) isHitWeekday = YES;
            break;
        case 6:
            if(self.mIsFri) isHitWeekday = YES;
            break;
        case 7:
            if(self.mIsSat) isHitWeekday = YES;
            break;
        default: //presume sunday with 0 or 7 value. but I don't know real value for sunday
            if(self.mIsSun) isHitWeekday = YES;
            break;
    }
    if(isHitWeekday) NSLog(@"cur time is hit weekday");
    if(isHitWeekday && isCurTimeBiggerThanStartTime && isCurTimeSmallerThanEndTime) {
        return YES;
    }
    else {
        return NO;
    }
}
@end
