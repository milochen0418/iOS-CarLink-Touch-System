//
//  ViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TrafficSettingsViewController.h"
#import "GlobalVars.h"
#import "ComboBoxDelegate.h"
#import "ActionTable.h"
#import "CoreDataHelper.h"
#import "RouteSettingEntity.h"



@implementation TrafficSettingsViewController

@synthesize mTableView;
@synthesize mObjArray;
@synthesize mCoreDataHelper;

-(void) editRouteSettingObj:(RouteSettingObj*)obj {
    NSLog(@"editRouteSettingObj");
    [self replaceConvertedObjArrayToCoreData];
}

-(void) addRouteSettingObj:(RouteSettingObj*)obj 
{
    NSLog(@"addRouteSettingObj");
    if(mObjArray == nil) {
        mObjArray = [NSMutableArray arrayWithCapacity:1];
    }
    [mObjArray addObject:obj];
    [self replaceConvertedObjArrayToCoreData];
}

-(void) deleteRouteSettingObj:(RouteSettingObj*)obj {
    NSLog(@"deleteRouteSettingObj");
    if(mObjArray == nil) return;
    [mObjArray removeObject:obj];
    if([mObjArray count]<= 0) {
        mObjArray = nil;
    }
    [self replaceConvertedObjArrayToCoreData];
}

-(void)replaceCoreDataToObjArray
{
    if(mObjArray == nil) {
        mObjArray = [NSMutableArray arrayWithCapacity:1];
    } 
    NSMutableArray * coreItems = [mCoreDataHelper readItems:@"RouteSettingEntity"];
    if(coreItems != nil && [coreItems count] > 0) 
    {
        [mObjArray removeAllObjects];
        int idx;
        for(idx = 0; idx < [coreItems count]; idx++) 
        {
            RouteSettingEntity* item = (RouteSettingEntity*)[coreItems objectAtIndex:idx];
            RouteSettingObj * obj = [[RouteSettingObj alloc]init];
            obj.mName = item.mName;
            obj.mEndTime = item.mEndTime;
            obj.mStartTime = item.mStartTime;
            obj.mFromWhere = item.mFromWhere;
            obj.mToWhere = item.mToWhere;
            obj.mIsFri = [item.mIsFri boolValue];
            obj.mIsMon = [item.mIsMon boolValue];
            obj.mIsSat = [item.mIsSat boolValue];
            obj.mIsSun = [item.mIsSun boolValue];
            obj.mIsThu = [item.mIsThu boolValue];
            obj.mIsTue = [item.mIsTue boolValue];
            obj.mIsWed = [item.mIsWed boolValue];
            obj.mIsEnable = [item.mIsEnable boolValue];
            [mObjArray addObject:obj];
        }
    }
}


-(void) replaceConvertedObjArrayToCoreData {
    NSLog(@"replaceConvertedObjArrayToCoreData");
    NSString * entityName = @"RouteSettingEntity";
    [mCoreDataHelper deleteAllItemsAndSave:entityName];    
    if(mObjArray != nil && [mObjArray count] > 0 ) 
    {
        int idx;
        for(idx = 0;idx<[mObjArray count];idx++){
            RouteSettingObj * obj = [mObjArray objectAtIndex:idx];
            EditItemCallback callback = ^(NSManagedObject *item) 
            {
                RouteSettingEntity * routeItem = (RouteSettingEntity*) item;
                routeItem.mName = obj.mName;
                routeItem.mEndTime = obj.mEndTime;
                routeItem.mStartTime = obj.mStartTime;
                routeItem.mFromWhere = obj.mFromWhere;
                routeItem.mToWhere = obj.mToWhere;
                routeItem.mIsFri = [NSNumber numberWithBool:obj.mIsFri];
                routeItem.mIsSat = [NSNumber numberWithBool:obj.mIsSat];
                routeItem.mIsSun = [NSNumber numberWithBool:obj.mIsSun];
                routeItem.mIsMon = [NSNumber numberWithBool:obj.mIsMon];
                routeItem.mIsTue = [NSNumber numberWithBool:obj.mIsTue];
                routeItem.mIsThu = [NSNumber numberWithBool:obj.mIsThu];
                routeItem.mIsWed = [NSNumber numberWithBool:obj.mIsWed];
                routeItem.mIsEnable = [NSNumber numberWithBool:obj.mIsEnable];
            };
            [mCoreDataHelper addItemAndSave:@"RouteSettingEntity" withBlock:callback];
            //if we don't use addItem and Save
            //the order will random when you add another item in the next time.
        }
//        [mCoreDataHelper saveAll];
    }
}


-(IBAction) clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav popViewControllerAnimated:YES];
    
//    [vars.exterNav popViewControllerAnimated:YES];    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
	[aTextField resignFirstResponder];
 	return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Set Traffic";
    mCoreDataHelper = [CoreDataHelper sharedInstance];
    if(mObjArray == nil) {
        mObjArray = [NSMutableArray arrayWithCapacity:1];
    }    
    [self replaceCoreDataToObjArray];
    
    self.mTableView.rowHeight = 70;
    self.mTableView.delegate = self;
    self.mTableView.dataSource = self;
    [self.mTableView reloadData];

}




- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    GlobalVars *vars = [GlobalVars sharedInstance];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}







- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation  != UIInterfaceOrientationPortrait && interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }    
    return YES;
}

//UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 70.0f;
//}

//UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"ArrayTableViewController didSelectRowAtIndexPath");
    GlobalVars *vars = [GlobalVars sharedInstance];
    //int idx = indexPath.row;
    int rowIdx = indexPath.row;
    int idx = rowIdx; //show array in reverse order
    RouteSettingObj * obj = nil;
    if(self.mObjArray == nil || idx>= [self.mObjArray count]) {
        NSLog(@"Go to Add Route Setting Page");
        vars.mRouteSettingIVC.mIsOnCreate = YES;
        [vars.interNav pushViewController:vars.mRouteSettingIVC animated:YES];
    }
    else 
    {
        obj = (RouteSettingObj*)[mObjArray objectAtIndex:idx];
        vars.mRouteSettingIVC.mIsOnCreate = NO;
        vars.mRouteSettingIVC.mObj = obj;
        [vars.interNav pushViewController:vars.mRouteSettingIVC animated:YES];
    }
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
}





//UITableViewDelegate
-(NSInteger) tableView:(UITableView*) tableView numberOfRowsInSection:(NSInteger) section
{
    //   NSLog(@"ArrayTableViewController numberOfRowsInSection");
//    return 1;
    NSLog(@"numberOfRowsInSection");
    if(mObjArray == nil) return 1;
    return [mObjArray count]+1;
}


//UITableViewDelegate
//-(UITableViewCell*) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
//{
//    NSLog(@"ArrayTableViewController cellForRowAtIndexPath");
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) 
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.textLabel.numberOfLines = 2;
//        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
//        cell.detailTextLabel.textColor = [UIColor whiteColor];
//        cell.detailTextLabel.text = @"detail text label";
//    } 
//        
//    
//    NSString * detailShowStr = @"click to add new route";
//    NSString * showStr = @"Add";
//    int rowIdx = indexPath.row;
//    int idx = rowIdx;
//    if(mObjArray ==nil || idx >= [mObjArray count])
//    {
//        NSLog(@"mObjArray ==nil || idx >= [mObjArray count]");
//    }
//    else
//    {
//        RouteSettingObj * obj = (RouteSettingObj*)[mObjArray objectAtIndex:idx];
//        showStr = obj.mName;
////        detailShowStr =[NSString stringWithFormat:@"%@ -> %@\n%@ -> %@" ,obj.mFromWhere, obj.mToWhere, obj.mStartTime, obj.mEndTime];
//        
//        detailShowStr =[NSString stringWithFormat:@"%@ -> %@" ,obj.mFromWhere, obj.mToWhere];
//    }
//    
//
//        
//        
////    cell.detailTextLabel.text = detailShowStr;
//    cell.textLabel.text = showStr;
//    cell.detailTextLabel.text = detailShowStr;
//    cell.textLabel.numberOfLines = 2;
//    cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
//    
//    cell.accessoryView.hidden = NO;    
//    DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:cell.textLabel.textColor];
//    accessory.highlightedColor = [UIColor blackColor];
//    cell.accessoryView =accessory;
//    return cell;
//}

//UITableViewDelegate for section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //    NSLog(@"ArrayTableViewController numberOfSectionsInTableView");
    
    return 1;
}

//UITableViewDelegate for section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
    
    if(section == 0 ) {
        return @"History";
    } else if(section==1){
        return @"Rear Seat Entertainment";
    } else if(section==2){
        return @"Accessories";
    }
    return nil; 
}






static int LBL_1_TAG = 25331;
static int LBL_2_TAG = 25332;
static int LBL_3_TAG = 25333;
static int LBL_4_TAG = 25334;
static int BTN_1_TAG = 25335;
static int IMG_1_TAG = 25336;

static UIImage * sIsSelecteImg;
static UIImage * sNotSelecteImg;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * sCellIdentifier = @"CellID";
    if(sIsSelecteImg==nil) sIsSelecteImg= [UIImage imageNamed:@"IsSelected.png"];
    if(sNotSelecteImg==nil) sNotSelecteImg= [UIImage imageNamed:@"NotSelected.png"];
    int checkboxHeight = sIsSelecteImg.size.height;
    int checkboxWidth = sIsSelecteImg.size.width;
//    int idx =indexPath.row;
    //CellDataObj * obj = [mCellDataObjs objectAtIndex:idx];
//    RouteSettingObj * obj = [mObjArray objectAtIndex:idx];
    int rowHeight = tableView.rowHeight;
    NSLog(@"tableView.rowHeight = %g", tableView.rowHeight);
    
    
    UILabel * cellLbl1;
    UILabel * cellLbl2;
    UILabel * cellLbl3;
    UILabel * cellLbl4;
    UIImageView * cellImgView1;
    UIButton * cellBtn1;
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sCellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewStyleGrouped reuseIdentifier:sCellIdentifier];
        
        if(cell == nil)
        {
            NSLog(@"reuse Cell is null");
        }
        
        
        cellLbl1 = [[UILabel alloc]initWithFrame:CGRectMake(50,0,300,30)];
        cellLbl1.backgroundColor = [UIColor clearColor];
        cellLbl1.textColor = [UIColor whiteColor];
        cellLbl1.font = [UIFont boldSystemFontOfSize:17.0f];
        cellLbl1.tag = LBL_1_TAG;
        
        cellLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(50,20,300,30)];
        cellLbl2.backgroundColor = [UIColor clearColor];
        cellLbl2.textColor = [UIColor whiteColor];
        cellLbl2.font = [UIFont systemFontOfSize:14.0f];
        cellLbl2.tag = LBL_2_TAG;
        
        cellLbl3 = [[UILabel alloc]initWithFrame:CGRectMake(50,40,300,30)];
        cellLbl3.backgroundColor = [UIColor clearColor];
        cellLbl3.textColor = [UIColor whiteColor];
        cellLbl3.font = [UIFont systemFontOfSize:14.0f];
        cellLbl3.tag = LBL_3_TAG;
        
        cellLbl4 = [[UILabel alloc]initWithFrame:CGRectMake(275,10,25,50)];
        cellLbl4.backgroundColor = [UIColor blackColor];
        cellLbl4.textColor = [UIColor whiteColor];
        cellLbl4.font = [UIFont systemFontOfSize:14.0f];
        cellLbl4.tag = LBL_4_TAG;
        
        
        cellImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(checkboxWidth/2,(rowHeight-checkboxHeight)/2,checkboxWidth,checkboxHeight)];
        cellImgView1.tag = IMG_1_TAG;
        
        cellBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0,0,checkboxWidth*2,rowHeight)];
        cellBtn1.tag = BTN_1_TAG;
        cellBtn1.backgroundColor = [UIColor clearColor];
        [cellBtn1 addTarget:self action:@selector(clickToCheck:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];

        [cell.contentView addSubview:cellLbl1];
        [cell.contentView addSubview:cellLbl2];
        [cell.contentView addSubview:cellLbl3];
        [cell.contentView addSubview:cellLbl4];
        [cell.contentView addSubview:cellBtn1];
        [cell.contentView addSubview:cellImgView1];
     
        cell.accessoryView.hidden = NO;
        DTCustomColoredAccessory *accessory = [DTCustomColoredAccessory accessoryWithColor:cellLbl1.textColor];
        accessory.highlightedColor = [UIColor blackColor];
        cell.accessoryView =accessory;
        
    }
    else
    {
        cellLbl1 = (UILabel*)[cell.contentView viewWithTag:LBL_1_TAG];
        cellLbl2 = (UILabel*)[cell.contentView viewWithTag:LBL_2_TAG];
        cellLbl3 = (UILabel*)[cell.contentView viewWithTag:LBL_3_TAG];
        cellBtn1 = (UIButton*)[cell.contentView viewWithTag:BTN_1_TAG];
        cellImgView1 = (UIImageView*) [cell.contentView viewWithTag:IMG_1_TAG];
    }
    
    
//    cellLbl1.text = obj.mText;
//    cellLbl2.text = obj.mText;
//    cellBtn1.highlighted = obj.mIsCheck;
    
    NSString * directionShowStr = @"click to add new route";
    NSString * timeShowStr = @"";
    NSString * nameShowStr = @"Add";
    int rowIdx = indexPath.row;
    int idx = rowIdx;
    
    if(mObjArray ==nil || idx >= [mObjArray count]) {
        cellImgView1.hidden = YES;
    }
    else
    {
        cellImgView1.hidden = NO;
        RouteSettingObj * obj = (RouteSettingObj*)[mObjArray objectAtIndex:idx];
        nameShowStr = obj.mName;
        directionShowStr =[NSString stringWithFormat:@"%@ -> %@" ,obj.mFromWhere, obj.mToWhere];
        if(obj.mIsEnable) {
            cellImgView1.image = sIsSelecteImg;
        }else {
            cellImgView1.image = sNotSelecteImg;
        }
        
        NSString *startTimeStr = @"";
        NSString *endTimeStr = @"";
        if(obj.mStartTime == nil || [obj.mStartTime isEqualToString:@""]) {
            startTimeStr = @"00:00:00";
        }
        else {
            startTimeStr = obj.mStartTime;
        }
        if(obj.mEndTime == nil || [obj.mEndTime isEqualToString:@""]) {
            endTimeStr = @"23:59:59";
        }
        else {
            endTimeStr = obj.mEndTime;
        }
        timeShowStr = [NSString stringWithFormat:@"[%@] -> [%@]", startTimeStr,endTimeStr];
        
    }
    
    cellLbl1.text = nameShowStr;
    cellLbl2.text = directionShowStr;
    cellLbl3.text = timeShowStr;


    
    cell.contentView.tag = idx;
    
    
    return cell;
    
}


-(IBAction) clickToCheck:(id)sender {
    NSLog(@"clickToCheck");
    UIButton * btn = (UIButton*) sender;
    UIView *contentView = [btn superview];
    
    UIImageView * imgView = (UIImageView*)[contentView viewWithTag:IMG_1_TAG];
    int idx = contentView.tag;
    RouteSettingObj * obj = [self.mObjArray objectAtIndex:idx];
    if(obj.mIsEnable) {
        obj.mIsEnable = NO;
        imgView.image =[UIImage imageNamed:@"NotSelected.png"];
    }
    else
    {
        obj.mIsEnable = YES;
        imgView.image =[UIImage imageNamed:@"IsSelected.png"];
    }
    
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    [self editRouteSettingObj:obj];
    vars.mTrafficEVC.mIsNeedToResetIncidentData = YES;
    [mTableView reloadData];
}




@end
