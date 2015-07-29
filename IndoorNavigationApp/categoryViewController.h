//
//  categoryViewController.h
//  IndoorNavigationApp
//
//  Created by user on 7/12/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "categoryTableViewCell.h"
#import "Employee.h"
#import "enhancedCell.h"
#import "Places.h"

@interface categoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) bool isFiltered;
@property (nonatomic, strong) NSString *categoryName;
@property (strong, nonatomic) Employee* categoryemployexy;
@property (strong, nonatomic) Places* categoryplacexy;
@property (nonatomic)  NSInteger *emp_plac;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imagefield;
@property (nonatomic, retain) UILabel *toastLabel;
@property (nonatomic, retain) UILabel *favLabel;

@end
