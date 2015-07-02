//
//  addEmployeeData.m
//  IndoorNavigationApp
//
//  Created by user on 6/26/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Roni Vincent.

#import "addEmployeeData.h"
#import <CoreData/CoreData.h>

@implementation addEmployeeData


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)save:(id)sender {
    
     NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    [newDevice setValue:self.namefield.text forKey:@"name"];
    [newDevice setValue:self.empidfield.text forKey:@"empid"];
    [newDevice setValue:self.desigfield.text forKey:@"desig"];
    [newDevice setValue:self.emailidfield.text forKey:@"email"];
    
    float xvalue = [self.xfield.text intValue];
    [newDevice setValue:[NSNumber numberWithFloat:xvalue] forKey:@"x"];
    
    float yvalue = [self.yfield.text intValue];
    [newDevice setValue:[NSNumber numberWithFloat:yvalue] forKey:@"y"];
    
    //  [newDevice setValue:self.yfield.text forKey:@"y"];
    [newDevice setValue:self.phnofield.text forKey:@"phno"];
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveplace:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Places" inManagedObjectContext:context];
    
    [newDevice setValue:self.placefield.text forKey:@"placeName"];
    
    
    float xvalue = [self.xPlace.text intValue];
    [newDevice setValue:[NSNumber numberWithFloat:xvalue] forKey:@"x"];
    
    float yvalue = [self.yPlace.text intValue];
    [newDevice setValue:[NSNumber numberWithFloat:yvalue] forKey:@"y"];
  
    [newDevice setValue:self.placeTypeField.text forKey:@"placeType"];
    
    NSError *error = nil;
    
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
