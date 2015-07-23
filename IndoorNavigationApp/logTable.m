//
//  logTable.m
//  IndoorNavigationApp
//
//  Created by user on 7/23/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "logTable.h"
#import "newcell.h"
#import "TimeLog.h"
#import <CoreData/CoreData.h>


@interface logTable ()

@property (strong) NSMutableArray *timecell;

@end

@implementation logTable


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
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TimeLog"];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"slno"
                                                                   ascending:YES];
    NSMutableArray *sortDescriptors = [[NSMutableArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
   
    NSError *error = nil;
    
    self.timecell = [[managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    NSLog(@"%lu", (unsigned long)_timecell.count);
    
    
   
    [managedObjectContext save:&error];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 500, 210, 25)];
    [self setToastLabel:tempLabel];
    
    
    
    [self.toastLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:13]];
    [self.toastLabel  setTextAlignment:NSTextAlignmentCenter];
    [self.toastLabel  setTextColor:[UIColor whiteColor]];
    self.toastLabel.backgroundColor =[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    self.toastLabel.layer.cornerRadius = 10;
    // self.label.layer.borderWidth = 1;
    self.toastLabel.layer.masksToBounds = YES;
    [_toastLabel setHidden:YES];
    [[self view] addSubview:_toastLabel];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



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
    NSString *s = [NSString stringWithFormat:@"%@", qr.slno];
    cell.slnofield.text = s;
    //sl++;
    
    
   
    return cell;
    
}

- (IBAction)timelogCancel:(id)sender {
 
    
    [self performSegueWithIdentifier:@"time2map" sender:self];
    
}

- (IBAction)clearHistory:(id)sender {
    
  if ([_timecell count] == 0) {
    
      [_toastLabel setText:@"History empty"];
      [_toastLabel setHidden:NO];

  }
    else
    {
        [_toastLabel setText:@"Scan history cleared"];
        [_toastLabel setHidden:NO];
    
    }
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(animate:)
                                   userInfo:nil
                                    repeats:NO];
    

    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)
                              [[sender superview] superview]];

    NSManagedObjectContext *managedObjectContext2 = [self managedObjectContext];
    NSFetchRequest *ch = [[NSFetchRequest alloc]init];
    [ch setEntity:[NSEntityDescription entityForName:@"TimeLog" inManagedObjectContext:managedObjectContext2]];
    
    // NSFetchRequest *requestdel = [[NSFetchRequest alloc]initWithEntityName:@"TimeLog"];
    // NSManagedObjectContext *managedObjectContext2 = [self managedObjectContext];
    NSArray *result = [managedObjectContext2 executeFetchRequest:ch error:nil];
    NSLog(@"%lu", (unsigned long)result.count);
    //count = result.count;
    
        //TimeLog *tim;
       // tim = [result objectAtIndex:0];
        
        //NSLog(@"date check%@",dateString);
       // NSLog(@"tim.date check%@",tim.date);
        //if (![dateString isEqualToString:tim.date]) {
    if (result.count!=0) {
        for (NSManagedObject * res in result) {
            [managedObjectContext2 deleteObject:res];
            [self.timecell removeObjectAtIndex:indexPath.row];
        }
        NSError *saveError = nil;
        [managedObjectContext2 save:&saveError];
    }
    
            //count = 0;
    
    [self.tableView reloadData];
    
    
}

-(void)animate:(NSTimer *)theTimer {
    [_toastLabel setHidden:YES];
    }

@end
