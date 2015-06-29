//
//  QRCode.h
//  IndoorNavigationApp
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QRCode : NSManagedObject

@property (nonatomic, retain) NSString * qr;
@property (nonatomic, retain) NSString * def;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;

@end
