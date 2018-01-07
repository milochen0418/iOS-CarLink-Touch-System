//
//  XOAPWhereDom.m
//  helloworld
//
//  Created by Milo Chen on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XOAPWhereDom.h"


@implementation XOAPWhereDom 

@synthesize mLocArray;
@synthesize mTmpLoc;

-(XOAPWhereDom*) init {
    self = [super init];
    if(self) {
        self.mLocArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}





-(NSString *) description {
//    int idx;
    if(mLocArray == nil ) 
    {
        return @"mLocArray is nil";
    } 
    else if([mLocArray count] == 0 ) 
    {
        return  @"[mLocArray count] == 0 ";
    } 
    else 
    {
        NSString * str = @"";
        int idx;
        for ( idx = 0; idx < [mLocArray count]; idx++ ) 
        {
            NSString * desc = @"";
            XOAPLoc * loc = [mLocArray objectAtIndex:idx];
            if(loc != nil) {
                desc = [loc description];
            } 
            else 
            {   
                desc = @"nil";
            }
            str = [NSString stringWithFormat:@"%@\n[%d]=%@", str,idx, desc];
        }
        return str;
    }
}



//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
    
    NSLog(@"didStartElement with elementName = %@ attr = %@", elementName, attributeDict);
    
    if ([elementName isEqualToString:@"loc"]) 
    {
        mTmpLoc = [[XOAPLoc alloc]init];
        NSString * idStr = (NSString*)[attributeDict valueForKey:@"id"];
        NSString * typeStr = (NSString*)[attributeDict valueForKey:@"type"];
        mTmpLoc.mType = typeStr;
        mTmpLoc.mWeatherId = idStr;
    } 
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    mTmpLoc.mName = string;
}



//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
    NSLog(@"didEndElement with elementName = %@", elementName);
    
    if ([elementName isEqualToString:@"loc"]) 
    {
        [self.mLocArray addObject:mTmpLoc];
        mTmpLoc = nil;
    }
}

@end


@implementation XOAPLoc 
@synthesize mName,mType,mWeatherId;
-(XOAPLoc*) init {
    self = [super init];
    if(self) {
 
    }
    return self;
}

-(NSString *) description 
{
    NSString * str = @"{";
    str = [NSString stringWithFormat:@"%@mWeatherId=%@\n",str,mWeatherId];
    str = [NSString stringWithFormat:@"%@mType=%@\n",str,mType];
    str = [NSString stringWithFormat:@"%@mName=%@\n",str,mName];
    str = [NSString stringWithFormat:@"%@\n}\n",str];
    return str;
}



@end

