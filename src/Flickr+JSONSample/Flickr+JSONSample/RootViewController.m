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
- (FlickrPhotosDataSource *)photos;
@end

@implementation RootViewController

- (void)dealloc
{
   [super dealloc];
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
   
   [self setDataSource:[self photos]];
   [self setTitle:[NSString stringWithFormat:@"%i Photos", [[self photos] numberOfPhotos]]];
   
   // Label back button as "Back".
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back button title") style:UIBarButtonItemStylePlain target:nil action:nil];
   [[self navigationItem] setBackBarButtonItem:backButton];
   [backButton release];
}

- (FlickrPhotosDataSource *)photos
{
   if (photos_) {
      return photos_;
   }
   
   return nil;
}

@end
