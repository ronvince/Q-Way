//
//  mapDraw.h
//  IndoorNavigationApp
//
//  Created by user on 6/29/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import <coreLocation/coreLocation.h>


@interface mapDraw : UIViewController <UIScrollViewDelegate,CLLocationManagerDelegate>

@property ( nonatomic )NSInteger *ix;
@property (nonatomic )NSInteger *iy;
@property (nonatomic)NSInteger *a;
@property (nonatomic)NSInteger *nullQrDB;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *databutton;
@property (strong, nonatomic) IBOutlet UIButton *QRcodebutton;
@property (strong, nonatomic) IBOutlet UIButton *logbutton;
@property (strong, nonatomic) IBOutlet UIButton *searchbutton;

@end