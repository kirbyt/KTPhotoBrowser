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

@class KTThumbsView;

@interface KTThumbsViewController : UIViewController <KTThumbViewDelegate> {
  id <KTPhotoBrowserDataSource> dataSource_;
  KTThumbsView *scrollView_;
  BOOL viewDidAppearOnce_;
  BOOL navbarWasTranslucent_;
}

@property (nonatomic, retain) id <KTPhotoBrowserDataSource> dataSource;

/**
 * Re-displays the thumbnail images.
 */
- (void)reloadThumbs;

/**
 * Called after loadPhotos completed. Does nothing by default.
 */
- (void)didFinishLoadingPhotos;

@end
