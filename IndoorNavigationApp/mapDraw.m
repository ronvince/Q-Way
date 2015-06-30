//
//  mapDraw.m
//  IndoorNavigationApp
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import "mapDraw.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
@import CoreGraphics;

@interface mapDraw ()
@property (nonatomic, strong) UIImageView *imageVie;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *imageVi;
@property (nonatomic, strong) UILabel *imla;
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
@synthesize imla =_imla;

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
NSInteger cx;//=600;
NSInteger cy;//=20;
NSInteger ca;

- (void)viewDidLoad {
    [super viewDidLoad];
   // NSLog(@"%li",num);
    num=0;
    
    // prev=0;
    cx = _ix ;
    cy = _iy ;
    ca = _a;
    NSLog(@"%i",a);
   // NSLog(@"%li",cy);
    self.currentHeading =[[CLHeading alloc] init];
    self.locationManager = [[CLLocationManager alloc ] init ];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.headingFilter = 1;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    
    UIImage *image = [UIImage imageNamed:@"Map.jpg"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(200,20), .size=CGSizeMake(800,1200)};
    
    UIImage *ima = [UIImage imageNamed:@""];
    self.imageVie = [[UIImageView alloc] initWithImage:ima];
    self.imageVie.frame = (CGRect){.origin=CGPointMake(0, 0), .size=CGSizeMake(1200,1200)};
    [self.scrollView addSubview:self.imageVie];
  [self.imageVie addSubview:self.imageView];
    if (_ix == NULL) {
        ca=0;
    }
    if (ca==1) {
        UIImage *imag = [UIImage imageNamed:@"ar"];
        self.imageVi = [[UIImageView alloc] initWithImage:imag];
        self.imageVi.frame = (CGRect){.origin=CGPointMake(cx,cy),.size=CGSizeMake(100,200)};
        
        [self.imageView addSubview:self.imageVi];
        
        self.imla = [[UILabel  alloc] initWithFrame:CGRectMake(-250,-50,600,100)];
        
        [_imla   setText:@"You"];
        [_imla setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:70]];
        [_imla setTextColor:[UIColor brownColor ]];
        // [_imla setTextAlignment:UITextAlignmentCenter];
        _imla.textAlignment = NSTextAlignmentCenter;
        [self.imageVi addSubview:self.imla];

    }
    
    
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
       // NSLog(@"magnet%i",(int)newHeading.magneticHeading);
        num =360-(int)newHeading.magneticHeading;
        //NSLog(@"num%li",num);
        //NSLog(@"prev%li",prev);
        self.imageView.transform = CGAffineTransformRotate (self.imageView.transform, DEGREES_TO_RADIANS(num-prev));NSLog(@"difference%li",num-prev);
        [self.imageVie addSubview:self.imageView];
        
        self.imageVi.transform = CGAffineTransformRotate (self.imageVi.transform, DEGREES_TO_RADIANS(-(num-prev)));
        
        [self.imageView addSubview:self.imageVi];
    
    
    
    
}
//-(void)didTouchView:(UIView *)aView{
//    NSLog(@"view touched, changing image");
//    _imageVi.image = [UIImage imageNamed:@"arrow"];
//}


- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    
    return self.imageVie;
}
//float jit=0.3125;
//float ji=0.3125;
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    
    if(_scrollView.zoomScale>=0.3125&&_scrollView.zoomScale<=2)
    {
        
        _imageVi.transform=CGAffineTransformMakeScale(0.312500/_scrollView.zoomScale,0.312500/_scrollView.zoomScale );
        self.imageVi.transform = CGAffineTransformRotate(self.imageVi.transform,DEGREES_TO_RADIANS(-num));
       
     
    }
    
    
    [self centerScrollViewContents];
    
}

- (IBAction)stillfunc:(id)sender {
    [self.locationManager stopUpdatingHeading];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
