//
//  EmployeeTable.h
//  IndoorNavigationApp
//
//  Created by user on 7/7/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployeeTable : UITableViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (nonatomic, assign) bool isFiltered;@end
