//
//  KTThumbsView.h
//  Sample
//
//  Created by Kirby Turner on 3/23/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTThumbsViewDataSource;
@class KTThumbsViewController;
@class KTThumbView;

@interface KTThumbsView : UIScrollView <UIScrollViewDelegate>
{
@private
   id <KTThumbsViewDataSource> dataSource_;
   KTThumbsViewController *controller_;
   NSMutableSet *reusableThumbViews_;
   
   // We use the following ivars to keep track of 
   // which thumbnail view indexes are visible.
   int firstVisibleIndex_;
   int lastVisibleIndex_;
}

@property (nonatomic, assign) id<KTThumbsViewDataSource> dataSource;
@property (nonatomic, assign) KTThumbsViewController *controller;

- (KTThumbView *)dequeueReusableThumbView;
- (void)reloadData;

@end

@protocol KTThumbsViewDataSource <NSObject>
@required
- (NSInteger)thumbsViewNumberOfThumbs:(KTThumbsView *)thumbsView;
- (KTThumbView *)thumbsView:(KTThumbsView *)thumbsView thumbForIndex:(NSInteger)index;
@optional
- (CGSize)thumbsViewThumbSize:(KTThumbsView *)thumbsView;
- (NSInteger)thumbsViewThumbsPerRow:(KTThumbsView *)thumbsView;

@end
