//
//  MTPopupWindow.h
//  PopupWindowProject
//
//  Created by Marin Todorov on 7/1/11.
//  Copyright 2011 Marin Todorov. MIT license
//  http://www.opensource.org/licenses/mit-license.php
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MTPopupWindow : NSObject
{
    UIView* bgView;
    UIView* bigPanelView;
    UIView* shadeView;
    UIButton* closeBtn;
    UIView* fauxView;
    UIImage* closeBtnImg;
    UIView * mShowView;
    UIWebView * mWebView;
    UIImageView * background;
}
@property (nonatomic,strong) UIWebView * mWebView;
@property (nonatomic,strong) UIView * mShowView;
@property (nonatomic,strong) UIImageView *background;

-(IBAction)closePopupWindow:(id)sender;
-(IBAction)closePopupWindowAnimate:(id)sender;
-(void)doTransitionWithContentFile:(NSString*)fName;
+(void)showWindowWithHTMLFile:(NSString*)fileName insideView:(UIView*)view;
+(void)showWindowWithView:(UIView*)showView insideView:(UIView*)view;
+(void)showCameraOkWindowWithTitle:(NSString*)title andMessage:(NSString*)message insideView:(UIView*)view;

+(void)closePopupWindow;



@property (nonatomic,strong) UIView *shadeView;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *bigPanelView;
@property (nonatomic,strong) UIView *fauxView;
@property (nonatomic,strong) UIImage* closeBtnImg;

@property (nonatomic,strong) UIButton* closeBtn;

#define WIDTH (200)
#define HEIGHT (200)
@end
