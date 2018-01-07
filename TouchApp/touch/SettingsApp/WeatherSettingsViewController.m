//
//  ViewController.m
//  helloworld
//
//  Created by Milo Chen on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WeatherSettingsViewController.h"
#import "GlobalVars.h"
#import "ComboBoxDelegate.h"
#import "WeatherExterViewController.h"
#import "XoapObj.h"


@implementation WeatherSettingsViewController

@synthesize mParseHelper;
@synthesize mSearchBtn,mSearchField;
@synthesize mParser;
@synthesize mXOAPWhereDom,mWeatherURL;
@synthesize mConnection,mExpectedLength,mTempDownloadData;

@synthesize mSelectedTableView;
@synthesize mLocIdLbl;
@synthesize mParsingAction;
@synthesize mRosenWeatherDom;
@synthesize mRosenWeatherURL;
@synthesize mLocId;

@synthesize mIsSelectC;
@synthesize mSelectedCity;
@synthesize mQueryWeatherBtn;
@synthesize mFCSegCtrl;
@synthesize mDbgTextView;

@synthesize mCurCityName;
@synthesize mReceivedURL;
@synthesize mCityComboBox;
@synthesize mCityComboBoxView;

@synthesize mIsOnCreate;
@synthesize mObj;

@synthesize mFilteredListContent,mSearchBar,mSearchDisplayController,mTmpTextField;


-(IBAction) clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav popViewControllerAnimated:YES];
//    [vars.exterNav popViewControllerAnimated:YES];    
    
}



-(IBAction)clickToSelFC:(id)sender {
    NSLog(@"clickToSelFC");
    switch(mFCSegCtrl.selectedSegmentIndex) 
    {
        case 0:
            NSLog(@"0");
            self.mIsSelectC = NO;
            [self getRosenWeather];
            break;
        case 1:
            NSLog(@"1");            
            self.mIsSelectC = YES;
            [self getRosenWeather];            
            break;
    }
}






-(void)didEndChoiceItem: (id)senderComboBox 
{
    NSLog(@"didEndChoiceItem");
    if(self.mCityComboBox == senderComboBox)
    {
        NSLog(@"match ComboBox");
        
        int idx = [self.mCityComboBox getSelectedIdx];
        XOAPLoc * loc = [self.mXOAPWhereDom.mLocArray objectAtIndex:idx];
        mLocId = loc.mWeatherId;        
        mCurCityName = loc.mName;        
        
        mLocIdLbl.text = loc.mWeatherId;
        mSelectedCity.text = loc.mName;
        
        NSString * setXoapLocId = self.mLocId;
        NSString * setXoapLocCityName = self.mCurCityName;
        
        GlobalVars *vars = [GlobalVars sharedInstance];
        NSDictionary *settingsDict = [vars getSettingsDict];
        
        [settingsDict setValue:setXoapLocId forKey:@"XoapLocId"];
        [settingsDict setValue:setXoapLocCityName forKey:@"XoapLocCityName"];
        
        
        [self getRosenWeather];
    }
    else
    {
        NSLog(@"dismatch ComboBox");
    }
}




-(IBAction)clickToSearch:(id)sender {
    NSLog (@"clickToSearch with field=%@", mSearchField.text);
    
    mParsingAction = PARSE_XOAP_WHERE_DOM;
    if(mXOAPWhereDom != nil) mXOAPWhereDom = nil;
    mXOAPWhereDom = [[XOAPWhereDom alloc]init];
    if(mRosenWeatherDom != nil) mRosenWeatherDom = nil;
    mRosenWeatherDom = [[RosenWeatherDom alloc] init];
    if(mWeatherURL!=nil) {
        mWeatherURL = nil;
    }
    
    
//    mWeatherURL= [NSString stringWithFormat:@"http://xoap.weather.com/search/search?where=%@", mSearchField.text];
    NSURL * url = [NSURL URLWithString:@"http://xoap.weather.com/search/search"];
    NSDictionary * paramDict = [NSDictionary dictionaryWithObjectsAndKeys:mSearchField.text,@"where", nil];
    url = [mParseHelper urlByAddingParameters:paramDict inURL:url];
    mWeatherURL = [url absoluteString];
    
    
    if(mTempDownloadData != nil) {
        mTempDownloadData = nil;
    }
    mTempDownloadData = [NSMutableData alloc];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:mWeatherURL]];
    self.mConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];    
    
}

- (void) getRosenWeather
{
    if(mParseHelper == nil) mParseHelper = [[ParseHelper alloc]init];
    [self writeSettings];
    mParsingAction = PARSE_ROSEN_WEATHER_DOM;
    if(mTempDownloadData != nil) {
        mTempDownloadData = nil;
    }
    mTempDownloadData = [NSMutableData alloc];

    
    NSString * metric = @"1";
    if( self.mIsSelectC) metric = @"0";
    
    NSString * newLocId = self.mCurCityName;
    newLocId = [mParseHelper extractValueByPattern:@"(.*?,.*?)(\\(|$)" inTxtStr:newLocId];    
    newLocId = [newLocId stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
    NSString * encodedNewLocId = [mParseHelper URLEncodedString:NSUTF8StringEncoding inUrlStr:newLocId];
    newLocId = encodedNewLocId;
    mRosenWeatherURL = [NSString stringWithFormat:@"http://rosenapp.com/api.class?action=weather&loc_id=%@&metric=%@", newLocId, metric];    
    
    
    
    GlobalVars *vars =[GlobalVars sharedInstance];
    vars.mEVC.mIsInitWeatherWidget = NO;
    vars.mWeatherEVC.mHasInit = NO;
    
    vars.mWeatherEVC.mUrlLbl.text = mRosenWeatherURL;
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:mRosenWeatherURL]];
    self.mConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextField {
	[aTextField resignFirstResponder];
 	return YES;
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict 
{
    switch (mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            [self.mXOAPWhereDom parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            [self.mRosenWeatherDom parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qualifiedName attributes:attributeDict];
            break;
    }
}

//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    switch(mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            [self.mXOAPWhereDom parser:parser foundCharacters:string];            
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            [self.mRosenWeatherDom parser:parser foundCharacters:string];            
            break;
    }
    
}


//NSXMLParserDelegate
- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
{
    switch(mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            [self.mXOAPWhereDom parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName]; 
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            [self.mRosenWeatherDom parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName]; 
            break;
    }
}





//NSURLConnectionDelegate
-(void) connection:(NSURLConnection *)connection didReceiveData: (NSData *) incomingData
{ 
    NSLog(@"NSURLConnection didReceiveData");
    [mTempDownloadData appendData:incomingData];
}

//NSURLConnectionDelegate
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"NSURLConnection connectionDidFinishLoading");    
    NSString *loadData = [[NSMutableString alloc] initWithData:mTempDownloadData encoding:NSISOLatin1StringEncoding];
    NSLog(@"\n\n\n\nloadData = %@\n\n\n\n",loadData);
    //    return;
    
    
    if(mParser) {
        mParser = nil;
    }
    
    //mParser = [[NSXMLParser alloc] initWithData:mTempDownloadData];
    
    //    dataUsingEncoding:encoding allowLossyConversion:YES] 
    
    mParser = [[NSXMLParser alloc] initWithData:[loadData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
    mDbgTextView.text = loadData;
    
    [mParser setDelegate:self];//(id<NSXMLParserDelegate>)
    [mParser setShouldResolveExternalEntities:YES];
    @try 
    {
        [mParser parse];
        
        NSError *err = [mParser parserError];
        NSLog(@"parser error = %@", err);
        
    }
    @catch( NSException *e) 
    {
        NSLog(@"Parsing Error");
        return;
    }
    
    
    switch (mParsingAction) {
        case PARSE_XOAP_WHERE_DOM:
            NSLog(@"mXOAPWhereDom = %@",mXOAPWhereDom);    
            
            //here parsing ok
            [self refreshComboBoxDataByWhereDom:mXOAPWhereDom];
            
            break;
        case PARSE_ROSEN_WEATHER_DOM:
            NSLog(@"mRosenWeatherDom = %@",mRosenWeatherDom);
            [self refreshWeatherGui];
            break;
    }
    
    [self refreshData];
    mTempDownloadData = nil;
    mConnection = nil;    
}

-(void)refreshComboBoxDataByWhereDom:(XOAPWhereDom*) xoapWhereDom {
    
    int idx;
    NSMutableArray * cityArray = [NSMutableArray arrayWithCapacity:1];
    for(idx = 0; idx<[xoapWhereDom.mLocArray count]; idx++) 
    {
        XOAPLoc * loc = [xoapWhereDom.mLocArray objectAtIndex:idx];
        [cityArray addObject:loc.mName];
    }
    [self.mCityComboBox changeComboData:cityArray withDefaultSelectedIdx:0];
    self.mCityComboBoxView.hidden = NO;

    
}
-(void) refreshWeatherGui {
    GlobalVars *vars =[GlobalVars sharedInstance];
    
    
    vars.mWeatherEVC.mCurTmpLbl.text = [NSString stringWithFormat:@"%@°", mRosenWeatherDom.mToday.mCurTmp];
    vars.mWeatherEVC.mWeatherTextLbl.text = mRosenWeatherDom.mToday.mText;
    vars.mWeatherEVC.mCurHiLoLbl.text = [NSString stringWithFormat:@"Hi %@°   Lo %@°",mRosenWeatherDom.mToday.mHighTmp, mRosenWeatherDom.mToday.mLowTmp];
    vars.mWeatherEVC.mHmidAndPpcpLbl.text = [NSString stringWithFormat:@"Humidity of %@%% and %@%% chance of rain", mRosenWeatherDom.mToday.mHumidityTmp ,mRosenWeatherDom.mToday.mPrecipitation];
    vars.mWeatherEVC.mWeatherCity.text = self.mCurCityName;
    
    
    
    //    vars.mEVC.mSunDescriptionLbl.text = [NSString stringWithFormat:@"Sun rise at %@ Sunset at %@",mRosenWeatherDom.mToday.mSunRise, mRosenWeatherDom.mToday.mSunSet];
    
    vars.mWeatherEVC.mSunDescriptionLbl.text = [NSString stringWithFormat:@"Sunrise %@ Sunset %@", mRosenWeatherDom.mToday.mSunRise,mRosenWeatherDom.mToday.mSunSet];
    
    
    vars.mWeatherEVC.mTodayImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mToday.mIcon]];
    
    
    vars.mWeatherEVC.mWindDescriptionLbl.text = [NSString stringWithFormat:@"Wind %@ at %@mph",mRosenWeatherDom.mToday.mWindDirection,mRosenWeatherDom.mToday.mWindSpeed];
    
    
    vars.mWeatherEVC.mD1WDLbl.text = mRosenWeatherDom.mDay1.mWeekDay;
    vars.mWeatherEVC.mD1HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay1.mHighTmp];
    vars.mWeatherEVC.mD1LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay1.mLowTmp];
    vars.mWeatherEVC.mD1IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay1.mIcon]];
    
    vars.mWeatherEVC.mD2WDLbl.text = mRosenWeatherDom.mDay2.mWeekDay;
    vars.mWeatherEVC.mD2HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay2.mHighTmp];
    vars.mWeatherEVC.mD2LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay2.mLowTmp];
    vars.mWeatherEVC.mD2IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay2.mIcon]];
    
    vars.mWeatherEVC.mD3WDLbl.text = mRosenWeatherDom.mDay3.mWeekDay;
    vars.mWeatherEVC.mD3HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay3.mHighTmp];
    vars.mWeatherEVC.mD3LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay3.mLowTmp];
    vars.mWeatherEVC.mD3IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay3.mIcon]];
    
    vars.mWeatherEVC.mD4WDLbl.text = mRosenWeatherDom.mDay4.mWeekDay;
    vars.mWeatherEVC.mD4HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay4.mHighTmp];
    vars.mWeatherEVC.mD4LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay4.mLowTmp];
    vars.mWeatherEVC.mD4IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay4.mIcon]];
    
    vars.mWeatherEVC.mD5WDLbl.text = mRosenWeatherDom.mDay5.mWeekDay;
    vars.mWeatherEVC.mD5HiLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay5.mHighTmp];
    vars.mWeatherEVC.mD5LoLbl.text = [NSString stringWithFormat:@"%@°",mRosenWeatherDom.mDay5.mLowTmp];
    vars.mWeatherEVC.mD5IconImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",mRosenWeatherDom.mDay5.mIcon]];
    
}



-(void) refreshWeatherGuiByObj {
//    GlobalVars *vars =[GlobalVars sharedInstance];
    
    NSString * getXoapLocId;
    NSString * getXoapLocCityName;
    bool getIsSelectedC;
    
//    SettingsManager *mgr = [SettingsManager sharedInstance];
//    WeatherSettingManager * wMgr = mgr.mWeatherSettingManager;
    getIsSelectedC = (BOOL)[mObj.mIsSelectC intValue];
    getXoapLocId = mObj.mLocId;
    getXoapLocCityName = mObj.mCurCityName;
    
    self.mIsSelectC = getIsSelectedC;
    self.mLocId = getXoapLocId;
    self.mCurCityName = getXoapLocCityName;

    
    self.mLocIdLbl.text = getXoapLocId;
    self.mSelectedCity.text = getXoapLocCityName;
    self.mSearchField.text = getXoapLocCityName;
    
    if(getIsSelectedC) {
        self.mFCSegCtrl.selectedSegmentIndex = 1;
    }else {
        self.mFCSegCtrl.selectedSegmentIndex = 0;
    }
    
}


-(void) refreshData {
    NSLog(@"refreshData");
    [mSelectedTableView reloadData];
    
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(self.mXOAPWhereDom == nil) return 0;
//    if(self.mXOAPWhereDom.mLocArray == nil ) return 0;
//    if([self.mXOAPWhereDom.mLocArray count] == 0 ) return 0;
//    return [self.mXOAPWhereDom.mLocArray count];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        //        cell.backgroundColor = [UIColor blackColor];
//        cell.backgroundColor = [UIColor clearColor];        
////        cell.textColor = [UIColor whiteColor];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    }
//    //cell.textLabel.text = [self.mCellTitles objectAtIndex: [indexPath row]];
//    
//    cell.textLabel.text = ((XOAPLoc*)[self.mXOAPWhereDom.mLocArray objectAtIndex:[indexPath row]]).mName ;
//    
//    return cell;
//}


-(void)method1:(NSString*)value1 {
    NSLog(@"WeatherInterViewController method1:(NSString*)value=%@", value1);
}
-(void)method2:(NSString*)value2 {
    NSLog(@"WeatherInterViewController method2:(NSString*)value=%@", value2);    
}


//NSURLConnectionDelegate
- (void)connection: (NSURLConnection *)connection didReceiveResponse: (NSURLResponse *)aResponse
{  
    NSLog(@"NSURLConnection didReceiveResponse");
}
//NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"NSURLConnection didFailWithError");
    mConnection = nil;
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didSelectRowAtIndexPath");
//    
//    
//    XOAPLoc *loc = [self.mXOAPWhereDom.mLocArray objectAtIndex:[indexPath row]];
//    mLocId = loc.mWeatherId;
//    mLocIdLbl.text = loc.mWeatherId;
//    mSelectedCity.text = loc.mName;
//    mCurCityName = loc.mName;
//    
//    
//    [self getRosenWeather];
//    
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    
    self.mFilteredListContent = [[NSMutableArray alloc] init];
    mSearchBar = [[UISearchBar alloc] init];
    mSearchBar.delegate = self;
    [mSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [mSearchBar sizeToFit];
    [self.view addSubview:mSearchBar];
    mSearchBar.hidden = YES;
    mSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:mSearchBar contentsController:self];
    [mSearchDisplayController setDelegate:self]; //delegate's type is UISearchDisplayDelegate
    [mSearchDisplayController setSearchResultsDataSource:self]; //datasource's type is
    
    
    
    
    mSearchField.delegate = self;
    
    mSelectedTableView.backgroundColor = [UIColor clearColor];
    [mSelectedTableView setDataSource:self];
    [mSelectedTableView setDelegate:self];
    mSelectedTableView.alpha = 1.0;
    
    if(mXOAPWhereDom != nil) mXOAPWhereDom = nil;
    mXOAPWhereDom = [[XOAPWhereDom alloc]init];
    if(mRosenWeatherDom != nil) mRosenWeatherDom = nil;
    mRosenWeatherDom = [[RosenWeatherDom alloc] init];
    
    [self readSettings];
    [self getRosenWeather];
    
    
    NSMutableArray * cityArray = [NSMutableArray arrayWithObjects:
                                  @"CA, Corona",  //set 1 to network , default 1
                                  @"Combined Redlight+Fixed speed camera",  //set 2 to network
                                  @"Redlight camera", //set idx+1 to network
                                  @"Average speed camera", //...
                                  @"Mobile radar/speedtrap", //set idx+1 to network
                                  nil]; //need send idx+1 to network
    


    mCityComboBox = [[ComboBox alloc] init];
    [mCityComboBox setContainer:mCityComboBoxView withComboData:cityArray andDefaultSelectedIdx:0];
    mCityComboBoxView.hidden = YES;
    mCityComboBox.delegate = self;
    
    self.navigationItem.title = @"Set Weather";
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    self.mSelectedTableView = nil;    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(mIsOnCreate) {
        mObj = [[WeatherObj alloc]init];
        mObj.mCurCityName = @"";
        mObj.mLocId=@"";
        mObj.mIsSelectC=@"0";
//        mObj.mName = @"new";
        mObj.mName = @"";
        self.mSearchField.text= @"";
        
        self.navigationItem.title = @"Create Weather";
    }
    else {
        if(mObj == nil) {
            GlobalVars *vars = [GlobalVars sharedInstance];
            [vars.interNav popViewControllerAnimated:YES];
        }
        self.navigationItem.title = @"Edit Weather";
    }
    [self refreshWeatherGuiByObj];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation  != UIInterfaceOrientationPortrait && interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown) {
        return NO;
    }    
    return YES;
}









-(void)writeSettings {
    NSLog(@"clickToWrite");
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    NSString * setXoapLocId = self.mLocId;
    NSString * setXoapLocCityName = self.mCurCityName;
    bool setIsSelectC = self.mIsSelectC; 
    
    SettingsManager *mgr = [SettingsManager sharedInstance];
    WeatherSettingManager * wMgr = mgr.mWeatherSettingManager;
    wMgr.mLocId = setXoapLocId;
    wMgr.mCurCityName = setXoapLocCityName;
    wMgr.mIsSelectC = setIsSelectC;
}


-(void)readSettings {    
    NSLog(@"clickToRead");        

    NSString * getXoapLocId;
    NSString * getXoapLocCityName;
    bool getIsSelectedC;

    SettingsManager *mgr = [SettingsManager sharedInstance];
    WeatherSettingManager * wMgr = mgr.mWeatherSettingManager;
    getIsSelectedC = wMgr.mIsSelectC;
    getXoapLocId = wMgr.mLocId;
    getXoapLocCityName = wMgr.mCurCityName;
    

    self.mIsSelectC = getIsSelectedC;
    self.mLocId = getXoapLocId;
    self.mCurCityName = getXoapLocCityName;
    
    self.mLocIdLbl.text = getXoapLocId;
    self.mSelectedCity.text = getXoapLocCityName;
    if(getIsSelectedC) {
        self.mFCSegCtrl.selectedSegmentIndex = 1;
    }else {
        self.mFCSegCtrl.selectedSegmentIndex = 0;
    }
}



-(IBAction)clickToSave:(id)sender
{
    NSLog(@"clickToSave");
    GlobalVars *vars = [GlobalVars sharedInstance];
    NSString * setXoapLocId = self.mLocId;
    NSString * setXoapLocCityName = self.mCurCityName;
    bool setIsSelectC = self.mIsSelectC;
    
    
    mObj.mLocId = setXoapLocId;
    mObj.mCurCityName = setXoapLocCityName;
    mObj.mIsSelectC = [NSString stringWithFormat:@"%d",(int)setIsSelectC];
    mObj.mTimeInterval = 0;
    
    if(mIsOnCreate == YES)
    {
//        [vars.mTrafficSettingsIVC addRouteSettingObj:mObj];
        [vars.mWeatherSettingsListIVC addWeatherObj:mObj];
    }
    else
    {
//        [vars.mTrafficSettingsIVC editRouteSettingObj:mObj];
        [vars.mWeatherSettingsListIVC editWeatherObj:mObj];
    }
    
    [vars.mWeatherSettingsListIVC.mTableView reloadData];
    [vars.interNav popViewControllerAnimated:YES];
    vars.mWeatherEVC.mIsNeedToResetWeatherData = YES;
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

        [vars.mWeatherSettingsListIVC deleteWeatherObj:mObj];
    }
    
    [vars.mWeatherSettingsListIVC.mTableView reloadData];
    [vars.interNav popViewControllerAnimated:YES];
    vars.mWeatherEVC.mIsNeedToResetWeatherData = YES;
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

    self.mLocId = product.mId;
    self.mLocIdLbl.text = product.mId;
    self.mSelectedCity.text = product.mCitySt;
    self.mCurCityName = product.mCitySt;
//    
//    mObj.mLocId = product.mId;
//    mObj.mCurCityName = product.mCitySt;
    


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
