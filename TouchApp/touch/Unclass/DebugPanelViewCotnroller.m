//
//  PanelViewCotnroller.m
//  helloworld
//
//  Created by Milo Chen on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DebugPanelViewCotnroller.h"
#import "GlobalVars.h"

@implementation DebugPanelViewCotnroller

@synthesize mDbgTextView,mDbgDynamicSeg,mDbgRefreshBtn;
@synthesize mDbgString,mDbgCleanBtn,mDbgLogFeedback, mIsDbgDynamic;

-(void) addLog:(NSString*)log {
    if(mDbgString==nil) mDbgString = @"";
    mDbgString = [mDbgString stringByAppendingString:[NSString stringWithFormat:@"\n%@",log]];
    if(mIsDbgDynamic) 
    {
        mDbgTextView.text = mDbgString;
        [mDbgTextView startScrolling];
    }
    
}

-(IBAction) clickToCleanLog : (id)sender 
{
    NSLog(@"clickToCleanLog");
    mDbgString = @"";
    mDbgTextView.text = mDbgString;
}

-(IBAction) clickToFeedbackLog : (id)sender 
{
    NSLog(@"clickToFeedbackLog");
    [self postDataToPhpServer:self.mDbgString];
    NSLogOut("clickToFeedbackLog");
    //[self postDataToPhpServer:@"11112222333344445555"];
    
    //TODO
}

-(IBAction) clickToRefresh : (id)sender 
{
    NSLog(@"clickToRefresh");
    if(mIsDbgDynamic == NO) {
        mDbgTextView.text = mDbgString;
    }
}

-(IBAction) clickToChangeDynamicSeg : (id)sender 
{
    NSLog(@"clickToChangeDynamicSeg");
    UISegmentedControl * ctrlSeg = (UISegmentedControl*) sender;
    int idx = ctrlSeg.selectedSegmentIndex;
    switch(idx) {
        case 0:
            mDbgRefreshBtn.enabled = YES;
            mIsDbgDynamic = NO;
            break;
        case 1:
            mDbgRefreshBtn.enabled = NO;
            mIsDbgDynamic = YES;
            [self clickToRefresh:nil];
            break;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefaultValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) initDefaultValue 
{
    mDbgString = @"";
    mDbgDynamicSeg.selectedSegmentIndex = 0;
    mDbgRefreshBtn.enabled = YES;
    mIsDbgDynamic = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) postDataToPhpServer:(NSString*)dataStr {
    NSLog(@"postDataToPhpServer");
    
    NSURL *url;
    NSMutableURLRequest *urlRequest;
    NSMutableData *postBody = [NSMutableData data];
    
    url = [NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.105/ecotest.php?data=%@", dataStr]];
    NSLog(@"url = %@", [url absoluteString]);
    
    urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *udid = @"0000000000000000000000000000000000000002";
    [postBody appendData:[udid dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES]];
    [urlRequest setHTTPBody:postBody];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    
    if(returnData)
    {
        NSString *result = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"result=======>%@",result);
    }
    else
    {
        NSLogOut(@"Wrong Connetion!");
    }
    
}





@end
