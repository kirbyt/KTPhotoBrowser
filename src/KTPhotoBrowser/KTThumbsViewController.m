//
//  KTThumbsViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbsViewController.h"
#import "KTPhotoScrollViewController.h"


@interface KTThumbsViewController (Private)
@end


@implementation KTThumbsViewController

@synthesize dataSource = dataSource_;

- (void)dealloc {
   [scrollView_ release], scrollView_ = nil;
   
   [super dealloc];
}

- (void)loadView {
   // Make sure to set wantsFullScreenLayout or the photo
   // will not display behind the status bar.
   [self setWantsFullScreenLayout:YES];

   UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)didFinishLoadingPhotos {
   // Do nothing by default.
}

- (void)loadPhotos {
   if ( ! dataSource_ ) {
      return;
   }
   
   int viewWidth = self.view.bounds.size.width;
   
   int thumbnailWidth = 75;
   int thumbnailHeight = 75;
   int itemsPerRow = 4;
   int spaceWidth = round((viewWidth - thumbnailWidth * itemsPerRow) / (itemsPerRow + 1));
   int spaceHeight = spaceWidth;
   
   int x = spaceWidth;
   int y = spaceHeight;
   
   // Calculate content size.
   int photoCount = [dataSource_ numberOfPhotos];
   
   int rowCount = photoCount / itemsPerRow;
   int rowHeight = thumbnailHeight + spaceHeight;
   CGSize contentSize = CGSizeMake(viewWidth, (rowHeight * (rowCount + 1)));
   [scrollView_ setContentSize:contentSize];

   [self removeAllSubviews];
   
   // Add new subviews.
   for (int i = 0; i < photoCount; i++) {
      KTThumbView *thumbView = [[KTThumbView alloc] initWithFrame:CGRectMake(x, y, thumbnailWidth, thumbnailHeight)];
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


#pragma mark -
#pragma mark WPSThumbViewDelegate
- (void)didSelectThumbAtIndex:(NSUInteger)index {
   KTPhotoScrollViewController *newController = [[KTPhotoScrollViewController alloc] 
                                                        initWithDataSource:dataSource_ 
                                                  andStartWithPhotoAtIndex:index];
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   [newController setNavigationBarStyle:[navbar barStyle]];
   [newController setTranslucent:[navbar isTranslucent]];
   
   BOOL isStatusbarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
   [newController setStatusbarHidden:isStatusbarHidden];
   
   [[self navigationController] pushViewController:newController animated:YES];
   [newController release];
}

@end
