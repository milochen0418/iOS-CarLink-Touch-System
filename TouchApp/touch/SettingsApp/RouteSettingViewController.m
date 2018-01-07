//
//  RouteSettingViewController.m
//  touch
//
//  Created by Milo Chen on 10/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteSettingViewController.h"

#import "GlobalVars.h"
#import "TrafficSettingsViewController.h"
#import "NSDate+Helper.h"
#import "ParseHelper.h"
#import "XoapObj.h"
@interface RouteSettingViewController ()

@end



@implementation RouteSettingViewController

@synthesize mCoreDataHelper;
@synthesize mFriBtn,mMonBtn,mSatBtn,mSunBtn,mThuBtn,mTueBtn,mWedBtn;


@synthesize mNameField,mFromWhereField,mToWhereField,mEndTimeField,mStartTimeField;
@synthesize mIsOnCreate;
@synthesize mObj;

@synthesize pickerViewPopup,pickerView,mFocusTextField;

@synthesize mFromSearchBtn,mFromSearchField,mFromCityComboBox,mFromCityComboBoxView,mFromXoapObjArray;
@synthesize mToSearchBtn,mToSearchField,mToCityComboBox,mToCityComboBoxView,mToXoapObjArray;

@synthesize mParseHelper;


@synthesize mFilteredListContent,mTmpTextField,mSearchDisplayController,mSearchBar;

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
    [aTextField resignFirstResponder];
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    mCoreDataHelper = [CoreDataHelper sharedInstance];
    mParseHelper = [[ParseHelper alloc] init];
    
    
    //initial internet query system
    self.mFilteredListContent = [[NSMutableArray alloc] init];
    mSearchBar = [[UISearchBar alloc] init];
    //    [mSearchBar setScopeButtonTitles:[NSArray arrayWithObjects:@"All",@"Device",@"Desktop",@"Portable",nil]];
    mSearchBar.delegate = self;
	[mSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[mSearchBar sizeToFit];
    
    [self.view addSubview:mSearchBar];
    mSearchBar.hidden = YES;
   	mSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mSearchBar contentsController:self];
    [mSearchDisplayController setDelegate:self]; //delegate's type is UISearchDisplayDelegate
	[mSearchDisplayController setSearchResultsDataSource:self]; //datasource's type is
    
    
    
    
    
    
    [self refreshToggleGUI];
    mNameField.delegate = self;
//    mFromWhereField.delegate = self;
//    mToWhereField.delegate = self;
    
    
    mFromSearchField.delegate = self;
    
    NSMutableArray * cityArray = [NSMutableArray arrayWithObjects:
                                  @"CA, Corona",  //set 1 to network , default 1
                                  nil]; //need send idx+1 to network
    mFromCityComboBox = [[ComboBox alloc] init];
    [mFromCityComboBox setContainer:mFromCityComboBoxView withComboData:cityArray andDefaultSelectedIdx:0];    
    mFromCityComboBoxView.hidden = YES;
    mFromCityComboBox.delegate = self;
    
    
    mToSearchField.delegate = self;
    
    mToCityComboBox = [[ComboBox alloc] init];
    [mToCityComboBox setContainer:mToCityComboBoxView withComboData:cityArray andDefaultSelectedIdx:0];    
    mToCityComboBoxView.hidden = YES;
    mToCityComboBox.delegate = self;
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidAppear:(BOOL)animated
{
    if(mIsOnCreate) 
    {
        mObj = [[RouteSettingObj alloc]init];

        self.navigationItem.title = @"Create Route";
    }
    else 
    {
        if(mObj == nil) 
        {
            GlobalVars *vars = [GlobalVars sharedInstance];
            [vars.interNav popViewControllerAnimated:YES];
        }
        self.navigationItem.title = @"Edit Route";
    }
    [self refreshGuiByObj];    
}




-(void) refreshGuiByObj 
{
    NSLog(@"refreshGuiByObj");
    self.mNameField.text = mObj.mName;
    
//    self.mToWhereField.text = mObj.mToWhere;
//    self.mFromWhereField.text = mObj.mFromWhere;    
    self.mToSearchField.text = mObj.mToWhere;
    self.mFromSearchField.text = mObj.mFromWhere;
    
    
    self.mStartTimeField.text = mObj.mStartTime;
    self.mEndTimeField.text = mObj.mEndTime;
    self.mMonBtn.tag = mObj.mIsMon;
    self.mTueBtn.tag = mObj.mIsTue;
    self.mWedBtn.tag = mObj.mIsWed;
    self.mThuBtn.tag = mObj.mIsThu;
    self.mFriBtn.tag = mObj.mIsFri;
    self.mSatBtn.tag = mObj.mIsSat;
    self.mSunBtn.tag = mObj.mIsSun;
    [self refreshToggleGUI];
}

-(IBAction) clickToToggle:(id)sender {
    NSLog(@"clickToToggle");
    UIButton * btn = (UIButton*)sender;
    if(btn.tag == 0 ) { 
        btn.tag = 1;
    }
    else {
        btn.tag = 0;
    }
    [self refreshToggleGUI];
}

-(void) refreshToggleGUI 
{
    [self performSelector:@selector(refreshToggleGUI:) withObject:nil afterDelay:0.001];
}

- (IBAction) refreshToggleGUI:(id)sender 
{
    if(mMonBtn.tag == 1) {
        mMonBtn.highlighted = YES ;
    }
    else {
        mMonBtn.highlighted = NO;
    }
    
    if(mTueBtn.tag == 1) {
        mTueBtn.highlighted = YES; 
    }
    else {
        mTueBtn.highlighted = NO;
    }
 
    
    if(mWedBtn.tag == 1) { 
        mWedBtn.highlighted = YES; 
    }
    else {
        mWedBtn.highlighted = NO;
    }
    
    if(mThuBtn.tag == 1) {
        mThuBtn.highlighted = YES; 
    }
    else
    {
        mThuBtn.highlighted = NO; 
    }
    
    if(mFriBtn.tag == 1) { 
        mFriBtn.highlighted = YES; 
    }
    else 
    {        
        mFriBtn.highlighted = NO; 
    }
    
    if(mSatBtn.tag == 1) 
    { 
        mSatBtn.highlighted = YES; 
    } 
    else 
    { 
        mSatBtn.highlighted = NO;
    }
    
    if(mSunBtn.tag == 1) 
    {
        mSunBtn.highlighted = YES; 
    }
    else {
        mSunBtn.highlighted = NO;
    }
}


-(IBAction)clickToSave:(id)sender 
{
    NSLog(@"clickToSave");
    GlobalVars *vars = [GlobalVars sharedInstance];
    mObj.mIsMon = self.mMonBtn.tag;
    mObj.mIsTue = self.mTueBtn.tag;
    mObj.mIsWed = self.mWedBtn.tag;
    mObj.mIsThu = self.mThuBtn.tag;
    mObj.mIsFri = self.mFriBtn.tag;
    mObj.mIsSat = self.mSatBtn.tag;
    mObj.mIsSun = self.mSunBtn.tag;
    mObj.mName = self.mNameField.text;
    
//    mObj.mFromWhere = self.mFromWhereField.text;
//    mObj.mToWhere = self.mToWhereField.text;
    mObj.mFromWhere = self.mFromSearchField.text;
    mObj.mToWhere = self.mToSearchField.text;
    mObj.mStartTime = self.mStartTimeField.text;
    mObj.mEndTime = self.mEndTimeField.text;
    mObj.mEncodedPolyline = nil;
    
    if(mIsOnCreate == YES) 
    {
        //[vars.mTrafficSettingsIVC.mObjArray addObject:mObj];
        [vars.mTrafficSettingsIVC addRouteSettingObj:mObj];
    }
    else 
    {
        [vars.mTrafficSettingsIVC editRouteSettingObj:mObj];
    }

    
    
    [vars.mTrafficSettingsIVC.mTableView reloadData];
    [vars.interNav popViewControllerAnimated:YES];
    
    vars.mTrafficEVC.mIsNeedToResetIncidentData = YES;
    
    
}

-(IBAction)clickToDelete:(id)sender 
{
//    deleteRouteSettingObj
    NSLog(@"clickToDelete");
    GlobalVars *vars = [GlobalVars sharedInstance];
    if(mIsOnCreate)
    {
    
    } 
    else
    {
        [vars.mTrafficSettingsIVC deleteRouteSettingObj:mObj];
    }
    
    [vars.mTrafficSettingsIVC.mTableView reloadData];
    [vars.interNav popViewControllerAnimated:YES];
    vars.mTrafficEVC.mIsNeedToResetIncidentData = YES;
}


//- (IBAction)textFieldDidBeginEditing:(UITextField *)aTextField{
//    [aTextField resignFirstResponder];
//}


- (IBAction)textFieldDidBeginEditing2:(UITextField *)aTextField{  
    [aTextField resignFirstResponder];  
    
    mFocusTextField = aTextField;
    
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];  
    
    //    UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];  
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];  
    //    pickerView.datePickerMode = UIDatePickerModeDate;  
    pickerView.datePickerMode = UIDatePickerModeTime;
    pickerView.hidden = NO;  
    pickerView.date = [NSDate date];  
    
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];  
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;  
    [pickerToolbar sizeToFit];  
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];  
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];  
    [barItems addObject:flexSpace];  
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];  
    [barItems addObject:doneBtn];  
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];  
    [barItems addObject:cancelBtn];  
    
    [pickerToolbar setItems:barItems animated:YES];  
    
    [pickerViewPopup addSubview:pickerToolbar];  
    [pickerViewPopup addSubview:pickerView];  
    [pickerViewPopup showInView:self.view];  
    [pickerViewPopup setBounds:CGRectMake(0,0,320, 464)];  
}  

-(void)doneButtonPressed:(id)sender{  
    //Do something here here with the value selected using [pickerView date] to get that value  
    UITextField * mTextField = mFocusTextField;
    
    NSDate * date = pickerView.date;
    mTextField.text = [NSString stringWithFormat:@"%@",[date getTime]];
    
    NSLog(@"Done %@", date);
    
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];  
}  

-(void)cancelButtonPressed:(id)sender{  
    NSLog(@"Cancel");
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];  
}  


-(IBAction)clickToFromSearch:(id)sender {
    if(mParseHelper == nil) {
        mParseHelper = [[ParseHelper alloc] init];
    }
    NSLog (@"clickToSearch with field=%@", mFromSearchField.text);
  
    NSString * weatherUrl= nil;
//    weatherUrl= [NSString stringWithFormat:@"http://xoap.weather.com/search/search?where=%@", mFromSearchField.text];
    NSURL * url = [NSURL URLWithString:@"http://xoap.weather.com/search/search"];
    NSDictionary * paramDict = [NSDictionary dictionaryWithObjectsAndKeys:mFromSearchField.text,@"where", nil];
    url = [mParseHelper urlByAddingParameters:paramDict inURL:url];
    weatherUrl = [url absoluteString];
    
    
    
    NSString * xmlStr = [mParseHelper getSyncXmlWithUrlStr: weatherUrl];
    
    NSLog(@"weatherUrl = %@", weatherUrl);
    NSLog(@"xmlStr = %@",xmlStr);
    
    xmlStr = [mParseHelper stringByRemovingNewLinesAndWhitespace:xmlStr];
    if([mParseHelper extractValueByPattern:@".*?(<error>).*?" inTxtStr:xmlStr])
    {
        NSLog(@"xml query is error for argument");
        mFromCityComboBoxView.hidden = YES;
        return;
    }
    
    if(nil == [mParseHelper extractValueByPattern:@".*?(<loc id).*?" inTxtStr:xmlStr]) 
    {
        NSLog(@"There is no data for this search word");
        mFromCityComboBoxView.hidden = YES;        
        return;
    }
    
    mFromCityComboBoxView.hidden = NO;
    NSMutableArray * array = [mParseHelper extractStrArrayByPattern:@"<loc\ (.*?</loc>)" inXmlStr:xmlStr];
    NSMutableArray * xoapObjArray = [NSMutableArray arrayWithCapacity:1];
    
    int idx;
    for ( idx = 0 ; idx < [array count]; idx ++ ) 
    {
        XoapObj * obj= [[XoapObj alloc]init];
        NSString *str = [array objectAtIndex:idx];
        obj.mId = [mParseHelper extractValueByPattern:@"id=\"(.*?)\"" inTxtStr:str];
        obj.mType = [mParseHelper extractValueByPattern:@"type=\"(.*?)\"" inTxtStr:str];
        obj.mCitySt = [mParseHelper extractValueByPattern:@"\">(.*?)</loc>" inTxtStr:str];        
        NSLog(@"str[%d] = %@", idx, str);
        NSLog(@"obj[%d].mId=%@",idx, obj.mId);
        NSLog(@"obj[%d].mType=%@",idx, obj.mType);
        NSLog(@"obj[%d].mCitySt=%@",idx, obj.mCitySt);
        //   NSLog(@"obj[%d] queryUrl = %@",idx, [obj getQueryUrlWithMetric:@"1"]
        NSLog(@"obj[%d] queryUrl = %@",idx, [XoapObj getQueryUrl:obj withMetric:@"1"]);
        [xoapObjArray addObject:obj];
    }
    
    if(xoapObjArray != nil) {
        mFromXoapObjArray = xoapObjArray;
    }
    
    [self.mFromSearchField resignFirstResponder];
    [self refreshFromComboBoxData];
}

-(void)refreshFromComboBoxData {
    
    int idx;
    NSMutableArray * cityArray = [NSMutableArray arrayWithCapacity:1];
    
    for(idx = 0; idx<[self.mFromXoapObjArray count]; idx++) 
    {
        //        XOAPLoc * loc = [xoapWhereDom.mLocArray objectAtIndex:idx];
        XoapObj * obj =   [mFromXoapObjArray objectAtIndex:idx];
        [cityArray addObject:obj.mCitySt];
    }
    [self.mFromCityComboBox changeComboData:cityArray withDefaultSelectedIdx:0];
    self.mFromCityComboBoxView.hidden = NO;
}

-(void)didEndChoiceItem: (id)senderComboBox 
{
    NSLog(@"didEndChoiceItem");
    if(self.mFromCityComboBox == senderComboBox)
    {
        NSLog(@"match ComboBox");
        int idx = [self.mFromCityComboBox getSelectedIdx];
        
        XoapObj * obj = [self.mFromXoapObjArray objectAtIndex:idx];
        self.mFromSearchField.text = obj.mCitySt;
        
    }
    else if(self.mToCityComboBox == senderComboBox)
    {
        NSLog(@"dismatch ComboBox");
        NSLog(@"match ComboBox");
        int idx = [self.mToCityComboBox getSelectedIdx];
        
        XoapObj * obj = [self.mToXoapObjArray objectAtIndex:idx];
        self.mToSearchField.text = obj.mCitySt;
        
    }
}






-(IBAction)clickToToSearch:(id)sender {
    if(mParseHelper == nil) {
        mParseHelper = [[ParseHelper alloc] init];
    }
    NSLog (@"clickToSearch with field=%@", mToSearchField.text);
    NSString * weatherUrl = nil;
//  weatherUrl= [NSString stringWithFormat:@"http://xoap.weather.com/search/search?where=%@", mToSearchField.text];
    
    NSURL * url = [NSURL URLWithString:@"http://xoap.weather.com/search/search"];
    NSDictionary * paramDict = [NSDictionary dictionaryWithObjectsAndKeys:mToSearchField.text,@"where", nil];
    url = [mParseHelper urlByAddingParameters:paramDict inURL:url];
    weatherUrl = [url absoluteString];
    
    
    
    NSString * xmlStr = [mParseHelper getSyncXmlWithUrlStr: weatherUrl];
    
    NSLog(@"weatherUrl = %@", weatherUrl);
    NSLog(@"xmlStr = %@",xmlStr);
    
    xmlStr = [mParseHelper stringByRemovingNewLinesAndWhitespace:xmlStr];
    if([mParseHelper extractValueByPattern:@".*?(<error>).*?" inTxtStr:xmlStr])
    {
        NSLog(@"xml query is error for argument");
        mToCityComboBoxView.hidden = YES;
        return;
    }
    
    if(nil == [mParseHelper extractValueByPattern:@".*?(<loc id).*?" inTxtStr:xmlStr]) 
    {
        NSLog(@"There is no data for this search word");
        mToCityComboBoxView.hidden = YES;        
        return;
    }
    
    mToCityComboBoxView.hidden = NO;
    NSMutableArray * array = [mParseHelper extractStrArrayByPattern:@"<loc\ (.*?</loc>)" inXmlStr:xmlStr];
    NSMutableArray * xoapObjArray = [NSMutableArray arrayWithCapacity:1];
    
    int idx;
    for ( idx = 0 ; idx < [array count]; idx ++ ) 
    {
        XoapObj * obj= [[XoapObj alloc]init];
        NSString *str = [array objectAtIndex:idx];
        obj.mId = [mParseHelper extractValueByPattern:@"id=\"(.*?)\"" inTxtStr:str];
        obj.mType = [mParseHelper extractValueByPattern:@"type=\"(.*?)\"" inTxtStr:str];
        obj.mCitySt = [mParseHelper extractValueByPattern:@"\">(.*?)</loc>" inTxtStr:str];        
        NSLog(@"str[%d] = %@", idx, str);
        NSLog(@"obj[%d].mId=%@",idx, obj.mId);
        NSLog(@"obj[%d].mType=%@",idx, obj.mType);
        NSLog(@"obj[%d].mCitySt=%@",idx, obj.mCitySt);
        //   NSLog(@"obj[%d] queryUrl = %@",idx, [obj getQueryUrlWithMetric:@"1"]
        NSLog(@"obj[%d] queryUrl = %@",idx, [XoapObj getQueryUrl:obj withMetric:@"1"]);
        [xoapObjArray addObject:obj];
    }
    
    if(xoapObjArray != nil) {
        mToXoapObjArray = xoapObjArray;
    }
    
    [self.mToSearchField resignFirstResponder];
    [self refreshToComboBoxData];
}

-(void)refreshToComboBoxData {
    int idx;
    NSMutableArray * cityArray = [NSMutableArray arrayWithCapacity:1];
    for(idx = 0; idx<[self.mToXoapObjArray count]; idx++) 
    {
        XoapObj * obj =   [mToXoapObjArray objectAtIndex:idx];
        [cityArray addObject:obj.mCitySt];
    }
    [self.mToCityComboBox changeComboData:cityArray withDefaultSelectedIdx:0];
    self.mToCityComboBoxView.hidden = NO;
}



- (void)filterContentForSearchTextForInternetXoap:(NSString*)searchText scope:(NSString*)scope
{
    
    
//    NSOperationQueue * queue = [NSOperationQueue sharedOperationInternetAutocompleteQueue];
    NSOperationQueue * queue = [NSOperationQueue sharedOperationInternetAutocompleteQueue];
    
    
    __block NSOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        
        //	[self.mFilteredListContent removeAllObjects];// First clear the filtered array.
        
        
        if(mParseHelper == nil) {
            mParseHelper = [[ParseHelper alloc] init];
        }
        NSLog (@"clickToSearch with field=%@", searchText);
        
        NSString * weatherUrl= nil;
        //    weatherUrl= [NSString stringWithFormat:@"http://xoap.weather.com/search/search?where=%@", mFromSearchField.text];
        NSURL * url = [NSURL URLWithString:@"http://xoap.weather.com/search/search"];
        NSDictionary * paramDict = [NSDictionary dictionaryWithObjectsAndKeys:searchText,@"where", nil];
        url = [mParseHelper urlByAddingParameters:paramDict inURL:url];
        weatherUrl = [url absoluteString];
        
        NSString * xmlStr = [mParseHelper getSyncXmlWithUrlStr: weatherUrl];
        
        NSLog(@"weatherUrl = %@", weatherUrl);
        NSLog(@"xmlStr = %@",xmlStr);
        
        xmlStr = [mParseHelper stringByRemovingNewLinesAndWhitespace:xmlStr];
        if([mParseHelper extractValueByPattern:@".*?(<error>).*?" inTxtStr:xmlStr])
        {
            NSLog(@"xml query is error for argument");
            //mFromCityComboBoxView.hidden = YES;
            return;
        }
        
        if(nil == [mParseHelper extractValueByPattern:@".*?(<loc id).*?" inTxtStr:xmlStr])
        {
            NSLog(@"There is no data for this search word");
            //mFromCityComboBoxView.hidden = YES;
            return;
        }
        NSMutableArray *array = [mParseHelper extractStrArrayByPattern:@"<loc\\ (.*?</loc>)" inXmlStr:xmlStr];
        
        
        NSMutableArray * xoapObjArray = [NSMutableArray arrayWithCapacity:1];
        
        int idx;
        for ( idx = 0 ; idx < [array count]; idx ++ )
        {
            XoapObj * obj= [[XoapObj alloc]init];
            NSString *str = [array objectAtIndex:idx];
            //obj = [array objectAtIndex:idx];
            
            obj.mId = [mParseHelper extractValueByPattern:@"id=\"(.*?)\"" inTxtStr:str];
            obj.mType = [mParseHelper extractValueByPattern:@"type=\"(.*?)\"" inTxtStr:str];
            obj.mCitySt = [mParseHelper extractValueByPattern:@"\">(.*?)</loc>" inTxtStr:str];
            NSLog(@"str[%d] = %@", idx, str);
            NSLog(@"obj[%d].mId=%@",idx, obj.mId);
            NSLog(@"obj[%d].mType=%@",idx, obj.mType);
            NSLog(@"obj[%d].mCitySt=%@",idx, obj.mCitySt);
            //   NSLog(@"obj[%d] queryUrl = %@",idx, [obj getQueryUrlWithMetric:@"1"]
            NSLog(@"obj[%d] queryUrl = %@",idx, [XoapObj getQueryUrl:obj withMetric:@"1"]);
            [xoapObjArray addObject:obj];
            //        NSString * extractStr = [mParseHelper extractValueByPattern:@"\">(.*?)</loc>" inTxtStr:str];
            //        [xoapObjArray addObject:extractStr];
        }
        
        if(xoapObjArray != nil) {
            //        mFromXoapObjArray = xoapObjArray;
            mFilteredListContent = xoapObjArray;
            dispatch_async(dispatch_get_main_queue(),^{
                [mSearchDisplayController.searchResultsTableView reloadData];
            });
        }
        
        
    }];
    
    if(queue != nil) {
        [queue cancelAllOperations];
        [queue addOperation:operation];
    }
}



-(IBAction) searchBarBecomeFirstResponder:(id)sender {
    [mSearchBar becomeFirstResponder];
}

-(IBAction) clickToInputTextField:(id)sender {
    mTmpTextField = (UITextField*)sender;
    mSearchBar.hidden = NO;
    //    [mTmpTextField resignFirstResponder];
    [mSearchDisplayController setActive:YES animated:YES];
    [self performSelector:@selector(searchBarBecomeFirstResponder:) withObject:nil afterDelay:0.5];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //    [self filterContentForSearchTextOnInternalArray:searchText scope:scope];
    [self filterContentForSearchTextForInternetXoap:searchText scope:scope];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView == self.mSearchDisplayController.searchResultsTableView)
	{
        return [self.mFilteredListContent count];
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    
    //	Product *product = nil;
    NSString * str = nil;
	if (tableView == self.mSearchDisplayController.searchResultsTableView)
	{
        //product = [self.mFilteredListContent objectAtIndex:indexPath.row];
        //str = (NSString*)[self.mFilteredListContent objectAtIndex:indexPath.row];
        XoapObj * obj =  (XoapObj*)[self.mFilteredListContent objectAtIndex:indexPath.row];
        str = obj.mCitySt;
    }
	else
	{
        //product = [self.listContent objectAtIndex:indexPath.row];
        str = @"None";
    }
    
	cell.textLabel.text = str;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //UIViewController *detailsViewController = [[UIViewController alloc] init];
    
	XoapObj *product = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        product = [self.mFilteredListContent objectAtIndex:indexPath.row];
    }
    //	else
    //	{
    //        product = [self.listContent objectAtIndex:indexPath.row];
    //    }
    
    
    //	detailsViewController.title = product.name;
    mTmpTextField.text = product.mCitySt;
    
    
    //    [[self navigationController] pushViewController:detailsViewController animated:YES];
    //    [detailsViewController release];
    mSearchBar.hidden = YES;
    [self.mSearchDisplayController setActive:NO animated:YES];
    
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller{
	/*
     Bob: Because the searchResultsTableView will be released and allocated automatically, so each time we start to begin search, we set its delegate here.
     */
	[self.searchDisplayController.searchResultsTableView setDelegate:self];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
	/*
	 Hide the search bar
	 */
	//[self.tableView setContentOffset:CGPointMake(0, 44.f) animated:YES];
    mSearchBar.hidden = YES;
}



@end
