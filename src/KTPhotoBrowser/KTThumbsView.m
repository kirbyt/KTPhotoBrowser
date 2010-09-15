//
//  KTThumbsView.m
//  Sample
//
//  Created by Kirby Turner on 3/23/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbsView.h"
#import "KTThumbView.h"
#import "KTThumbsViewController.h"


@implementation KTThumbsView

@synthesize controller = controller_;

- (void)setDataSource:(id <KTPhotoBrowserDataSource>)newDataSource {
   dataSource_ = newDataSource;
   [self setNeedsLayout];
}

- (void)removeAllSubviews {
   int count = [[self subviews] count];
   for (int i = count; i > 0; i--) {
      UIView *subview = [[self subviews] objectAtIndex:i - 1];
      [subview removeFromSuperview];
   }
}

- (void)layoutSubviews {
   if ( ! dataSource_ ) {
      return;
   }
   
   if (controller_) {
      [controller_ willLoadThumbs];
   }
   
   int viewWidth = self.bounds.size.width;
   int viewHeight = self.bounds.size.height;
   
   int thumbnailWidth = 75;
   int thumbnailHeight = 75;
   
   if ([dataSource_ respondsToSelector:@selector(thumbSize)]) {
      CGSize customThumbSize = [dataSource_ thumbSize];
      thumbnailWidth = customThumbSize.width;
      thumbnailHeight = customThumbSize.height;
   }
   
   int itemsPerRow;
   if ([dataSource_ respondsToSelector:@selector(thumbsPerRow)]) {
      itemsPerRow = [dataSource_ thumbsPerRow];
   } else {  // Figure it out.
      itemsPerRow = floor(viewWidth / thumbnailWidth);
   }
   
   // Ensure a minimum of space between images.
   int minimumSpace = 5;
   if (viewWidth - itemsPerRow * thumbnailWidth < minimumSpace) {
     itemsPerRow--;
   }
   
   if (itemsPerRow < 1) itemsPerRow = 1;  // Ensure at least one per row.
   
   int spaceWidth = round((viewWidth - thumbnailWidth * itemsPerRow) / (itemsPerRow + 1));
   int spaceHeight = spaceWidth;
   
   // Calculate content size.
   int photoCount = [dataSource_ numberOfPhotos];
   
   int rowCount = ceil(photoCount / (float)itemsPerRow);
   int rowHeight = thumbnailHeight + spaceHeight;
   CGSize contentSize = CGSizeMake(viewWidth, (rowHeight * rowCount + spaceHeight));
   
   [self setContentSize:contentSize];
   
   [self removeAllSubviews];
   
   BOOL thumbsHaveBorder = YES;
   if ([dataSource_ respondsToSelector:@selector(thumbsHaveBorder)]) {
      thumbsHaveBorder = [dataSource_ thumbsHaveBorder];
   }
   
   NSInteger rowsPerView = viewHeight / rowHeight;
   NSInteger topRow = self.contentOffset.y / rowHeight;
   NSInteger bottomRow = topRow + rowsPerView;
   
   NSInteger startAtIndex = topRow * itemsPerRow;
   NSInteger stopAtIndex = (bottomRow * itemsPerRow) + itemsPerRow;
   if (stopAtIndex > photoCount) stopAtIndex = photoCount;
   
   int x = spaceWidth;
   int y = spaceHeight + (topRow * rowHeight);
   
   // Add new subviews.
   for (int i = startAtIndex; i < stopAtIndex; i++) {
      if (i >= 0) {
         KTThumbView *thumbView = [[KTThumbView alloc] initWithFrame:CGRectMake(x, y, thumbnailWidth, thumbnailHeight) andHasBorder:thumbsHaveBorder];
         [thumbView setController:controller_];
         [thumbView setTag:i];
         
         if ([dataSource_ respondsToSelector:@selector(thumbImageAtIndex:thumbView:)] == NO) {
            UIImage *thumbImage = [dataSource_ thumbImageAtIndex:i];
            [thumbView setThumbImage:thumbImage];
         } else {
            [dataSource_ thumbImageAtIndex:i thumbView:thumbView];
         }
         
         
         [self addSubview:thumbView];
         [thumbView release];
      }
      
      // Adjust the position.
      if ( (i+1) % itemsPerRow == 0) {
         // Start new row.
         x = spaceWidth;
         y += thumbnailHeight + spaceHeight;
      } else {
         x += thumbnailWidth + spaceWidth;
      }
   }
   
   if (controller_) {
      [controller_ didLoadThumbs];
   }
}

@end
