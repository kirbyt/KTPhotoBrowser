//
//  RootViewController.m
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "FlickrPhotosDataSource.h"

@interface RootViewController ()
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
- (FlickrPhotosDataSource *)photos;
@end

@implementation RootViewController

@synthesize activityIndicator = activityIndicator_;

- (void)dealloc
{
   [photos_ release], photos_ = nil;
   [activityIndicator_ release], activityIndicator_ = nil;
   [super dealloc];
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
   
   UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   [activityIndicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
   [activityIndicator setCenter:[[self view] center]];
   [activityIndicator startAnimating];
   [self setActivityIndicator:activityIndicator];
   [activityIndicator release];

   [[self view] addSubview:[self activityIndicator]];

   // Label back button as "Back".
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back button title") style:UIBarButtonItemStylePlain target:nil action:nil];
   [[self navigationItem] setBackBarButtonItem:backButton];
   [backButton release];
}

- (void)viewDidAppear:(BOOL)animated
{
   [self setDataSource:[self photos]];
   [self setTitle:[NSString stringWithFormat:@"%i Photos", [[self photos] numberOfPhotos]]];
   [[self activityIndicator] stopAnimating];
}

- (FlickrPhotosDataSource *)photos
{
   if (photos_) {
      return photos_;
   }
   
   photos_ = [[FlickrPhotosDataSource alloc] init];
   [photos_ fetchPhotos];
   
   return photos_;
}


@end
