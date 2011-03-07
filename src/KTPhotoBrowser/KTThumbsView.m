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

@synthesize dataSource = dataSource_;
@synthesize controller = controller_;

- (void)dealloc
{
   [reusableThumbViews_ release], reusableThumbViews_ = nil;
   [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      // We keep a collection of reusable thumbnail
      // views. This improves performance by not
      // requiring a create view each and every time.
      reusableThumbViews_ = [[NSMutableSet alloc] init];
      
      // No thumbnail views are visible at first; note this by
      // making the firsts very high and the lasts very low
      firstVisibleIndex_ = NSIntegerMax;
      lastVisibleIndex_  = NSIntegerMin;
      
      // We are the scrollview delegate because we
      // need to control the content layout during
      // scrolling.
      [self setDelegate:self];
   }
   return self;
}

//- (void)queueNonVisibleSubviews
//{
//   if (!reusableThumbViews_) {
//      reusableThumbViews_ = [[NSMutableSet alloc] init];
//   }
//   
//   int count = [[self subviews] count];
//   for (int i = count; i > 0; i--) {
//      UIView *subview = [[self subviews] objectAtIndex:i - 1];
//      if ([subview isKindOfClass:[KTThumbView class]]) {
//         
//         CGRect rect = [subview convertRect:[subview frame] toView:[self superview]];
//         NSLog(@"rect=(%f, %f, %f, %f)", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
//         BOOL offscreen = ((rect.origin.y < 0) || (rect.origin.y > [self frame].size.height));
//         if (offscreen) {
//            NSLog(@"Off screen. Queue view for reuse.");
//            // Queue the subview.
//            [reusableThumbViews_ addObject:[subview retain]];
//            [subview removeFromSuperview];
//         }
//         
//         //&& !CGRectContainsPoint([subview frame], [self contentOffset])) {
//      }
//   }
//}

- (KTThumbView *)dequeueReusableThumbView
{
   KTThumbView *thumbView = [reusableThumbViews_ anyObject];
   if (thumbView != nil) {
      // The only object retaining the view is the
      // reusableThumbViews set, so we retain/autorelease
      // it before returning it so that it's not immediately
      // deallocated when removed form the set.
      [[thumbView retain] autorelease];
      [reusableThumbViews_ removeObject:thumbView];
   }
   return thumbView;
}

- (void)reloadData
{
   for (UIView *view in [self subviews]) {
      if ([view isKindOfClass:[KTThumbView class]]) {
         [reusableThumbViews_ addObject:view];
      }
      [view removeFromSuperview];
   }
   
   firstVisibleIndex_ = NSIntegerMax;
   lastVisibleIndex_  = NSIntegerMin;
   
   [self setNeedsLayout];
}

- (void)layoutSubviews 
{
   [super layoutSubviews];

   CGRect visibleBounds = [self bounds];
   int viewWidth = visibleBounds.size.width;
   int viewHeight = visibleBounds.size.height;
   
   // first recycle all thumb views that are no longer visible
   for (UIView *view in [self subviews]) {
      
      if ([view isKindOfClass:[KTThumbView class]]) {
         // We want to see if the view intersect the scrollView's 
         // bounds, so we need to convert their frames to our own 
         // coordinate system.
         CGRect viewFrame = [view convertRect:[view frame] toView:self];
         
         // If the view doesn't intersect, it's not visible, so we can recycle it
         if (! CGRectIntersectsRect(viewFrame, visibleBounds)) {
            [reusableThumbViews_ addObject:view];
            [view removeFromSuperview];
         }
      }
   }
   
   // Do a bunch of math to determine which rows and colums
   // are visible.

   int thumbnailWidth = 75;   // Default thumbnail size.
   int thumbnailHeight = 75;  // Default thumbnail size.
   if ([dataSource_ respondsToSelector:@selector(thumbsViewThumbSize:)]) {
      CGSize customThumbSize = [dataSource_ thumbsViewThumbSize:self];
      thumbnailWidth = customThumbSize.width;
      thumbnailHeight = customThumbSize.height;
   }

   int itemsPerRow;
   if ([dataSource_ respondsToSelector:@selector(thumbsViewThumbsPerRow:)]) {
      itemsPerRow = [dataSource_ thumbsViewThumbsPerRow:self];
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
   int thumbCount = [dataSource_ thumbsViewNumberOfThumbs:self];
   int rowCount = ceil(thumbCount / (float)itemsPerRow);
   int rowHeight = thumbnailHeight + spaceHeight;
   CGSize contentSize = CGSizeMake(viewWidth, (rowHeight * rowCount + spaceHeight));
   [self setContentSize:contentSize];
   
   NSInteger rowsPerView = viewHeight / rowHeight;
   NSInteger topRow = visibleBounds.origin.y / rowHeight;
   NSInteger bottomRow = topRow + rowsPerView;
   
   NSInteger startAtIndex = MAX(0, topRow * itemsPerRow);
   NSInteger stopAtIndex = MIN(thumbCount, (bottomRow * itemsPerRow) + itemsPerRow);

   // Set our initial origin.
   int x = spaceWidth;
   int y = spaceHeight + (topRow * rowHeight);
   
   // Iterate through the needed thumbnail views adding
   // any views that are missing.
   for (int index = startAtIndex; index < stopAtIndex; index++) {
      BOOL isThumbViewMissing = (firstVisibleIndex_ > index || lastVisibleIndex_ < index);

      if (isThumbViewMissing) {
         KTThumbView *thumbView = [dataSource_ thumbsView:self thumbForIndex:index];

         // Set the frame so the view is inserted into the correct position.
         CGRect newFrame = CGRectMake(x, y, thumbnailWidth, thumbnailHeight);
         [thumbView setFrame:newFrame];
         
         // Store the current index so the thumb view can 
         // find it later.
         [thumbView setTag:index];
         
         [self addSubview:thumbView];
      }
      
      // Adjust the position.
      if ( (index+1) % itemsPerRow == 0) {
         // Start new row.
         x = spaceWidth;
         y += thumbnailHeight + spaceHeight;
      } else {
         x += thumbnailWidth + spaceWidth;
      }
   }
   
   // Remember which thumb view indexes are visible.
   firstVisibleIndex_ = startAtIndex;
   lastVisibleIndex_  = stopAtIndex;
   
   
//   if ( ! dataSource_ ) {
//      return;
//   }
//
//   if (controller_) {
//      [controller_ willLoadThumbs];
//   }
//   
//   int viewWidth = self.bounds.size.width;
//   int viewHeight = self.bounds.size.height;
//   
//   int thumbnailWidth = 75;
//   int thumbnailHeight = 75;
//   
//   if ([dataSource_ respondsToSelector:@selector(thumbSize)]) {
//      CGSize customThumbSize = [dataSource_ thumbSize];
//      thumbnailWidth = customThumbSize.width;
//      thumbnailHeight = customThumbSize.height;
//   }
//   
//   int itemsPerRow;
//   if ([dataSource_ respondsToSelector:@selector(thumbsPerRow)]) {
//      itemsPerRow = [dataSource_ thumbsPerRow];
//   } else {  // Figure it out.
//      itemsPerRow = floor(viewWidth / thumbnailWidth);
//   }
//   
//   // Ensure a minimum of space between images.
//   int minimumSpace = 5;
//   if (viewWidth - itemsPerRow * thumbnailWidth < minimumSpace) {
//     itemsPerRow--;
//   }
//   
//   if (itemsPerRow < 1) itemsPerRow = 1;  // Ensure at least one per row.
//   
//   int spaceWidth = round((viewWidth - thumbnailWidth * itemsPerRow) / (itemsPerRow + 1));
//   int spaceHeight = spaceWidth;
//   
//   // Calculate content size.
//   int photoCount = [dataSource_ numberOfPhotos];
//   
//   int rowCount = ceil(photoCount / (float)itemsPerRow);
//   int rowHeight = thumbnailHeight + spaceHeight;
//   CGSize contentSize = CGSizeMake(viewWidth, (rowHeight * rowCount + spaceHeight));
//   
//   [self setContentSize:contentSize];
//   
//   [self queueNonVisibleSubviews];
//   
//   BOOL thumbsHaveBorder = YES;
//   if ([dataSource_ respondsToSelector:@selector(thumbsHaveBorder)]) {
//      thumbsHaveBorder = [dataSource_ thumbsHaveBorder];
//   }
//   
//   NSInteger rowsPerView = viewHeight / rowHeight;
//   NSInteger topRow = self.contentOffset.y / rowHeight;
//   NSInteger bottomRow = topRow + rowsPerView;
//   
//   NSInteger startAtIndex = topRow * itemsPerRow;
//   NSInteger stopAtIndex = (bottomRow * itemsPerRow) + itemsPerRow;
//   if (stopAtIndex > photoCount) stopAtIndex = photoCount;
//   
//   int x = spaceWidth;
//   int y = spaceHeight + (topRow * rowHeight);
//   
//   
//   // Add new subviews.
//   for (int i = startAtIndex; i < stopAtIndex; i++) {
//      if (i >= 0) {
//         KTThumbView *thumbView = [self dequeueReusableThumbView];
//         if (!thumbView) {
//            thumbView = [[KTThumbView alloc] initWithFrame:CGRectMake(x, y, thumbnailWidth, thumbnailHeight) andHasBorder:thumbsHaveBorder];
//            [thumbView setController:controller_];
//            NSLog(@"Create new thumb view");
//         } else {
//            NSLog(@"Reuse thumb view");
//         }
//         
//         CGRect newFrame = [thumbView frame];
//         newFrame.origin.x = x;
//         newFrame.origin.y = y;
//         [thumbView setFrame:newFrame];
//         
//         [thumbView setTag:i];
//         
//         if ([dataSource_ respondsToSelector:@selector(thumbImageAtIndex:thumbView:)] == NO) {
//            UIImage *thumbImage = [dataSource_ thumbImageAtIndex:i];
//            [thumbView setThumbImage:thumbImage];
//         } else {
//            [dataSource_ thumbImageAtIndex:i thumbView:thumbView];
//         }
//         
//         
//         [self addSubview:thumbView];
//         [thumbView release];
//      }
//      
//      // Adjust the position.
//      if ( (i+1) % itemsPerRow == 0) {
//         // Start new row.
//         x = spaceWidth;
//         y += thumbnailHeight + spaceHeight;
//      } else {
//         x += thumbnailWidth + spaceWidth;
//      }
//   }
//   
//   if (controller_) {
//      [controller_ didLoadThumbs];
//   }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//   CGPoint newContentOffset = [scrollView contentOffset];
//   NSLog(@"Previous content offset=(%f, %f) New content offset=(%f, %f)", previousContentOffset_.x, previousContentOffset_.y, newContentOffset.x, newContentOffset.y);
//   previousContentOffset_ = newContentOffset;
}

@end
