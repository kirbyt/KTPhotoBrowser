//
//  Photos.m
//  Sample
//
//  Created by Kirby Turner on 2/10/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "Photos.h"
#import "UIImage+KTCategory.h"

#define INITIAL_CACHE_SIZE 5

@implementation Photos

@synthesize delegate = delegate_;

- (void)dealloc {
   [documentPath_ release], documentPath_ = nil;
   [photosPath_ release], photosPath_ = nil;
   [thumbnailsPath_ release], thumbnailsPath_ = nil;
   
   [fileNames_ release], fileNames_ = nil;
   [photoCache_ release], photoCache_ = nil;
   [thumbnailCache_ release], thumbnailCache_ = nil;
   
   [queue_ release], queue_ = nil;
   
   [super dealloc];
}

- (id)init {
   self = [super init];
   if (self != nil) {
      photoCache_ = [[NSMutableDictionary alloc] initWithCapacity:INITIAL_CACHE_SIZE];
      thumbnailCache_ = [[NSMutableDictionary alloc] initWithCapacity:INITIAL_CACHE_SIZE];
      queue_ = [[NSOperationQueue alloc] init];
   }
   return self;
}

- (void)flushCache {
   [photoCache_ removeAllObjects];
   [thumbnailCache_ removeAllObjects];
}

- (void)releasePhotoList {
   // Release cached list of file names to force refresh.
   [fileNames_ release], fileNames_ = nil;
}


#pragma mark -
#pragma mark File Names and Paths

// Creates the path if it does not exist.
- (void)ensurePathAt:(NSString *)path {
   NSFileManager *fm = [NSFileManager defaultManager];
   if ( [fm fileExistsAtPath:path] == false ) {
      [fm createDirectoryAtPath:path
    withIntermediateDirectories:YES
                     attributes:nil
                          error:NULL];
   }
}

- (NSString *)documentPath {
   if ( ! documentPath_ ) {
		NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentPath_ = [searchPaths objectAtIndex: 0];
      [documentPath_ retain];
   }
   return documentPath_;
}

- (NSString *)photosPath {
   if ( ! photosPath_ ) {
      photosPath_ = [[self documentPath] stringByAppendingPathComponent:@"images"];
      [photosPath_ retain];
      [self ensurePathAt:photosPath_];
   }
   return photosPath_;
}

- (NSString *)thumbnailsPath {
   if ( ! thumbnailsPath_ ) {
      thumbnailsPath_ = [[self documentPath] stringByAppendingPathComponent:@"thumbnails"];
      [thumbnailsPath_ retain];
      [self ensurePathAt:thumbnailsPath_];
   }
   return thumbnailsPath_;
}

- (NSArray *)fileNames {
   if (fileNames_) {
      return fileNames_;
   }
   
   NSError *error = nil;
   NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self photosPath] error:&error];
   if ( ! error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"];
      NSArray *imagesOnly = [dirContents filteredArrayUsingPredicate:predicate];
      fileNames_ = [NSMutableArray arrayWithArray:imagesOnly];
      [fileNames_ retain];
   } else {
#ifdef DEBUG
      NSLog(@"error: %@", [error localizedDescription]);
#endif
      fileNames_ = [[NSMutableArray alloc] init];
   }
   
   return fileNames_;
}


#pragma mark -
#pragma mark Photo Management

- (UIImage *)imageAtPath:(NSString *)path cache:(NSMutableDictionary *)cache {
   // Retrieve image from the cache.
   UIImage *image = [cache objectForKey:path];
   // If not in the cache, retrieve from the file system
   // and add to the cache.
   if (image == nil) {
      image = [UIImage imageWithContentsOfFile:path];
      if (image) {
         [cache setObject:image forKey:path];
      }
   }
   
   return image;
}

- (void)sendDidFinishSaveNotification {
   if (delegate_ != nil && [delegate_ respondsToSelector:@selector(didFinishSave)]) {
      [delegate_ didFinishSave];
   }
}

- (void)savePhoto:(UIImage *)photo toPath:(NSString *)path {
   NSData *jpg = UIImageJPEGRepresentation(photo, 0.8);  // 1.0 = least compression, best quality
   [jpg writeToFile:path atomically:NO];

   [self performSelectorOnMainThread:@selector(releasePhotoList)
                          withObject:nil
                       waitUntilDone:YES];
   
   [self performSelectorOnMainThread:@selector(sendDidFinishSaveNotification) 
                          withObject:nil 
                       waitUntilDone:NO];
}

- (void)savePhoto:(UIImage *)photo asThumbnailNamed:(NSString *)name {
   UIImage *thumbnail = [photo imageScaleAndCropToMaxSize:CGSizeMake(75,75)];
   NSString *thumbnailPath = [[self thumbnailsPath] stringByAppendingPathComponent:name];
   [self savePhoto:thumbnail toPath:thumbnailPath];
}

- (void)savePhoto:(UIImage *)photo named:(NSString *)name {
   // Save full size image. Note we will scale down the full size
   // image in order to improve display performance.
   CGRect bounds = [[UIScreen mainScreen] bounds];
   CGFloat newSize = (bounds.size.width > bounds.size.height) ? bounds.size.width : bounds.size.height;
   // Make sure we are only scaling down. Do not scale up the image.
   UIImage *scaledImage;
   if (newSize < photo.size.width && newSize < photo.size.width) {
      scaledImage = [photo imageScaleAspectToMaxSize:newSize];
   } else {
      scaledImage = photo;
   }
   
   NSString *path = [[self photosPath] stringByAppendingPathComponent:name];
   [self savePhoto:scaledImage toPath:path];
}

- (void)savePhoto:(id)data {
   NSAssert(data != nil, @"Unassigned NSArray for data.");
   
   UIImage *photo = (UIImage *)[data objectAtIndex:0];
   NSString *name = (NSString *)[data objectAtIndex:1];
   BOOL addToPhotoAlbum = [(NSNumber *)[data objectAtIndex:2] boolValue];
   
   NSString *fileName = [NSString stringWithFormat:@"%@.jpg", name];

   [self savePhoto:photo asThumbnailNamed:fileName];
   [self savePhoto:photo named:fileName];

   if (addToPhotoAlbum) {
      // Save the photo to the Photo.app Photo Library.
      UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
   }
}

- (void)savePhoto:(UIImage *)photo withName:(NSString *)name addToPhotoAlbum:(BOOL)addToPhotoAlbum{
   NSArray *data = [NSArray arrayWithObjects:photo, name, [NSNumber numberWithBool:addToPhotoAlbum], nil];
   NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                           selector:@selector(savePhoto:)
                                                                             object:data];
   [queue_ addOperation:operation];
   [operation release];
}

- (void)deletePhotoAtPath:(NSString *)path {
   [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
   
   [self performSelectorOnMainThread:@selector(releasePhotoList)
                          withObject:nil
                       waitUntilDone:YES];
   
   [self performSelectorOnMainThread:@selector(sendDidFinishSaveNotification) 
                          withObject:nil 
                       waitUntilDone:NO];
}

- (void)deleteImageNamed:(id)data {
   if ([data isKindOfClass:[NSString class]]) {
      NSString *name = (NSString *)data;
      NSString *path = [[self photosPath] stringByAppendingPathComponent:name];
      [self deletePhotoAtPath:path];
      
      NSString *thumbnailPath = [[self thumbnailsPath] stringByAppendingPathComponent:name];
      [self deletePhotoAtPath:thumbnailPath];
   }
   [data release];
}

- (void)removeCachedImageNamed:(NSString *)name {
   // Remove from the full image cache.
   NSString *path = [[self photosPath] stringByAppendingPathComponent:name];
   [photoCache_ removeObjectForKey:path];

   // Remove from the thumbnail image cache.
   path = [[self thumbnailsPath] stringByAppendingPathComponent:name];
   [thumbnailCache_ removeObjectForKey:path];

   // Remove from the file list.
   [fileNames_ removeObject:name];
}


#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
   NSInteger count = [[self fileNames] count];
   return count;
}

- (UIImage *)imageAtIndex:(NSInteger)index {
   NSString *fileName = [[self fileNames] objectAtIndex:index];
   NSString *path = [[self photosPath] stringByAppendingPathComponent:fileName];
   return [self imageAtPath:path cache:photoCache_];
}

- (UIImage *)thumbImageAtIndex:(NSInteger)index {
   NSString *fileName = [[self fileNames] objectAtIndex:index];
   NSString *path = [[self thumbnailsPath] stringByAppendingPathComponent:fileName];
   return [self imageAtPath:path cache:thumbnailCache_];
}

- (void)deleteImageAtIndex:(NSInteger)index {
   NSString *name = [[self fileNames] objectAtIndex:index];
   
   // Note: name will be released when removed from 
   // the cache (in the message removeCachedImageNamed:).
   // However, it is needed in the secondary thread that
   // performs the physical delete of the image files.
   // Therefore, we will retain name and release it in
   // the secondary thread.
   [name retain];

   // Remove the image from the cache. 
   [self removeCachedImageNamed:name];
   
   // Delete the images from the device.
   NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                           selector:@selector(deleteImageNamed:)
                                                                             object:name];
   [queue_ addOperation:operation];
   [operation release];
}

// - (BOOL)thumbsHaveBorder {
//   return NO;
// }

// - (CGSize)thumbSize {
//   return CGSizeMake(120, 120);
// }

// - (NSInteger)thumbsPerRow {
//   return 1;
// }

// - (UIColor *)imageBackgroundColor {
//   return [UIColor whiteColor];
// }


@end
