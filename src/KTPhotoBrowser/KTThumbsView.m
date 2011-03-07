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
@synthesize thumbsHaveBorder = thumbsHaveBorder_;
@synthesize thumbsPerRow = thumbsPerRow_;
@synthesize thumbSize = thumbSize_;

- (void)dealloc
{
   [reusableThumbViews_ release], reusableThumbViews_ = nil;
   [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      // Set default values.
      thumbsHaveBorder_ = YES;
      thumbsPerRow_ = NSIntegerMin; // Forces caluation because on view size.
      thumbSize_ = CGSizeMake(75, 75);
      
      // We keep a collection of reusable thumbnail
      // views. This improves performance by not
      // requiring a create view each and every time.
      reusableThumbViews_ = [[NSMutableSet alloc] init];
      
      // No thumbnail views are visible at first; note this by
      // making the firsts very high and the lasts very low
      firstVisibleIndex_ = NSIntegerMax;
      lastVisibleIndex_  = NSIntegerMin;
      lastItemsPerRow_   = NSIntegerMin;
   }
   return self;
}

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

- (void)queueReusableThumbViews
{
   for (UIView *view in [self subviews]) {
      if ([view isKindOfClass:[KTThumbView class]]) {
         [reusableThumbViews_ addObject:view];
         [view removeFromSuperview];
      }
   }
   
   firstVisibleIndex_ = NSIntegerMax;
   lastVisibleIndex_  = NSIntegerMin;
}

- (void)reloadData
{
   [self queueReusableThumbViews];
   [self setNeedsLayout];
}

- (void)layoutSubviews 
{
   [super layoutSubviews];

   CGRect visibleBounds = [self bounds];
   int visibleWidth = visibleBounds.size.width;
   int visibleHeight = visibleBounds.size.height;
   
   // Do a bunch of math to determine which rows and colums
   // are visible.

   int itemsPerRow = thumbsPerRow_;
   if (itemsPerRow == NSIntegerMin) {
      itemsPerRow = floor(visibleWidth / thumbSize_.width);
   }
   if (itemsPerRow != lastItemsPerRow_) {
      // Force re-load of grid cells. Unfortunately this means
      // visible cells will reload, which can hurt performance
      // when the thumbnail image isn't cached. Need to find a
      // better approach.
      [self queueReusableThumbViews];
   }
   lastItemsPerRow_ = itemsPerRow;
   
   // Ensure a minimum of space between images.
   int minimumSpace = 5;
   if (visibleWidth - itemsPerRow * thumbSize_.width < minimumSpace) {
     itemsPerRow--;
   }
   
   if (itemsPerRow < 1) itemsPerRow = 1;  // Ensure at least one per row.
   
   int spaceWidth = round((visibleWidth - thumbSize_.width * itemsPerRow) / (itemsPerRow + 1));
   int spaceHeight = spaceWidth;
   
   // Calculate content size.
   int thumbCount = [dataSource_ thumbsViewNumberOfThumbs:self];
   int rowCount = ceil(thumbCount / (float)itemsPerRow);
   int rowHeight = thumbSize_.height + spaceHeight;
   CGSize contentSize = CGSizeMake(visibleWidth, (rowHeight * rowCount + spaceHeight));
   [self setContentSize:contentSize];
   
   NSInteger rowsPerView = visibleHeight / rowHeight;
   NSInteger topRow = MAX(0, floorf(visibleBounds.origin.y / rowHeight));
   NSInteger bottomRow = topRow + rowsPerView;

   
   CGRect extendedVisibleBounds = CGRectMake(visibleBounds.origin.x, MAX(0, visibleBounds.origin.y), visibleBounds.size.width, visibleBounds.size.height + rowHeight);
   
   // Recycle all thumb views that are no longer visible
   for (UIView *view in [self subviews]) {
      
      if ([view isKindOfClass:[KTThumbView class]]) {
         // We want to see if the view intersect the scrollView's 
         // bounds, so we need to convert their frames to our own 
         // coordinate system.
         CGRect viewFrame = [view frame];
         
         // If the view doesn't intersect, it's not visible, so we can recycle it
         if (! CGRectIntersectsRect(viewFrame, extendedVisibleBounds)) {
            [reusableThumbViews_ addObject:view];
            [view removeFromSuperview];
         }
      }
   }
      
   
   NSInteger startAtIndex = MAX(0, topRow * itemsPerRow);
   NSInteger stopAtIndex = MIN(thumbCount, (bottomRow * itemsPerRow) + itemsPerRow);

   // Set our initial origin.
   int x = spaceWidth;
   int y = spaceHeight + (topRow * rowHeight);
   
   // Iterate through the needed thumbnail views adding
   // any views that are missing.
   for (int index = startAtIndex; index < stopAtIndex; index++) {
      // If index is between first and last, then not missing.
      BOOL isThumbViewMissing = !(index >= firstVisibleIndex_ && index < lastVisibleIndex_);

      if (isThumbViewMissing) {
         KTThumbView *thumbView = [dataSource_ thumbsView:self thumbForIndex:index];

         // Set the frame so the view is inserted into the correct position.
         CGRect newFrame = CGRectMake(x, y, thumbSize_.width, thumbSize_.height);
         [thumbView setFrame:newFrame];

         // Store the current index so the thumb view can 
         // find it later.
         [thumbView setTag:index];
         
         [thumbView setHasBorder:thumbsHaveBorder_];
         
         [self addSubview:thumbView];
      }

      
      // Adjust the position.
      if ( (index+1) % itemsPerRow == 0) {
         // Start new row.
         x = spaceWidth;
         y += thumbSize_.height + spaceHeight;
      } else {
         x += thumbSize_.width + spaceWidth;
      }
   }
   
   // Remember which thumb view indexes are visible.
   firstVisibleIndex_ = startAtIndex;
   lastVisibleIndex_  = stopAtIndex;
}


@end
