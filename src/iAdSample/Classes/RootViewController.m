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

   UIView *thumbnailView = [[self view] retain];
   [thumbnailView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
   
   UIView *newContainerView = [[UIView alloc] initWithFrame:CGRectZero];
   [newContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
   [newContainerView addSubview:thumbnailView];
   
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

@end
