//
//  homeViewController.m
//  IndoorNavigationApp
//
//  Created by user on 7/12/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Anita Grace Daniel.

#import "homeViewController.h"

@interface homeViewController ()

@end

@implementation homeViewController
@synthesize nameLabel;
@synthesize xField;
@synthesize yField;
@synthesize employe;
@synthesize place;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.navigationItem.title = @"Employees";
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setNameLabel:nil];
    [self setXField:nil];
     [self setYField:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    if(employe)
    {
    nameLabel.text = employe.name;
    xField.text = employe.desig;
    }
    else if(place)
    {
        nameLabel.text =place.placeName;
        [xField setText:[NSString stringWithFormat:@"%@", place.x]];
        [yField setText:[NSString stringWithFormat:@"%@", place.y]];
    }
   }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
