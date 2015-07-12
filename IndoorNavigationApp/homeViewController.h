//
//  homeViewController.h
//  IndoorNavigationApp
//
//  Created by user on 7/12/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "Places.h"
@interface homeViewController : UIViewController
@property (strong, nonatomic) Employee* employe;
@property (strong, nonatomic) Places* place;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *xField;
@property (weak, nonatomic) IBOutlet UILabel *yField;

@end
