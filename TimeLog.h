//
//  TimeLog.h
//  IndoorNavigationApp
//
//  Created by user on 7/1/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeLog : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * deftime;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * datetime;

@end
