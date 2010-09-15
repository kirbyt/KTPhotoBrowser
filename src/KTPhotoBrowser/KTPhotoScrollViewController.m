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

const CGFloat ktkDefaultPortraitToolbarHeight   = 44;
const CGFloat ktkDefaultLandscapeToolbarHeight  = 33;
const CGFloat ktkDefaultToolbarHeight = 44;

#define BUTTON_DELETEPHOTO 0
#define BUTTON_CANCEL 1
#define CONTENT_OFFSET 20

@interface KTPhotoScrollViewController (Private)
- (void)toggleChrome:(BOOL)hide;
- (void)startChromeDisplayTimer;
- (void)cancelChromeDisplayTimer;
- (void)hideChrome;
- (void)showChrome;
- (void)swapCurrentAndNextPhotos;
- (void)nextPhoto;
- (void)previousPhoto;
- (void)toggleNavButtons;
@end

@implementation KTPhotoScrollViewController

@synthesize statusBarStyle = statusBarStyle_;
@synthesize statusbarHidden = statusbarHidden_;


- (void)dealloc {
   [nextButton_ release], nextButton_ = nil;
   [previousButton_ release], previousButton_ = nil;
   [scrollView_ release], scrollView_ = nil;
   [toolbar_ release], toolbar_ = nil;
  
   [dataSource_ release], dataSource_ = nil;  
   
   [currentPhoto_ release], currentPhoto_ = nil;
   [nextPhoto_ release], nextPhoto_ = nil;
   
   [super dealloc];
}

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index {
   if (self = [super init]) {
     startWithIndex_ = index;
     dataSource_ = [dataSource retain];
     
     // Make sure to set wantsFullScreenLayout or the photo
     // will not display behind the status bar.
     [self setWantsFullScreenLayout:YES];

     BOOL isStatusbarHidden = [[UIApplication sharedApplication] isStatusBarHidden];
     [self setStatusbarHidden:isStatusbarHidden];
     
     self.hidesBottomBarWhenPushed = YES;
   }
   return self;
}

- (void)loadView {
   [super loadView];
   
   CGRect scrollFrame = [[UIScreen mainScreen] bounds];
   scrollFrame.size.width += CONTENT_OFFSET;
   UIScrollView *newView = [[UIScrollView alloc] initWithFrame:scrollFrame];
   [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
   [newView setDelegate:self];
   
   UIColor *backgroundColor = [dataSource_ respondsToSelector:@selector(imageBackgroundColor)] ?
                                [dataSource_ imageBackgroundColor] : [UIColor blackColor];  
   [newView setBackgroundColor:backgroundColor];
   [newView setPagingEnabled:YES];
   [newView setShowsVerticalScrollIndicator:NO];
   [newView setShowsHorizontalScrollIndicator:NO];
   
   [[self view] addSubview:newView];
   
   scrollView_ = newView;
   [scrollView_ retain];
   
   [newView release];
   
   nextButton_ = [[UIBarButtonItem alloc] 
                  initWithImage:KTLoadImageFromBundle(@"nextIcon.png")
                  style:UIBarButtonItemStylePlain
                  target:self
                  action:@selector(nextPhoto)];
   
   previousButton_ = [[UIBarButtonItem alloc] 
                      initWithImage:KTLoadImageFromBundle(@"previousIcon.png")
                      style:UIBarButtonItemStylePlain
                      target:self
                      action:@selector(previousPhoto)];
   
   UIBarButtonItem *trashButton = nil;
   if ([dataSource_ respondsToSelector:@selector(deleteImageAtIndex:)]) {
     trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                 target:self
                                                                 action:@selector(trashPhoto)];
   }

   UIBarItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                    target:nil 
                                                                    action:nil];
   
   CGRect screenFrame = [[UIScreen mainScreen] bounds];
   CGRect toolbarFrame = CGRectMake(0, 
                                    screenFrame.size.height - ktkDefaultToolbarHeight, 
                                    screenFrame.size.width, 
                                    ktkDefaultToolbarHeight);
   toolbar_ = [[UIToolbar alloc] initWithFrame:toolbarFrame];
   [toolbar_ setBarStyle:UIBarStyleBlackTranslucent];
   [toolbar_ setItems:[NSArray arrayWithObjects:
                       space, previousButton_, space, nextButton_, space, trashButton, nil]];
   [[self view] addSubview:toolbar_];
   
   if (trashButton) [trashButton release];
   [space release];
}

- (void)setTitleWithCurrentPhotoIndex {
   NSInteger index = [currentPhoto_ photoIndex] + 1;
   NSString *formatString = NSLocalizedString(@"%1$i of %2$i", @"Picture X out of Y total.");
   NSString *title = [NSString stringWithFormat:formatString, index, pageCount_, nil];
   [self setTitle:title];
}

- (void)applyNewIndex:(NSUInteger)newIndex photoController:(KTPhotoViewController *)photoController {
   BOOL outOfBounds = newIndex >= pageCount_ || newIndex < 0;
   
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
   [self setScrollViewContentSizeWithPageCount:pageCount_];

   
   // Auto-scroll to the stating photo.
   [self autoScrollToIndex:startWithIndex_];
   
   [self applyNewIndex:startWithIndex_ photoController:currentPhoto_];
   [self applyNewIndex:(startWithIndex_ + 1) photoController:nextPhoto_];
   
   [self setTitleWithCurrentPhotoIndex];
   [self toggleNavButtons];
   
   [self startChromeDisplayTimer];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
  // The first time the view appears, store away the previous controller's values so we can reset on pop.
  UINavigationBar *navbar = [[self navigationController] navigationBar];
  if (!viewDidAppearOnce_) {
    viewDidAppearOnce_ = YES;
    navbarWasTranslucent_ = [navbar isTranslucent];
    statusBarStyle_ = [[UIApplication sharedApplication] statusBarStyle];
  }
  // Then ensure translucency. Without it, the view will appear below rather than under it.  
  [navbar setTranslucent:YES];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
  
  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
  // Reset nav bar translucency and status bar style to whatever it was before.
  UINavigationBar *navbar = [[self navigationController] navigationBar];
  [navbar setTranslucent:navbarWasTranslucent_];
  [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle_ animated:YES];
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
   [self cancelChromeDisplayTimer];
}

- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
   CGRect toolbarFrame = toolbar_.frame;
   if ((interfaceOrientation) == UIInterfaceOrientationPortrait || (interfaceOrientation) == UIInterfaceOrientationPortraitUpsideDown) {
      toolbarFrame.size.height = ktkDefaultPortraitToolbarHeight;
   } else {
      toolbarFrame.size.height = ktkDefaultLandscapeToolbarHeight+1;
   }
   
   toolbarFrame.size.width = self.view.frame.size.width;
   toolbarFrame.origin.y =  self.view.frame.size.height - toolbarFrame.size.height;
   toolbar_.frame = toolbarFrame;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
   return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
                                duration:(NSTimeInterval)duration {

   rotationInProgress_ = YES;
   
   // Hide the next photo to prevent it from overlapping 
   // the during rotation's animation.
   [[nextPhoto_ view] setHidden:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
   // Note the scrollview has already been resized by
   // the time this method is called.
   
   // Set the new context size.
   [self setScrollViewContentSizeWithPageCount:pageCount_];
   
   
   // Rotate the toolbar.
   [self updateToolbarWithOrientation:toInterfaceOrientation];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

   // Reposition the photo views we have in memory.
   [self applyNewIndex:[currentPhoto_ photoIndex] photoController:currentPhoto_];
   [self applyNewIndex:[nextPhoto_ photoIndex] photoController:nextPhoto_];
   [[nextPhoto_ view] setHidden:NO];
   
   [self autoScrollToIndex:[currentPhoto_ photoIndex]];
   rotationInProgress_ = NO;
}

- (UIView *)rotatingFooterView {
   return toolbar_;
}

- (void)deleteCurrentPhoto {
   if (dataSource_) {
      // TODO: Animate the deletion of the current photo.

      NSInteger photoIndexToDelete = [currentPhoto_ photoIndex];
      [dataSource_ deleteImageAtIndex:photoIndexToDelete];

      pageCount_ -= 1;
      if (pageCount_ == 0) {
         [self showChrome];
         [[self navigationController] popViewControllerAnimated:YES];
      } else {
         [self setScrollViewContentSizeWithPageCount:pageCount_];
         NSInteger nextIndex = photoIndexToDelete;
         if (nextIndex == pageCount_) {
            nextIndex -= 1;
         }
         [self applyNewIndex:nextIndex photoController:currentPhoto_];
         [self applyNewIndex:(nextIndex + 1) photoController:nextPhoto_];
         [self autoScrollToIndex:nextIndex];
         [self scrollViewDidEndScrollingAnimation:scrollView_];
         [self setTitleWithCurrentPhotoIndex];
         [self toggleNavButtons];
      }
   }
}

- (void)toggleNavButtons {
   [previousButton_ setEnabled:([currentPhoto_ photoIndex] > 0)];
   [nextButton_ setEnabled:([currentPhoto_ photoIndex] < pageCount_ - 1)];
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
     if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:withAnimation:)]) {
       [[UIApplication sharedApplication] setStatusBarHidden:hide withAnimation:YES];
     } else {  // Deprecated in iOS 3.2+.
       id sharedApp = [UIApplication sharedApplication];  // Get around deprecation warnings.
       [sharedApp setStatusBarHidden:hide animated:YES];
     }
   }

   CGFloat alpha = hide ? 0.0 : 1.0;
   
   // Must set the navigation bar's alpha, otherwise the photo
   // view will be pushed until the navigation bar.
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   [navbar setAlpha:alpha];
   
   [toolbar_ setAlpha:alpha];
                              
   [UIView commitAnimations];
   
   if ( ! isChromeHidden_ ) {
      [self startChromeDisplayTimer];
   }
}

- (void)hideChrome {
   if (chromeHideTimer_ && [chromeHideTimer_ isValid]) {
      [chromeHideTimer_ invalidate];
      chromeHideTimer_ = nil;
   }
   [self toggleChrome:YES];
}

- (void)showChrome {
   [self toggleChrome:NO];
}

- (void)startChromeDisplayTimer {
   [self cancelChromeDisplayTimer];
   chromeHideTimer_ = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                       target:self 
                                                     selector:@selector(hideChrome)
                                                     userInfo:nil
                                                      repeats:NO];
}

- (void)cancelChromeDisplayTimer {
   if (chromeHideTimer_) {
      [chromeHideTimer_ invalidate];
   }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
   if (rotationInProgress_) {
      // The contentOffset is adjusted and breaks the 
      // code below. Therefore, ignore scrolling when
      // rotating.
      return;
   }
#ifdef DEBUG
   NSLog(@"%s", __PRETTY_FUNCTION__);
   NSLog(@"contentOffset %f,%f", scrollView.contentOffset.x, scrollView.contentOffset.y);
#endif
   
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
   if (rotationInProgress_) {
      // The contentOffset is adjusted and breaks the 
      // code below. Therefore, ignore scrolling when
      // rotating.
      return;
   }

   CGFloat pageWidth = scrollView.frame.size.width;
   float fractionalPage = scrollView.contentOffset.x / pageWidth;
   NSInteger nearestNumber = lround(fractionalPage);
   
   if ([currentPhoto_ photoIndex] != nearestNumber) {
      [currentPhoto_ turnOffZoom];
      KTPhotoViewController *swapController = currentPhoto_;
      currentPhoto_ = nextPhoto_;
      nextPhoto_ = swapController;
      [self setTitleWithCurrentPhotoIndex];
      [self toggleNavButtons];
   }
}


#pragma mark -
#pragma mark Toolbar Actions

- (void)nextPhoto {
   [self autoScrollToIndex:[currentPhoto_ photoIndex] + 1];
   [self scrollViewDidEndScrollingAnimation:scrollView_];
   [self startChromeDisplayTimer];
}

- (void)previousPhoto {
   [self autoScrollToIndex:[currentPhoto_ photoIndex] - 1];
   [self scrollViewDidEndScrollingAnimation:scrollView_];
   [self startChromeDisplayTimer];
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
   [self startChromeDisplayTimer];
}

@end
