//
//  RootViewController.m
//  ReallyBigPhotoLibrary
//
//  Created by Kirby Turner on 9/14/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "PhotoDataSource.h"


@implementation RootViewController

- (void)dealloc 
{
   [data_ release], data_ = nil;
   [super dealloc];
}


#pragma mark -
#pragma mark View lifecycle

- (PhotoDataSource *)data
{
   if (data_) {
      return data_;
   }
   
   data_ = [[PhotoDataSource alloc] init];
   return data_;
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
   
   [self setDataSource:[self data]];
   [self setTitle:[NSString stringWithFormat:@"%i Photos", [data_ numberOfPhotos]]];

   // Label back button as "Back".
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back button title") style:UIBarButtonItemStylePlain target:nil action:nil];
   [[self navigationItem] setBackBarButtonItem:backButton];
   [backButton release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}



#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
   // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
   // For example: self.myOutlet = nil;
}




@end

