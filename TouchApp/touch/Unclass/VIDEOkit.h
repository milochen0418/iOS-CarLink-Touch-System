
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "VIDEOkit.h"
//#import "AppDelegate.h"
#import "GlobalVars.h"

@interface VIDEOkit : NSObject 
{
	UIImageView *baseView;	
}
@property (nonatomic, weak)   UIViewController *delegate;
@property (nonatomic, strong) UIWindow *outwindow;
@property (nonatomic, strong) CADisplayLink *displayLink;

//@property (nonatomic, strong) AppDelegate *mainDelegate;

+ (void) startupWithDelegate: (id) aDelegate;
+ (VIDEOkit *) sharedInstance;
@end
