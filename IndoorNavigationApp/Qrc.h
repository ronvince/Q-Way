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
@interface Qrc : UIViewController <AVCaptureMetadataOutputObjectsDelegate>


@property (nonatomic,strong )NSString *Qrx;
@property (nonatomic,strong )NSString *Qry;
@property (weak, nonatomic) IBOutlet UIView *vi;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *start;

- (IBAction)StartFunction:(id)sender;
@end
