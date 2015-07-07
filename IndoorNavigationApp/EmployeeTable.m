//
//  EmployeeTable.m
//  IndoorNavigationApp
//
//  Created by user on 7/7/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "EmployeeTable.h"
#import "enchancedCell.h"
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

- (UITableViewCell *)tableView:(UITableView *)tableView

         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   /* NSMutableArray *defaultData = [[NSMutableArray alloc] init];
    [defaultData addObject:@"PM"];
    [defaultData addObject:@"Developer"];
    [defaultData addObject:@"Architect"];
    [defaultData addObject:@"BA"];
    [defaultData addObject:@"Trainee"];
    [defaultData addObject:@"Intern"];
    
    */
    
    UIImageView *imagefield =[[UIImageView alloc] init];
    //setting default image
    
   // imagefield.image = [UIImage imageNamed:@"default.jpg"];
    
    
    static NSString *CellIdentifier = @"Cell";
    enchancedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial Rounded MT" size:16.0];
    
    Employee *emp;
    if(isFiltered)
    {
        emp = [self.tableArray objectAtIndex:indexPath.row];
           }
    else
    {
    emp= [self.allTableData objectAtIndex:indexPath.row];
    }
    
    cell.desigfield.text=emp.desig;
    cell.emailfield.text=emp.email;
    cell.namefield.text=emp.name;
    
    
    NSString *inputString = emp.empid;
    int value = [inputString intValue];
    NSString *imageName=[NSString stringWithFormat:@"%d.jpg",value];
    
    // [self.view addSubview:dot];
    cell.imagefield.layer.cornerRadius = imagefield.frame.size.width/2;
    cell.imagefield.layer.cornerRadius =  cell.imagefield.frame.size.height/2;
    cell.imagefield.layer.masksToBounds = YES;
    cell.imagefield.layer.borderWidth = 0;
    cell.imagefield.image=[UIImage imageNamed:imageName];
    
    return cell;
    
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
