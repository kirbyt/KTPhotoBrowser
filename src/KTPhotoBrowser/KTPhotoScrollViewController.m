//
//  KTPhotoScrollViewController.m
//  KTPhotoBrowser
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
#import "KTPhotoBrowserGlobal.h"
#import "KTPhotoViewController.h"

const CGFloat ktkDefaultToolbarHeight = 44;

#define BUTTON_DELETEPHOTO 0
#define BUTTON_CANCEL 1
#define CONTENT_OFFSET 20

@interface KTPhotoScrollViewController (Private)
- (NSInteger)pageCount;
- (void)toggleChrome:(BOOL)hide;
@end

@implementation KTPhotoScrollViewController

@synthesize statusBarStyle = statusBarStyle_;
@synthesize navigationBarStyle = navigationBarStyle_;
@synthesize translucent = translucent_;
@synthesize statusbarHidden = statusbarHidden_;


- (void)dealloc {
   [scrollView_ release], scrollView_ = nil;
   [toolbar_ release], toolbar_ = nil;
   
   [currentPhoto_ release], currentPhoto_ = nil;
   [nextPhoto_ release], nextPhoto_ = nil;
   
   [super dealloc];
}

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index {
   if (self = [super init]) {
      startWithIndex_ = index;
      dataSource_ = dataSource;

      // Make sure to set wantsFullScreenLayout or the photo
      // will not display behind the status bar.
      [self setWantsFullScreenLayout:YES];
   }
   return self;
}

- (void)loadView {
   [super loadView];
   
   CGRect scrollFrame = [[UIScreen mainScreen] bounds];
   scrollFrame.size.width += CONTENT_OFFSET;
   UIScrollView *newView = [[UIScrollView alloc] initWithFrame:scrollFrame];
   [newView setDelegate:self];
   [newView setBackgroundColor:[UIColor blackColor]];
   [newView setPagingEnabled:YES];
   [newView setShowsVerticalScrollIndicator:NO];
   [newView setShowsHorizontalScrollIndicator:NO];
   
   [[self view] addSubview:newView];
   
   scrollView_ = newView;
   [scrollView_ retain];
   
   [newView release];
   
   UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] 
                                  initWithImage:KTLoadImageFromBundle(@"nextIcon.png")
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(nextPhoto)];

   UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] 
                                      initWithImage:KTLoadImageFromBundle(@"previousIcon.png")
                                      style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(previousPhoto)];
   
   UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                target:self
                                                                                action:@selector(trashPhoto)];

   UIBarItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                    target:nil 
                                                                    action:nil];
   
   CGRect screenFrame = [[UIScreen mainScreen] bounds];
   CGRect toolbarFrame = CGRectMake(0, 
                                    screenFrame.size.height - ktkDefaultToolbarHeight, 
                                    screenFrame.size.width, 
                                    ktkDefaultToolbarHeight);
   toolbar_ = [[UIToolbar alloc] initWithFrame:toolbarFrame];
   [toolbar_ setBarStyle:[self navigationBarStyle]];
   [toolbar_ setTranslucent:[self isTranslucent]];
   [toolbar_ setItems:[NSArray arrayWithObjects:
                       space, previousButton, space, nextButton, space, trashButton, nil]];
   [[self view] addSubview:toolbar_];
}

- (void)setTitleWithCurrentPhotoIndex {
   NSInteger index = [currentPhoto_ photoIndex] + 1;
   NSString *title = [NSString stringWithFormat:@"%i of %i", index, pageCount_, nil];
   [self setTitle:title];
}

- (void)applyNewIndex:(NSUInteger)newIndex photoController:(KTPhotoViewController *)photoController {
   BOOL outOfBounds = newIndex >= [self pageCount] || newIndex < 0;
   
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

- (void)autoScrollToIndex:(NSInteger)index {
   CGRect frame = scrollView_.frame;
   frame.origin.x = frame.size.width * index;
   frame.origin.y = 0;
   [scrollView_ scrollRectToVisible:frame animated:NO];
}

- (void)setScrollViewContentSizeWithPageCount:(NSInteger)pageCount {
   if (pageCount == 0) {
      pageCount = 1;
   }

   CGSize size = CGSizeMake(scrollView_.frame.size.width * pageCount, 
                            scrollView_.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
   [scrollView_ setContentSize:size];
   [scrollView_ setContentOffset:CGPointMake(0,CONTENT_OFFSET)];
}

- (void)viewDidLoad {
   [super viewDidLoad];
  
   currentPhoto_ = [[KTPhotoViewController alloc] initWithDataSource:dataSource_];
   [currentPhoto_ setScroller:self];
   [scrollView_ addSubview:[currentPhoto_ view]];

   nextPhoto_ = [[KTPhotoViewController alloc] initWithDataSource:dataSource_];
   [nextPhoto_ setScroller:self];
   [scrollView_ addSubview:[nextPhoto_ view]];
   
   // Set content size to allow scrolling.
   pageCount_ = [dataSource_ numberOfPhotos];
   [self setScrollViewContentSizeWithPageCount:[self pageCount]];
   
   // Auto-scroll to the stating photo.
   [self autoScrollToIndex:startWithIndex_];
   
   [self applyNewIndex:startWithIndex_ photoController:currentPhoto_];
   [self applyNewIndex:(startWithIndex_ + 1) photoController:nextPhoto_];
   
   [self setTitleWithCurrentPhotoIndex];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (NSInteger)pageCount {
   return pageCount_;
}

- (void)deleteCurrentPhoto {
   if (dataSource_) {
      [dataSource_ deleteImageAtIndex:[currentPhoto_ photoIndex]];
      
      // TODO: Animate the deletion of the current photo.
      
      pageCount_ -= 1;
      if ([self pageCount] == 0) {
         [[self navigationController] popViewControllerAnimated:YES];
      }
      
      // Resize scrollview context size.
      [self setScrollViewContentSizeWithPageCount:[self pageCount]];
      
      // Move to the next photo.
      [self autoScrollToIndex:[currentPhoto_ photoIndex] + 1];
      [self scrollViewDidEndScrollingAnimation:scrollView_];
   }
}


#pragma mark -
#pragma mark Chrome Helpers

- (void)toggleChromeDisplay {
   [self toggleChrome:!isChromeHidden_];
}

- (void)toggleChrome:(BOOL)hide {
   isChromeHidden_ = hide;
   [UIView beginAnimations:nil context:nil];
   
   [UIView setAnimationDuration:0.3];
   
   if ( ! [self isStatusbarHidden] ) {
      [[UIApplication sharedApplication] setStatusBarHidden:hide animated:YES];
   }

   CGFloat alpha = hide ? 0.0 : 1.0;
   
   // Must set the navigation bar's alpha, otherwise the photo
   // view will be pushed until the navigation bar.
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   [navbar setAlpha:alpha];
   
   [toolbar_ setAlpha:alpha];
                              
   [UIView commitAnimations];
}

- (void)hideChrome {
   [self toggleChrome:YES];
}

- (void)showChrome {
   [self toggleChrome:NO];
}


#pragma mark -
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   [self hideChrome];
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
      
      [self setTitleWithCurrentPhotoIndex];
   }
   
   [self showChrome];
}


#pragma mark -
#pragma mark Toolbar Actions

- (void)nextPhoto {
   [self autoScrollToIndex:[currentPhoto_ photoIndex] + 1];
   [self scrollViewDidEndScrollingAnimation:scrollView_];
}

- (void)previousPhoto {
   [self autoScrollToIndex:[currentPhoto_ photoIndex] - 1];
   [self scrollViewDidEndScrollingAnimation:scrollView_];
}

- (void)trashPhoto {
   UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button text.")
                                              destructiveButtonTitle:NSLocalizedString(@"Delete Photo", @"Delete Photo button text."), nil
                                                   otherButtonTitles:nil];
   [actionSheet showInView:[self view]];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   if (buttonIndex == BUTTON_DELETEPHOTO) {
      [self deleteCurrentPhoto];
   }
}

@end
