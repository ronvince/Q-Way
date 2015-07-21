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
#import "infoViewController.h"
#import <CoreData/CoreData.h>

@interface EmployeeTable ()
@property (strong) NSMutableArray *allTableData;
@property (strong) NSMutableArray *tableArray;
@property (strong) NSMutableArray *defaultData;
@property (strong) NSMutableArray *prevoiusdata;

@end

@implementation EmployeeTable
@synthesize isFiltered;
CAShapeLayer *shapeLayer ;
@synthesize toastLabel;
int prevTextLen,glsl,glCor=0,gllen=0;


//int x,y;
int employ_plac=0; // whether the category belongs to employe/places.
int check; //// For checking whether the view appears for the first

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
    if (employ_plac==0) {
        printf("employ_plac==0 employee");
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Employee"];
        self.allTableData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        self.tableArray = self.allTableData;
         isFiltered = FALSE;
        [self.tableView reloadData];
        NSLog(@"%lu", (unsigned long)_allTableData.count);
    }
    else if (employ_plac==1)
    {
        printf("employ_plac==1 places");
        NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Places"];
        self.allTableData = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
        self.tableArray = self.allTableData;
         isFiltered = FALSE;
        [self.tableView reloadData];
        NSLog(@"%lu", (unsigned long)_allTableData.count);
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar.delegate = (id)self;
    glsl = 0;
    
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.200 green:0.463 blue:.827 alpha:1];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    //for toast message
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 450, 210, 25)];
    [self setToastLabel:tempLabel];

    [toastLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:13]];
    [toastLabel  setTextAlignment:NSTextAlignmentCenter];
    [toastLabel  setTextColor:[UIColor whiteColor]];
    toastLabel.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    toastLabel.layer.cornerRadius = 10;
    toastLabel.layer.masksToBounds = YES;
    [toastLabel setHidden:YES];
    [[self view] addSubview:toastLabel];
    
  }
-(void)defaultDatashow{
    if (employ_plac==0) {
        self.defaultData  = [[NSMutableArray alloc] init];
        [self.defaultData  addObject:@"PM"];
        [self.defaultData  addObject:@"Developer"];
        [self.defaultData  addObject:@"Architect"];
        [self.defaultData  addObject:@"BA"];
        [self.defaultData  addObject:@"Trainee"];
        [self.defaultData  addObject:@"Intern"];
            }
    else if (employ_plac==1){
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
    printf("did %d", check);
    if(check==0)
    {
        
    [_buttonEmploy setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_buttonPlace setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    [shapeLayer removeFromSuperlayer];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    x1=(self.buttonEmploy.center.x)-45.0;
    x2=(self.buttonEmploy.center.x)+45.0;
    
    
    [path1 moveToPoint:CGPointMake(x1, 0)];
    [path1 addLineToPoint:CGPointMake(x2,0)];
    shapeLayer= [CAShapeLayer layer];
    shapeLayer.path = [path1 CGPath];
    shapeLayer.strokeColor = [[UIColor yellowColor] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor yellowColor] CGColor];
    [self.lineView.layer addSublayer:shapeLayer];
    }
    else{
        [_buttonPlace setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
        [_buttonEmploy setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [shapeLayer removeFromSuperlayer];
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        x1=(self.buttonPlace.center.x)-31.0;
        x2=(self.buttonPlace.center.x)+31.0;
        
        
        [path1 moveToPoint:CGPointMake(x1, 0)];
        [path1 addLineToPoint:CGPointMake(x2,0)];
        shapeLayer= [CAShapeLayer layer];
        shapeLayer.path = [path1 CGPath];
        shapeLayer.strokeColor = [[UIColor yellowColor] CGColor];
        shapeLayer.lineWidth = 2.0;
        shapeLayer.fillColor = [[UIColor yellowColor] CGColor];
        [self.lineView.layer addSublayer:shapeLayer];

    }
    if(!isFiltered)
    { self.searchBar.text=nil ;}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)serfunc:(NSTimer *)theTimer{
    int temp,uvar;
    NSString *str1 = (NSString*)[theTimer userInfo];
    temp = [str1 intValue];
    uvar = temp%10;
    temp = temp/10;
    printf("temp value in text func = %d\n", temp);
    printf("sl value in textfunc = %d", glsl);
    NSLog(@"sgsdgsdgsdfg   %@\n",t1);
    
    if ((glsl==temp)&&(uvar==employ_plac)) {
        
        self.prevoiusdata = self.tableArray;
        NSLog(@"previ count = %lu",(unsigned long)self.prevoiusdata.count);
        if(t1.length == 0)
        {
            isFiltered = FALSE;
            self.tableArray = self.allTableData;
            prevTextLen = (int)t1.length;
            
        }
        else if((prevTextLen<t1.length) && (employ_plac==0)&&(glCor==1) )
        {
            glCor=0;
            isFiltered = true;
            _tableArray = [[NSMutableArray alloc] init];
            prevTextLen = (int)t1.length;
            
            for (Employee*  employe in self.allTableData)
            {
                NSRange nameRange = [employe.name rangeOfString:t1 options:NSCaseInsensitiveSearch];
                NSRange descriptionRange = [ employe.desig rangeOfString:t1 options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
                {
                    [_tableArray addObject: employe];
                }
            }
        }
        else if((prevTextLen<t1.length) && (employ_plac==0) )
        {
            isFiltered = true;
            _tableArray = [[NSMutableArray alloc] init];
            prevTextLen = (int)t1.length;
            
            for (Employee*  employe in _prevoiusdata)
            {
                NSRange nameRange = [employe.name rangeOfString:t1 options:NSCaseInsensitiveSearch];
                NSRange descriptionRange = [ employe.desig rangeOfString:t1 options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
                {
                    [_tableArray addObject: employe];
                }
            }
        }
        else if((prevTextLen>=t1.length) && (employ_plac==0)){
            prevTextLen = (int)t1.length;
            isFiltered = true;
            _tableArray = [[NSMutableArray alloc] init];
            
            for (Employee *employe in self.allTableData){
                NSRange nameRange = [employe.name rangeOfString:t1 options:NSCaseInsensitiveSearch];
                NSRange descriptionRange = [ employe.desig rangeOfString:t1 options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound || descriptionRange.location != NSNotFound)
                {
                    [_tableArray addObject: employe];
                }
            }
            
        }
        else if((prevTextLen<t1.length) && (employ_plac==1)&&(glCor==1))
        {
            glCor = 0;
            isFiltered = true;
            _tableArray = [[NSMutableArray alloc] init];
            prevTextLen = (int)t1.length;
            for (Places*  place in self.allTableData)
            {
                NSRange nameRange = [place.placeName rangeOfString:t1 options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [_tableArray addObject: place];
                }
            }
        }

        
        else if((prevTextLen<t1.length) && (employ_plac==1))
        {
            isFiltered = true;
            _tableArray = [[NSMutableArray alloc] init];
            prevTextLen = (int)t1.length;
            for (Places*  place in self.prevoiusdata)
            {
                NSRange nameRange = [place.placeName rangeOfString:t1 options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [_tableArray addObject: place];
                }
            }
        }
        else if((prevTextLen>=t1.length) &&(employ_plac==1)){
            prevTextLen = (int)t1.length;
            isFiltered = true;
            self.tableArray = [[NSMutableArray alloc] init];
            
            for (Places*  place in self.allTableData)
            {
                NSRange nameRange = [place.placeName rangeOfString:t1 options:NSCaseInsensitiveSearch];
                if(nameRange.location != NSNotFound )
                {
                    [_tableArray addObject: place];
                }
            }
            
        }
        [self.tableView reloadData];
        
    }
    
    
}
NSString *t1;

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (text.length<gllen) {
        glCor = 1;
    }
    gllen = (int)text.length;
    
    t1= text;
    printf("%d",glsl);
    glsl++;
    printf("%d",glsl);
    int temp = glsl;
    printf("value of temp in search %d", temp);
    NSString *str = [NSString stringWithFormat:@"%d",temp];
    NSString *uvar = [NSString stringWithFormat:@"%d",employ_plac];
    
    str = [str stringByAppendingString:uvar];
    NSLog(@"%@",str);
    [NSTimer scheduledTimerWithTimeInterval:1.5
                                     target:self
                                   selector:@selector(serfunc:)
                                   userInfo:str
                                    repeats:NO];
    
    
    
    
}
#pragma mark - Table view data source

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isFiltered && (employ_plac==0))
    {
        return YES;
    }
    return NO;
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
        return 6;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    UIImageView *imagefield =[[UIImageView alloc] init];
       static NSString *CellIdentifier = @"Cell";
    enhancedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    [bgColorView setBackgroundColor:[UIColor colorWithRed:0.698 green:0.745 blue:0.745 alpha:1]];
    [cell setSelectedBackgroundView:bgColorView];

    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.font=[UIFont fontWithName:@"Arial Rounded MT" size:16.0];
    Employee *emp;
    Places *place;
    if(employ_plac==0)         //Employee results
    {
        if(isFiltered)
        {
          
            
            emp = [self.tableArray objectAtIndex:indexPath.row];
            cell.namefield.text=emp.name;
            NSString *inputString = emp.empid;
            int value = [inputString intValue];
            NSLog(@"%d",value);
            NSString *imageName=[NSString stringWithFormat:@"7.jpg"];
            
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
    else if(employ_plac==1)            //Places results
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
     Employee*  employe;
    Places *place;
    categoryViewController *cat = [self.storyboard instantiateViewControllerWithIdentifier:@"categoryViewController"];
    
    
    if(employ_plac==0)       //EMPLOYEE
    {
    if(isFiltered)
    {
        employe = [_tableArray objectAtIndex:indexPath.row];
        _employexy = employe;
        [self performSegueWithIdentifier:@"search" sender:self];
       
    }
    else
    {
        NSString *str= [_defaultData objectAtIndex:indexPath.row];
        cat.categoryName = str;
        cat.emp_plac=employ_plac ;
              [self.navigationController pushViewController:cat animated:true];
    }
    }
    else if(employ_plac==1)     //PLACES
    {
        if(isFiltered)
        {
            place = [_tableArray objectAtIndex:indexPath.row];
            _placexy=place;
            [self performSegueWithIdentifier:@"search" sender:self];
         
        }
        else
        {
            NSString *str= [_defaultData objectAtIndex:indexPath.row];
            cat.categoryName = str;
            cat.emp_plac=employ_plac;
            [self.navigationController pushViewController:cat animated:true];
        }

    }
}
int x1,x2;

- (IBAction)employeefunc:(id)sender {
    
    [self.buttonEmploy setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
    
    employ_plac=0;
     check=0; // For checking whether the view appears for the first
    self.searchBar.text=nil;
    [self defaultDatashow];
     self.tableArray=self.defaultData;
    [self selection];
    [shapeLayer removeFromSuperlayer];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    x1=(self.buttonEmploy.center.x)-45.0;
    x2=(self.buttonEmploy.center.x)+45.0;
  
    
    [path1 moveToPoint:CGPointMake(x1, 0)];
    [path1 addLineToPoint:CGPointMake(x2,0)];
    shapeLayer= [CAShapeLayer layer];
    shapeLayer.path = [path1 CGPath];
    shapeLayer.strokeColor = [[UIColor yellowColor] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor yellowColor] CGColor];
           [self.lineView.layer addSublayer:shapeLayer];

    [_buttonEmploy setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [_buttonPlace setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
   
    
}
- (IBAction)placefunc:(id)sender {
    employ_plac=1;
    check=1;
    self.searchBar.text=nil;
   [self defaultDatashow];
    self.tableArray=self.defaultData;
   [self selection];
    
    [shapeLayer removeFromSuperlayer];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    x1=(self.buttonPlace.center.x)-31.0;
    x2=(self.buttonPlace.center.x)+31.0;
    
    
    [path1 moveToPoint:CGPointMake(x1, 0)];
    [path1 addLineToPoint:CGPointMake(x2,0)];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path1 CGPath];
    shapeLayer.strokeColor = [[UIColor yellowColor] CGColor];
    shapeLayer.lineWidth = 2.0;
    shapeLayer.fillColor = [[UIColor yellowColor] CGColor];
    [self.lineView.layer addSublayer:shapeLayer];

    [_buttonEmploy setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_buttonPlace setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    
    
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSIndexPath *path=[[NSIndexPath alloc]init];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        
    }
    
}


-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSError* error = nil;
    Employee *obj = [self.tableArray objectAtIndex:indexPath.row];
      NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Employee" inManagedObjectContext:managedObjectContext]];
    
    NSString *delstring = obj.empid;
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"empid == %@ ", delstring]];
    
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    Employee *emp1=[results  objectAtIndex:0];
    
    
    UITableViewRowAction *favAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"     " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        
        NSError* error = nil;
        
        if([emp1.favrt  isEqual:@"1"])
        {
            emp1.favrt = @"0";
            [toastLabel setText:@"Removed from favourites!!"];
            [toastLabel setHidden:NO];
        
        }
        else
        {
            emp1.favrt = @"1";
            [toastLabel setText:@"Added to favourites!!"];
            [toastLabel setHidden:NO];
         
        }
        [NSTimer scheduledTimerWithTimeInterval:1.5
                                         target:self
                                       selector:@selector(animate:)
                                       userInfo:nil
                                        repeats:NO];
        
        [managedObjectContext save:&error];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];        
    }];
    
    //setting 
    if([emp1.favrt  isEqual:@"1"] )
        favAction.backgroundColor = [[UIColor  alloc] initWithPatternImage:[UIImage imageNamed:@"icon2.png"]];
    else
        favAction.backgroundColor = [[UIColor  alloc] initWithPatternImage:[UIImage imageNamed:@"icon1.png"]];
    
    
    
    
    UITableViewRowAction *infoAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"    "  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        
        infoViewController *popController = [[infoViewController alloc] init];
        Employee *employe;
        
        NSLog(@"%ld",(long)indexPath.row);
        
        employe= [self.tableArray objectAtIndex:indexPath.row];
        popController.employe=employe;
        NSLog(@"%@",employe.name);
        popController.contentSize = CGSizeMake(200, 245);
        popController.arrowDirection =0;
        
        [self presentViewController:popController animated:YES completion:nil];
        
    }];
    infoAction.backgroundColor = [[UIColor  alloc] initWithPatternImage:[UIImage imageNamed:@"icon3.png"]];;
    
    
    return @[infoAction,favAction];
}


- (IBAction)cancelbutton:(id)sender {
    if (employ_plac==0) {
        check=0;
    }
    else{
        check = 1;
    }
    
    printf("cancel button%d", check);
     [self performSegueWithIdentifier:@"time2map" sender:self];
}


-(void)animate:(NSTimer *)theTimer {
    [toastLabel setHidden:YES];
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
