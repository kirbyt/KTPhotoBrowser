//
//  RootViewController.h
//  iAdSample
//
//  Created by Kirby Turner on 3/2/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <iAd/iAd.h>
#import "KTThumbsViewController.h"
#import "PhotoPickerController.h"
#import "Photos.h"


@interface RootViewController : KTThumbsViewController <PhotoPickerControllerDelegate, PhotosDelegate, MFMailComposeViewControllerDelegate, ADBannerViewDelegate>
{
   PhotoPickerController *photoPicker_;
   Photos *myPhotos_;
   UIActivityIndicatorView *activityIndicatorView_;
   UIWindow *window_;
   UIView *thumbnailView_;
   ADBannerView *bannerView_;
   BOOL bannerIsVisible_;
}

- (id)initWithWindow:(UIWindow *)window;

@end
