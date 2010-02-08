//
//  WPSPhotoScrollViewController.m
//  HelloBaby
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//
//  Portions of the following code was derived from the Virtual Pages scroller
//  posted by Matt Gallagher at:
//  http://cocoawithlove.com/2009/01/multiple-virtual-pages-in-uiscrollview.html
//
//  Portions created by Matt Gallagher on 24/01/09.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//
//

#import "KTPhotoScrollViewController.h"
#import "KTPhotoBrowserDataSource.h"
#import "KTPhotoViewController.h"

#define PHOTO_SEPARATOR 30

@implementation KTPhotoScrollViewController

- (void)dealloc {
   [scrollView_ release], scrollView_ = nil;
   
   [currentPhoto_ release], currentPhoto_ = nil;
   [nextPhoto_ release], nextPhoto_ = nil;
   
   [super dealloc];
}

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index {
   if (self = [super init]) {
      startWithIndex_ = index;
      dataSource_ = dataSource;
   }
   return self;
}

- (void)loadView {
   CGRect frame = [[UIScreen mainScreen] applicationFrame];
   UIScrollView *newView = [[UIScrollView alloc] initWithFrame:frame];
   [newView setDelegate:self];
   [newView setBackgroundColor:[UIColor blackColor]];
   [newView setPagingEnabled:YES];
   [newView setShowsVerticalScrollIndicator:NO];
   [newView setShowsHorizontalScrollIndicator:NO];
   
   [self setView:newView];
   
   scrollView_ = newView;
   [scrollView_ retain];
   
   [newView release];
}

- (void)applyNewIndex:(NSUInteger)newIndex photoController:(KTPhotoViewController *)photoController {
   NSInteger photoCount = [dataSource_ numberOfPhotos];
   BOOL outOfBounds = newIndex >= photoCount || newIndex < 0;
   
   if ( !outOfBounds ) {
      CGRect photoFrame = photoController.view.frame;
      photoFrame.origin.y = 0;
      photoFrame.origin.x = scrollView_.frame.size.width * newIndex;
      photoController.view.frame = photoFrame;
   } else {
      CGRect photoFrame = photoController.view.frame;
      photoFrame.origin.y = scrollView_.frame.size.height;
      photoController.view.frame = photoFrame;
   }
   
   [photoController setPhotoIndex:newIndex];
}

- (void)viewDidLoad {
   [super viewDidLoad];

   currentPhoto_ = [[KTPhotoViewController alloc] initWithDataSource:dataSource_];
   nextPhoto_ = [[KTPhotoViewController alloc] initWithDataSource:dataSource_];
   [scrollView_ addSubview:[currentPhoto_ view]];
   [scrollView_ addSubview:[nextPhoto_ view]];
   
   NSInteger widthCount = [dataSource_ numberOfPhotos];
   if (widthCount == 0) {
      widthCount = 1;
   }
   
   // Add a small separator between the pictures.
   CGRect bounds = [scrollView_ bounds];
   bounds.size.width += PHOTO_SEPARATOR;
   [scrollView_ setBounds:bounds];
   
   CGSize size = CGSizeMake((scrollView_.frame.size.width + PHOTO_SEPARATOR) * widthCount, 
                            scrollView_.frame.size.height /2);
   [scrollView_ setContentSize:size];
   [scrollView_ setContentOffset:CGPointMake(0,0)];
   
   // Auto-scroll to the stating photo.
   CGRect frame = scrollView_.frame;
   frame.origin.x = frame.size.width * startWithIndex_;
   frame.origin.y = 0;
   [scrollView_ scrollRectToVisible:frame animated:NO];
   
   [self applyNewIndex:startWithIndex_ photoController:currentPhoto_];
   [self applyNewIndex:(startWithIndex_ + 1) photoController:nextPhoto_];
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

#pragma mark _
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   CGFloat pageWidth = scrollView.frame.size.width;
   float fractionalPage = scrollView.contentOffset.x / pageWidth;
   
   NSInteger lowerNumber = floor(fractionalPage);
   NSInteger upperNumber = lowerNumber + 1;
   
   if (lowerNumber == [currentPhoto_ photoIndex]) {
      if (upperNumber != [nextPhoto_ photoIndex]) {
         [self applyNewIndex:upperNumber photoController:nextPhoto_];
      }
   } else if (upperNumber == [currentPhoto_ photoIndex]) {
      if (lowerNumber != [nextPhoto_ photoIndex]) {
         [self applyNewIndex:lowerNumber photoController:nextPhoto_];
      }
   } else {
      if (lowerNumber == [nextPhoto_ photoIndex]) {
         [self applyNewIndex:upperNumber photoController:currentPhoto_];
      } else if (upperNumber == [nextPhoto_ photoIndex]) {
         [self applyNewIndex:lowerNumber photoController:currentPhoto_];
      } else {
         [self applyNewIndex:lowerNumber photoController:currentPhoto_];
         [self applyNewIndex:upperNumber photoController:nextPhoto_];
      }
   }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   CGFloat pageWidth = scrollView.frame.size.width;
   float fractionalPage = scrollView.contentOffset.x / pageWidth;
   NSInteger nearestNumber = lround(fractionalPage);
   
   if ([currentPhoto_ photoIndex] != nearestNumber) {
      KTPhotoViewController *swapController = currentPhoto_;
      currentPhoto_ = nextPhoto_;
      nextPhoto_ = swapController;
   }
}



@end
