//
//  ComboBox.m
//
//  Created by Dor Alon on 12/17/11.
//  http://doralon.net

#import "ComboBox.h"
#import "ComboBoxDelegate.h"
#import "GlobalVars.h"
@implementation ComboBox

@synthesize delegate;
@synthesize mIsSupportExternalView;


-(int) getSelectedIdx 
{
    return mSelectedIdx;
}

-(NSString*) getSelectedText {
    return textField.text;
    
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//-- UIPickerViewDelegate, UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    mSelectedIdx = row;
    textField.text = [dataArray objectAtIndex:row];
    NSLog(@"didSelectRow");

}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [dataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [dataArray objectAtIndex:row];
}

//-- ComboBox


//-(void) setComboData:(NSMutableArray*) data withDefaultSelectedIdx:(int)idx
//{
//    dataArray = data;    
//    mSelectedIdx = idx;
//    textField.text = [data objectAtIndex:mSelectedIdx];
//}

-(void) changeComboData:(NSMutableArray*) data withDefaultSelectedIdx:(int)idx {
    dataArray = data;    
    mSelectedIdx = idx;
    textField.text = [data objectAtIndex:mSelectedIdx];    
}

-(void) setContainer:(UIView*)view withComboData:(NSMutableArray*) data andDefaultSelectedIdx:(int)idx 
{

    self.view.frame = CGRectMake(0, 0, view.frame.size.width,view.frame.size.height);
    [view addSubview:self.view];
    view.backgroundColor = [UIColor clearColor];
    
    //need to add subview before set gui information.
    
    dataArray = data;    
    mSelectedIdx = idx;
    textField.text = [data objectAtIndex:mSelectedIdx];    
}


-(void) someMethod {
    if(delegate == nil) return;
    if(![delegate conformsToProtocol:(@protocol(ComboBoxDelegate))]) return;
    if([delegate respondsToSelector:@selector(method1:)]) {
        [delegate method1:@"delegate.method1 ola"];
    }
    if([delegate respondsToSelector:@selector(method2:)]) {
        [delegate method2:@"delegate.method2 a pay rise"];
    }

}

-(void)doneClicked:(id) sender
{
    [textField resignFirstResponder]; //hides the pickerView
//    [textField.delegate textFieldDidEndEditing:textField];
    if(delegate != nil) {
        [self someMethod];
    }
    
    if(delegate != nil) {
        [delegate didEndChoiceItem:self];
    }
}



-(void) performShowPicker {
    [textField becomeFirstResponder];
//    [self performSelector:@selector(showPicker:) withObject:nil];
}

- (IBAction)showPicker:(id)sender {
    NSLog(@"showPicker is invoked in ComboBox");
//    pickerView = [[UIPickerView alloc] init];
    
    if(mIsSupportExternalView) {
//      pickerView = [[UIPickerView alloc ] initWithFrame:CGRectMake(320,20,300,200)];  
      pickerView = [[UIPickerView alloc ] initWithFrame:CGRectMake(355,32,300,200)];          
    } else {
      pickerView = [[UIPickerView alloc ] init];  
    }

    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;

    UIToolbar* toolbar = [[UIToolbar alloc] init];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [toolbar sizeToFit];
    
    //to make the done button aligned to the right
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked:)];
    
    
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpaceLeft, doneButton, nil]];

    //custom input view
    
    textField.inputView = pickerView;
    
    if(mIsSupportExternalView) {
        [textField.inputView removeFromSuperview];
        GlobalVars *vars =[GlobalVars sharedInstance];
        [vars.exterNav.view addSubview:textField.inputView];
    }
    
    textField.inputAccessoryView = toolbar;    
}

-(void) cancelPicker  {
    NSLog(@"cancelPicker is invoked");
    if(textField != nil && textField.inputView != nil) {
    [textField.inputView removeFromSuperview];
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)aTextField
{    
    [self showPicker:aTextField];
    return YES;
}

@end
