//
//  FlickrPhotosDataSource.m
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "FlickrPhotosDataSource.h"


@implementation FlickrPhotosDataSource

- (void)dealloc
{
   [super dealloc];
}

- (id)init
{
   self = [super init];
   if (self) {

   }
   return self;
}

- (NSInteger)numberOfPhotos
{
   return 0;
}

// Implement either these, for synchronous images…
- (UIImage *)imageAtIndex:(NSInteger)index
{
   return nil;
}

- (UIImage *)thumbImageAtIndex:(NSInteger)index
{
   return nil;
}

@end
