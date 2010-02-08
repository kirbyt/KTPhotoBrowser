//
//  PhotoList.m
//  HelloBaby
//
//  Created by Kirby Turner on 2/2/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "PhotoList.h"

@implementation PhotoList

- (void) dealloc {
   [photos_ release], photos_ = nil;
   [documentPath_ release], documentPath_ = nil;
   [photoPath_ release], photoPath_ = nil;
   [thumbnailPath_ release], thumbnailPath_ = nil;
   
   [super dealloc];
}

- (void)createPath:(NSString *)path {
   NSFileManager *fileManager = [NSFileManager defaultManager];
   NSError *error = nil;
   [fileManager createDirectoryAtPath:path
          withIntermediateDirectories:YES
                           attributes:nil
                                error:&error];
   if (error) {
      NSLog(@"Fail to create directory - error: %@", [error localizedDescription]);
   }
}

- (BOOL)doesPathExists:(NSString *)path {
   NSFileManager *fileManager = [NSFileManager defaultManager];
   return [fileManager fileExistsAtPath:path];
}

- (NSString *)documentPath {
   if ( ! documentPath_ ) {
		NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		documentPath_ = [searchPaths objectAtIndex: 0];
      [documentPath_ retain];
   }
   return documentPath_;
}

- (NSString*)photoPath {
	if (! photoPath_) {
      photoPath_ = [[self documentPath] stringByAppendingPathComponent:@"/photos"];
		[photoPath_ retain];
      
      if (! [self doesPathExists:photoPath_]) {
         [self createPath:photoPath_];
      }
	}
	return photoPath_;
}

- (NSString *)thumbnailPath {
	if (! thumbnailPath_) {
      thumbnailPath_ = [[self documentPath] stringByAppendingPathComponent:@"/thumbnails"];
		[thumbnailPath_ retain];
      
      if (! [self doesPathExists:thumbnailPath_]) {
         [self createPath:thumbnailPath_];
      }
	}
	return thumbnailPath_;
}

- (NSArray *)photos {
   if (photos_) {
      return photos_;
   }


   NSError *error = nil;
   NSArray *filenames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self photoPath] error:&error];
   if ( ! error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"];
      NSArray *photosOnly = [filenames filteredArrayUsingPredicate:predicate];
      photos_ = [[NSMutableArray alloc] initWithCapacity:[photosOnly count]];
      for (NSString *name in photosOnly) {
         NSString *photoPath = [NSString stringWithFormat:@"%@/%@", [self photoPath], name];
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
   NSString *path;
   NSString *fileName = [NSString stringWithFormat:@"%@.jpg", name];

   if (addToPhotoAlbum) {
      // Save the photo to the Photo Library.
      UIImageWriteToSavedPhotosAlbum(photo, nil, nil, nil);
   }
   
   // Save full size image.
   path = [[self photoPath] stringByAppendingPathComponent:fileName];
   [self savePhoto:photo toPath:path];
   
   // Release cached list to force refresh.
   [photos_ release], photos_ = nil;
}

@end
