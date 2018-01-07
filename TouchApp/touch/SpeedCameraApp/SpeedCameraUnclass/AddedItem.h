//
//  AddedItem.h
//  SpeedCamera
//
//  Created by Milo Chen on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AddedItem : NSManagedObject

@property (nonatomic, retain) NSString * mDirection;
@property (nonatomic, retain) NSString * mDirtype;
@property (nonatomic, retain) NSString * mId;
@property (nonatomic, retain) NSNumber * mLat;
@property (nonatomic, retain) NSNumber * mLng;
@property (nonatomic, retain) NSString * mSpeed;
@property (nonatomic, retain) NSString * mStars;
@property (nonatomic, retain) NSString * mType;
@property (nonatomic, retain) NSString * mVotes;

@end
