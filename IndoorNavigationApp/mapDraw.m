//
//  mapDraw.m
//  IndoorNavigationApp
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Jithin V.

#import "mapDraw.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "EmployeeTable.h"
#import <CoreData/CoreData.h>
#import "Qrc.h"
#import "categoryViewController.h"
#import "infoViewController.h"
@import CoreGraphics;

@interface mapDraw ()
@property (nonatomic, strong) UIImageView *imageVie;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageVi;
@property (nonatomic, strong) UILabel *imglbl;
@property (nonatomic, strong) UILabel *giflbl;
@property (nonatomic, strong) UIButton *subimbtn;
@property (strong, nonatomic) FLAnimatedImageView *greengif;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;
- (void)imageTapped:(UITapGestureRecognizer*)recognizer;

@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLHeading * currentHeading;

@end

@implementation mapDraw

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
@synthesize scrollView = _scrollView;
@synthesize imageVie = _imageVie;
@synthesize imageView = _imageView;
@synthesize imageVi = _imageVi;
@synthesize imglbl =_imglbl;
@synthesize giflbl =_giflbl;
@synthesize subimbtn=_subimbtn;
@synthesize greengif=_greengif;


int a =0;
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageVie.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
        
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
        
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageVie.frame = contentsFrame;
    
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    
    CGPoint pointInView = [recognizer locationInView:self.imageVie];
    CGFloat newZoomScale =self.scrollView.zoomScale*1.5;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    pointInView.y=pointInView.y;
    pointInView.x=pointInView.x;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x-(w / 2.0);
    CGFloat y = pointInView.y-(h / 2.0);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    }

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    CGFloat newZoomScale =self.scrollView.zoomScale/1.5;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
    
}

NSInteger cx;
NSInteger cy;
NSInteger ca=0;
NSInteger nu;
NSInteger ex;
NSInteger ey;
NSInteger ea=0;
 NSMutableArray *gifimg;
NSMutableArray *employeedetails;
NSMutableArray *placedetails;
int rotationlock=0;
int lock=0;
int m;

- (void)viewDidLoad
{
    [super viewDidLoad];
    num=0;
   
    NSLog(@"%i",a);
    
    
    self.currentHeading =[[CLHeading alloc] init];
    self.locationManager = [[CLLocationManager alloc ] init ];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.headingFilter = 1;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    
    UIImage *image = [UIImage imageNamed:@"floor.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(400,425), .size=CGSizeMake(400,600)};
    
    UIImage *ima = [UIImage imageNamed:@""];
    self.imageVie = [[UIImageView alloc] initWithImage:ima];
    self.imageVie.frame = (CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(1200,1450)};
    [self.scrollView addSubview:self.imageVie];
  [self.imageVie addSubview:self.imageView];
    
    
    
    if (_ix == NULL) {
      //  ca=0;
    }
   // NSLog(@"%@",_ca);
    if (ca==1) {
        UIImage *imag = [UIImage imageNamed:@"ar"];
        self.imageVi = [[UIImageView alloc] initWithImage:imag];
        self.imageVi.frame = (CGRect){.origin=CGPointMake(cx,cy),.size=CGSizeMake(100,200)};
        
        [self.imageView addSubview:self.imageVi];
        
        self.imglbl = [[UILabel  alloc] initWithFrame:CGRectMake(-250,-50,600,100)];
        
        [_imglbl   setText:@"You"];
        [_imglbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
        [_imglbl setTextColor:[UIColor brownColor ]];
        _imglbl.textAlignment = NSTextAlignmentCenter;
        [self.imageVi addSubview:self.imglbl];

    }
    
    
    
    
    if (nu==1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid" message:@"No such QR Code in Database" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
               [alert show];
        
        
        
        
    }
    //////////////////////////////////////////
    if(ea==1)
    {
    self.greengif=[[FLAnimatedImageView alloc]init];
    FLAnimatedImage *gifwork = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spot" ofType:@"gif"]]];
    // self.greengif = [[FLAnimatedImage alloc] :gifwork];
    self.greengif.frame = (CGRect){.origin=CGPointMake(ex,ey), .size=CGSizeMake(200,200)};
    self.greengif.animatedImage = gifwork;
    
    [self.imageView addSubview:self.greengif];
        
        self.giflbl = [[UILabel  alloc] initWithFrame:CGRectMake(-200,-30,600,100)];
        
       // [_giflbl   setText:_employe.name];
        [_giflbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
        [_giflbl setTextColor:[UIColor brownColor ]];
        _giflbl.textAlignment = NSTextAlignmentCenter;
        
        [self.greengif addSubview:self.giflbl];
        
        self.subimbtn = [[UIButton  alloc] initWithFrame:CGRectMake(67,67,70,70)];//(67,67,70,70)
        [_subimbtn setUserInteractionEnabled:YES ];
        
        //[_subimbtn  setTitle:@"J" forState:UIControlStateNormal];
        [_subimbtn setBackgroundColor:[UIColor clearColor]];
        //[_subimbtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        self.imageVie.userInteractionEnabled = YES;
        self.imageView.userInteractionEnabled = YES;
        self.greengif.userInteractionEnabled = YES;
        [self.greengif addSubview:self.subimbtn];

          [gifimg addObject:_greengif];
       
        
    }

    if(gifimg.count==0)
        gifimg = [[NSMutableArray alloc] initWithObjects:nil];
    
    
     employeedetails = [[NSMutableArray alloc] initWithObjects:nil];
     placedetails = [[NSMutableArray alloc] initWithObjects:nil];
    for(m=0;m<gifimg.count;m++)
    {
        [self.imageView addSubview:gifimg[m]];
    }

/////////////////////////////////////////////////
    self.scrollView.contentSize = CGSizeMake(self.imageVie.frame.size.width , self.imageVie.frame.size.height);
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self.imageView addGestureRecognizer:tap];
    //////////////////////////
    
    _imageView.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-58));
    
    //////////////////////

    [self.view addSubview:self.databutton];
     [self.view addSubview:self.searchbutton];
     [self.view addSubview:self.logbutton];
     [self.view addSubview:self.QRcodebutton];
    [self.view addSubview:self.clearbutton];
    [self.view addSubview:self.lockbutton];
   [self.view addSubview:self.favbutton];  //////////////////////////////////////////////////////
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height/ self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale =1;//minScale;
    self.scrollView.maximumZoomScale =5.0;
    self.scrollView.zoomScale = minScale;
    
    
    
    CGFloat newZoomScale =1;
   // newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = _imageView.center.x- (w / 2.0f);
    CGFloat y = _imageView.center.y- (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];

    
    
    
    [self centerScrollViewContents];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

NSInteger  num=0;
NSInteger prev;
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading

{
   
        prev=num;
        self.currentHeading = newHeading;
        num =360-(int)newHeading.magneticHeading;
    if(rotationlock==0)
    {
        self.imageView.transform = CGAffineTransformRotate (self.imageView.transform, DEGREES_TO_RADIANS(num-prev));
        [self.imageVie addSubview:self.imageView];
    }

    self.imageVi.transform = CGAffineTransformRotate (self.imageVi.transform, DEGREES_TO_RADIANS(-(num-prev)));
        
        [self.imageView addSubview:self.imageVi];

    
    
}



- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    
    return self.imageVie;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    int i=0;
    
    if(_scrollView.zoomScale>=0.3125&&_scrollView.zoomScale<=5)
    {
        
        _imageVi.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
        self.imageVi.transform = CGAffineTransformRotate(self.imageVi.transform,DEGREES_TO_RADIANS(-(num-58)));
       
     
        for(i=0;i<gifimg.count;i++)
        {
            _greengif=gifimg[i];
            _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            
        }
    }
    
    
    [self centerScrollViewContents];
    
}
int btnx;
int btny;



- (void)imageTapped:(UITapGestureRecognizer*)recognizer {
    
    CGPoint tapPoint = [recognizer locationInView:self.imageView];
    btnx=tapPoint.x;
    btny=tapPoint.y;
    NSLog(@"hi");
    
    NSLog(@"%i",btnx);
    NSLog(@"%i",btny);
 infoViewController *popController = [[infoViewController alloc] init];
    
    for(int i=0;i<employeedetails.count;i++)
        {
            _employemap=employeedetails[i];
             NSLog(@"%@",_employemap.x);
             NSLog(@"%@",_employemap.y);
             NSLog(@"%i",btnx);
             NSLog(@"%i",btny);
            if([_employemap.x intValue]<=(btnx-94) && [_employemap.x intValue]>=(btnx-106)&&[_employemap.y intValue]<=(btny-94) && [_employemap.y intValue]>=(btny-106))
            {
        
            popController.employe=_employemap;
                popController.contentSize = CGSizeMake(210, 245);
                 [self presentViewController:popController animated:YES completion:nil];
            }
        }
    for(int i=0;i<placedetails.count;i++)
    {
        _placemap=placedetails[i];
        if([_placemap.x intValue]<=(btnx-94) && [_placemap.x intValue]>=(btnx-106)&&[_placemap.y intValue]<=(btny-94) && [_placemap.y intValue]>=(btny-106))
        {
            popController.if_emp_place = 1;
            popController.place=_placemap;
            popController.contentSize = CGSizeMake(210, 245);
            [self presentViewController:popController animated:YES completion:nil];
        }
    }
    

   

}


- (IBAction)stillfunc:(id)sender {
    [self.locationManager stopUpdatingHeading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
{
   
    if ([segue.identifier isEqualToString:@"modal1"])
    {
        Qrc *Qrcode = (Qrc *)segue.sourceViewController;
        NSLog(@"Values are %@", Qrcode.Qrx);
        NSLog(@"Values are %@", Qrcode.Qry);
        [self.locationManager startUpdatingHeading];
        if(Qrcode.Qrx!=NULL && Qrcode.Qry!=NULL)
        {
           [_imageVi removeFromSuperview];
           cx=[Qrcode.Qrx intValue];
           cy=[Qrcode.Qry intValue];
           UIImage *imag = [UIImage imageNamed:@"ar"];
           self.imageVi = [[UIImageView alloc] initWithImage:imag];
           self.imageVi.frame = (CGRect){.origin=CGPointMake(cx,cy),.size=CGSizeMake(100,200)};
           
           [self.imageView addSubview:self.imageVi];
            
           
           self.imglbl = [[UILabel  alloc] initWithFrame:CGRectMake(-250,-50,600,100)];
           [_imglbl   setText:@"You"];
           [_imglbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
           [_imglbl setTextColor:[UIColor brownColor ]];
           _imglbl.textAlignment = NSTextAlignmentCenter;
           [self.imageVi addSubview:self.imglbl];
              _imageView.layer.anchorPoint=CGPointMake((float)(cx+50)/400,(float)(cy+100)/600);
            _imageVi.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            self.imageVi.transform = CGAffineTransformRotate(self.imageVi.transform,DEGREES_TO_RADIANS(-(num-58)));
            
        }
        
    }
    else if([segue.identifier isEqualToString:@"search"])
    {
        EmployeeTable *search = (EmployeeTable *)segue.sourceViewController;

    if(search.employexy)
      {
          [employeedetails addObject:search.employexy];
        ex=[search.employexy.x  intValue];
        ey=[search.employexy.y intValue];
        [self.locationManager startUpdatingHeading];
        self.greengif=[[FLAnimatedImageView alloc]init];
        FLAnimatedImage *gifwork = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spot" ofType:@"gif"]]];
        self.greengif.frame = (CGRect){.origin=CGPointMake(ex,ey), .size=CGSizeMake(200,200)};
        self.greengif.animatedImage = gifwork;
        
        self.giflbl = [[UILabel  alloc] initWithFrame:CGRectMake(-200,-30,600,100)];
        
        [_giflbl   setText:search.employexy.name];
        [_giflbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
        [_giflbl setTextColor:[UIColor brownColor ]];
        _giflbl.textAlignment = NSTextAlignmentCenter;
        
        [self.greengif addSubview:self.giflbl];
        
        
        self.imageVie.userInteractionEnabled = YES;
        self.imageView.userInteractionEnabled = YES;
        self.greengif.userInteractionEnabled = YES;
        
        
        [gifimg addObject:_greengif];
        
          [self.imageView addSubview:_greengif];
      }
        
    else if(search.placexy)
     {
        [placedetails addObject:search.placexy];
        ex=[search.placexy.x  intValue];
        ey=[search.placexy.y intValue];
        [self.locationManager startUpdatingHeading];
        self.greengif=[[FLAnimatedImageView alloc]init];
        FLAnimatedImage *gifwork = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spot" ofType:@"gif"]]];
        self.greengif.frame = (CGRect){.origin=CGPointMake(ex,ey), .size=CGSizeMake(200,200)};
        self.greengif.animatedImage = gifwork;
        
        self.giflbl = [[UILabel  alloc] initWithFrame:CGRectMake(-200,-30,600,100)];
        
        [_giflbl   setText:search.placexy.placeName];
        [_giflbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
        [_giflbl setTextColor:[UIColor brownColor ]];
        _giflbl.textAlignment = NSTextAlignmentCenter;
        
        [self.greengif addSubview:self.giflbl];
        
//        self.subimbtn = [[UIButton  alloc] initWithFrame:CGRectMake(67,67,70,70)];
//         [_subimbtn setUserInteractionEnabled:YES ];
//        [_subimbtn addTarget:self
//                      action:@selector(tapped)
//            forControlEvents:UIControlEventTouchUpInside];
//        [_subimbtn setBackgroundColor:[UIColor clearColor]];
        self.imageVie.userInteractionEnabled = YES;
        self.imageView.userInteractionEnabled = YES;
        self.greengif.userInteractionEnabled = YES;
        //[self.greengif addSubview:self.subimbtn];
        
        [gifimg addObject:_greengif];
        
        [self.imageView addSubview:_greengif];
        }
        
    }
else if([segue.identifier isEqualToString:@"time2map"])
    {
        
        [self.locationManager startUpdatingHeading];
    }
else if([segue.identifier isEqualToString:@"favourite"])
{
    
    [self.locationManager startUpdatingHeading];
}
    
else if([segue.identifier isEqualToString:@"categorysearch"])
    {
        categoryViewController *categorysearch = (categoryViewController *)segue.sourceViewController;
        
        if(categorysearch.emp_plac==0)
        {
           
            
            [employeedetails addObject:categorysearch.categoryemployexy];
            
            ex=[categorysearch.categoryemployexy.x  intValue];
            ey=[categorysearch.categoryemployexy.y intValue];
            [self.locationManager startUpdatingHeading];
            self.greengif=[[FLAnimatedImageView alloc]init];
            FLAnimatedImage *gifwork = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spot" ofType:@"gif"]]];
            self.greengif.frame = (CGRect){.origin=CGPointMake(ex,ey), .size=CGSizeMake(200,200)};
            self.greengif.animatedImage = gifwork;
            
           
            
            self.giflbl = [[UILabel  alloc] initWithFrame:CGRectMake(-200,-30,600,100)];
            
            [_giflbl   setText:categorysearch.categoryemployexy.name];
            [_giflbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
            [_giflbl setTextColor:[UIColor brownColor ]];
            _giflbl.textAlignment = NSTextAlignmentCenter;
            
            [self.greengif addSubview:self.giflbl];
            
            
            self.imageVie.userInteractionEnabled = YES;
            self.imageView.userInteractionEnabled = YES;
            self.greengif.userInteractionEnabled = YES;
            [gifimg addObject:_greengif];
            
           [self.imageView addSubview:_greengif];
        }
        
        else if((int)categorysearch.emp_plac==1)
        {
            
            [placedetails addObject:categorysearch.categoryplacexy];
            ex=[categorysearch.categoryplacexy.x  intValue];
            ey=[categorysearch.categoryplacexy.y intValue];
            [self.locationManager startUpdatingHeading];
            self.greengif=[[FLAnimatedImageView alloc]init];
            FLAnimatedImage *gifwork = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spot" ofType:@"gif"]]];
            self.greengif.frame = (CGRect){.origin=CGPointMake(ex,ey), .size=CGSizeMake(200,200)};
            self.greengif.animatedImage = gifwork;
            
            
            self.giflbl = [[UILabel  alloc] initWithFrame:CGRectMake(-200,-30,600,100)];
            
            [_giflbl   setText:categorysearch.categoryplacexy.placeName];
            [_giflbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
            [_giflbl setTextColor:[UIColor brownColor ]];
            _giflbl.textAlignment = NSTextAlignmentCenter;
            
            [self.greengif addSubview:self.giflbl];
            
            self.imageVie.userInteractionEnabled = YES;
            self.imageView.userInteractionEnabled = YES;
            self.greengif.userInteractionEnabled = YES;
            
            
            [gifimg addObject:_greengif];
            
            [self.imageView addSubview:_greengif];
        }
        
    }

}
    
    

- (IBAction)clearfunction:(id)sender
{
    
    for(m=0;m<gifimg.count;m++)
    {
        _greengif=gifimg[m];
        [_greengif removeFromSuperview];
    }
    NSLog(@"%li",gifimg.count);
    if(gifimg.count>0)
    {
         gifimg = [[NSMutableArray alloc] initWithObjects:nil];
    }
    if(placedetails.count>0)
    {
        placedetails = [[NSMutableArray alloc] initWithObjects:nil];
    }
    if(employeedetails.count>0)
    {
        employeedetails = [[NSMutableArray alloc] initWithObjects:nil];
    }
    NSLog(@"%li",gifimg.count);
}

- (IBAction)lockfunction:(id)sender
{
    if(lock%2==0)
    {
        rotationlock=1;
    }
    else
    {
        if(rotationlock==1)
        {
            [self.locationManager stopUpdatingHeading];
            rotationlock=0;
            num=0;
            _imageView.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-58));
            _imageVi.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            self.imageVi.transform = CGAffineTransformRotate(self.imageVi.transform,DEGREES_TO_RADIANS(-(num-58)));
            [self.locationManager startUpdatingHeading];
        }
        
    }
    lock++;

    
}
@end
