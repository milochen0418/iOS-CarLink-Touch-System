//
//  PanelViewCotnroller.h
//  helloworld
//
//  Created by Milo Chen on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@class DAAutoTextView;

@interface DebugPanelViewCotnroller : UIViewController
{
//    UITextView * mDbgTextView;
    DAAutoTextView *mDbgTextView;
    UISegmentedControl * mDbgDynamicSeg;
    UIButton * mDbgRefreshBtn;
    UIButton * mDbgCleanBtn;
    UIButton * mDbgLogFeedback;
    NSString * mDbgString;
    BOOL mIsDbgDynamic;
}


@property (nonatomic) BOOL mIsDbgDynamic;
@property (nonatomic,strong) IBOutlet UIButton * mDbgCleanBtn;
@property (nonatomic,strong) IBOutlet UIButton * mDbgLogFeedback;
@property (nonatomic,strong) NSString * mDbgString;


//@property (nonatomic,strong) IBOutlet UITextView * mDbgTextView;
@property (nonatomic,strong) IBOutlet DAAutoTextView * mDbgTextView;
@property (nonatomic,strong) IBOutlet UISegmentedControl * mDbgDynamicSeg;
@property (nonatomic,strong) IBOutlet UIButton * mDbgRefreshBtn;

-(IBAction) clickToRefresh : (id)sender;
-(IBAction) clickToChangeDynamicSeg : (id)sender;
-(IBAction) clickToCleanLog : (id)sender;
-(IBAction) clickToFeedbackLog : (id)sender;
-(void) initDefaultValue ;
-(void) addLog:(NSString*)log;

-(void) postDataToPhpServer:(NSString*)dataStr ;
@end
