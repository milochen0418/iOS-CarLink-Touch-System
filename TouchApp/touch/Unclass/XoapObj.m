//
//  XoapObj.m
//  helloworld.testXoapQuery
//
//  Created by Milo Chen on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XoapObj.h"
#import "ParseHelper.h"

@implementation XoapObj

@synthesize mId,mType,mCitySt;
@synthesize mParseHelper;
-(XoapObj*) init {
    self = [super init];
    if(self) {
        self.mId=@"";
        self.mCitySt=@"";
        self.mType=@"";
    }
    return self;
}



+(NSString *) getQueryUrl:(XoapObj*)obj withMetric:(NSString*)metric {
    ParseHelper * mParseHelper = [[ParseHelper alloc] init];
    NSString * newLocId = obj.mCitySt;
    newLocId = [mParseHelper extractValueByPattern:@"(.*?,.*?)(\\(|$)" inTxtStr:newLocId];    
    newLocId = [newLocId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:newLocId];
    newLocId = encodedNewLocId;
    
    NSString * rosenWeatherURL = [NSString stringWithFormat:@"http://rosenapp.com/api.class?action=weather&loc_id=%@&metric=%@", newLocId, metric]; 
    return rosenWeatherURL;
}


@end
