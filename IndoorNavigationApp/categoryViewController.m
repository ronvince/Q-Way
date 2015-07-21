//
//  categoryViewController.m
//  IndoorNavigationApp
//
//  Created by user on 7/12/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Anita Grace Daniel.

#import "categoryViewController.h"
#import "mapDraw.h"
#import "Places.h"
#import <CoreData/CoreData.h>
#import "infoViewController.h"

@interface categoryViewController ()

@property (strong) NSMutableArray *categoryTableData;
@property (strong) NSMutableArray *filteredtableArray;
@property (strong) NSMutableArray *prevFilterArray;

@end

@implementation categoryViewController
@synthesize categoryName;
@synthesize isFiltered;

@synthesize emp_plac;  //whether category belongs to employee / places.
int prevCatTextLen,catSl,locLen=0,locCor=0;

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
        catSearchtext = 0;
    //customizing search bar
    self.searchBar.delegate = (id)self;
    self.searchBar.placeholder=categoryName;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    _imagefield.layer.cornerRadius = _imagefield.frame.size.width/2;
    _imagefield.layer.cornerRadius =  _imagefield.frame.size.height/2;
    _imagefield.layer.masksToBounds = YES;
    _imagefield.layer.borderWidth = 0;

    if([categoryName isEqualToString:@"Entry/Exit"])
    {
        NSString *imageName=[NSString stringWithFormat:@"Entry.png"];
        _imagefield.image=[UIImage imageNamed:imageName] ;
    }
    else
    {
        NSString *imageName=[NSString stringWithFormat:@"%@.png",categoryName];
        _imagefield.image=[UIImage imageNamed:imageName]  ;
    }
    
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 450, 210, 25)];
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
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self selection];
}


-(void)selection{
    if ((int)emp_plac==0)
    {
        printf("u==0 employee");
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:managedObjectContext]];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"desig == %@ " , categoryName]];
        NSError* error = nil;
        self.categoryTableData = [[managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
        self.filteredtableArray = self.categoryTableData;
        [self.tableView reloadData];
        NSLog(@"%lu",(unsigned long)self.categoryTableData.count);
        
        
    }
    else if ((int)emp_plac==1)
    {
        printf("u==1 places");
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Places" inManagedObjectContext:managedObjectContext]];
        
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"placeType == %@ " , categoryName]];
        NSError* error = nil;
        self.categoryTableData = [[managedObjectContext executeFetchRequest:fetchRequest error:&error]mutableCopy];
        self.filteredtableArray = self.categoryTableData;
        [self.tableView reloadData];
          NSLog(@"%lu",(unsigned long)self.categoryTableData.count);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)catSearchFunc:(NSTimer *)theTimer{
    int temp;
    NSString *str1 = (NSString*) [theTimer userInfo];
    temp = [str1 intValue];
    if (catSl==temp) {
        self.prevFilterArray = self.filteredtableArray;
        if(catSearchtext.length == 0)
        {
            isFiltered = FALSE;
            self.filteredtableArray = self.categoryTableData;
            prevCatTextLen = (int)catSearchtext.length;
        }
        else if((prevCatTextLen<catSearchtext.length) && (emp_plac==0) &&(locCor==0))
        {
            locCor =0;
            isFiltered = true;
            self.filteredtableArray = [[NSMutableArray alloc] init];
            prevCatTextLen = (int)catSearchtext.length;
            
            for (Employee*  employe in self.categoryTableData)
            {
                NSRange nameRange = [employe.name rangeOfString:catSearchtext options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [_filteredtableArray addObject: employe];
                }
            }
        }
        else if((prevCatTextLen<catSearchtext.length) && (emp_plac==0) )
        {
            isFiltered = true;
            self.filteredtableArray = [[NSMutableArray alloc] init];
            prevCatTextLen = (int)catSearchtext.length;
            
            for (Employee*  employe in self.prevFilterArray)
            {
                NSRange nameRange = [employe.name rangeOfString:catSearchtext options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [_filteredtableArray addObject: employe];
                }
            }
        }
        else if ((prevCatTextLen>=catSearchtext.length)&& (emp_plac==0)){
            prevCatTextLen = (int)catSearchtext.length;
            isFiltered = true;
            self.filteredtableArray = [[NSMutableArray alloc]init];
            
            for (Employee * employe in self.categoryTableData) {
                NSRange nameRange = [employe.name rangeOfString:catSearchtext options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [_filteredtableArray addObject: employe];
                }
                
            }
        }
        else if((prevCatTextLen<catSearchtext.length) && ((int) emp_plac==1)&&(locCor==0))
        {
            locCor=0;
            isFiltered = true;
            self.filteredtableArray = [[NSMutableArray alloc] init];
            prevCatTextLen = (int)catSearchtext.length;
            
            for (Places*  place in self.categoryTableData)
            {
                NSRange nameRange = [place.placeName rangeOfString:catSearchtext options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [self.filteredtableArray addObject: place];
                }
            }
        }
        else if((prevCatTextLen<catSearchtext.length) && ((int) emp_plac==1))
        {
            isFiltered = true;
            self.filteredtableArray = [[NSMutableArray alloc] init];
            prevCatTextLen = (int)catSearchtext.length;
            
            for (Places*  place in self.prevFilterArray)
            {
                NSRange nameRange = [place.placeName rangeOfString:catSearchtext options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [self.filteredtableArray addObject: place];
                }
            }
        }
        else if ((prevCatTextLen>=catSearchtext.length)&&((int)emp_plac==1)){
            
            prevCatTextLen = (int)catSearchtext.length;
            isFiltered = true;
            self.filteredtableArray = [[NSMutableArray alloc]init];
            for (Places*  place in self.categoryTableData)
            {
                NSRange nameRange = [place.placeName rangeOfString:catSearchtext options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [self.filteredtableArray addObject: place];
                }
            }
            
        }
        
        
        [self.tableView reloadData];
    }
}

NSString *catSearchtext;

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (text.length<locLen) {
        locCor=0;
    }
    locLen = (int)text.length;
    catSearchtext = text;
    catSl++;
    int temp = catSl;
    NSString *str = [NSString stringWithFormat:@"%d",temp];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(catSearchFunc:) userInfo:str repeats:NO];
    
    
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
        return self.filteredtableArray.count;
    else
        return self.categoryTableData.count;
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    categoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category" forIndexPath:indexPath];
    
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial Rounded MT" size:16.0];
    Employee *emp;
    Places *place;
    if(emp_plac==0)     // EMPLOYEE
    {
         emp = [self.filteredtableArray objectAtIndex:indexPath.row];
        cell.nameField.text=emp.name;
        NSLog(@"%@", emp.name);
        NSLog(@"%@", categoryName);
        cell.desigField.text = emp.desig;
        cell.emailField.text=emp.email;
        
        NSString *inputString = emp.empid;
        int value = [inputString intValue];
        NSLog(@"%d",value);
        NSString *imageName=[NSString stringWithFormat:@"7.jpg"];
        
        
        cell.imageField.layer.cornerRadius = cell.imageField.frame.size.width/2;
        cell.imageField.layer.cornerRadius =  cell.imageField.frame.size.height/2;
        cell.imageField.layer.masksToBounds = YES;
        cell.imageField.layer.borderWidth = 0;
        cell.imageField.image=[UIImage imageNamed:imageName];
      }
 
    else if((int)emp_plac==1)   //PLACE
      {
      
            place = [self.filteredtableArray objectAtIndex:indexPath.row];
            cell.nameField.text=place.placeName;
           
            cell.desigField.text = place.placeType;
          if([categoryName isEqualToString:@"Entry/Exit"])
          {
              NSString *imageName=[NSString stringWithFormat:@"Entry.png"];
              cell.imageField.image=[UIImage imageNamed:imageName] ;
          }
          else
          {
              
            NSString *imageName=[NSString stringWithFormat:@"%@.png",place.placeType];
          cell.imageField.image=[UIImage imageNamed:imageName];
          }
    
            cell.imageField.layer.cornerRadius = cell.imageField.frame.size.width/2;
            cell.imageField.layer.cornerRadius =  cell.imageField.frame.size.height/2;
            cell.imageField.layer.masksToBounds = YES;
            cell.imageField.layer.borderWidth = 0;
          
            cell.desigField.text=place.placeType;
            cell.emailField.text=@" ";
        }
[cell.popButton addTarget:self action:@selector(showPopover:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDetailsForIndexPath:indexPath];
}


-(void) showDetailsForIndexPath:(NSIndexPath*)indexPath
{
    [self.searchBar resignFirstResponder];
    Employee*  employe;
    Places *place;
    if(emp_plac==0)
      {
        employe = [self.filteredtableArray objectAtIndex:indexPath.row];
        _categoryemployexy=employe;
        [self performSegueWithIdentifier:@"categorysearch" sender:self];
       }
    else if((int)emp_plac==1)
      {
            place = [self.filteredtableArray objectAtIndex:indexPath.row];
            _categoryplacexy=place;
            [self performSegueWithIdentifier:@"categorysearch" sender:self];
           
      }
}


- (IBAction)showPopover:(id)sender
{
    infoViewController *popController = [[infoViewController alloc] init];
    Employee *employe;
    Places *place;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)
                              [[sender superview] superview]];
    
    if(emp_plac==0)
    {
        employe= [_filteredtableArray objectAtIndex:indexPath.row];
        popController.employe=employe;
        popController.if_emp_place = emp_plac;
    }
    else  if((int)emp_plac==1)
    {
       place= [_filteredtableArray objectAtIndex:indexPath.row];
       popController.place=place;
       popController.if_emp_place = emp_plac;
    }
    popController.contentSize = CGSizeMake(210, 245);
    popController.arrowDirection =0;
    
    [self presentViewController:popController animated:YES completion:nil];
    
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (emp_plac==0)
    {
        return YES;
    }
    return NO;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSIndexPath *path=[[NSIndexPath alloc]init];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
    }
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSError* error = nil;
    Employee *obj = [self.filteredtableArray objectAtIndex:indexPath.row];
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
    
    
    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"    " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        
        NSError* error = nil;
      
        if([emp1.favrt  isEqual:@"1"])
        {
            emp1.favrt = @"0";
              [_toastLabel setText:@"Removed from favourites!!"];
            [_toastLabel setHidden:NO];
                 }
        else
        {
            emp1.favrt = @"1";
            [_toastLabel setText:@"Added to favourites!!"];
        [_toastLabel setHidden:NO];
            
        }
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(animate:)
                                       userInfo:nil
                                        repeats:NO];
        
        
        [managedObjectContext save:&error];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    
    if([emp1.favrt  isEqual:@"1"] )
        favAction.backgroundColor = [[UIColor  alloc] initWithPatternImage:[UIImage imageNamed:@"icon2.png"]];
    else
        favAction.backgroundColor = [[UIColor  alloc] initWithPatternImage:[UIImage imageNamed:@"icon1.png"]];
    
    
    
    
    UITableViewRowAction *infoAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"     "  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
       
        infoViewController *popController = [[infoViewController alloc] init];
        Employee *employe;
        
        NSLog(@"%ld",(long)indexPath.row);
        
        employe= [self.filteredtableArray objectAtIndex:indexPath.row];
        popController.employe=employe;
        NSLog(@"%@",employe.name);
        popController.contentSize = CGSizeMake(200, 245);
        popController.arrowDirection =0;
        
        [self presentViewController:popController animated:YES completion:nil];
        
    }];
    
   
   infoAction.backgroundColor = [[UIColor  alloc] initWithPatternImage:[UIImage imageNamed:@"icon3.png"]];;
    
    
    return @[infoAction,favAction];
}


-(void)animate:(NSTimer *)theTimer {
    [_toastLabel setHidden:YES];
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
