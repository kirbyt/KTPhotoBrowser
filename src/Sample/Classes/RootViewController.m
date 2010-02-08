//
//  RootViewController.m
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "UIImage+KTCategory.h"


@implementation RootViewController

- (void)dealloc {
   [photos_ release], photos_ = nil;
   [documentPath_ release], documentPath_ = nil;
   
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
   
   [self setDataSource:self];
   [self loadPhotos];
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


#pragma mark -
#pragma mark Photo Management

- (NSString *)documentPath {
   if ( ! documentPath_ ) {
		NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentPath_ = [searchPaths objectAtIndex: 0];
      [documentPath_ retain];
   }
   return documentPath_;
}

- (NSArray *)photos {
   if (photos_) {
      return photos_;
   }
   
   
   NSError *error = nil;
   NSArray *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self documentPath] error:&error];
   if ( ! error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"];
      NSArray *photosOnly = [filenames filteredArrayUsingPredicate:predicate];
      photos_ = [[NSMutableArray alloc] initWithCapacity:[photosOnly count]];
      for (NSString *name in photosOnly) {
         NSString *photoPath = [NSString stringWithFormat:@"%@/%@", [self documentPath], name];
         [photos_ addObject:photoPath];
      }
   } else {
#ifdef DEBUG
      NSLog(@"error: %@", [error localizedDescription]);
#endif
      photos_ = [[NSMutableArray alloc] init];
   }
   
   return photos_;
}

- (void)savePhoto:(UIImage *)photo toPath:(NSString *)path {
   NSData *jpg = UIImageJPEGRepresentation(photo, 1.0);  // 1.0 = least compression, best quality
   [jpg writeToFile:path atomically:NO];
}

- (void)savePhoto:(UIImage *)photo withName:(NSString *)name addToPhotoAlbum:(BOOL)addToPhotoAlbum{
   if (addToPhotoAlbum) {
      // Save the photo to the Photo Library.
      UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
   }
   
   // Save full size image.
   NSString *fileName = [NSString stringWithFormat:@"%@.jpg", name];
   NSString *path = [[self documentPath] stringByAppendingPathComponent:fileName];
   [self savePhoto:photo toPath:path];
   
   // Release cached list to force refresh.
   [photos_ release], photos_ = nil;
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
   NSProcessInfo *processInfo = [NSProcessInfo processInfo];
   NSString *name = [processInfo globallyUniqueString];
   // Save to the photo album if picture is from the camera.
   [self savePhoto:image withName:name addToPhotoAlbum:isFromCamera];
   [self loadPhotos];
}


#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
   NSInteger count = [[self photos] count];
   return count;
}

- (UIImage *)imageAtIndex:(NSInteger)index {
   NSString *path = [[self photos] objectAtIndex:index];
   UIImage *image = [UIImage imageWithContentsOfFile:path];
   return image;
}

- (UIImage *)thumbImageAtIndex:(NSInteger)index {
   NSString *path = [[self photos] objectAtIndex:index];
   UIImage *image = [UIImage imageWithContentsOfFile:path];
   UIImage *thumbImage = [image scaleAndCropToMaxSize:CGSizeMake(75,75)];
   return thumbImage;
}


@end
