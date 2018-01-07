//
//  XOAPWhereDom.h
//  helloworld
//
//  Created by Milo Chen on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XOAPLoc;

@interface XOAPWhereDom : NSObject <NSXMLParserDelegate>{
    NSMutableArray * mLocArray;
    XOAPLoc *mTmpLoc;
}
-(NSString *) description;
@property (nonatomic,strong) XOAPLoc *mTmpLoc;
@property (nonatomic,strong) NSMutableArray *mLocArray;



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict ;
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string ;
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName ;


@end


@interface XOAPLoc : NSObject {
    NSString * mWeatherId;
    NSString * mType;
    NSString * mName;
}
-(NSString *) description;
@property (nonatomic,strong) NSString * mWeatherId;
@property (nonatomic,strong) NSString * mType;
@property (nonatomic,strong) NSString * mName;

@end


