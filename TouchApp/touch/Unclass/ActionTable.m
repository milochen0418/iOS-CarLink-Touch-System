//
//  ActionTable.m
//  helloworld.testUITableView
//
//  Created by Milo Chen on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionTable.h"
//#import "DTCustomColoredAccessory.h"

@implementation ActionTable
@synthesize  mTexts,mTableView,mSelStrs,mDidSelectedIndexPath;
@synthesize mPerformer;

-(ActionTable *) initWithPerformer:(NSObject*)performer andTable:(UITableView*)tableView andTextArray:(NSMutableArray*)textArray andSelStrArray:(NSMutableArray*)selStrArray {
    self = [super init];
    if(self) 
    {
        self.mPerformer = performer;
        self.mSelStrs = selStrArray;
        self.mTableView = tableView;
        self.mTexts = textArray;
        mTableView.delegate = self;
        mTableView.dataSource = self;
    }
    return self;
}




//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

//UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    mDidSelectedIndexPath = indexPath;
    int idx = indexPath.row;
    NSString * selStr = [self.mSelStrs objectAtIndex:idx];
    if(selStr == nil ) return;
    SEL sele = NSSelectorFromString(selStr);
    [mPerformer performSelector:sele withObject:nil];    
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//UITableViewDelegate
-(NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section 
{
    if(mTexts == nil) return 0;
    return [mTexts count];
}

//UITableViewDelegate
-(UITableViewCell*) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath 
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];        
        cell.textLabel.textColor = [UIColor whiteColor];
    }
//    cell.textLabel.text= (NSString*)[mTableTexts objectAtIndex:indexPath.row];    
      cell.textLabel.text= (NSString*)[mTexts objectAtIndex:indexPath.row];      
    //    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:cell.textLabel.textColor];
    accessory.highlightedColor = [UIColor blackColor];
    cell.accessoryView =accessory;
    return cell;
}

//UITableViewDelegate for section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//UITableViewDelegate for section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
//    NSString * sectionStr = [NSString stringWithFormat:@"Section %d",(int)section];
//    return sectionStr;
    return nil;
}



//UITableViewDelegate for section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    //customize for section header
    int SectionHeaderHeight = 30;
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    int maxWidth = mTableView.frame.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, SectionHeaderHeight)];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    int borderWidth = 10;
    btn.frame = CGRectMake(borderWidth,6,maxWidth-2*borderWidth,30);
    //btn.titleLabel.text = sectionTitle;
    [btn setTitle:sectionTitle forState:UIControlStateNormal];
    btn.alpha = 0.5;
    [view addSubview:btn];
    return view;    
}


@end














@implementation DTCustomColoredAccessory

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//- (void)dealloc
//{
//	[_accessoryColor release];
//	[_highlightedColor release];
//    [super dealloc];
//}

+ (DTCustomColoredAccessory *)accessoryWithColor:(UIColor *)color
{
    //	DTCustomColoredAccessory *ret = [[[DTCustomColoredAccessory alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)] autorelease];
	DTCustomColoredAccessory *ret = [[DTCustomColoredAccessory alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
    
	ret.accessoryColor = color;
    
	return ret;
}

- (void)drawRect:(CGRect)rect
{
	// (x,y) is the tip of the arrow
	CGFloat x = CGRectGetMaxX(self.bounds)-3.0;;
	CGFloat y = CGRectGetMidY(self.bounds);
	const CGFloat R = 4.5;
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
    
	if (self.highlighted)
	{
		[self.highlightedColor setStroke];
	}
	else
	{
		[self.accessoryColor setStroke];
	}
    
	CGContextStrokePath(ctxt);
}

- (void)setHighlighted:(BOOL)highlighted
{
    //	[super setHighlighted:highlighted];
  	[super setHighlighted:NO];  
	[self setNeedsDisplay];
}

- (UIColor *)accessoryColor
{
	if (!_accessoryColor)
	{
		//return [UIColor blackColor];
        return [UIColor whiteColor]; //change by milo 
	}
    
	return _accessoryColor;
}

- (UIColor *)highlightedColor
{
	if (!_highlightedColor)
	{
		return [UIColor whiteColor];
	}
    
	return _highlightedColor;
}

@synthesize accessoryColor = _accessoryColor;
@synthesize highlightedColor = _highlightedColor;

@end
