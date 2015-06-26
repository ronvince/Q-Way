//
//  Employee.h
//  IndoorNavigationApp
//
//  Created by user on 6/26/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * desig;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * empid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phno;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;

@end
