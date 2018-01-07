//
//  TrafficObjForWidget.m
//  touch
//
//  Created by Milo Chen on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrafficObjForWidget.h"
#import "TrafficObject.h"
#import "ParseHelper.h"
@implementation TrafficObjForWidget

@synthesize mEndTime,mStartTime,mTrafficItemTypeDesc;
@synthesize mPointDesc,mRoadwayDesc,mDirectionLocalDesc;

@synthesize mRoadwaySignId,mTrafficSignId;
@synthesize mParseHelper;

-(UIImage*) getRoadwaySignImg {
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
    return [TrafficObjForWidget getRoadwaySignImgFromId:self.mRoadwaySignId];
    
}

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
    

}

-(UIImage*) getTrafficSignImg {
    if(mParseHelper == nil) 
    {
        mParseHelper = [[ParseHelper alloc]init];
    }
    
    if(self.mTrafficSignId == nil) {
        self.mTrafficSignId = self.mTrafficItemTypeDesc;
    }
    
    return [TrafficObject getTrafficSignImgFromId:self.mTrafficSignId];
}


+(UIImage*) getTrafficSignImgFromId:(NSString*)trafficSignId {
    if(trafficSignId == nil) 
    {
        return [UIImage imageNamed:@"j0824_traffic_sign_other_wraning.png"];
    }
    else 
    {
        return [UIImage imageNamed:@"j0824_traffic_sign_construction.png"];
    }
}


-(TrafficObjForWidget*) init
{ 
    self = [super init];
    if(self) {
        self.mTrafficItemTypeDesc=@"";
        self.mEndTime = @"";
        self.mStartTime = @"";
        self.mPointDesc = @"";
        self.mRoadwayDesc = @"";
        self.mDirectionLocalDesc = @"";
    }
    return self;
    
}

-(void) reloadObjWidget 
{

}


-(void) loadObjWidget 
{
    
}


-(BOOL) isEmptyStr :(NSString*)str {
    if(str == nil || [str isEqualToString:@""] ) return YES;
    return NO;
}


@end
