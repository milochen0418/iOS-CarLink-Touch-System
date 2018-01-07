//
//  TrafficObject.m
//  touch
//
//  Created by Milo Chen on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrafficObject.h"
#import "ParseHelper.h"
#import "AppDelegate.h"





@implementation TrafficObject
@synthesize mEndTime,mStartTime,mTrafficItemTypeDesc;
@synthesize mPointDesc,mRoadwayDesc;
@synthesize mLat,mLng,mAlertcDesc,mPointLocalDesc,mCriticalityDesc,mTrafficItemDesc,mRoadwayLocalDesc,mDirectionLocalDesc;



@synthesize mRoadwaySignId,mTrafficSignId;
@synthesize mParseHelper;



-(BOOL) isEmptyStr :(NSString*)str {
    if(str == nil || [str isEqualToString:@""] ) return YES;
    return NO;
}



//From Kevin's letter
//I believe there should be 3 classifications of road:
//* Freeway (I, Interstate, Frwy)
//* Highway (Highway, Hwy, Route, CA-, SR-, NV-, US-, 2chr followed by dash followed by number)
//* Street (Road, Street, Drive, Boulevard, Avenue, Rd, St, Dr, Blvd, Av)
//
//* 4th would be blank if no road variable, for instance weather, planned event, other news, etc.
//
//In the traffic page, use
//
//Freeway; interstate icon without '0' (you should already have)
//Highway; highway icon without '0' (I will provide tomorrow)
//Street; Street icon


-(UIImage*) getRoadwaySignImg
{
    
    
    if(mParseHelper == nil) mParseHelper = [[ParseHelper alloc]init];
    
    NSString * tmpId;
//    self.mRoadwaySignId.mSignFullName = self.mRoadwayDesc;
    NSString * fullName = self.mRoadwayDesc;
//    if([self isEmptyStr:self.mRoadwaySignId.mSignFullName]) mRoadwaySignId.mSignFullName=@"";
    
    if([self isEmptyStr:fullName]) fullName=@"";    

    NSString * grepInterstate = [mParseHelper extractValueByPattern:@"(Interstate )" inTxtStr:fullName];
    NSString * grepFrwy = [mParseHelper extractValueByPattern:@"(Frwy )" inTxtStr:fullName];
    NSString * grepHighway = [mParseHelper extractValueByPattern:@"(Highway )" inTxtStr:fullName];
    NSString * grepHwy = [mParseHelper extractValueByPattern:@"(Hwy )" inTxtStr:fullName];
    NSString * grepRoute = [mParseHelper extractValueByPattern:@"(Route )" inTxtStr:fullName];
    
    NSString * grepI = [mParseHelper extractValueByPattern:@"(I-)" inTxtStr:fullName];
    NSString * grepCA = [mParseHelper extractValueByPattern:@"(CA-)" inTxtStr:fullName];
    NSString * grepSR = [mParseHelper extractValueByPattern:@"(SR-)" inTxtStr:fullName];    
    NSString * grepNV = [mParseHelper extractValueByPattern:@"(NV-)" inTxtStr:fullName];
    NSString * grepUS = [mParseHelper extractValueByPattern:@"(US-)" inTxtStr:fullName];
    NSString * grepRoad = [mParseHelper extractValueByPattern:@"(Road )" inTxtStr:fullName];
    NSString * grepStreet = [mParseHelper extractValueByPattern:@"(Street )" inTxtStr:fullName];
    NSString * grepDrive = [mParseHelper extractValueByPattern:@"(Drive )" inTxtStr:fullName];
    NSString * grepBoulevard = [mParseHelper extractValueByPattern:@"(Boulevard )" inTxtStr:fullName];
    NSString * grepAvenue = [mParseHelper extractValueByPattern:@"(Avenue )" inTxtStr:fullName];
    NSString * grepRd = [mParseHelper extractValueByPattern:@"(Rd )" inTxtStr:fullName];
    NSString * grepSt = [mParseHelper extractValueByPattern:@"(St )" inTxtStr:fullName];
    NSString * grepDr = [mParseHelper extractValueByPattern:@"(Dr )" inTxtStr:fullName];    
    NSString * grepBlvd = [mParseHelper extractValueByPattern:@"(Blvd )" inTxtStr:fullName];
    NSString * grepAv = [mParseHelper extractValueByPattern:@"(Av )" inTxtStr:fullName];    
    
    
    if(self.mRoadwaySignId == nil) 
    {
        self.mRoadwaySignId = [[RoadwaySignId alloc]init];
        if(![self isEmptyStr:grepCA] || ![self isEmptyStr:grepSR] || ![self isEmptyStr:grepNV] || ![self isEmptyStr:grepUS] || ![self isEmptyStr:grepUS] || ![self isEmptyStr:grepI])
        {
            NSString * extractStr = [mParseHelper extractValueByPattern:@"(.+?)-" inTxtStr:self.mRoadwayDesc];
            mRoadwaySignId.mRoadwayName = extractStr;
            mRoadwaySignId.mSignFullName = fullName;
            //mRoadwaySignId.mRoadwayNumber = @"";
            NSString * roadwayNumber = @"";
            roadwayNumber = [mParseHelper extractValueByPattern:@".+?-(.+?)$" inTxtStr:fullName];
            if([self isEmptyStr:roadwayNumber])
            {
                roadwayNumber = [mParseHelper extractValueByPattern:@".+?-(.+?) " inTxtStr:fullName];
            }
            
            if([self isEmptyStr:roadwayNumber]) 
            {
                mRoadwaySignId.mRoadwayNumber = @"";
            }
            else 
            {
                mRoadwaySignId.mRoadwayNumber = roadwayNumber;
            }
            
            if(![self isEmptyStr:grepI]) 
            {
                mRoadwaySignId.mRoadImgType = @"freeway";
            }
            else 
            {
                mRoadwaySignId.mRoadImgType = @"highway";
            }
        }
        else if(![self isEmptyStr:grepInterstate] || ![self isEmptyStr:grepFrwy])
        {
            mRoadwaySignId.mRoadImgType = @"freeway";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = @"";
            if(![self isEmptyStr:grepInterstate])
            {
                mRoadwaySignId.mRoadwayName = grepInterstate;
            }
            else if (![self isEmptyStr:grepFrwy]) 
            {
                mRoadwaySignId.mRoadwayName = grepFrwy;
            }
        }
        else if(![self isEmptyStr:grepRoad]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepRoad;
        }
        else if(![self isEmptyStr:grepStreet]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepStreet;
        }
        else if(![self isEmptyStr:grepDrive]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepDrive;
        }
        else if(![self isEmptyStr:grepBoulevard]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepBoulevard;
        }
        else if(![self isEmptyStr:grepAvenue]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepAvenue;
        }
        else if(![self isEmptyStr:grepRd]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepRd;
        }
        else if(![self isEmptyStr:grepSt]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepSt;
        }
        else if(![self isEmptyStr:grepDr]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepDr;
        }
        else if(![self isEmptyStr:grepBlvd]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepBlvd;
        }
        else if(![self isEmptyStr:grepAv]) {
            mRoadwaySignId.mRoadImgType = @"street";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayNumber = @"";
            mRoadwaySignId.mRoadwayName = grepAv;
        }
        else 
        {
            mRoadwaySignId.mRoadImgType = @"blank";
            mRoadwaySignId.mSignFullName = fullName;
            mRoadwaySignId.mRoadwayName = @"";
            mRoadwaySignId.mSignFullName = @"";
        }
    }    
    return [TrafficObject getRoadwaySignImgFromId:self.mRoadwaySignId];
}


//+(UIImage*) getRoadwaySignImgFromId:(NSString*)roadwaySignId {    
+(UIImage*) getRoadwaySignImgFromId:(RoadwaySignId*)roadwaySignId 
{
//    return nil;
    
    if( roadwaySignId == nil ) return nil ;
    if( roadwaySignId.mRoadImgType == nil ) return nil;
    if( [roadwaySignId.mRoadImgType isEqualToString:@""] ) return nil;
    if( [roadwaySignId.mRoadImgType isEqualToString:@"blank"]) return nil;
    
    
    if([roadwaySignId.mRoadImgType isEqualToString:@"freeway"]) {
        return [UIImage imageNamed:@"j1024-roadway-freeway.png"];
    }
    else if([roadwaySignId.mRoadImgType isEqualToString:@"highway"]){
        return [UIImage imageNamed:@"j1024-roadway-highway.png"];
    }
    else if([roadwaySignId.mRoadImgType isEqualToString:@"street"]) {
        return [UIImage imageNamed:@"j1024-roadway-street.png"];
    }
    else {
        return nil;
    }
        
//    if(roadwaySignId == nil)
//    {
//        return [UIImage imageNamed:@"j0824_roadway_sign_interstate_0.png"];
//    }
//    else if([roadwaySignId isEqualToString:@"CA"]){
//        return [UIImage imageNamed:@"j0824_roadway_sign_highway.png"];        
//    }
//    else if([roadwaySignId isEqualToString:@"I"]){
//        return [UIImage imageNamed:@"j0824_roadway_sign_interstate.png"];        
//    }
//    else
//    {
//        return [UIImage imageNamed:@"j0824_roadway_sign_interstate_0.png"];           
//    }
}

-(UIImage*) getTrafficSignImg 
{
    if(mParseHelper == nil) 
    {
        mParseHelper = [[ParseHelper alloc]init];
    }
    
    if(self.mTrafficSignId == nil) 
    {
        self.mTrafficSignId = self.mTrafficItemTypeDesc;
    }

    return [TrafficObject getTrafficSignImgFromId:self.mTrafficSignId];    
}

+(UIImage*) getTrafficSignImgFromId:(NSString*)trafficSignId 
{
    if(trafficSignId == nil) 
    {
        return [UIImage imageNamed:@"j1012-incident-warning.png"];
    }
    else 
    {
        if([trafficSignId isEqualToString:@"SCHEDULED CONSTRUCTION"]) {
            return [UIImage imageNamed:@"j1012-incident-construction.png"];
        } 
        else if([trafficSignId isEqualToString:@"ACCIDENT"]) {
            return [UIImage imageNamed:@"j1012-incident-accident.png"];
        }
        else if([trafficSignId isEqualToString:@"CONGESTION"]) {
            return [UIImage imageNamed:@"j1012-incident-congestion.png"];
        }
        else if([trafficSignId isEqualToString:@"DISABLED VEHICLE"]) {
            return [UIImage imageNamed:@"j1012-incident-accident.png"];
        }
        else if([trafficSignId isEqualToString:@"MASS TRANSIT"]) {
            return [UIImage imageNamed:@"j1012-incident-warning.png"];
        }
        else if([trafficSignId isEqualToString:@"ROAD HAZARD"]) {
            return [UIImage imageNamed:@"j1012-incident-warning.png"];
        }
        else if([trafficSignId isEqualToString:@"CONSTRUCTION"]) {
            return [UIImage imageNamed:@"j1012-incident-construction.png"];
        }        
        else if([trafficSignId isEqualToString:@"PLANNED EVENT"]) {
            return [UIImage imageNamed:@"j1012-incident-event.png"];
        }
        else if([trafficSignId isEqualToString:@"OTHER NEWS"]) {
            return [UIImage imageNamed:@"j1012-incident-warning.png"];
        }
        else if([trafficSignId isEqualToString:@"WEATHER"]) {
            return [UIImage imageNamed:@"j1012-incident-weather.png"];
        }
        else if([trafficSignId isEqualToString:@"MISC"]) {
            return [UIImage imageNamed:@"j1012-incident-warning.png"];
        }
        return [UIImage imageNamed:@"j1012-incident-warning.png"];
    }
}


-(TrafficObject*) init
{ 
    self = [super init];
    if(self) {
        self.mTrafficItemTypeDesc=@"";
        self.mEndTime = @"";
        self.mStartTime = @"";
        self.mPointDesc = @"";
        self.mRoadwayDesc = @"";
        self.mLat=@"";
        self.mLng=@"";
        self.mAlertcDesc=@"";
        self.mPointLocalDesc=@"";
        self.mCriticalityDesc=@"";
        self.mTrafficItemDesc=@"";
        self.mRoadwayLocalDesc=@"";
        self.mDirectionLocalDesc=@"";
    }
    return self;
}




static ParseHelper *sParseHelper = nil;

+(NSMutableArray*) getTrafficObjectArrayFromIncidentUrlStr: (NSString*)urlStr 
{
    if(sParseHelper == nil) sParseHelper = [[ParseHelper alloc]init];
    ParseHelper * mParseHelper = sParseHelper;
    NSMutableArray * mTrafficObjs = nil;

    NSString * tmpXmlUrlStr = [NSString stringWithFormat:@"http://%@/RosenTouch/TrafficApp/incident.xml", [AppDelegate getHostName]];
    
//    if(mIncidentXmlUrls != nil ) {
//        NSString * incidentXmlUrl = [mIncidentXmlUrls objectAtIndex:0];
//        tmpXmlUrlStr = incidentXmlUrl;
//        NSLog(@"tmpXmlUrlStr = %@", tmpXmlUrlStr);
//    }
    if(urlStr!= nil) {
        tmpXmlUrlStr = urlStr;
    }
    
    
    NSString * xmlStrTmp = [mParseHelper getXmlStringFromUrlStr:tmpXmlUrlStr];
    
//    NSLog(@"xmlStrTmp = %@", xmlStrTmp);        
    NSString *xmlStr = [mParseHelper stringByRemovingNewLinesAndWhitespace:xmlStrTmp];
    
    NSString *trafficItemsVal = [mParseHelper extractValueBetweenTag:@"TRAFFIC_ITEMS" inXmlStr:xmlStr];
    NSMutableArray *arr = nil;
    if(trafficItemsVal != nil) {
        arr = [mParseHelper extractStrArrayBySameTwoTag:@"TRAFFIC_ITEM" inXmlStr:trafficItemsVal];    
    }
    
    
    if(arr != nil && [arr count]>0){
        int idx;
        for(idx = 0; idx < [arr count]; idx++ ) 
        {
            NSString * testCDATA = nil;
            NSString * str = [arr objectAtIndex:idx];
            NSString * trafficItemTypeDesc = [mParseHelper extractValueBetweenTag:@"TRAFFIC_ITEM_TYPE_DESC" inXmlStr:str];
            NSString * startTime = [mParseHelper extractValueBetweenTag:@"START_TIME" inXmlStr:str];
            NSString * endTime = [mParseHelper extractValueBetweenTag:@"END_TIME" inXmlStr:str];
            
            NSString * roadwayStr = [mParseHelper extractValueBetweenBeginStr:@"<ROADWAY ID=\"" andEndStr:@"</ROADWAY>" inTxtStr:str];
            
            NSString * pointStr = [mParseHelper extractValueBetweenBeginStr:@"<POINT ID=\"" andEndStr:@"</POINT>" inTxtStr:str];
            NSString * roadwayDesc = [mParseHelper extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"NTCSA\">" andEndStr:@"</DESCRIPTION>" inTxtStr:roadwayStr];
            
            
            testCDATA = [mParseHelper extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:roadwayDesc];
            if(testCDATA != nil) roadwayDesc = testCDATA;
            
            NSString * pointDesc = [mParseHelper extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"LOCAL\">" andEndStr:@"</DESCRIPTION>" inTxtStr:pointStr];
            //pointDesc = [mParseHelper extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:pointDesc];
            testCDATA = [mParseHelper extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:pointDesc];
            if(testCDATA != nil ) pointDesc = testCDATA;
            
            
            NSString * trafficItemDesc = [mParseHelper extractValueBetweenBeginStr:@"<TRAFFIC_ITEM_DESCRIPTION TYPE=\"desc\">" andEndStr:@"</TRAFFIC_ITEM_DESCRIPTION>" inTxtStr:str];
            //trafficItemDesc = [mParseHelper extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:trafficItemDesc];
            
            testCDATA = [mParseHelper extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:trafficItemDesc];
            if(testCDATA != nil) trafficItemDesc = testCDATA;
            
            NSString * lat = [mParseHelper extractValueBetweenTag:@"GEOLOC" inXmlStr:str];
            lat = [mParseHelper extractValueBetweenTag:@"ORIGIN" inXmlStr:lat];
            lat = [mParseHelper extractValueBetweenTag:@"LATITUDE" inXmlStr:lat];
            
            
            NSString * lng = [mParseHelper extractValueBetweenTag:@"GEOLOC" inXmlStr:str];
            lng = [mParseHelper extractValueBetweenTag:@"ORIGIN" inXmlStr:lng];
            lng = [mParseHelper extractValueBetweenTag:@"LONGITUDE" inXmlStr:lng];
            
            NSString * directionLocalDesc = [mParseHelper extractValueBetweenTag:@"LOCATION" inXmlStr:str];
            directionLocalDesc = [mParseHelper extractValueBetweenTag:@"DEFINED" inXmlStr:directionLocalDesc];
            directionLocalDesc = [mParseHelper extractValueBetweenTag:@"ORIGIN" inXmlStr:directionLocalDesc];
            directionLocalDesc = [mParseHelper extractValueBetweenTag:@"DIRECTION" inXmlStr:directionLocalDesc];
            directionLocalDesc = [mParseHelper extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"LOCAL\">" andEndStr:@"</DESCRIPTION>" inTxtStr:directionLocalDesc];
            //if(directionLocalDesc == nil) directionLocalDesc = @"no direction local desc";
            if(directionLocalDesc == nil) directionLocalDesc = @"";
            
            NSString * pointLocalDesc = [mParseHelper extractValueBetweenTag:@"LOCATION" inXmlStr:str];
            pointLocalDesc = [mParseHelper extractValueBetweenTag:@"DEFINED" inXmlStr:pointLocalDesc];
            pointLocalDesc = [mParseHelper extractValueBetweenTag:@"ORIGIN" inXmlStr:pointLocalDesc];
            pointLocalDesc = [mParseHelper extractValueBetweenBeginStr:@"<POINT ID=\"" andEndStr:@"</POINT>" inTxtStr:pointLocalDesc];
            pointLocalDesc = [mParseHelper extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"LOCAL\">" andEndStr:@"</DESCRIPTION>" inTxtStr:pointLocalDesc];
            pointLocalDesc = [mParseHelper extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:pointLocalDesc];            
            //if(pointLocalDesc == nil) pointLocalDesc = @"no point local desc";
            if(pointLocalDesc == nil) pointLocalDesc = @"";
            
            //            NSString * roadwayLocalDesc;
            NSString * roadwayLocalDesc = [mParseHelper extractValueBetweenTag:@"LOCATION" inXmlStr:str];
            roadwayLocalDesc = [mParseHelper extractValueBetweenTag:@"DEFINED" inXmlStr:roadwayLocalDesc];
            roadwayLocalDesc = [mParseHelper extractValueBetweenTag:@"ORIGIN" inXmlStr:roadwayLocalDesc];
            roadwayLocalDesc = [mParseHelper extractValueBetweenBeginStr:@"<ROADWAY ID=\"" andEndStr:@"</ROADWAY>" inTxtStr:roadwayLocalDesc];
            roadwayLocalDesc = [mParseHelper extractValueBetweenBeginStr:@"<DESCRIPTION TYPE=\"LOCAL\">" andEndStr:@"</DESCRIPTION>" inTxtStr:roadwayLocalDesc];
            roadwayLocalDesc = [mParseHelper extractValueBetweenBeginStr:@"<!\\[CDATA\\[" andEndStr:@"\\]\\]" inTxtStr:roadwayLocalDesc];            
            //            if(roadwayLocalDesc == nil) roadwayLocalDesc = @"no roadway local desc";
            if(roadwayLocalDesc == nil) roadwayLocalDesc = @"";
            
            NSString * criticalityDesc = [mParseHelper extractValueBetweenTag:@"CRITICALITY" inXmlStr:str];
            criticalityDesc = [mParseHelper extractValueBetweenTag:@"DESCRIPTION" inXmlStr:criticalityDesc];
            
            NSString * alertcDesc=[mParseHelper extractValueBetweenTag:@"ALERTC" inXmlStr:str];
            alertcDesc = [mParseHelper extractValueBetweenTag:@"DESCRIPTION" inXmlStr:alertcDesc];
            //if(alertcDesc == nil) alertcDesc = @"no alertc desc";
            if(alertcDesc == nil) alertcDesc = @"";
            
            TrafficObject * obj = [[TrafficObject alloc]init ];
            obj.mTrafficItemTypeDesc = trafficItemTypeDesc;
            obj.mTrafficItemDesc = trafficItemDesc;
            obj.mLat = lat;
            obj.mLng = lng;
            directionLocalDesc = [mParseHelper extractValueByPattern:@"(.+?)bound" inTxtStr:directionLocalDesc];
            obj.mDirectionLocalDesc = directionLocalDesc;
            
            obj.mStartTime = startTime;
            obj.mEndTime = endTime;
            obj.mPointDesc = pointDesc;
            obj.mPointLocalDesc = pointLocalDesc;
            obj.mRoadwayDesc = roadwayDesc;
            obj.mRoadwayLocalDesc = roadwayLocalDesc;
            
            obj.mCriticalityDesc = criticalityDesc;
            obj.mAlertcDesc = alertcDesc;
            
            //            if(obj.mPointDesc== nil ) obj.mPointDesc = @"no roadway";
            if(obj.mPointDesc== nil ) obj.mPointDesc = @"";
            //            if(obj.mRoadwayDesc == nil) obj.mRoadwayDesc = @"no point";
            if(obj.mRoadwayDesc == nil) obj.mRoadwayDesc = @"";
//            NSLog(@"RoadwayDesc=%@ ,PointDesc = %@", obj.mRoadwayDesc, obj.mPointDesc);
            
            if(mTrafficObjs ==nil) {
                mTrafficObjs = [NSMutableArray arrayWithCapacity:1];
            }
            [mTrafficObjs addObject:obj];
        }
    }
    return mTrafficObjs;    
}


-(void) reloadObj
{
    
}


-(void) loadObj
{
    
}



@end




