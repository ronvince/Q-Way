//
//  Qrc.m
//  IndoorNavigationApp
//
//  Created by user on 6/28/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Roni Vincent and Jithin V.

#import "Qrc.h"
#import <CoreData/CoreData.h>
#import "QRCode.h"
#import "TimeLog.h"
#import "mapDraw.h"

@interface Qrc ()
@property (strong) NSMutableArray *qrcodes;
@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
-(void)stopReading;

@end

@implementation Qrc
int nullQrDB =1;
NSManagedObjectContext *managedObjectContext;
- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _isReading = NO;
    _captureSession = nil;
    //_test.text = _lblStatus.text;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction method implementation
- (IBAction)StartFunction:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [_start setTitle:@"Stop"];

            
        }
    }
    else{
        [self stopReading];
        [_start setTitle:@"Start!"];
    }
    // _test.text = _lblStatus.text;
    _isReading = !_isReading;
}

#pragma mark - Private method implementation
- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_vi.layer.bounds];
    [_vi.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    return YES;
}
-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}
NSInteger x;
NSInteger y;
#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
           // [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj
            
            NSString *string = [metadataObj stringValue];
            
            NSLog(@"%@",string);
            
            
            //code for fetch in timelog
            /*            NSManagedObjectContext *managedObjectContext1 = [self managedObjectContext];
             NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] initWithEntityName:@"TimeLog"];
             
             fetchRequest1.fetchLimit = 1;
             fetchRequest1.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"slno" ascending:NO]];
             
             NSError *error = nil;
             
             id last = [managedObjectContext1 executeFetchRequest:fetchRequest1 error:&error].firstObject;
             
             NSLog(@"%@", last);
             */
            
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"QRCode" inManagedObjectContext:managedObjectContext]];
            // self.employees = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
            // NSString *delstring = _deletefield.text;
            
            //for (NSManagedObject *device in self.employees){
            
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"qr == %@ ", string]];
            NSError* error = nil;
            NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSLog(@"hellooo %lu",(unsigned long)results.count);
            /*      Employee *emp=[results  objectAtIndex:0];
             [managedObjectContext deleteObject:emp];
             //}
             [managedObjectContext save:&error];
             
             
             */
            
            QRCode *qc;
            if (results.count!=0){
                nullQrDB = 0;
                qc = [results objectAtIndex:0];
                NSLog(@"qrcode count  %lu", (unsigned long)results.count);
                NSLog(@"%@%@", qc.x,qc.y);
                
                // x= qc.x;
                x = [qc.x integerValue];
                y = [qc.y integerValue];
                
                // y=qc.y;
                
                //code for timelog db
                NSString *qrdef = qc.def;
                
                NSManagedObjectContext *context = [self managedObjectContext];
                
                // Create a new managed object
                NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"TimeLog" inManagedObjectContext:context];
                [newDevice setValue:qrdef forKey:@"deftime"];
                
                //code for obtaining date
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setDateFormat:@"MMM dd, yyyy"];
                
                NSDate *now = [[NSDate alloc] init];
                
                NSString *dateString = [format stringFromDate:now];
                
                [newDevice setValue:dateString forKey:@"date"];
                
                NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
                [format1 setDateFormat:@"hh:mm"];
                
                NSDate *now1 = [[NSDate alloc] init];
                
                NSString *timeString = [format1 stringFromDate:now1];
                
                [newDevice setValue:timeString forKey:@"time"];
                NSLog(@"%@", timeString);
                
                NSDateFormatter *format2 = [[NSDateFormatter alloc] init];
                [format2 setDateFormat:@"MMM dd, yyyy hh:mm:ss"];
                
                NSDate *now2 = [[NSDate alloc] init];
                
                NSString *datetimeString = [format2 stringFromDate:now2];
                NSLog(@"%@", datetimeString);
                [newDevice setValue:datetimeString forKey:@"datetime"];
                //code for Unique id
                
                
                
               

            }
            
            
            
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_start performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
            
            
        }
        
    }

}
- (IBAction)okfun:(id)sender {
    
    
    
}
//NSNumber *b = 1;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"modal"]) {
         NSLog(@"ok");
                mapDraw *controller = (mapDraw *)segue.destinationViewController;
        controller.ix=x;
        controller.iy=y;
        controller.a=1;
        controller.nullQrDB = nullQrDB;
       
    }
}


@end
