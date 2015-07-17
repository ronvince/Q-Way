//
//  Qrc.h
//  IndoorNavigationApp
//
//  Created by user on 6/28/15.
//  Copyright (c) 2015 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "CaptureSessionManager.h"
@interface Qrc : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;

@property (nonatomic,strong )NSString *Qrx;
@property (nonatomic,strong )NSString *Qry;
@property (nonatomic)  NSInteger nullQrDB;
//@property (weak, nonatomic) IBOutlet UIView *vi;
@property (strong, nonatomic) IBOutlet UIView *view5;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *start;
//- (IBAction)StartFunction:(id)sender;

@property (retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UILabel *scanningLabel;
@property (nonatomic, retain) UILabel *DisplayLabel;




@end
