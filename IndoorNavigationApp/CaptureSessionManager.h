//
//  CaptureSessionManager.h
//  IndoorNavigationApp
//
//  Created by user on 7/13/15.
//  Copyright (c) 2015 user. All rights reserved.
//
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>

#import <Foundation/Foundation.h>

@interface CaptureSessionManager : NSObject

@property (retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (retain) AVCaptureSession *captureSession;

- (void)addVideoPreviewLayer;
- (void)addVideoInput;
@end