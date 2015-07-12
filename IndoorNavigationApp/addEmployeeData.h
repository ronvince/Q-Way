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

@property (weak, nonatomic) IBOutlet UITextField *xPlace;

@property (weak, nonatomic) IBOutlet UITextField *placefield;
@property (weak, nonatomic) IBOutlet UITextField *placeTypeField;

@property (weak, nonatomic) IBOutlet UITextField *yPlace;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;
-(IBAction)saveplace:(id)sender;


@end
