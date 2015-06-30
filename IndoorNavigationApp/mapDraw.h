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
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end