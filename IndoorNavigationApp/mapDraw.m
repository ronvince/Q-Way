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
@import CoreGraphics;

@interface mapDraw ()
@property (nonatomic, strong) UIImageView *imageVie;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageVi;
@property (nonatomic, strong) UILabel *imglbl;
@property (nonatomic, strong) UILabel *giflbl;
@property (nonatomic, strong) UIButton *subimbtn;
@property (strong, nonatomic) FLAnimatedImageView *greengif;
- (void)tapped;

- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

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
    
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    CGFloat newZoomScale =self.scrollView.zoomScale*1.5;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    pointInView.y=pointInView.y+200;
    pointInView.x=pointInView.x+30;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0);
    CGFloat y = pointInView.y - (h / 2.0);
    
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
int m;
- (void)viewDidLoad {
    [super viewDidLoad];
    num=0;
    
    cx = _ix ;
    cy = _iy ;
    ca = _a;
    nu = _nullQrDB;

    NSLog(@"%i",a);
    
   // NSLog(@"%li",cy);
    if(_employe)
    {
        NSString *name = _employe.name;
        //xField.text = employe.desig;
       ea=1;
        ex =[_employe.x intValue];
        ey =[_employe.y intValue];
        
    }
    else if(_place)
    {
        //nameLabel.text =place.placeName;
//        [xField setText:[NSString stringWithFormat:@"%@", place.x]];
//        [yField setText:[NSString stringWithFormat:@"%@", place.y]];
//        ca=1;
//        cx=_place.x;
//        cy =_place.y;
//        NSLog(@"%i",cx);
//        NSLog(@"%i",cy);
    }


    
    
    
    self.currentHeading =[[CLHeading alloc] init];
    self.locationManager = [[CLLocationManager alloc ] init ];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.headingFilter = 1;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    
    UIImage *image = [UIImage imageNamed:@"floor.png"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(200,20), .size=CGSizeMake(800,1200)};
    
    UIImage *ima = [UIImage imageNamed:@""];
    self.imageVie = [[UIImageView alloc] initWithImage:ima];
    self.imageVie.frame = (CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(1200,1200)};
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
        
        [_giflbl   setText:_employe.name];
        [_giflbl setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
        [_giflbl setTextColor:[UIColor brownColor ]];
        _giflbl.textAlignment = NSTextAlignmentCenter;
        
        [self.greengif addSubview:self.giflbl];
        
        self.subimbtn = [[UIButton  alloc] initWithFrame:CGRectMake(67,67,70,70)];//(67,67,70,70)
        [_subimbtn setUserInteractionEnabled:YES ];
        [_subimbtn addTarget:self
                      action:@selector(tapped)
            forControlEvents:UIControlEventTouchUpInside];
        
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
    [self.view addSubview:self.databutton];
     [self.view addSubview:self.searchbutton];
     [self.view addSubview:self.logbutton];
     [self.view addSubview:self.QRcodebutton];
   
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.scrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height/ self.scrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    self.scrollView.minimumZoomScale =minScale;
    self.scrollView.maximumZoomScale =2.0;
    self.scrollView.zoomScale = minScale;
    [self centerScrollViewContents];
    
}

NSInteger  num=0;
NSInteger prev;
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading

{
   
        prev=num;
        self.currentHeading = newHeading;
        num =360-(int)newHeading.magneticHeading;
        self.imageView.transform = CGAffineTransformRotate (self.imageView.transform, DEGREES_TO_RADIANS(num-prev));
        [self.imageVie addSubview:self.imageView];
        
        self.imageVi.transform = CGAffineTransformRotate (self.imageVi.transform, DEGREES_TO_RADIANS(-(num-prev)));
        
        [self.imageView addSubview:self.imageVi];
    
    
    
    
}



- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    
    return self.imageVie;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    int i=0;
    
    if(_scrollView.zoomScale>=0.3125&&_scrollView.zoomScale<=2)
    {
        
        _imageVi.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
        self.imageVi.transform = CGAffineTransformRotate(self.imageVi.transform,DEGREES_TO_RADIANS(-num));
       
     
        for(i=0;i<gifimg.count;i++)
        {
            _greengif=gifimg[i];
            _greengif.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
            
        }
    }
    
    
    [self centerScrollViewContents];
    
}
-(void)tapped
{
    
    int btnx;
    int btny;
    btnx=_greengif.center.x;
    btny=_greengif.center.y;
    NSLog(@"hi");
    
}

- (IBAction)stillfunc:(id)sender {
    [self.locationManager stopUpdatingHeading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
