#import "AppInstallationInterViewController.h"
#import "GlobalVars.h"

@implementation AppInstallationInterViewController


@synthesize mAppIconImgView;
@synthesize mAppNameLbl;
@synthesize mAppObj;
@synthesize mAppDescTextView;
@synthesize mAppObjIdx;
@synthesize mInstallItBtn;




-(IBAction) clickToBack:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    [vars.interNav popViewControllerAnimated:YES];
    [vars.exterNav popViewControllerAnimated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self changeBtnIntoBlk:mInstallItBtn];
    NSString* navTitle = @"App Install";
    self.navigationItem.backBarButtonItem = 
    [[UIBarButtonItem alloc] initWithTitle:navTitle 
                             style:UIBarButtonItemStyleBordered
                             target: self
                             action: @selector(clickToBack:)
     ];
    self.navigationItem.title = navTitle;
    
    
    

}




- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(IBAction) clickToInstallIt:(id)sender {
    GlobalVars *vars = [GlobalVars sharedInstance];
    if([mAppObj isInstalled])
    {
        [mAppObj actionIt];
        [self performSelector:@selector(clickToBack:) withObject:nil];
    }
    else 
    {
        [mAppObj actionIt];
        [vars.interNav popViewControllerAnimated:NO];
        [vars.exterNav popViewControllerAnimated:NO];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    
//    GlobalVars *vars = [GlobalVars sharedInstance];
    
    [self performSelector:@selector(performLoadAppInfo:) withObject:nil afterDelay:1];
}

-(IBAction)performLoadAppInfo:(id)sender {
    [mAppObj loadAppIconAndName];
    self.mAppNameLbl.text = mAppObj.mAppName;
    self.mAppIconImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:mAppObj.mAppIconUrl]]];
    self.mAppDescTextView.text = mAppObj.mAppDescription;
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    GlobalVars * vars = [GlobalVars sharedInstance];
    if([vars.exterNav topViewController] == vars.mAppInstallationEVC ) {
        [vars.exterNav popViewControllerAnimated:YES];
    }
    
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

-(void) changeBtnIntoBlk:(UIButton*)btn 
{
    //please makesure that button height is bigger than or equal to 48px
    //button is set as customType in .xib file
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    
    UIImage * blackImage = [[UIImage imageNamed:@"blk_button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21];
    
    [btn setBackgroundImage:blackImage forState:UIControlStateNormal];
	[btn setBackgroundImage:blackImage forState:UIControlStateDisabled];
	[btn setEnabled:YES];    
}


@end
