//
//  EmployeeTable.m
//  IndoorNavigationApp
//
//  Created by user on 7/7/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "EmployeeTable.h"
#import "enhancedCell.h"
#import "Employee.h"

@interface EmployeeTable ()
@property (strong) NSMutableArray *allTableData;
@property (strong) NSMutableArray *tableArray;
//@property (strong) NSMutableArray *defaultData;
@end

@implementation EmployeeTable
@synthesize isFiltered;

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar.delegate = (id)self;
  }
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    // [self setSearchBar:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
    self.allTableData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    self.tableArray = self.allTableData;
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    
    if(text.length == 0)
    {
        isFiltered = FALSE;
    }
    else
    {
        isFiltered = true;
        _tableArray = [[NSMutableArray alloc] init];
        
        for (Employee*  employe in _allTableData)
        {
            NSRange nameRange = [employe.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [ employe.desig rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [_tableArray addObject: employe];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.isFiltered)
        
        return self.tableArray.count;
    else
        
        return self.allTableData.count;
        //return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    static NSString *CellIdentifier = @"Cell";
    enhancedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial Rounded MT" size:16.0];
    /*if (cell == nil)
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
     */
    
    Employee *emp;
    if(isFiltered)
        
        emp = [self.tableArray objectAtIndex:indexPath.row];
    else
        emp = [self.allTableData objectAtIndex:indexPath.row];
    
    cell.namefield.text=emp.name;
    cell.desigfield.text=emp.desig;
    cell.emailfield.text=emp.email;
    
    NSString *inputString = emp.empid;
    int value = [inputString intValue];
    NSLog(@"%d",value);
    
    NSString *imageName=[NSString stringWithFormat:@"%d.jpg",value];
    
    UIImageView *imagefield =[[UIImageView alloc] initWithFrame:CGRectMake(50,50,20,20)];
    
    // [self.view addSubview:dot];
    cell.imagefield.layer.cornerRadius = imagefield.frame.size.width/2;
    cell.imagefield.layer.cornerRadius =  cell.imagefield.frame.size.height/2;
    cell.imagefield.layer.masksToBounds = YES;
    cell.imagefield.layer.borderWidth = 0;
    
    cell.imagefield.image=[UIImage imageNamed:imageName];
    NSLog(@"%@", imageName);
    NSLog(@"%@", emp.name);
    return cell;   
    
    
}


@end
