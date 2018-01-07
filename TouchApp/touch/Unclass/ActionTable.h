//
//  ActionTable.h
//  helloworld.testUITableView
//
//  Created by Milo Chen on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionTable : NSObject <UITableViewDelegate, UITableViewDataSource>{
    UITableView * mTableView;
    NSMutableArray * mTexts;
    NSMutableArray * mSelStrs;    
    NSIndexPath* mDidSelectedIndexPath;
    NSObject * mPerformer;
}

@property (nonatomic,strong) UITableView * mTableView;
@property (nonatomic,strong) NSMutableArray * mTexts;
@property (nonatomic,strong) NSMutableArray * mSelStrs;    
@property (nonatomic,strong) NSIndexPath * mDidSelectedIndexPath;
@property (nonatomic,strong) NSObject * mPerformer;

-(ActionTable *) initWithPerformer:(NSObject*)performer andTable:(UITableView*)tableView andTextArray:(NSMutableArray*)textArray andSelStrArray:(NSMutableArray*)selStrArray;


@end


@interface DTCustomColoredAccessory : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color;

@end
