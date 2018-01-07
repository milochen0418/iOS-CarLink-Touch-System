//
//  ComboBoxDelegate.h
//  touch
//
//  Created by Milo Chen on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ComboBoxDelegate <NSObject>
@optional
-(void)method1:(NSString*)value1;
-(void)method2:(NSString*)value2;
-(void)didEndChoiceItem:(id)senderComboBox;
@end
