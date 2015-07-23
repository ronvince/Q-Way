//
//  logTable.h
//  IndoorNavigationApp
//
//  Created by user on 7/23/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface logTable : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) UILabel *toastLabel;@end
