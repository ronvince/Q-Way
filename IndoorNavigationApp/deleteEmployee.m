//
//  deleteEmployee.m
//  IndoorNavigationApp
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Roni Vincent.

#import "deleteEmployee.h"
#import <CoreData/CoreData.h>
#import "Employee.h"
#import "Places.h"

@interface deleteEmployee()
@property (strong, nonatomic) IBOutlet UITextField *deletefield;
@property (strong, nonatomic) IBOutlet UITextField *deleteplaces;

@property (strong) NSMutableArray *employees;

@end

@implementation deleteEmployee
NSManagedObjectContext *_managedObjectContext;
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (IBAction)deletefunc:(id)sender {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:managedObjectContext]];
    
     NSString *delstring = _deletefield.text;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@ ", delstring]];
    NSError* error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"hellooo %lu",(unsigned long)results.count);
    if(results.count){
        Employee *emp=[results  objectAtIndex:0];
        [managedObjectContext deleteObject:emp];

    }
        //}
    [managedObjectContext save:&error];
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)delplaces:(id)sender {
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Places" inManagedObjectContext:managedObjectContext]];
    
    NSString *delstring = _deleteplaces.text;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"placeName == %@ ", delstring]];
    NSError* error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"hellooo %lu",(unsigned long)results.count);
    if(results.count){
        Places *pl=[results  objectAtIndex:0];
        [managedObjectContext deleteObject:pl];
        
    }
    //}
    [managedObjectContext save:&error];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
