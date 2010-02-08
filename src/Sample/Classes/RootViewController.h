//
//  RootViewController.h
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTPhotoBrowserDataSource.h"
#import "PhotoPickerController.h"
#import "KTThumbsViewController.h"


@protocol KTPhotoBrowserDataSource;
@protocol PhotoPickerControllerDelegate;
@class PhotoPickerController;

@interface RootViewController : KTThumbsViewController <KTPhotoBrowserDataSource, PhotoPickerControllerDelegate> {
   PhotoPickerController *photoPicker_;
   NSMutableArray *photos_;
   NSString *documentPath_;
}

@end
