//
//  SDWebImageRootViewController.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "SDWebImageRootViewController.h"
#import "SDWebImageDataSource.h"

@interface SDWebImageRootViewController ()
- (void)showActivityIndicator;
- (void)hideActivityIndicator;
@end

@implementation SDWebImageRootViewController

- (void)dealloc {
   [images_ release], images_ = nil;
   [super dealloc];
}

- (id)initWithWindow:(UIWindow *)window {
   self = [super init];
   if (self) {
      window_ = window;
   }
   return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];
  
   self.title = @"SDWebImage Sample";
   
   images_ = [[SDWebImageDataSource alloc] init];
   [self setDataSource:images_];
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

- (void)willLoadThumbs {
   [self showActivityIndicator];
}

- (void)didLoadThumbs {
   [self hideActivityIndicator];
}


#pragma mark -
#pragma mark Activity Indicator

- (UIActivityIndicatorView *)activityIndicator {
   if (activityIndicatorView_) {
      return activityIndicatorView_;
   }
   
   activityIndicatorView_ = [[UIActivityIndicatorView alloc] 
                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   [activityIndicatorView_ setCenter:self.view.center];
   
   return activityIndicatorView_;
}

- (void)showActivityIndicator {
   if (window_) {
      [window_ addSubview:[self activityIndicator]];
   }
   [[self activityIndicator] startAnimating];
}

- (void)hideActivityIndicator {
   [[self activityIndicator] stopAnimating];
   [[self activityIndicator] removeFromSuperview];
}


@end
