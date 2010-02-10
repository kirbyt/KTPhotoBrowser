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
      fileNames_ = [dirContents filteredArrayUsingPredicate:predicate];
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
      [cache setObject:image forKey:path];
   }
   
   return image;
}

- (void)savePhoto:(id)data {
   UIImage *photo = [data objectAtIndex:0];
   NSString *path = [data objectAtIndex:1];

   NSData *jpg = UIImageJPEGRepresentation(photo, 0.8);  // 1.0 = least compression, best quality
   [jpg writeToFile:path atomically:NO];
}

- (void)savePhoto:(UIImage *)photo toPath:(NSString *)path {
   NSArray *data = [NSArray arrayWithObjects:photo, path, nil];
   NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                           selector:@selector(savePhoto:)
                                                                             object:data];
   [queue_ addOperation:operation];
   [operation release];
}

- (void)savePhoto:(UIImage *)photo withName:(NSString *)name addToPhotoAlbum:(BOOL)addToPhotoAlbum{
   if (addToPhotoAlbum) {
      // Save the photo to the Photo Library.
      UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
   }
   
   // Save full size image.
   NSString *fileName = [NSString stringWithFormat:@"%@.jpg", name];
   NSString *path = [[self photosPath] stringByAppendingPathComponent:fileName];
   [self savePhoto:photo toPath:path];
   
   // Save thumbnail image.
   UIImage *thumbnail = [photo scaleAndCropToMaxSize:CGSizeMake(75,75)];
   NSString *thumbnailPath = [[self thumbnailsPath] stringByAppendingPathComponent:fileName];
   [self savePhoto:thumbnail toPath:thumbnailPath];
   
   // Release cached list of file names to force refresh.
   [fileNames_ release], fileNames_ = nil;
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


@end
