//
//  SDWebImageRootViewController.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "FlickrRootViewController.h"
#import "FlickrDataSource.h"


@implementation FlickrRootViewController

- (void)dealloc 
{
   [activityIndicator_ release], activityIndicator_ = nil;
   [images_ release], images_ = nil;
   [super dealloc];
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
   self.title = @"Flickr Sample";

   activityIndicator_ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   CGPoint center = [[self view] center];
   [activityIndicator_ setCenter:center];
   [activityIndicator_ setHidesWhenStopped:YES];
   [activityIndicator_ startAnimating];
   [[self view] addSubview:activityIndicator_];
}

- (void)viewDidAppear:(BOOL)animated
{
   if (!images_) {
      images_ = [[FlickrDataSource alloc] init];
      [self setDataSource:images_];
   }
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)willLoadThumbs 
{
   [activityIndicator_ startAnimating];
}

- (void)didLoadThumbs 
{
   [activityIndicator_ stopAnimating];
}


@end
