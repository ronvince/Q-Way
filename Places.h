//
//  Places.h
//  IndoorNavigationApp
//
//  Created by user on 7/11/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Places : NSManagedObject

@property (nonatomic, retain) NSString * placeName;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSString * placeType;

@end
