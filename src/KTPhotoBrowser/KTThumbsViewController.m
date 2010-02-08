//
//  WPSThumbsViewController.m
//  HelloBaby
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
   UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
   [scrollView setScrollsToTop:YES];
   [scrollView setScrollEnabled:YES];
   
   
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

- (void)loadPhotos {
   if ( ! dataSource_ ) {
      return;
   }
   
   int thumbnailWidth = 75;
   int thumbnailHeight = 75;
   int spaceWidth = 4;
   int spaceHeight = 4;
   
   int x = spaceWidth;
   int y = spaceHeight;
   
   int itemsPerRow = 4;
   
   // Calculate content size.
   int photoCount = [dataSource_ numberOfPhotos];
   
   int rowCount = photoCount / itemsPerRow;
   int rowHeight = thumbnailHeight + spaceHeight;
   CGSize contentSize = CGSizeMake(320, (rowHeight * (rowCount + 1)));
   [scrollView_ setContentSize:contentSize];
   
   
   for(int i=0; i < photoCount; i++) {
      KTThumbView *thumbView = [[KTThumbView alloc] initWithFrame:CGRectMake(x, y, thumbnailWidth, thumbnailHeight)];
      [thumbView setDelegate:self];
      [thumbView setTag:i];
      
      UIImage *thumbImage = [dataSource_ thumbImageAtIndex:i];
      [thumbView setThumbImage:thumbImage];

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
