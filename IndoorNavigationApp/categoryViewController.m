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

@interface categoryViewController ()

@property (strong) NSMutableArray *categoryTableData;
@property (strong) NSMutableArray *filteredtableArray;
@property (strong) NSMutableArray *prevFilterArray;

@end

@implementation categoryViewController
@synthesize categoryName;
@synthesize isFiltered;
@synthesize emp_plac;
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
    
    self.searchBar.delegate = (id)self;
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self selection];
   // [self defaultDatashow];
    
    
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
            prevCatTextLen = catSearchtext.length;
        }
        else if((prevCatTextLen<catSearchtext.length) && (emp_plac==0) &&(locCor==0))
        {
            locCor =0;
            isFiltered = true;
            self.filteredtableArray = [[NSMutableArray alloc] init];
            prevCatTextLen = catSearchtext.length;
            
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
            prevCatTextLen = catSearchtext.length;
            
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
            prevCatTextLen = catSearchtext.length;
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
            prevCatTextLen = catSearchtext.length;
            
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
            prevCatTextLen = catSearchtext.length;
            
            for (Places*  place in self.prevFilterArray)
            {
                NSRange nameRange = [place.placeName rangeOfString:catSearchtext options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [self.filteredtableArray addObject: place];
                }
            }
        }
        else if ((prevCatTextLen>=catSearchtext.length)&&(emp_plac==1)){
            
            prevCatTextLen = catSearchtext.length;
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
    locLen = text.length;
    catSearchtext = text;
    catSl++;
    int temp = catSl;
    NSString *str = [NSString stringWithFormat:@"%d",temp];
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(catSearchFunc:) userInfo:str repeats:NO];
    
    
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
        // NSLog(@"%lu", (unsigned long)self.categoryTableData.count);
        return self.categoryTableData.count;
    
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    categoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category" forIndexPath:indexPath];
    
    NSLog(@"fswasgdsdfhg");
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial Rounded MT" size:16.0];
    Employee *emp;
    Places *place;
    if(emp_plac==0)
    {
      if(isFiltered)
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
        NSString *imageName=[NSString stringWithFormat:@"%d.jpg",value];
        
        
        cell.imageField.layer.cornerRadius = cell.imageField.frame.size.width/2;
        cell.imageField.layer.cornerRadius =  cell.imageField.frame.size.height/2;
        cell.imageField.layer.masksToBounds = YES;
        cell.imageField.layer.borderWidth = 0;
        cell.imageField.image=[UIImage imageNamed:imageName];
      }
    else
      {
        emp = [self.categoryTableData objectAtIndex:indexPath.row];
        cell.nameField.text=emp.name;
        NSLog(@"%@", emp.name);
        NSLog(@"%@", categoryName);
        cell.desigField.text = emp.desig;
        cell.emailField.text=emp.email;
        NSString *inputString = emp.empid;
        int value = [inputString intValue];
        NSLog(@"%d",value);
        NSString *imageName=[NSString stringWithFormat:@"%d.jpg",value];
        
        
        cell.imageField.layer.cornerRadius = cell.imageField.frame.size.width/4;
        cell.imageField.layer.cornerRadius =  cell.imageField.frame.size.height/4;
        cell.imageField.layer.masksToBounds = YES;
        cell.imageField.layer.borderWidth = 0;
        cell.imageField.image=[UIImage imageNamed:imageName];
      }
    }
    else if((int)emp_plac==1)
    {
        if(isFiltered)
        {
            place = [self.filteredtableArray objectAtIndex:indexPath.row];
            cell.nameField.text=place.placeName;
           
            cell.desigField.text = place.placeType;
        
            
            NSString *imageName=[NSString stringWithFormat:@"%@.png",place.placeType];
            cell.imageField.layer.cornerRadius = cell.imageField.frame.size.width/2;
            cell.imageField.layer.cornerRadius =  cell.imageField.frame.size.height/2;
            cell.imageField.layer.masksToBounds = YES;
            cell.imageField.layer.borderWidth = 0;
            cell.imageField.image=[UIImage imageNamed:imageName];
            cell.desigField.text=place.placeType;
            cell.emailField.text=@" ";
        }
        else
        {
            place = [self.categoryTableData objectAtIndex:indexPath.row];
            cell.nameField.text=place.placeName;
            
            cell.desigField.text = place.placeType;
            
             NSLog(@"dgdhgihuguigh");
            NSString *imageName=[NSString stringWithFormat:@"%@.png",place.placeType];
            cell.imageField.layer.cornerRadius = cell.imageField.frame.size.width/2;
            cell.imageField.layer.cornerRadius =  cell.imageField.frame.size.height/2;
            cell.imageField.layer.masksToBounds = YES;
            cell.imageField.layer.borderWidth = 0;
            cell.imageField.image=[UIImage imageNamed:imageName];
            cell.desigField.text=place.placeType;
            cell.emailField.text=@" ";

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
    mapDraw* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"mapDraw"];
    Employee*  employe;
    Places *place;
    if(emp_plac==0)
    {
        if(isFiltered)
       {
        employe = [self.filteredtableArray objectAtIndex:indexPath.row];
      //  vc.employe = employe;
        
        [self.navigationController pushViewController:vc animated:true];
       }
    else
       {
        
        employe = [self.categoryTableData objectAtIndex:indexPath.row];
       // vc.employe = employe;
        
        [self.navigationController pushViewController:vc animated:true];
        
       }
    }
    else if((int)emp_plac==1)
    {
        if(isFiltered)
        {
            place = [self.filteredtableArray objectAtIndex:indexPath.row];
          //  vc.place = place;
            
            [self.navigationController pushViewController:vc animated:true];
        }
        else
        {
            
            place = [self.categoryTableData objectAtIndex:indexPath.row];
            //vc.place = place;
            
            [self.navigationController pushViewController:vc animated:true];
            
        }
    
    
    
    
    }
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
