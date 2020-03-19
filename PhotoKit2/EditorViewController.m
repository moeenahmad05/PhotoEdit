//
//  PicStick
//
//  Copyright (c) 2014 AppsVilla Inc. All rights reserved.
//

#import "EditorViewController.h"
#import "FXBlurView.h"
#import "PECropViewController.h"
#import "GADInterstitial.h"


#define isPhone5 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define ORIGINAL_MAX_WIDTH 612.0f


@interface EditorViewController () 
@property(nonatomic, strong) GADInterstitial *interstitial;
@end

@implementation EditorViewController
@synthesize mainVC;


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
    
    self.interstitial = [[GADInterstitial alloc] init];
 //   self.interstitial.adUnitID = @"ca-app-pub-9182552420942246/8100514015";
    self.interstitial.delegate = self;
    [self.interstitial loadRequest:[GADRequest request]];
    
    // Assumes an image named "SplashImage" exists.
    //self.imageView = [[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"SplashImage"]];
    //self.imageView.frame = self.view.frame;
    //self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    //[self.view addSubview:self.imageView];


    

    //setup Blur Background (FXBlurView):
    _blurView.backgroundColor = [UIColor clearColor];
    _blurView.tintColor = [UIColor clearColor];
    _blurView.dynamic = YES;
   
}

- (IBAction)openImageEditor:(id)sender {
    
    [self displayEditorForImage:_img.image];
}

/**
 * Ad Placement
 */

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial {
    [self.interstitial presentFromRootViewController:self];
}

- (void)interstitial:(GADInterstitial *)interstitial
didFailToReceiveAdWithError:(GADRequestError *)error {
 //   [self.imageView removeFromSuperview];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)interstitial {
  //  [self.imageView removeFromSuperview];
}

//#warning PLEASE PROVIDE API KEY AND SECRET (API_KEY.h) _ Remove this line if you provide KEY and SECRET .

- (void)displayEditorForImage:(UIImage *)imageToEdit
{
    // kAviaryAPIKey and kAviarySecret are developer defined
    // and contain your API key and secret respectively
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [AFPhotoEditorController setAPIKey:KEY secret:SECRET];
    });
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:imageToEdit];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}




- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    [_blureImage setImage:image];
    [_img setImage:image];

    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (IBAction)shareImage:(id)sender {
    
   sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Instagram",@"Save Image", nil];

    [sheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    

    switch (buttonIndex) {
        case 0:

            
            [self instagram];
            break;
            
        case 1:
    

            [self saveAndSocial];
        default:
            break;
    }
}



- (void)instagram {
    
    
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = _img.image;
    
    
    CGSize size = _img.image.size;

    controller.image  =  [self imageByScalingAndCroppingForSourceImage:controller.image targetSize:size];
    
    CGFloat width = controller.image.size.width;
    CGFloat height = controller.image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];

}




- (void)saveAndSocial {
    
    NSArray* dataToShare = @[_img.image];
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                      applicationActivities:nil];

    

    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    }
    
    else {
        
        
        if ([pop isPopoverVisible]) {
            [pop dismissPopoverAnimated:YES];
            [sheet dismissWithClickedButtonIndex:1 animated:YES];
            
            return;
        }
        
        pop = [[ UIPopoverController alloc]initWithContentViewController:activityViewController];
        [pop setDelegate:self];
        [pop setPopoverContentSize: CGSizeMake(320, 480)];
        CGRect rect = CGRectMake(220, 850, 320, 480);
        
        
        
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



- (IBAction)backToMain:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark New Photo copping

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    
   
    
    [controller dismissViewControllerAnimated:YES completion:^ {
        
        
        
        
        NSURL *instagramURL = [NSURL URLWithString:@"instagram://location?id=1"];
        
        if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
            
            NSURL *url;
            docFile.delegate = self;
            
            
            
            //Save image to directory
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
            
            
            NSData *imageData = UIImagePNGRepresentation(croppedImage);
            
            [imageData writeToFile:savedImagePath atomically:NO];
            
            //load image
            NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.jpg"];
            UIImage *tempImage = [UIImage imageWithContentsOfFile:getImagePath];
            
            
            //Hook it with Instagram
            NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Image.ig"];
            [UIImageJPEGRepresentation(tempImage, 1.0) writeToFile:jpgPath atomically:YES];
            
            
            
            url = [[NSURL alloc] initFileURLWithPath:jpgPath];
            docFile = [UIDocumentInteractionController interactionControllerWithURL:url];
            [docFile setUTI:@"com.instagram.photo"];
            docFile.annotation = @{@"InstagramCaption" : @" #PicStick" };

           
        if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPad) {
            
             [docFile presentOpenInMenuFromRect:CGRectMake(350, 840, 320, 480) inView:self.view animated:YES];
            
        } else {
            
            [docFile presentOpenInMenuFromRect:self.view.bounds inView:self.view animated:YES];
            
        }
            
        }else {
            
            UIAlertView *errorToShare = [[UIAlertView alloc] initWithTitle:@"Instagram unavailable " message:@"You need to install Instagram" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [errorToShare show];
            
        }
        
        
    }];
    
    
    
    
    
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
   
    [controller dismissViewControllerAnimated:YES completion:NULL];
}





#pragma mark image scale utility


- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}





- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}




@end
