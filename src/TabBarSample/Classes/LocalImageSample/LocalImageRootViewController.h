//
//  RootViewController.h
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"
#import "PhotoPickerController.h"
#import "Photos.h"


@class Photos;

@interface LocalImageRootViewController : KTThumbsViewController <PhotoPickerControllerDelegate, PhotosDelegate> {
   PhotoPickerController *photoPicker_;
   Photos *myPhotos_;
   UIActivityIndicatorView *activityIndicatorView_;
   UIWindow *window_;
}

- (id)initWithWindow:(UIWindow *)window;

@end
