//
//  addQrData.m
//  IndoorNavigationApp
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Roni Vincent

#import "addQrData.h"
#import <CoreData/CoreData.h>


@implementation addQrData

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


- (IBAction)savefunc:(id)sender {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"QRCode" inManagedObjectContext:context];
    [newDevice setValue:self.qrfield.text forKey:@"qr"];
    
    float xvalue = [self.xfield.text intValue];
    [newDevice setValue:[NSNumber numberWithFloat:xvalue] forKey:@"x"];
    
    //[newDevice setValue:self.xfield.text forKey:@"x"];
    
    float yvalue = [self.yfield.text intValue];
    [newDevice setValue:[NSNumber numberWithFloat:yvalue] forKey:@"y"];
    
    // [newDevice setValue:self.yfield.text forKey:@"y"];
    [newDevice setValue:self.deffield.text forKey:@"def"];
    
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }


}

@end
