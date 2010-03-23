//
//  KTThumbsView.m
//  Sample
//
//  Created by Kirby Turner on 3/23/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbsView.h"
#import "KTThumbView.h"


@implementation KTThumbsView

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
   
   int viewWidth = self.bounds.size.width;
   
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
   
   if (itemsPerRow < 1) itemsPerRow = 1;  // Ensure at least one per row.
   
   int spaceWidth = round((viewWidth - thumbnailWidth * itemsPerRow) / (itemsPerRow + 1));
   int spaceHeight = spaceWidth;
   
   int x = spaceWidth;
   int y = spaceHeight;
   
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
   
   // Add new subviews.
   for (int i = 0; i < photoCount; i++) {
      KTThumbView *thumbView = [[KTThumbView alloc] initWithFrame:CGRectMake(x, y, thumbnailWidth, thumbnailHeight) andHasBorder:thumbsHaveBorder];
      [thumbView setDelegate:self];
      [thumbView setTag:i];
      
      if ([dataSource_ respondsToSelector:@selector(thumbImageAtIndex:thumbView:)] == NO) {
         UIImage *thumbImage = [dataSource_ thumbImageAtIndex:i];
         [thumbView setThumbImage:thumbImage];
      } else {
         [dataSource_ thumbImageAtIndex:i thumbView:thumbView];
      }
      
      
      [self addSubview:thumbView];
      [thumbView release];
      
      // Adjust the position.
      if ( (i+1) % itemsPerRow == 0) {
         // Start new row.
         x = spaceWidth;
         y += thumbnailHeight + spaceHeight;
      } else {
         x += thumbnailWidth + spaceWidth;
      }
   }
//   [self didFinishLoadingPhotos];
}

@end
