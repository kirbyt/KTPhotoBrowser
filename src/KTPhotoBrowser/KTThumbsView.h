//
//  KTThumbsView.h
//  Sample
//
//  Created by Kirby Turner on 3/23/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTPhotoBrowserDataSource.h"

@class KTThumbsViewController;

@interface KTThumbsView : UIScrollView {
   id <KTPhotoBrowserDataSource> dataSource_;
   KTThumbsViewController *controller_;
}

@property (nonatomic, assign) KTThumbsViewController *controller;

/**
 * Sets the local ivar for the data source. 
 * Setting the data source will cause the layoutSubviews
 * to fire.
 */
- (void)setDataSource:(id <KTPhotoBrowserDataSource>)newDataSource;

@end
