//
//  ComboBox.h
//
//  Created by Dor Alon on 12/17/11.
//  http://doralon.net

#import <UIKit/UIKit.h>


@protocol ComboBoxDelegate;
@interface ComboBox : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
{
    UIPickerView* pickerView;
    IBOutlet UITextField* textField;
    NSMutableArray *dataArray;
    int mSelectedIdx;
    //id<ComboBoxDelegate> __unsafe_unretained delegate;
    BOOL mIsSupportExternalView;
}

//@property (unsafe_unretained) id<ComboBoxDelegate> delegate;
@property (nonatomic,assign) id<ComboBoxDelegate> delegate;
@property (nonatomic) BOOL mIsSupportExternalView;

-(void) someMethod;


-(void) performShowPicker ;

-(void) setContainer:(UIView*)view withComboData:(NSMutableArray*) data andDefaultSelectedIdx:(int)idx;
-(void) changeComboData:(NSMutableArray*) data withDefaultSelectedIdx:(int)idx;

//set the picker view items

-(int) getSelectedIdx;
-(NSString*) getSelectedText;
-(void) cancelPicker ;
@end
