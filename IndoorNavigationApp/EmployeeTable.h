//
//  EmployeeTable.h
//  IndoorNavigationApp
//
//  Created by user on 7/7/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee.h"
#import "Places.h"

@interface EmployeeTable : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Employee* employexy;
@property (strong, nonatomic) Places* placexy;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *buttonPlace;
@property (weak, nonatomic) IBOutlet UIButton *buttonEmploy;
@property (nonatomic, assign) bool isFiltered;

@property (weak, nonatomic) IBOutlet UIView *lineView;


@end
