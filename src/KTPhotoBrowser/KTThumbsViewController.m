//
//  KTThumbsViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbsViewController.h"
#import "KTThumbsView.h"
#import "KTPhotoScrollViewController.h"


@interface KTThumbsViewController (Private)
@end


@implementation KTThumbsViewController

@synthesize dataSource = dataSource_;

- (void)dealloc {
   [scrollView_ release], scrollView_ = nil;
   [dataSource_ release], dataSource_ = nil;
   
   [super dealloc];
}

- (void)loadView {
   // Make sure to set wantsFullScreenLayout or the photo
   // will not display behind the status bar.
   [self setWantsFullScreenLayout:YES];

   KTThumbsView *scrollView = [[KTThumbsView alloc] initWithFrame:CGRectZero];
   [scrollView setScrollsToTop:YES];
   [scrollView setScrollEnabled:YES];
   [scrollView setBackgroundColor:[UIColor whiteColor]];
   
   // Set main view to the scroll view.
   [self setView:scrollView];
   
   // Retain a reference to the scroll view.
   scrollView_ = scrollView;
   [scrollView_ retain];
   
   // Release the local scroll view reference.
   [scrollView release];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
  // The first time the view appears, store away the current translucency so we can reset on pop.
  UINavigationBar *navbar = [[self navigationController] navigationBar];
  if (!viewDidAppearOnce_) {
    viewDidAppearOnce_ = YES;
    navbarWasTranslucent_ = [navbar isTranslucent];
  }
  // Then ensure translucency to match the look of Apple's Photos app.
  [navbar setTranslucent:YES];
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  // Restore old translucency when we pop this controller.
  UINavigationBar *navbar = [[self navigationController] navigationBar];
  [navbar setTranslucent:navbarWasTranslucent_];
  [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//   [self loadPhotos];
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return YES;
}

- (void)didFinishLoadingPhotos {
   // Do nothing by default.
}

- (void)loadPhotos {
   return;
   if ( ! dataSource_ ) {
      return;
   }
  
   int viewWidth = self.view.bounds.size.width;
   
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
  
   [scrollView_ setContentSize:contentSize];

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


      [scrollView_ addSubview:thumbView];
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
   [self didFinishLoadingPhotos];
}

- (void)removeAllSubviews {
   int count = [[scrollView_ subviews] count];
   for (int i = count; i > 0; i--) {
      UIView *subview = [[scrollView_ subviews] objectAtIndex:i - 1];
      [subview removeFromSuperview];
   }
}

- (void)setDataSource:(id <KTPhotoBrowserDataSource>)newDataSource {
   dataSource_ = newDataSource;
   [scrollView_ setDataSource:newDataSource];
}


#pragma mark -
#pragma mark WPSThumbViewDelegate
- (void)didSelectThumbAtIndex:(NSUInteger)index {
   KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc] 
                                                        initWithDataSource:dataSource_ 
                                                  andStartWithPhotoAtIndex:index];
  
   [[self navigationController] pushViewController:newController animated:YES];
   [newController release];
}

@end
