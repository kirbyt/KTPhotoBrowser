//
//  KTThumbsViewController.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTPhotoBrowserDataSource.h"
#import "KTThumbView.h"


@interface KTThumbsViewController : UIViewController <KTThumbViewDelegate> {
  id <KTPhotoBrowserDataSource> dataSource_;
  UIScrollView *scrollView_;
  UIColor *photoBackgroundColor_;
  BOOL viewDidAppearOnce_;
  BOOL navbarWasTranslucent_;
}

@property (nonatomic, assign) id <KTPhotoBrowserDataSource> dataSource;
@property (nonatomic, retain) UIColor *photoBackgroundColor;

/**
 * Loads the photos for display.
 */
- (void)loadPhotos;

/**
 * Called after loadPhotos completed. Does nothing by default.
 */
- (void)didFinishLoadingPhotos;

/**
 * Removes all subviews from the scroll view. Used to remove thumbnail photos.
 */
- (void)removeAllSubviews;

@end
