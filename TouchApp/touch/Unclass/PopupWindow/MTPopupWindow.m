//
//  MTPopupWindow.m
//  PopupWindowProject
//
//  Created by Marin Todorov on 7/1/11.
//  Copyright 2011 Marin Todorov. MIT license
//  http://www.opensource.org/licenses/mit-license.php
//

#import "MTPopupWindow.h"
#import "GlobalVars.h"
//#define kShadeViewTag 1000
#define kShadeViewTag 1212

@interface MTPopupWindow(Private)
- (id)initWithSuperview:(UIView*)sview andFile:(NSString*)fName;
@end

@implementation MTPopupWindow


@synthesize bgView,bigPanelView,closeBtn,shadeView,fauxView,closeBtnImg;
@synthesize background,mWebView,mShowView;


static MTPopupWindow* staticMTPopupWindow = nil;

+(void)showWindowWithHTMLFile:(NSString*)fileName insideView:(UIView*)view
{    
    if(staticMTPopupWindow != nil) {
        [staticMTPopupWindow releaseProp];
        staticMTPopupWindow = nil;
    }
    
    if(staticMTPopupWindow == nil) {
        staticMTPopupWindow = [[MTPopupWindow alloc] initWithSuperview:view andFile:fileName];    
    }    
//    [[MTPopupWindow alloc] initWithSuperview:view andFile:fileName];
}

-(void)releaseProp 
{
    
    if(mWebView != nil) [mWebView removeFromSuperview];
    if(fauxView != nil) [fauxView removeFromSuperview];
    if(background != nil ) [background removeFromSuperview];
    if(mShowView != nil ) [mShowView removeFromSuperview];
    if(closeBtn != nil ) [ closeBtn removeFromSuperview];
    if(shadeView != nil) [ shadeView removeFromSuperview];
    if(bigPanelView != nil) [bigPanelView removeFromSuperview];
    if(bgView != nil) [bgView removeFromSuperview];
    
    self.shadeView = nil;
    self.bgView = nil;
    self.bigPanelView = nil;
    self.fauxView = nil;
    self.closeBtnImg = nil;
    self.closeBtn = nil;
    self.background = nil;
    self.mShowView = nil;
    
    self.mWebView = nil;
}

+(void)showCameraOkWindowWithTitle:(NSString*)title andMessage:(NSString*)message insideView:(UIView*)view
{
//    [MTPopupWindow showWindowWithHTMLFile:@"http://www.google.com" insideView:view];
//    return;
    
    if(staticMTPopupWindow != nil) 
    {
        [staticMTPopupWindow releaseProp];
        staticMTPopupWindow = nil;
    }
    
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    UIView * showView = vars.mCameraOkAlertVC.view;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        vars.mCameraOkAlertVC.mMessageTextView.text = message;
        vars.mCameraOkAlertVC.mTitleLbl.text = title;


    if(staticMTPopupWindow == nil) 
    {
//        staticMTPopupWindow = [[MTPopupWindow alloc] initWithSuperview:view andView:showView];
        staticMTPopupWindow = [[MTPopupWindow alloc] initWithSuperview:view andView:showView];
    }        
        
    });        
    
}



+(void)showWindowWithView:(UIView*)showView insideView:(UIView*)view {
    
    if(staticMTPopupWindow != nil) {
        [staticMTPopupWindow releaseProp];
        staticMTPopupWindow = nil;
    }
    
    if(staticMTPopupWindow == nil) {
        staticMTPopupWindow = [[MTPopupWindow alloc] initWithSuperview:view andView:showView];    
    }        
}

+(void)closePopupWindow {
    [staticMTPopupWindow closePopupWindow:nil];
}


- (id)initWithSuperview:(UIView*)sview andView:(UIView*)showView
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        //UIImage* closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
        closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];    
        [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closePopupWindow:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGRect rect = CGRectMake(sview.bounds.origin.x, sview.bounds.origin.y,sview.bounds.size.width,sview.bounds.size.height);
        
        bgView = [[UIView alloc] initWithFrame: rect] ;
        [sview addSubview: bgView];
//        [self performSelector:@selector(doTransitionWithContentFile:) withObject:fName afterDelay:0.1];
        
        [self performSelector:@selector(doTransitionWithContentView:) withObject:showView afterDelay:0.1];        
    }
    
    return self;
}


- (id)initWithSuperview:(UIView*)sview andFile:(NSString*)fName
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        //UIImage* closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
        closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];    
        [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closePopupWindow:) forControlEvents:UIControlEventTouchUpInside];
        
        
        CGRect rect = CGRectMake(sview.bounds.origin.x, sview.bounds.origin.y,sview.bounds.size.width,sview.bounds.size.height);
        
        bgView = [[UIView alloc] initWithFrame: rect] ;
        [sview addSubview: bgView];
        [self performSelector:@selector(doTransitionWithContentFile:) withObject:fName afterDelay:0.1];
    }
    
    return self;
}



-(void)doTransitionWithContentView:(UIView*) showView {
    mShowView = showView;
    fauxView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 100, 100)];    
    [bgView addSubview: fauxView];
    
    bigPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width*0.75, bgView.frame.size.height*0.75)];        
    bigPanelView.center = CGPointMake( bgView.frame.size.width/2, bgView.frame.size.height/2);    
    
    UIImage * bgImage = [[UIImage imageNamed:@"popupWindowBack.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:21];
//    UIImageView* background = [[UIImageView alloc] initWithImage:bgImage];
    background = [[UIImageView alloc] initWithImage:bgImage];  
    
    NSLog(@"bigPanelView.frame.size.width = %f",bigPanelView.frame.size.width);
    CGRect rectBg = bigPanelView.frame;
    rectBg = CGRectMake(rectBg.origin.x, rectBg.origin.y, rectBg.size.width-30, rectBg.size.height-30);
    
    background.frame = CGRectMake(rectBg.origin.x, rectBg.origin.y, rectBg.size.width, rectBg.size.height);    
    background.center = CGPointMake(bigPanelView.frame.size.width/2, bigPanelView.frame.size.height/2);
    [bigPanelView addSubview: background];
    
    
    int webOffset = 10; 
    
    GlobalVars *vars = [GlobalVars sharedInstance];
    CGRect vrect = vars.mAddCameraAlertVC.view.frame;
    CGRect drect = bigPanelView.frame;
    vars.mAddCameraAlertVC.view.frame = CGRectMake(30,30,drect.size.width-60,drect.size.height-60);
    
    
//    [bigPanelView addSubview:vars.mAddCameraAlertVC.view];
    [bigPanelView addSubview:mShowView];
    //add the close button
    int closeBtnOffset = 5;
    
    
    
    [closeBtn setFrame:CGRectMake( background.frame.origin.x +  closeBtnOffset, 
                                  background.frame.origin.y + closeBtnOffset,
                                  closeBtnImg.size.width + closeBtnOffset, 
                                  closeBtnImg.size.height + closeBtnOffset)];    
    
    
    
    [bigPanelView addSubview: closeBtn];
    
    //animation options
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromRight |
    UIViewAnimationOptionAllowUserInteraction    |
    UIViewAnimationOptionBeginFromCurrentState;
    
    //run the animation
    [UIView transitionFromView:fauxView toView:bigPanelView duration:0.5 options:options completion: ^(BOOL finished) {
        //        UIView* shadeView = [[UIView alloc] initWithFrame:bgView.frame];
        shadeView = [[UIView alloc] initWithFrame:bgView.frame];
        
        shadeView.backgroundColor = [UIColor blackColor];
        shadeView.alpha = 0.3;
        shadeView.tag = kShadeViewTag;
        [bgView addSubview:shadeView];
        [bgView sendSubviewToBack:shadeView];
    }];
}

-(void)doTransitionWithContentFile:(NSString*)fName
{

    fauxView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 100, 100)];    
    [bgView addSubview: fauxView];

    bigPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bgView.frame.size.width*0.75, bgView.frame.size.height*0.75)];        
    bigPanelView.center = CGPointMake( bgView.frame.size.width/2, bgView.frame.size.height/2);    

    
//    UIImageView* background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popupWindowBack.png"]];    
    
//    UIImage * blackImage = [[UIImage imageNamed:@"blk_button.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:21];
    
    UIImage * bgImage = [[UIImage imageNamed:@"popupWindowBack.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:21];
    //UIImageView* background = [[UIImageView alloc] initWithImage:bgImage];
    background = [[UIImageView alloc] initWithImage:bgImage];
    

    NSLog(@"bigPanelView.frame.size.width = %f",bigPanelView.frame.size.width);
    CGRect rectBg = bigPanelView.frame;
    rectBg = CGRectMake(rectBg.origin.x, rectBg.origin.y, rectBg.size.width-30, rectBg.size.height-30);

    background.frame = CGRectMake(rectBg.origin.x, rectBg.origin.y, rectBg.size.width, rectBg.size.height);    
    background.center = CGPointMake(bigPanelView.frame.size.width/2, bigPanelView.frame.size.height/2);
    
    
    [bigPanelView addSubview: background];
    
    
    int webOffset = 10; 
    
    
    BOOL isReadWeb = YES;
    if(isReadWeb) 
    {
        UIWebView* web = [[UIWebView alloc] initWithFrame:CGRectInset(background.frame, webOffset, webOffset)];
        self.mWebView = web;
    
        web.backgroundColor = [UIColor clearColor];
        if ([fName hasPrefix:@"http"]) {
            //load a web page
            web.scalesPageToFit = YES;
            [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: fName]]];
        }
        else 
        {
            //load a local file
            NSError* error = nil;
            NSString* fileContents = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fName] encoding:NSUTF8StringEncoding error: &error];
            if (error!=NULL) {
                NSLog(@"error loading %@: %@", fName, [error localizedDescription]);
            } else {
                [web loadHTMLString: fileContents baseURL:[NSURL URLWithString:@"file://"]];
            }
        }
        [bigPanelView addSubview: web];
    }
    
    GlobalVars *vars = [GlobalVars sharedInstance];
    
    BOOL isUseView = NO;
    if(isUseView) {
        CGRect vrect = vars.mAddCameraAlertVC.view.frame;
        CGRect drect = bigPanelView.frame;
        vars.mAddCameraAlertVC.view.frame = CGRectMake(30,30,drect.size.width-60,drect.size.height-60);
        [bigPanelView addSubview:vars.mAddCameraAlertVC.view];
    }
    //add the close button
    int closeBtnOffset = 5;
    
    
//    UIImage* closeBtnImg = [UIImage imageNamed:@"popupCloseBtn.png"];
//    closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];    
//    [closeBtn setImage:closeBtnImg forState:UIControlStateNormal];
    
//    [closeBtn setFrame:CGRectMake( background.frame.origin.x + background.frame.size.width - closeBtnImg.size.width - closeBtnOffset, 
//                                   background.frame.origin.y ,
//                                   closeBtnImg.size.width + closeBtnOffset, 
//                                   closeBtnImg.size.height + closeBtnOffset)];    
    
    [closeBtn setFrame:CGRectMake( background.frame.origin.x +  closeBtnOffset, 
                                  background.frame.origin.y + closeBtnOffset,
                                  closeBtnImg.size.width + closeBtnOffset, 
                                  closeBtnImg.size.height + closeBtnOffset)];    
    
//    [closeBtn addTarget:self action:@selector(closePopupWindow:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [bigPanelView addSubview: closeBtn];
    
    //animation options
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromRight |
                                        UIViewAnimationOptionAllowUserInteraction    |
                                        UIViewAnimationOptionBeginFromCurrentState;
    
    //run the animation
    [UIView transitionFromView:fauxView toView:bigPanelView duration:0.5 options:options completion: ^(BOOL finished) {
//        UIView* shadeView = [[UIView alloc] initWithFrame:bgView.frame];
        shadeView = [[UIView alloc] initWithFrame:bgView.frame];
        
        shadeView.backgroundColor = [UIColor blackColor];
        shadeView.alpha = 0.3;
        shadeView.tag = kShadeViewTag;
        [bgView addSubview:shadeView];
        [bgView sendSubviewToBack:shadeView];
    }];
}



/**
 * Removes the window background and calls the animation of the window
 */
-(IBAction)closePopupWindow:(id)sender
{
    //remove the shade
//change by milo   
    [[bgView viewWithTag: kShadeViewTag] removeFromSuperview];        
//    [self performSelector:@selector(closePopupWindowAnimate) withObject:nil afterDelay:0.1];
//    [self closePopupWindowAnimate];  
    [self performSelector:@selector(closePopupWindowAnimate:) withObject:nil afterDelay:0.1];
}



-(IBAction)closePopupWindowAnimate:(id)sender
{

    //faux view
    __block UIView* fauxView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 200, 200)];

    
    [bgView addSubview: fauxView];

    //run the animation
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionFlipFromLeft |
    UIViewAnimationOptionAllowUserInteraction    |
    UIViewAnimationOptionBeginFromCurrentState;
    
    //hold to the bigPanelView, because it'll be removed during the animation
//    [bigPanelView retain];

    
    [UIView transitionFromView:bigPanelView toView:fauxView duration:0.5 options:options completion:^(BOOL finished) {

        if(NO) {
        //when popup is closed, remove all the views
        for (UIView* child in bigPanelView.subviews) {
            [child removeFromSuperview];
        }
        for (UIView* child in bgView.subviews) {
            [child removeFromSuperview];
        }
//        [bigPanelView release];
        bigPanelView = nil;
        [bgView removeFromSuperview];
//        [self release];
        staticMTPopupWindow = nil;
        }
        else {
            [self releaseProp];
        }
    }];
}

@end