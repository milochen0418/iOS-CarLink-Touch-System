//
//  AppObject.h
//  touch
//
//  Created by Curt ucera on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppObject : NSObject {
    NSString * mNativeApplicationURLScheme;
    NSString * mITuneInstallURL;
    NSString * mAppIconUrl;
    NSString * mAppName;
    NSString * mAppDescription;
}
@property (nonatomic,strong) NSString * mAppDescription;
@property (nonatomic,strong) NSString * mNativeApplicationURLScheme;
@property (nonatomic,strong) NSString * mITuneInstallURL;
@property (nonatomic,strong) NSString * mAppIconUrl;
@property (nonatomic,strong) NSString * mAppName;

-(AppObject*) initWithUrlScheme:(NSString*)urlScheme andITuneUrl:(NSString*)iTuneUrl;
-(void) reloadAppIconAndName;
-(void) loadAppIconAndName;
-(BOOL) isInstalled;
-(void) openITuneForInstall;
-(void) openApplication;
-(void) actionIt; //check whether install and decide to install or open application
-(UIImage*) getIconFromAppStore;


@end
