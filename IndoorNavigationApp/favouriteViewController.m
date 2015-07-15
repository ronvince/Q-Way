//
//  favouriteViewController.m
//  IndoorNavigationApp
//
//  Created by user on 7/15/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "favouriteViewController.h"
#import <CoreData/CoreData.h>
@interface favouriteViewController ()
@property (strong) NSMutableArray *tableArray;
@end

@implementation favouriteViewController


- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:managedObjectContext]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"favrt == 1 " ]];
    NSError* error = nil;
    self.tableArray = [[managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
    NSLog(@"%lu", (unsigned long)self.tableArray.count);
    [self.tableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    
    return self.tableArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    favrtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favrt" forIndexPath:indexPath];
    Employee*  emp;
    
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial Rounded MT" size:16.0];
    
    emp = [self.tableArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=emp.name;
    cell.desigField.text = emp.desig;
    
    
    NSString *inputString = emp.empid;
     int value = [inputString intValue];
  
     NSString *imageName=[NSString stringWithFormat:@"%d.jpg",value];
     
     
     cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
     cell.imageView.layer.cornerRadius =  cell.imageView.frame.size.height/2;
     cell.imageView.layer.masksToBounds = YES;
     cell.imageView.layer.borderWidth = 0;
     cell.imageView.image=[UIImage imageNamed:imageName];
     
      return cell;
}

- (IBAction)cancelfunction:(id)sender {
    [self performSegueWithIdentifier:@"favourite" sender:self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSIndexPath *path=[[NSIndexPath alloc]init];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
           }
    
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"     " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSError* error = nil;
        Employee *obj = [self.tableArray objectAtIndex:indexPath.row];
        /*
         NSLog(@"NAME  %@", obj.name);
         NSLog(@"NAME  %@", obj.favrt);
         */
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:managedObjectContext]];
        
        NSString *delstring = obj.empid;
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"empid == %@ ", delstring]];
        
        NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        Employee *emp1=[results  objectAtIndex:0];
        /*
         NSLog(@"NAME  %@", emp1.name);
         NSLog(@"NAME  %@", obj.favrt);
         */
        emp1.favrt = @"0";
        [managedObjectContext save:&error];
        
        [self.tableArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        [self.tableView reloadData];
        
        

        
    }];
     favAction.backgroundColor = [[UIColor  alloc] initWithPatternImage:[UIImage imageNamed:@"Untitled.png"]];;
        
    return @[favAction];
}



    /*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
