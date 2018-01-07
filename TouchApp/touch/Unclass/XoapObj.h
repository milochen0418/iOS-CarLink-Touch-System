//
//  XoapObj.h
//  helloworld.testXoapQuery
//
//  Created by Milo Chen on 10/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ParseHelper;
@interface XoapObj : NSObject 
{}

@property (nonatomic,strong) NSString *mId;
@property (nonatomic,strong) NSString *mType;
@property (nonatomic,strong) NSString *mCitySt;
@property (nonatomic,strong) ParseHelper *mParseHelper;
+(NSString *) getQueryUrl:(XoapObj*)obj withMetric:(NSString*)metric;

@end
