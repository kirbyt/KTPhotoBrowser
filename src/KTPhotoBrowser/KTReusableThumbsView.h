//
//  KTReusableThumbsView.h
//  Sample
//
//  Created by Constantine Fry on 2/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTPhotoBrowserDataSource.h"

@class KTThumbsViewController;
@interface KTReusableThumbsView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UITableView *table_; 
    id <KTPhotoBrowserDataSource> dataSource_;
    KTThumbsViewController *controller_;
    int itemsPerRow_;
    BOOL thumbsHaveBorder;
    CGFloat thumbnailWidth;
    CGFloat thumbnailHeight;
    CGSize thumbSize;
    CGSize spaceSize;
}

@property (nonatomic, assign) KTThumbsViewController *controller;

/**
 * Sets the local ivar for the data source. 
 * Setting the data source will cause the layoutSubviews
 * to fire.
 */
-(void)reload;
- (void)setDataSource:(id <KTPhotoBrowserDataSource>)newDataSource;
@end
