//
//  Qrc.m
//  IndoorNavigationApp
//
//  Created by user on 6/28/15.
//  Copyright (c) 2015 user. All rights reserved.
//  Written By Anita Grace Daniel and Roni Vincent.


#import "Qrc.h"
#import <CoreData/CoreData.h>
#import "QRCode.h"
#import "TimeLog.h"
#import "mapDraw.h"

@interface Qrc ()
@property (strong) NSMutableArray *qrcodes;
/*@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
-(void)stopReading;
*/
@end

@implementation Qrc
@synthesize scanningLabel;
@synthesize DisplayLabel;
int check1 = 0;
UIButton *overlayButton, *cancelButton;

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
     _nullQrDB=1;
    _progressView.progress = 0.0;
   
    check1 = 0;
    [self setCaptureManager:[[CaptureSessionManager alloc] init] ];
    
    [[self captureManager] addVideoInput];
    
    
    
    [[self captureManager] addVideoPreviewLayer];
    CGRect layerRect = [[[self view] layer] bounds];
    [[[self captureManager] previewLayer] setBounds:layerRect];
    [[[self captureManager] previewLayer] setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                                                  CGRectGetMidY(layerRect))];
    [[[self view] layer] addSublayer:[[self captureManager] previewLayer]];
       UIImageView *overlayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue_squre.png"]];
    
    [overlayImageView setFrame:CGRectMake(self.view.center.x-115, 140, 230, 230)];
    [[self view] addSubview:overlayImageView];
    //[overlayImageView release];
 
    
    overlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [overlayButton setImage:[UIImage imageNamed:@"scanbutton.png"] forState:UIControlStateNormal];
    [overlayButton setFrame:CGRectMake(145, 405, 80, 60)];
    [overlayButton addTarget:self action:@selector(scanButtonPressed)   forControlEvents:UIControlEventTouchUpInside];
    
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //[[cancelButton imageView] setContentMode: UIViewContentModeScaleAspectFit];
    [cancelButton setImage:[UIImage imageNamed:@"cancelnew.png"] forState:UIControlStateNormal];
    [cancelButton setFrame:CGRectMake(20, 30, 120, 40)];
    [cancelButton addTarget:self action:@selector(cancelButtonPressed)   forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
//    UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 50, 250, 30)];
//    [self setScanningLabel:tempLabel];
//    // [tempLabel release];
//    [scanningLabel setBackgroundColor:[UIColor clearColor]];
//    //[scanningLabel setFont:[UIFont fontWithName:@"Courier" size: 18.0]];
//    [scanningLabel setTextColor:[UIColor redColor]];
//    [scanningLabel setText:@"SCANNING IN PROGRESS!!"];
//    [scanningLabel setHidden:YES];
//    [[self view] addSubview:scanningLabel];
    
    UILabel *temp = [[UILabel alloc] initWithFrame:CGRectMake(70, 430, 250, 200)];
    [self setDisplayLabel:temp];
    [scanningLabel setBackgroundColor:[UIColor clearColor]];
    [DisplayLabel setHidden:NO];
    [[self view] addSubview:DisplayLabel];
    [_captureManager.captureSession startRunning];
    
    
       //[[self view] addSubview:overlayButton];


   
    int screenwidth=self.view.frame.size.width;
    int screenHeight=self.view.frame.size.height;
    _view1=[[UIView alloc ]initWithFrame:CGRectMake(0,0, screenwidth, 140)];
    _view1.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.5];
    _view2=[[UIView alloc ]initWithFrame:CGRectMake(0, 140, self.view.center.x-115, 230)];
    _view2.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.5];
    _view3=[[UIView alloc ]initWithFrame:CGRectMake(self.view.center.x+115, 140, self.view.center.x-115, 230)];
    _view3.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.5];
    _view4=[[UIView alloc ]initWithFrame:CGRectMake(0, 370, screenwidth, screenHeight-370)];
    _view4.backgroundColor=[UIColor colorWithWhite:0.7 alpha:0.5];
    [self.view addSubview:_view1];
    [self.view addSubview:_view2];
    [self.view addSubview:_view3];
    [self.view addSubview:_view4];
    _view5.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_view5];
    [overlayButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:cancelButton];
   // _progressView.transform=CGAffineTransformMakeRotation((3.14)/2);
    //_progressView.transform=CGAffineTransformScale(_progressView.transform, 1.0f, 3.0f);
     //   _progressView.transform=CGAffineTransformTranslate(_progressView.transform, 150, 100);
    
    [self.view addSubview:_progressView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) scanButtonPressed {
    overlayButton.hidden = YES;
    [[self scanningLabel] setHidden:NO];
    [self performSelector:@selector(startReading:) withObject:[self scanningLabel]  ];
}

-(void) cancelButtonPressed{
    _nullQrDB=2;
    [self performSegueWithIdentifier:@"modal1" sender:self];
}

- (void)startReading:(UILabel *)label {
    // [label setHidden:YES];
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureManager.captureSession addOutput:captureMetadataOutput];
    
    //NSLog(@"%d",check);
    NSLog(@"DFGIKGILAUFG");
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    
    // [captureManager.captureSession startRunning];
    
}
- (void)makeMyProgressBarMoving {
    
    float actual = [_progressView progress];
    if (actual < 1) {
        _progressView.progress = actual + ((float)3/(float)100);
        [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(makeMyProgressBarMoving) userInfo:nil repeats:NO];
    }
    else{
        
        
        
    }
    
}
-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    
    UIImageView *img=[[UIImageView alloc] initWithFrame:self.view5.bounds];
    img.image=[UIImage imageNamed:@"qrcodeview.jpg"];
    [self.view5 addSubview:img];
    
    
    [_captureManager.captureSession stopRunning];
    _captureManager.captureSession = nil;
   
}
 
 

NSInteger x;
NSInteger y;
#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            
            [scanningLabel performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            NSLog(@"%@",scanningLabel.text);            NSString *string = [metadataObj stringValue];
            
            NSLog(@"%@",string);
            
            NSString *dateString;
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"MMM dd, yyyy"];
            
            NSDate *now = [[NSDate alloc] init];
            
            dateString = [format stringFromDate:now];
            NSLog(@"date check%@",dateString);

            //code for fetch in timelog
            
            
            NSUInteger count;
            NSManagedObjectContext *managedObjectContext2 = [self managedObjectContext];
            NSFetchRequest *ch = [[NSFetchRequest alloc]init];
            [ch setEntity:[NSEntityDescription entityForName:@"TimeLog" inManagedObjectContext:managedObjectContext2]];
            
           
            NSArray *result = [managedObjectContext2 executeFetchRequest:ch error:nil];
            NSLog(@"%lu", (unsigned long)result.count);
            count = result.count;
            if (result.count!=0) {
                TimeLog *tim;
                tim = [result objectAtIndex:0];
                
                NSLog(@"date check%@",dateString);
                NSLog(@"tim.date check%@",tim.date);
                if (![dateString isEqualToString:tim.date]) {
                    for (NSManagedObject * res in result) {
                        [managedObjectContext2 deleteObject:res];
                    }
                    NSError *saveError = nil;
                    [managedObjectContext2 save:&saveError];
                    count = 0;
                }
                
            }
            
            
            
            
            
            NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"QRCode" inManagedObjectContext:managedObjectContext]];
            
            
            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"qr == %@ ", string]];
            NSError* error = nil;
            NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
            NSLog(@"hellooo %lu",(unsigned long)results.count);
          
            
            QRCode *qc;
            NSLog(@"check outside%d",check1);
            if ((results.count!=0)&&(check1<1)){
                _nullQrDB = 0;
                check1++;
                qc = [results objectAtIndex:0];
                NSLog(@"qrcode count  %lu", (unsigned long)results.count);
                NSLog(@"%@%@", qc.x,qc.y);
                
                // x= qc.x;
                self.Qrx =[NSString stringWithFormat:@"%@",qc.x];//@"%@",qc.x; //[qc.x integerValue];
                self.Qry =[NSString stringWithFormat:@"%@",qc.y]; //[qc.y integerValue];
                
                // y=qc.y;
                
                //code for timelog db
                NSString *qrdef = qc.def;
                
                NSManagedObjectContext *context = [self managedObjectContext];
                
                // Create a new managed object
                NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"TimeLog" inManagedObjectContext:context];
                [newDevice setValue:qrdef forKey:@"deftime"];
                
                //code for obtaining date
                
                [newDevice setValue:dateString forKey:@"date"];
                
                NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
                [format1 setDateFormat:@"hh:mm a"];
                
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
                
                
                int f = (int)count;
                f++;
                printf("%d",f);
                NSNumber *f1 = [NSNumber numberWithInt:f];
                [newDevice setValue:f1 forKey:@"slno"];NSLog(@"%@", f1);
                
                
                
            }
            
            
            
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            
            _progressView.progress = 0.0;
           
            [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];
            
            sleep(3);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"modal1" sender:self];
            });
            
        }
        
    }
    
}



@end