//
//  timeLogTable.m
//  IndoorNavigationApp
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Roni Vincent.

#import "timeLogTable.h"
#import "newcell.h"
#import "TimeLog.h"
#import <CoreData/CoreData.h>

@interface timeLogTable()

@property (strong) NSMutableArray *timecell;

@end

@implementation timeLogTable
int sl = 1;
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    sl=1;
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TimeLog"];
    
    //    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TimeLog" inManagedObjectContext:context];
    //    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datetime"
                                                                   ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy"];
    
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [format stringFromDate:now];
    //dateString =@"hdfhjkfg";
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date == %@", dateString]];
    NSError *error = nil;
    
    self.timecell = [[managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    NSLog(@"%lu", (unsigned long)_timecell.count);
    
    
    //    self.timecell = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [managedObjectContext save:&error];

    
    
    
    //    self.timecell = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//new code

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.timecell.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    newCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //    NSString *searchcontents = @"";
    //    if ([searchcontents isEqualToString:_searchfield.text]) {
    //static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //NSManagedObject *device = [self.timecell objectAtIndex:indexPath.row];
    
    TimeLog *qr = [self.timecell objectAtIndex:indexPath.row];
    
    
    /*  [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@", [device valueForKey:@"fname"], [device valueForKey:@"sname"]]];
     [cell.detailTextLabel setText:[device valueForKey:@"age"]];*/
    cell.deffield.text = qr.deftime;
    cell.timefield.text = qr.time;
    //cell.datefield.text = qr.date;
 //   cell.slnofield.text = qr.slno;
    NSString *s = [NSString stringWithFormat:@"%d",sl];
    cell.slnofield.text = s;
    sl++;
    
    
    NSLog(@"helloWorld");
    return cell;
    
}

@end
