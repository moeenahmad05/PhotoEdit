//
//  PicStick
//
//  Copyright (c) 2014 AppsVilla Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end


#define isPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
@implementation ViewController
@synthesize editorVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}






- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create a view of the standard size at the bottom of the screen.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(20.0,
                                                90.0 - GAD_SIZE_728x90.height, GAD_SIZE_728x90.width, GAD_SIZE_728x90.height)];
    } else {
        bannerView_ = [[GADBannerView alloc]
                       initWithFrame:CGRectMake(0.0,
                                                50.0 -
                                                GAD_SIZE_320x50.height,
                                                GAD_SIZE_320x50.width,
                                                GAD_SIZE_320x50.height)];
    }
    // Available AdSize constants are explained in GADAdSize.h.
    
    
    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
    //Alan's iphone site
  //  bannerView_.adUnitID = @"ca-app-pub-5516145521106025/4019734793";
    
    // Let the runtime know which UIViewController to restore after taking
    // the user wherever the ad goes and add it to the view hierarchy.
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    
    // Initiate a generic request to load it with an ad
    
    GADRequest *request = [GADRequest request];
    //request.testing = YES;
    [bannerView_ loadRequest: request];
    
    
    
    //import image
    [self importLastImage];

    //lunch custom camera
//  [self launchCamera];
}



#pragma mark Buttons' Action ______


- (IBAction)sampleImage:(id)sender {
    
    NSString *xibName ;
    
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
        
        xibName = @"EditorViewController_iPad";
        
    }else {
        
        if (isPhone5) {
            
            xibName = @"EditorViewController";
            
        }else {
            
            xibName = @"EditorViewController_35";
        }
    }
    
    
    
    editorVC  = [[EditorViewController alloc]initWithNibName:xibName bundle:nil];
    editorVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:editorVC animated:YES completion:nil];
}



- (IBAction)photoLibrary:(id)sender {
    
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        ipc = [[UIImagePickerController alloc]init];
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:nil];
        
        }
    
    else {
        
        if ([pop isPopoverVisible]) {
            [pop dismissPopoverAnimated:YES];

            return;
        }
        
        ipc = [[UIImagePickerController alloc]init];
        ipc.delegate = self;
        pop = [[ UIPopoverController alloc]initWithContentViewController:ipc];
        [pop setDelegate:self];
        [pop setPopoverContentSize: CGSizeMake(320, 480)];
        CGRect rect = CGRectMake(220, 680, 320, 480);
    
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [pop presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                
            });
            
        }else {
            
               [pop presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        }
        
        
    }

    
}

bool isCamera;
- (IBAction)camera:(id)sender {
    
//    isCamera = YES;
//    [picker takePicture];
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        picker = [[UIImagePickerController alloc] init];
        [picker setDelegate:self];
        [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:picker animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your Device Doesn't Support Camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
    }

    
}


bool isFront;
- (IBAction)switchCamera:(id)sender {
    
    if ((isFront = !isFront)) {
        
        picker.cameraDevice=UIImagePickerControllerCameraDeviceFront;

    }else {
        
        isFront  = NO;
        picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
    }
   
    
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _temp.image  =   [info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:NO completion: ^ {
     [pop dismissPopoverAnimated:YES];
    
        NSString *xibName ;
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            
            xibName = @"EditorViewController_iPad";
            
        }else {
            
            if (isPhone5) {
                
                xibName = @"EditorViewController";
                
            }else {
                
                xibName = @"EditorViewController_35";
            }
        }
        
        
        editorVC  = [[EditorViewController alloc]initWithNibName:xibName bundle:nil];
        editorVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:editorVC animated:YES completion:nil];
        editorVC.blureImage.image = _temp.image;
        editorVC.img.image =  _temp.image;
        editorVC.mainVC = self;
      
    }];
   
    

 

    
}



#pragma mark  ______
#pragma mark Methods ______
-(void)importLastImage {
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // Chooses the photo at the last index
        [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:([group numberOfAssets]-1)]
                                options:0
                             usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                 
                                 // The end of the enumeration is signaled by asset == nil.
                                 if (alAsset) {
                                     ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                     latestPhoto = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                                 
                                     
                                     
                                     NSString *maskStr ;
                                     
                                       
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            
            maskStr = @"mask_pad.png";
     
        }else {
       
            if (isPhone5) {
                
                maskStr = @"mask_ph.png";
                
            }else {
             
                maskStr = @"mask_ph35.png";
            }
    }
                                     UIImage *OrigImage = latestPhoto;
                                     UIImage *mask = [UIImage imageNamed:maskStr];
                                     UIImage *maskedImage = [self maskImage:OrigImage withMask:mask];
                                     _lastPhoto.image = maskedImage;
                                                                          
                                 }else {
                          
                                 }
       }];
    }
                         failureBlock: ^(NSError *error) {
                             // Typically you should handle an error more gracefully than this.
                             NSLog(@"No groups");
                             
                             UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"No Image found" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                             [alert show];
                             
}];
    
}



//Masking LastPhotoImage
- (UIImage*) maskImage:(UIImage *)mainImage withMask:(UIImage *)maskImage {
    
    CGImageRef imageReference = mainImage.CGImage;
    CGImageRef maskReference = maskImage.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
    
}



- (void) launchCamera {
    
     if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
         
    // Set up the camera
    picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;

    picker.showsCameraControls = NO;
    picker.navigationBarHidden = YES;
    picker.toolbarHidden = YES;
    
    // animate the fade in after the shutter opens
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:2.2f];
    _cameraView.alpha = 0;
    _cameraView.alpha = 1;
    [UIView commitAnimations];
    
         _cameraView.backgroundColor = [UIColor blackColor];
    [_cameraView addSubview:picker.view];
         
     }else {
         
         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Your Device Doesn't Support Camera" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
         [alert show];
     }
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
