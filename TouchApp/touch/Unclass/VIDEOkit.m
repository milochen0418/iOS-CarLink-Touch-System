

#import "VIDEOkit.h"
//#import "ExternalDisplayViewController.h"
#import "GlobalVars.h"
#define SAFE_PERFORM_WITH_ARG(THE_OBJECT, THE_SELECTOR, THE_ARG) (([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG] : nil)

#define SCREEN_CONNECTED	([UIScreen screens].count > 1)

@implementation VIDEOkit
@synthesize delegate;
@synthesize outwindow, displayLink;


static VIDEOkit *sharedInstance = nil;

- (void) setupExternalScreen
{
	// Check for missing screen
	if (!SCREEN_CONNECTED) {
        NSLogOut("External screen SCREEN_CONNECTED == false");        
        return;
    }

	 GlobalVars *vars = [GlobalVars sharedInstance];
    
	// Set up external screen
	UIScreen *secondaryScreen = [[UIScreen screens] objectAtIndex:1];
	UIScreenMode *screenMode = [[secondaryScreen availableModes] lastObject];
    
//    [secondaryScreen setOverscanCompensation:UIScreenOverscanCompensationScale];
    [secondaryScreen setOverscanCompensation:UIScreenOverscanCompensationInsetApplicationFrame];    

//    [secondaryScreen setOverscanCompensation:UIScreenOverscanCompensationInsetBounds];    
    
	//CGRect rect = (CGRect){.size = screenMode.size};
    CGRect rect = [secondaryScreen bounds];
//    rect.size.height = 480;
//    rect.size.width = 1000;
//    rect.origin.x = 0;
//    rect.origin.y = 0;
    
//    vars.internalVC.uiTextView_ScreenHeight.text = [NSString stringWithFormat:@"ScreenHeight = %f and Y=%f",rect.size.height, rect.origin.y];
//    vars.internalVC.uiTextView_ScreenWidth.text = [NSString stringWithFormat:@"ScreenWidth = %f and X=%f",rect.size.width, rect.origin.x];
    

    
	NSLog(@"Extscreen size: %@", NSStringFromCGSize(rect.size));
	
	// Create new outwindow
	self.outwindow = [[UIWindow alloc] initWithFrame:CGRectZero];
	outwindow.screen = secondaryScreen;
	outwindow.screen.currentMode = screenMode; // Thanks Scott Lawrence
	[outwindow makeKeyAndVisible];
	outwindow.frame = rect;
    
	// Add base video view to outwindow
	baseView = [[UIImageView alloc] initWithFrame:rect];
	baseView.backgroundColor = [UIColor darkGrayColor];
    
	//[outwindow addSubview:baseView];
    //ExternalDisplayViewController *hwvc = [[ExternalDisplayViewController alloc]init];
//    ExternalDisplayViewController *hwvc = [[ExternalDisplayViewController alloc] initWithNibName:@"ExternalDisplayViewController" bundle:nil];
    
//    UINavigationController * hwvc = vars.exterNav.topViewController;
    UINavigationController * hwvc = vars.exterNav;
    
    hwvc.view.frame = rect;
    
//    [outwindow addSubview:hwvc.view];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hwvc];    
    outwindow.rootViewController = vars.exterNav;
    
    //outwindow.rootViewController = hwvc;
    
	// Restore primacy of main window
	[delegate.view.window makeKeyAndVisible];
}

- (void) updateScreen
{
	// Abort if the screen has been disconnected
	if (!SCREEN_CONNECTED && outwindow)
		self.outwindow = nil;
	
	// (Re)initialize if there's no output window
	if (SCREEN_CONNECTED && !outwindow)
		[self setupExternalScreen];
	
	// Abort if we have encountered some weird error
	if (!self.outwindow) return;
	
	// Go ahead and update
    SAFE_PERFORM_WITH_ARG(delegate, @selector(updateExternalView:), baseView);
}

- (void) screenDidConnect: (NSNotification *) notification
{
    NSLog(@"Screen connected");
    UIScreen *screen = [[UIScreen screens] lastObject];
    
    if (displayLink)
    {
        [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [displayLink invalidate];
        self.displayLink = nil;
    }
    
    // Check for current display link
    if (!displayLink)
    {
        self.displayLink = [screen displayLinkWithTarget:self selector:@selector(updateScreen)];
        NSInteger fI = 1;
        [self.displayLink setFrameInterval:fI];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void) screenDidDisconnect: (NSNotification *) notification
{
	NSLog(@"Screen disconnected.");
    if (displayLink)
    {
        [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [displayLink invalidate];
        self.displayLink = nil;
    }
}

- (id) init
{
	if (!(self = [super init])) return self;
	
	// Handle output window creation
	if (SCREEN_CONNECTED) 
        [self screenDidConnect:nil];
	
	// Register for connect/disconnect notifications
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    
	return self;
}

- (void) dealloc
{
    [self screenDidDisconnect:nil];
	self.outwindow = nil;
}

+ (VIDEOkit *) sharedInstance
{
	if (!sharedInstance)	
		sharedInstance = [[self alloc] init];
	return sharedInstance;
}

+ (void) startupWithDelegate: (id) aDelegate
{
    [[self sharedInstance] setDelegate:aDelegate];
}
@end
