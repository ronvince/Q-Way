//
//  favouriteViewController.h
//  IndoorNavigationApp
//
//  Created by user on 7/15/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "favrtTableViewCell.h"
#import <CoreData/CoreData.h>
#import "Employee.h"


@interface favouriteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Employee* favouriteemployeexy;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
