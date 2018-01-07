//
//  WeatherSettingsListViewController.h
//  touch
//
//  Created by Milo Chen on 12/11/12.
//
//

#import <UIKit/UIKit.h>
@class CoreDataHelper;
@class WeatherObj;
@interface WeatherSettingsListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
}
@property (nonatomic,strong) IBOutlet UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray * mObjArray; //NSString Array
@property (nonatomic,strong) CoreDataHelper * mCoreDataHelper;

-(void) editWeatherObj:(WeatherObj*)obj ;
-(void) addWeatherObj:(WeatherObj*)obj ;
-(void) deleteWeatherObj:(WeatherObj*)obj ;
@end
