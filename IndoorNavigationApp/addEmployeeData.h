//
//  addEmployeeData.h
//  IndoorNavigationApp
//
//  Created by user on 6/26/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addEmployeeData : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *empidfield;
@property (strong, nonatomic) IBOutlet UITextField *namefield;
@property (strong, nonatomic) IBOutlet UITextField *desigfield;
@property (strong, nonatomic) IBOutlet UITextField *emailidfield;
@property (strong, nonatomic) IBOutlet UITextField *phnofield;
@property (strong, nonatomic) IBOutlet UITextField *xfield;
@property (strong, nonatomic) IBOutlet UITextField *yfield;
-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;




@end
