//
//  PicStick
//
//  Copyright (c) 2014 AppsVilla Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>
#import "GADBannerView.h"
#import "EditorViewController.h"

@class EditorViewController;
@interface ViewController : UIViewController <UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIPopoverControllerDelegate>
{

    GADBannerView *bannerView_;
    UIImagePickerController *picker;
    UIImage *latestPhoto;
    
    UIImagePickerController * ipc;
    UIPopoverController *pop;
    
    EditorViewController *editorVC;
}

@property (strong, nonatomic)EditorViewController *editorVC;

@property (strong, nonatomic) IBOutlet UIImageView *lastPhoto;
@property (strong, nonatomic) IBOutlet UIView *cameraView;
@property (strong, nonatomic) IBOutlet UIImageView *temp;

@end
