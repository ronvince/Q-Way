//
//  infoViewController.m
//  IndoorNavigationApp
//
//  Created by user on 7/10/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "infoViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface infoViewController () <UIPopoverPresentationControllerDelegate>

@end

@implementation infoViewController
@synthesize if_emp_place;

- (instancetype)init {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *pop=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 230,250)];
    // pop.backgroundColor = [UIColor colorWithRed:0.722 green:0.722 blue:0.722 alpha:1];
    
    //name field
    UILabel *name=[[UILabel alloc] initWithFrame:CGRectMake(0,0,230,75)];
    name.textAlignment = NSTextAlignmentCenter;
    name.center = CGPointMake(115,135);
    
    //setting designation
    UILabel *desig=[[UILabel alloc] initWithFrame:CGRectMake(10,85,190,100)];
    desig.textAlignment = NSTextAlignmentCenter;
    desig.center = CGPointMake(115,160);
    desig.textColor = [UIColor redColor];
    
    //setting email info
    UILabel *email=[[UILabel alloc] initWithFrame:CGRectMake(10,95,230,120)];
    email.textAlignment = NSTextAlignmentCenter;
    email.center = CGPointMake(115,195);
    [email setFont:[UIFont fontWithName:@"Times New Roman" size:18.0f]];
    email.textColor =[UIColor  colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    
    // setting imageview
    UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(65, 20, 100,95)];
    
    img.layer.cornerRadius = img.frame.size.width/2;
    img.layer.cornerRadius =  img.frame.size.height/2;
    img.layer.masksToBounds = YES;
    img.layer.borderWidth = 0;
    
    
    UILabel *phno=[[UILabel alloc] initWithFrame:CGRectMake(10,125,150,100)];
    phno.textAlignment = NSTextAlignmentCenter;
    phno.center = CGPointMake(115,225);
    //phno.textColor = [UIColor redColor];
    
    
    
    if(if_emp_place==0)
    {
        name.text=_employe.name;
        desig.text=_employe.desig;
        email.text=_employe.email;
        phno.text=_employe.phno;
        NSString *inputString = _employe.empid;
        int value = [inputString intValue];
        NSLog(@"%d",value);
        NSString *imageName=[NSString stringWithFormat:@"7.jpg"];
        img.image = [UIImage imageNamed:imageName];
    }
    else if((int)if_emp_place==1)
    {
        
        name.text=_place.placeName;
        desig.text=_place.placeType;
        // email.text=_employe.email;
        
        NSString *imageName=[NSString stringWithFormat:@"%@.png",_place.placeType];
        img.image = [UIImage imageNamed:imageName];
    }
    
    
    [self.view addSubview:pop];
    [self.view addSubview:name];
    [self.view addSubview:desig];
    [self.view addSubview:img];
    [self.view addSubview:email];
   // [self.view addSubview:phno];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController {
    
    self.sourceRect = CGRectMake(180, 230, 0, 0);
    
    
    
    self.popoverPresentationController.sourceView = self.sourceView ? self.sourceView : self.view;
    self.popoverPresentationController.sourceRect = self.sourceRect;
    self.preferredContentSize = self.contentSize;
    //    self.preferredContentSize = CGSizeMake(195, 45);
    self.popoverPresentationController.permittedArrowDirections = self.arrowDirection ? self.arrowDirection : 0;
    
    self.popoverPresentationController.backgroundColor = self.backgroundColor;
    self.popoverPresentationController.popoverLayoutMargins = self.popoverLayoutMargins;
}

#pragma mark - Adaptive Presentation Controller Delegate

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}/*
  #pragma mark - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */

@end

