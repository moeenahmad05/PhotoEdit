//
//  PicStick
//
//  Copyright (c) 2014 AppsVilla Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import "ViewController.h"
#import "PECropViewController.h"
#import <AviarySDK/AviarySDK.h>
#import "API_KEY.h"
#import "GADBannerView.h"

@class ViewController;
@interface EditorViewController : UIViewController <AFPhotoEditorControllerDelegate , UINavigationBarDelegate , UINavigationControllerDelegate ,UIActionSheetDelegate ,PECropViewControllerDelegate , UIDocumentInteractionControllerDelegate , UIPopoverControllerDelegate>{
    
       GADBannerView *bannerView_;
    ViewController *mainVC;
           UIDocumentInteractionController *docFile;
      UIPopoverController *pop;
    
    UIActionSheet *sheet;
}


@property (strong, nonatomic)ViewController *mainVC;
@property (strong, nonatomic) IBOutlet UIImageView *img;
@property (strong, nonatomic) IBOutlet UIImageView *blureImage;
@property (strong, nonatomic) IBOutlet FXBlurView *blurView;

@end
