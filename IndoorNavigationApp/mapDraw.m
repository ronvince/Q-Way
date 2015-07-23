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
#import "favouriteViewController.h"
#import <AudioToolbox/AudioServices.h>

@import CoreGraphics;

@interface mapDraw ()
@property (nonatomic, strong) UIView *imageView;
@property (nonatomic, strong) UIImageView *Mapimage;
@property (nonatomic, strong) UIImageView *Qrimage;
@property (nonatomic, strong) UILabel *imglbl;
@property (nonatomic, strong) UILabel *giflbl;
@property (nonatomic, strong) UIButton *subimbtn;
@property (strong, nonatomic) FLAnimatedImageView *greengif;
@property (strong, nonatomic) FLAnimatedImageView *refreshgif;

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
@synthesize imageView = _imageView;
@synthesize Mapimage = _Mapimage;
@synthesize Qrimage = _Qrimage;
@synthesize imglbl =_imglbl;
@synthesize giflbl =_giflbl;
@synthesize subimbtn=_subimbtn;
@synthesize greengif=_greengif;


int a =0;
- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
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
    
    self.imageView.frame = contentsFrame;
    
}


- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    
    CGPoint pointInView = [recognizer locationInView:self.imageView];
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
int subviewstart=0;
int searchstart=0;
int samesearch;

- (void)viewDidLoad
{
    [super viewDidLoad];
    num=0;
    self.currentHeading =[[CLHeading alloc] init];
    self.locationManager = [[CLLocationManager alloc ] init ];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.headingFilter = 1;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    
    UIImage *image = [UIImage imageNamed:@"floor.png"];
    self.Mapimage = [[UIImageView alloc] initWithImage:image];
    self.Mapimage.frame = (CGRect){.origin=CGPointMake(400,425), .size=CGSizeMake(400,600)};

    self.imageView = [[UIView alloc] init];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(1200,1450)};
    [self.scrollView addSubview:self.imageView];
  [self.imageView addSubview:self.Mapimage];
    
    
    //for toast message
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 540, 210, 25)];
    [self setInvalidlabel:tempLabel];
    [self.invalidlabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:13]];
    [self.invalidlabel  setTextAlignment:NSTextAlignmentCenter];
    [self.invalidlabel setTextColor:[UIColor whiteColor]];
    self.invalidlabel.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1];
    self.invalidlabel.layer.cornerRadius = 10;
    self.invalidlabel.layer.masksToBounds = YES;
    [_invalidlabel setHidden:YES];
    [[self view] addSubview:_invalidlabel];

    
    
    
    if (nu==1)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid" message:@"No such QR Code in Database" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
               [alert show];
    
        
    }
    //////////////////////////////////////////
    
    
    self.imageView.userInteractionEnabled = YES;
    self.Mapimage.userInteractionEnabled = YES;
    
    gifimg = [[NSMutableArray alloc] initWithObjects:nil];
    
    
    employeedetails = [[NSMutableArray alloc] initWithObjects:nil];
    placedetails = [[NSMutableArray alloc] initWithObjects:nil];
    
/////////////////////////////////////////////////
    self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width , self.imageView.frame.size.height);
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
    [self.Mapimage addGestureRecognizer:tap];
    //////////////////////////
    
    _Mapimage.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-58));
    
    //////////////////////

    [self.view addSubview:self.databutton];
     [self.view addSubview:self.searchbutton];
     [self.view addSubview:self.logbutton];
     [self.view addSubview:self.QRcodebutton];
    [self.view addSubview:self.clearbutton];
    [self.view addSubview:self.lockbutton];
   [self.view addSubview:self.favbutton];
    //////////////////////////////////////////////////////
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height/ self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale =1;
    self.scrollView.maximumZoomScale =5.0;
    self.scrollView.zoomScale = minScale;
    
    
    
    CGFloat newZoomScale =1;
   
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = _Mapimage.center.x- (w / 2.0f);
    CGFloat y = _Mapimage.center.y- (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];

    
    
    
    [self centerScrollViewContents];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    
}

NSInteger  num=0;
NSInteger prev=0;
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading

{
   
        prev=num;
        self.currentHeading = newHeading;
        num =360-(int)newHeading.magneticHeading;
    if(rotationlock==0)
      {
        self.Mapimage.transform = CGAffineTransformRotate (self.Mapimage.transform, DEGREES_TO_RADIANS(num-prev));
        [self.imageView addSubview:self.Mapimage];
      }
   
    if(subviewstart==1)
      {
        self.Qrimage.transform = CGAffineTransformRotate (self.Qrimage.transform, DEGREES_TO_RADIANS(-(num-prev)));
        
        [self.Mapimage addSubview:self.Qrimage];
      }
    if (searchstart==1 )
    {
        for(m=0;m<gifimg.count;m++)
        {
            _greengif=gifimg[m];
            self.greengif.transform = CGAffineTransformRotate (self.greengif.transform, DEGREES_TO_RADIANS(-(num-prev)));

        }

    }
        
    
    
}



- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    int i=0;
    
    if(_scrollView.zoomScale>=0.3125&&_scrollView.zoomScale<=5)
    {
        if(subviewstart==1)
         {
            _Qrimage.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            self.Qrimage.transform = CGAffineTransformRotate(self.Qrimage.transform,DEGREES_TO_RADIANS(-(num-58)));
         }
     
    
                for(i=0;i<gifimg.count;i++)
                {
                    _greengif=gifimg[i];
                _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
                    
                self.greengif.transform = CGAffineTransformRotate(self.greengif.transform,DEGREES_TO_RADIANS(-(num-58)));
                }



    }
    
    
    [self centerScrollViewContents];
    
}
int btnx;
int btny;



- (void)imageTapped:(UITapGestureRecognizer*)recognizer
 {
    
    CGPoint tapPoint = [recognizer locationInView:self.Mapimage];
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
                popController.contentSize = CGSizeMake(230, 245);
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
            popController.contentSize = CGSizeMake(230, 245);
            [self presentViewController:popController animated:YES completion:nil];
          }
    }
    

   

}


- (IBAction)stillfunc:(id)sender
  {
    [self.locationManager stopUpdatingHeading];
  }


- (void)didReceiveMemoryWarning
  {
    [super didReceiveMemoryWarning];
  }

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue
 {
   
    if ([segue.identifier isEqualToString:@"modal1"])
    {
        Qrc *Qrcode = (Qrc *)segue.sourceViewController;
        NSLog(@"Values are %@", Qrcode.Qrx);
        NSLog(@"Values are %@", Qrcode.Qry);
        NSLog(@"Values are %ld", (long)Qrcode.nullQrDB);
        [self.locationManager startUpdatingHeading];
        
           if(Qrcode.Qrx!=NULL && Qrcode.Qry!=NULL)
               
            {
                
              [_Qrimage removeFromSuperview];
              cx=[Qrcode.Qrx intValue];
              cy=[Qrcode.Qry intValue];
              UIImage *imag = [UIImage imageNamed:@"ar"];
              self.Qrimage = [[UIImageView alloc] initWithImage:imag];
              self.Qrimage.frame = (CGRect){.origin=CGPointMake(cx,cy),.size=CGSizeMake(100,200)};
           
              [self.Mapimage addSubview:self.Qrimage];
                subviewstart=1;
           
              self.imglbl = [[UILabel  alloc] initWithFrame:CGRectMake(-250,-50,600,100)];
              [_imglbl   setText:@"You"];
              [_imglbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
              [_imglbl setTextColor:[UIColor brownColor ]];
              _imglbl.textAlignment = NSTextAlignmentCenter;
              [self.Qrimage addSubview:self.imglbl];
                
                
             _Qrimage.layer.anchorPoint = CGPointMake(0.5,0.95);
                
                
              _Mapimage.layer.anchorPoint=CGPointMake((float)(cx+50)/400,(float)(cy+100)/600);
              _Qrimage.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
              self.Qrimage.transform = CGAffineTransformRotate(self.Qrimage.transform,DEGREES_TO_RADIANS(-(num-58)));
            
                }
           else if(Qrcode.nullQrDB==1)
               {
           
               [_invalidlabel setText:@"Invalid QRcode "];
               [_invalidlabel setHidden:NO];
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
           
               [NSTimer scheduledTimerWithTimeInterval:1.5
                                                target:self
                                              selector:@selector(animate:)
                                              userInfo:nil
                                               repeats:NO];
              }
           else if (Qrcode.nullQrDB==2){
               [_invalidlabel setText:@"No QR Code Scanned"];
               [_invalidlabel setHidden:NO];
               AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
               
               [NSTimer scheduledTimerWithTimeInterval:1.5
                                                target:self
                                              selector:@selector(animate:)
                                              userInfo:nil
                                               repeats:NO];
           }
    }
    else if([segue.identifier isEqualToString:@"search"])
    {
        EmployeeTable *search = (EmployeeTable *)segue.sourceViewController;
    
        [self.locationManager startUpdatingHeading];

     if(search.employexy)
       {
           samesearch=0;
           for (m=0; m<employeedetails.count;m++)
           {
               _employemap=employeedetails[m];
               if (search.employexy.empid==_employemap.empid)
               {
                   samesearch=1;
               }
           }
           
           if(samesearch==0)
             
           {
           
             [employeedetails addObject:search.employexy];
             ex=[search.employexy.x  intValue];
             ey=[search.employexy.y intValue];
             
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
        
        
             self.imageView.userInteractionEnabled = YES;
             self.Mapimage.userInteractionEnabled = YES;
             self.greengif.userInteractionEnabled = YES;
        
        
             [gifimg addObject:_greengif];
        
             [self.Mapimage addSubview:_greengif];
             searchstart=1;
             _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
             self.greengif.transform = CGAffineTransformRotate(self.greengif.transform,DEGREES_TO_RADIANS(-(num-58)));
           }
       }
    else if(search.placexy)
      {
          samesearch=0;
          for (m=0; m<placedetails.count;m++)
          {
              _placemap=placedetails[m];
              if (search.placexy.placeName==_placemap.placeName)
              {
                  samesearch=1;
              }
          }
          
          if(samesearch==0)
              
          {

          
        [placedetails addObject:search.placexy];
        ex=[search.placexy.x  intValue];
        ey=[search.placexy.y intValue];
        
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

        self.imageView.userInteractionEnabled = YES;
        self.Mapimage.userInteractionEnabled = YES;
        self.greengif.userInteractionEnabled = YES;
        [gifimg addObject:_greengif];
        
        [self.Mapimage addSubview:_greengif];
        searchstart=1;
        _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
         self.greengif.transform = CGAffineTransformRotate(self.greengif.transform,DEGREES_TO_RADIANS(-(num-58)));
          }
        }
        
     }
  else if([segue.identifier isEqualToString:@"time2map"])
    {
        
        [self.locationManager startUpdatingHeading];
    }
  else if([segue.identifier isEqualToString:@"favourite"])
   {
    
       favouriteViewController *favouritesearch = (favouriteViewController *)segue.sourceViewController;
       [self.locationManager startUpdatingHeading];
       
       if(favouritesearch.favouriteemployeexy)
       {
           samesearch=0;
           for (m=0; m<employeedetails.count;m++)
           {
               _employemap=employeedetails[m];
               if (favouritesearch.favouriteemployeexy.empid==_employemap.empid)
               {
                   samesearch=1;
               }
           }
           
           if(samesearch==0)
               
           {
               
               [employeedetails addObject:favouritesearch.favouriteemployeexy];
               ex=[favouritesearch.favouriteemployeexy.x  intValue];
               ey=[favouritesearch.favouriteemployeexy.y intValue];
               
               self.greengif=[[FLAnimatedImageView alloc]init];
               FLAnimatedImage *gifwork = [[FLAnimatedImage alloc] initWithAnimatedGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spot" ofType:@"gif"]]];
               self.greengif.frame = (CGRect){.origin=CGPointMake(ex,ey), .size=CGSizeMake(200,200)};
               self.greengif.animatedImage = gifwork;
               
               self.giflbl = [[UILabel  alloc] initWithFrame:CGRectMake(-200,-30,600,100)];
               
               [_giflbl   setText:favouritesearch.favouriteemployeexy.name];
               [_giflbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
               [_giflbl setTextColor:[UIColor brownColor ]];
               _giflbl.textAlignment = NSTextAlignmentCenter;
               
               [self.greengif addSubview:self.giflbl];
               
               
               self.imageView.userInteractionEnabled = YES;
               self.Mapimage.userInteractionEnabled = YES;
               self.greengif.userInteractionEnabled = YES;
               
               
               [gifimg addObject:_greengif];
               
               [self.Mapimage addSubview:_greengif];
               searchstart=1;
               _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
               self.greengif.transform = CGAffineTransformRotate(self.greengif.transform,DEGREES_TO_RADIANS(-(num-58)));
           }
       }

       
       
       
    
   }
    
  else if([segue.identifier isEqualToString:@"categorysearch"])
    {
        categoryViewController *categorysearch = (categoryViewController *)segue.sourceViewController;
        [self.locationManager startUpdatingHeading];
        if(categorysearch.emp_plac==0)
        {
            samesearch=0;
            for (m=0; m<employeedetails.count;m++)
            {
                _employemap=employeedetails[m];
                if (categorysearch.categoryemployexy.empid==_employemap.empid)
                {
                    samesearch=1;
                }
            }
            
            if(samesearch==0)
                
            {

            
            
            [employeedetails addObject:categorysearch.categoryemployexy];
            
            ex=[categorysearch.categoryemployexy.x  intValue];
            ey=[categorysearch.categoryemployexy.y intValue];
            
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
            
            
            self.imageView.userInteractionEnabled = YES;
            self.Mapimage.userInteractionEnabled = YES;
            self.greengif.userInteractionEnabled = YES;
            [gifimg addObject:_greengif];
            
           [self.Mapimage addSubview:_greengif];
            searchstart=1;
            _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            
            self.greengif.transform = CGAffineTransformRotate(self.greengif.transform,DEGREES_TO_RADIANS(-(num-58)));
            }
        }
        
        else if((int)categorysearch.emp_plac==1)
        {
            
            
            samesearch=0;
            for (m=0; m<placedetails.count;m++)
            {
                _placemap=placedetails[m];
                if (categorysearch.categoryplacexy.placeName==_placemap.placeName)
                {
                    samesearch=1;
                }
            }
            
            if(samesearch==0)
                
            {
                

            
            [placedetails addObject:categorysearch.categoryplacexy];
            ex=[categorysearch.categoryplacexy.x  intValue];
            ey=[categorysearch.categoryplacexy.y intValue];
    
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
            
            self.imageView.userInteractionEnabled = YES;
            self.Mapimage.userInteractionEnabled = YES;
            self.greengif.userInteractionEnabled = YES;
            
            
            [gifimg addObject:_greengif];
            
            [self.Mapimage addSubview:_greengif];
            searchstart=1;
             _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            self.greengif.transform = CGAffineTransformRotate(self.greengif.transform,DEGREES_TO_RADIANS(-(num-58)));
            }
        }
        
    }

 }
    
    

- (IBAction)clearfunction:(id)sender
 {
     
     NSMutableArray *imageArray = [NSMutableArray new];
     
     for (int i = 1; i <= 12; i ++) {
         [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"l%d.png",i]]];
     }
     
     [self.clearbutton setImage:[UIImage imageNamed:@"l1.png"] forState:UIControlStateNormal];
     
     [self.clearbutton.imageView setAnimationImages:[imageArray copy]];
     [self.clearbutton.imageView setAnimationDuration:.5];
     
     [self.clearbutton.imageView startAnimating];
    
     [NSTimer scheduledTimerWithTimeInterval:0.5
                                      target:self
                                    selector:@selector(loading:)
                                    userInfo:nil
                                     repeats:NO];
     
     
 }


-(void)loading:(NSTimer *)theTimer {
    
    
    for(m=0;m<gifimg.count;m++)
    {
        _greengif=gifimg[m];
        [_greengif removeFromSuperview];
    }
    
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
    searchstart=0;
    
    [self.clearbutton.imageView stopAnimating];
    UIImage *btnImage1 = [UIImage imageNamed:@"ic-refresh.png"];
    [self.clearbutton setImage:btnImage1 forState:UIControlStateNormal];

}



- (IBAction)lockfunction:(id)sender
 {
    if(lock%2==0)
     {
         UIImage *btnImage1 = [UIImage imageNamed:@"un_lock.png"];
         [sender setImage:btnImage1 forState:UIControlStateNormal];
         rotationlock=1;
     }
    else
    {
        UIImage *btnImage1 = [UIImage imageNamed:@"ic-lock.png"];
        [sender setImage:btnImage1 forState:UIControlStateNormal];
        if(rotationlock==1)
         {
            [self.locationManager stopUpdatingHeading];
            rotationlock=0;
            num=0;
            _Mapimage.transform=CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-58));
            _Qrimage.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            self.Qrimage.transform = CGAffineTransformRotate(self.Qrimage.transform,DEGREES_TO_RADIANS(-(num-58)));
             
             if (searchstart==1)
             {
                 for(m=0;m<gifimg.count;m++)
                 {
                     _greengif=gifimg[m];
                     self.greengif.transform = CGAffineTransformMakeRotation ( DEGREES_TO_RADIANS(-(num-58)));
                      _greengif.transform=CGAffineTransformScale(_greengif.transform, 0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
                     
                 }
                 
             }

             
            [self.locationManager startUpdatingHeading];
         }
        
    }
    lock++;
 }


-(void)animate:(NSTimer *)theTimer {
    [_invalidlabel setHidden:YES];
}



@end
