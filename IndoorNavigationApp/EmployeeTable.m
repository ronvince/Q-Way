//
//  EmployeeTable.m
//  IndoorNavigationApp
//
//  Created by user on 7/7/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Roni Vincent and Anita Grace Daniel.

#import "EmployeeTable.h"
#import "enhancedCell.h"
#import "Employee.h"
#import "mapDraw.h"
#import "Places.h"
#import "homeViewController.h"
#import "categoryViewController.h"
#import <CoreData/CoreData.h>

@interface EmployeeTable ()
@property (strong) NSMutableArray *allTableData;
@property (strong) NSMutableArray *tableArray;
@property (strong) NSMutableArray *defaultData;
@property (strong) NSMutableArray *prevoiusdata;
@end

@implementation EmployeeTable
@synthesize isFiltered;
int prevTextLen;
//int x,y;
int u=0;

//NSManagedObjectContext *managedObjectContext;
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
-(void)selection{
    if (u==0) {
        printf("u==0 employee");
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
        self.allTableData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        self.tableArray = self.allTableData;
        [self.tableView reloadData];
        NSLog(@"%lu", (unsigned long)_allTableData.count);
    }
    else if (u==1)
    {
        printf("u==1 places");
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Places"];
        self.allTableData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        self.tableArray = self.allTableData;
        [self.tableView reloadData];
        NSLog(@"%lu", (unsigned long)_allTableData.count);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = (id)self;
  }
-(void)defaultDatashow{
    if (u==0) {
        self.defaultData  = [[NSMutableArray alloc] init];
        [self.defaultData  addObject:@"PM"];
        [self.defaultData  addObject:@"Developer"];
        [self.defaultData  addObject:@"Architect"];
        [self.defaultData  addObject:@"BA"];
        [self.defaultData  addObject:@"Trainee"];
        [self.defaultData  addObject:@"Intern"];
            }
    else if (u==1){
        self.defaultData   = [[NSMutableArray alloc] init];
        [self.defaultData  addObject:@"Meeting"];
        [self.defaultData  addObject:@"Entry/Exit"];
        [self.defaultData  addObject:@"Beverage"];
        [self.defaultData  addObject:@"Toilet"];
        [self.defaultData  addObject:@"Server"];
        [self.defaultData  addObject:@"Eatery"];
    }
    
}



/*- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
 */

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
    [self selection];
    [self defaultDatashow];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    self.prevoiusdata = self.tableArray;
    if(text.length == 0)
    {
        isFiltered = FALSE;
        self.tableArray = self.allTableData;
        prevTextLen = text.length;
       
    }
    else if((prevTextLen<text.length) && (u==0) )
    {
        isFiltered = true;
        _tableArray = [[NSMutableArray alloc] init];
        prevTextLen = text.length;
        
        for (Employee*  employe in _prevoiusdata)
        {
            NSRange nameRange = [employe.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [ employe.desig rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [_tableArray addObject: employe];
            }
        }
    }
    else if((prevTextLen>text.length) && (u==0)){
        prevTextLen = text.length;
        isFiltered = true;
        _tableArray = [[NSMutableArray alloc] init];
        
        for (Employee *employe in self.allTableData){
            NSRange nameRange = [employe.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange descriptionRange = [ employe.desig rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
            {
                [_tableArray addObject: employe];
            }
        }

    }
    
   else if((prevTextLen<text.length) && (u==1))
    {
        isFiltered = true;
        _tableArray = [[NSMutableArray alloc] init];
        prevTextLen = text.length;
        for (Places*  place in self.prevoiusdata)
        {
            NSRange nameRange = [place.placeName rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound )
            {
                [_tableArray addObject: place];
            }
        }
    }
   else if((prevTextLen>text.length) &&(u==1)){
       prevTextLen = text.length;
       isFiltered = true;
       self.tableArray = [[NSMutableArray alloc] init];
       
       for (Places*  place in self.allTableData)
       {
           NSRange nameRange = [place.placeName rangeOfString:text options:NSCaseInsensitiveSearch];
           if(nameRange.location != NSNotFound )
           {
               [_tableArray addObject: place];
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
        return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    UIImageView *imagefield =[[UIImageView alloc] init];
    //setting default image
    // imagefield.image = [UIImage imageNamed:@"default.jpg"];
    
    static NSString *CellIdentifier = @"Cell";
    enhancedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:0.698 green:0.745 blue:0.745 alpha:1]];
    [cell setSelectedBackgroundView:bgColorView];

    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial Rounded MT" size:16.0];
    Employee *emp;
    Places *place;
    if(u==0)         //Employee results
    {
        if(isFiltered  )
        {
            
            emp = [self.tableArray objectAtIndex:indexPath.row];
            cell.namefield.text=emp.name;
            NSString *inputString = emp.empid;
            int value = [inputString intValue];
            NSString *imageName=[NSString stringWithFormat:@"%d.jpg",value];
            
            cell.imagefield.layer.cornerRadius = imagefield.frame.size.width/2;
            cell.imagefield.layer.cornerRadius =  cell.imagefield.frame.size.height/2;
            cell.imagefield.layer.masksToBounds = YES;
            cell.imagefield.layer.borderWidth = 0;
            cell.imagefield.image=[UIImage imageNamed:imageName];
            cell.desigfield.text=emp.desig;
            cell.emailfield.text=emp.email;
            
        }
        else
        {
            NSString *test = [_defaultData objectAtIndex:indexPath.row];
            NSLog(@"%@",test);
            cell.namefield.text=test;
            cell.imagefield.layer.cornerRadius = cell.imagefield.frame.size.width/2;
            cell.imagefield.layer.cornerRadius =  cell.imagefield.frame.size.height/2;
            cell.imagefield.layer.masksToBounds = YES;
            cell.imagefield.layer.borderWidth = 0;
            cell.emailfield.text=@" ";
            cell.desigfield.text=@" ";
            
            NSString *imageName=[NSString stringWithFormat:@"%@.png",test];
            cell.imagefield.image=[UIImage imageNamed:imageName];
        }
        
    }
    else if(u==1)            //Places results
    {
        if(isFiltered)
        {
            
            place = [self.tableArray objectAtIndex:indexPath.row];
            cell.namefield.text=place.placeName;
            
             NSString *imageName=[NSString stringWithFormat:@"%@.png",place.placeType];
             cell.imagefield.layer.cornerRadius = imagefield.frame.size.width/2;
             cell.imagefield.layer.cornerRadius =  cell.imagefield.frame.size.height/2;
             cell.imagefield.layer.masksToBounds = YES;
             cell.imagefield.layer.borderWidth = 0;
             cell.imagefield.image=[UIImage imageNamed:imageName];
             cell.desigfield.text=place.placeType;
             cell.emailfield.text=@" ";
                       
        }
        else
        {
            NSString *test = [_defaultData objectAtIndex:indexPath.row];
            NSLog(@"%@",test);
            cell.namefield.text=test;
            cell.imagefield.layer.cornerRadius = cell.imagefield.frame.size.width/2;
            cell.imagefield.layer.cornerRadius =  cell.imagefield.frame.size.height/2;
            cell.imagefield.layer.masksToBounds = YES;
            cell.imagefield.layer.borderWidth = 0;
            cell.emailfield.text=@" ";
             cell.desigfield.text=@" ";
            if([test isEqualToString:@"Entry/Exit"])
            {
             NSString *imageName=[NSString stringWithFormat:@"Entry.png"];
                cell.imagefield.image=[UIImage imageNamed:imageName] ;
            }
            else
            {
            NSString *imageName=[NSString stringWithFormat:@"%@.png",test];
                cell.imagefield.image=[UIImage imageNamed:imageName]  ;
            }
           
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}

-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    [self.searchBar resignFirstResponder];
    homeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    Employee*  employe;
    Places *place;
    categoryViewController *cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryViewController"];
    
    
    if(u==0)       //EMPLOYEE
    {
    if(isFiltered)
    {
        employe = [_tableArray objectAtIndex:indexPath.row];
        vc.employe = employe;
        
        [self.navigationController pushViewController:vc animated:true];
    }
    else
    {
        NSString *str= [_defaultData objectAtIndex:indexPath.row];
        cat.categoryName = str;
       cat.emp_plac=u;
        //  NSLog(@"%@",cat.categoryName);
        [self.navigationController pushViewController:cat animated:true];
    }
    }
    else if(u==1)     //PLACES
    {
        if(isFiltered)
        {
            place = [_tableArray objectAtIndex:indexPath.row];
            vc.place = place;
            
            [self.navigationController pushViewController:vc animated:true];
        }
        else
        {
            NSString *str= [_defaultData objectAtIndex:indexPath.row];
            cat.categoryName = str;
            cat.emp_plac=u;
            //  NSLog(@"%@",cat.categoryName);
            [self.navigationController pushViewController:cat animated:true];
        }

    }
}


- (IBAction)employeefunc:(id)sender {
    u=0;
    self.searchBar.text=nil;
    self.tableArray=self.defaultData;
    [self defaultDatashow];
    [self selection];

    
}
- (IBAction)placefunc:(id)sender {
    u=1;
    self.searchBar.text=nil;
    self.tableArray=self.defaultData;
    [self defaultDatashow];
    [self selection];
}







//-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"asfdsadf");
//   // Employee *emp;
////    x=[emp.x intValue];
////    y= [emp.y intValue];
//    
//}
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if([segue.identifier isEqualToString:@"returnmap"]) {
//        NSLog(@"ok");
//        mapDraw *controller = (mapDraw *)segue.destinationViewController;
//        controller.ix=x;
//        controller.iy=y;
//        controller.a=1;
//        
//    }
//}


@end
