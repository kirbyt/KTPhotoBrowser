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


@class Photos;

@interface RootViewController : KTThumbsViewController <PhotoPickerControllerDelegate> {
   PhotoPickerController *photoPicker_;
   Photos *myPhotos_;
}

@end
