//
//  RootViewController.m
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

- (void)dealloc {
   [myPhotos_ release], myPhotos_ = nil;
   
   [super dealloc];
}

- (void)viewDidLoad {
   [super viewDidLoad];
   
   [self setTitle:NSLocalizedString(@"Photo Album", @"Photo Album screen title.")];
   
   UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                              target:self
                                                                              action:@selector(addPhoto)];
   [[self navigationItem] setRightBarButtonItem:addButton];
   [addButton release];
   
   if (myPhotos_ == nil) {
      myPhotos_ = [[Photos alloc] init];
      [myPhotos_ setDelegate:self];
   }
   [self setDataSource:myPhotos_];
   [self loadPhotos];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
   [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
   [myPhotos_ flushCache];
}



#pragma mark -
#pragma mark Actions

- (void)addPhoto {
   if (!photoPicker_) {
      photoPicker_ = [[PhotoPickerController alloc] initWithDelegate:self];
   }
   [photoPicker_ show];
}


#pragma mark -
#pragma mark PhotoPickerControllerDelegate

- (void)photoPickerController:(PhotoPickerController *)controller didFinishPickingWithImage:(UIImage *)image isFromCamera:(BOOL)isFromCamera {
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

- (void)didFinishSave {
   [self loadPhotos];
}

@end
