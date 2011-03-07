//
//  RootViewController.m
//  iAdSample
//
//  Created by Kirby Turner on 3/2/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"


@interface RootViewController ()
- (UIActivityIndicatorView *)activityIndicator;
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end

@implementation RootViewController

- (void)dealloc
{
   [myPhotos_ release], myPhotos_ = nil;
   [activityIndicatorView_ release], activityIndicatorView_ = nil;
   [thumbnailView_ release], thumbnailView_ = nil;
   [bannerView_ release], bannerView_ = nil;
   
   [super dealloc];
}

- (id)initWithWindow:(UIWindow *)window 
{
   self = [super init];
   if (self) {
      window_ = window;
   }
   return self;
}

- (void)loadView
{
   [super loadView];
   
   // Build a new view hierarchy.
   
   [self setWantsFullScreenLayout:NO];

   UIView *newContainerView = [[UIView alloc] initWithFrame:CGRectZero];
   [newContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
   
   thumbnailView_ = [[self view] retain];
   [thumbnailView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
   [newContainerView addSubview:thumbnailView_];
   
   bannerIsVisible_ = NO;
   bannerView_ = [[ADBannerView alloc] initWithFrame:CGRectZero];
   [bannerView_ setDelegate:self];
   [bannerView_ setRequiredContentSizeIdentifiers:[NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil]];
   [bannerView_ setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
   [newContainerView addSubview:bannerView_];
   
   
   [self setView:newContainerView];
   [newContainerView release];
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
   
   [self setTitle:NSLocalizedString(@"Photo Album", @"Photo Album screen title.")];
   
   UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(addPhoto)];
   [[self navigationItem] setRightBarButtonItem:addButton];
   [addButton release];
   
   if (myPhotos_ == nil) {
      myPhotos_ = [[Photos alloc] init];
      [myPhotos_ setDelegate:self];
   }
   [self setDataSource:myPhotos_];
   
   // Hide the banner view just off the top.
   CGRect bannerViewFrame = [bannerView_ frame];
   bannerViewFrame.origin.y = -bannerViewFrame.size.height;
   bannerViewFrame.origin.x = 0;
   [bannerView_ setFrame:bannerViewFrame];
}

- (void)viewWillAppear:(BOOL)animated 
{
   [super viewWillAppear:animated];
   
   // Superclass makes the navigation bar translucent. We need
   // to override this behavior. This keeps the thumbnails from
   // scrolling behind the navigation bar.
   UINavigationBar *navbar = [[self navigationController] navigationBar];
   [navbar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning 
{
   // Releases the view if it doesn't have a superview.
   [super didReceiveMemoryWarning];
   
   // Release any cached data, images, etc that aren't in use.
   [myPhotos_ flushCache];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
      [bannerView_ setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
   } else {
      [bannerView_ setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierPortrait];
   }
}

- (void)willLoadThumbs 
{
   [self showActivityIndicator];
}

- (void)didLoadThumbs 
{
   [self hideActivityIndicator];
}


#pragma mark -
#pragma mark Activity Indicator

- (UIActivityIndicatorView *)activityIndicator 
{
   if (activityIndicatorView_) {
      return activityIndicatorView_;
   }
   
   activityIndicatorView_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   [activityIndicatorView_ setCenter:self.view.center];
   
   return activityIndicatorView_;
}

- (void)showActivityIndicator 
{
   if (window_) {
      [window_ addSubview:[self activityIndicator]];
   }
   [[self activityIndicator] startAnimating];
}

- (void)hideActivityIndicator 
{
   [[self activityIndicator] stopAnimating];
   [[self activityIndicator] removeFromSuperview];
}


#pragma mark -
#pragma mark Actions

- (void)addPhoto 
{
   if (!photoPicker_) {
      photoPicker_ = [[PhotoPickerController alloc] initWithDelegate:self];
   }
   [photoPicker_ show];
}


#pragma mark -
#pragma mark PhotoPickerControllerDelegate

- (void)photoPickerController:(PhotoPickerController *)controller didFinishPickingWithImage:(UIImage *)image isFromCamera:(BOOL)isFromCamera 
{
   [self showActivityIndicator];
   
   NSString * const key = @"nextNumber";
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   NSNumber *nextNumber = [defaults valueForKey:key];
   if ( ! nextNumber ) {
      nextNumber = [NSNumber numberWithInt:1];
   }
   [defaults setObject:[NSNumber numberWithInt:([nextNumber intValue] + 1)] forKey:key];
   
   NSString *name = [NSString stringWithFormat:@"picture-%05i", [nextNumber intValue]];
   
   // Save to the photo album if picture is from the camera.
   [myPhotos_ savePhoto:image withName:name addToPhotoAlbum:isFromCamera];
}


#pragma mark -
#pragma mark PhotosDelegate

- (void)didFinishSave 
{
   [self reloadThumbs];
}

- (void)exportImageAtPath:(NSString *)path
{
   NSData *imageData = [NSData dataWithContentsOfFile:path];
   
   MFMailComposeViewController *controller = 
   [[MFMailComposeViewController alloc] init];
   
   [controller setMailComposeDelegate:self];
   [controller addAttachmentData:imageData 
                        mimeType:@"image/jpeg" 
                        fileName:@"Image.jpg"];
   
   [controller setMessageBody:@"Image attached" isHTML:NO];
   
   // Show the status bar because, otherwise, we will have some layout
   // problems when the controller is dismissed.
   if ([[UIApplication sharedApplication] respondsToSelector:
        @selector(setStatusBarHidden:withAnimation:)]) 
   {
      [[UIApplication sharedApplication] setStatusBarHidden:NO 
                                              withAnimation:YES];
   } 
   else 
   {
      // get around deprecation warnings.
      id sharedApp = [UIApplication sharedApplication];
      [sharedApp setStatusBarHidden:NO animated:YES];
   }
   
   [self.navigationController presentModalViewController:controller 
                                                animated:YES];
   [controller release];   
}

#pragma mark -
#pragma mark MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController*)controller 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error
{
   [self.navigationController dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
   if (!bannerIsVisible_)
   {
      [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
      // Slide down the thumbnail view to display the ad.
      // Assumes the banner view is just off the top of the screen.
      [banner setFrame:CGRectOffset([banner frame], 0, [banner frame].size.height)];
      [thumbnailView_ setFrame:CGRectOffset([thumbnailView_ frame], 0, [banner frame].size.height)];
      [UIView commitAnimations];
      bannerIsVisible_ = YES;
   }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
   NSLog(@"iAd banner error: %@", [error localizedDescription]);
   if (bannerIsVisible_)
   {
      [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
      // Assumes the banner view is placed at the top of the screen.
      [banner setFrame:CGRectOffset([banner frame], 0, -[banner frame].size.height)];
      [thumbnailView_ setFrame:CGRectOffset([thumbnailView_ frame], 0, -[banner frame].size.height)];
      [UIView commitAnimations];
      bannerIsVisible_ = NO;
   }
}
       
       
@end
