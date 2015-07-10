//
//  categoryTableViewCell.h
//  IndoorNavigationApp
//
//  Created by user on 7/12/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface categoryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameField;
@property (weak, nonatomic) IBOutlet UILabel *desigField;
@property (weak, nonatomic) IBOutlet UILabel *emailField;

@property (weak, nonatomic) IBOutlet UIImageView *imageField;
@property (weak, nonatomic) IBOutlet UIButton *popButton;

@end
