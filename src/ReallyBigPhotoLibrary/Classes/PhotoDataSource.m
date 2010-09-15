//
//  PhotoDataSource.m
//  ReallyBigPhotoLibrary
//
//  Created by Kirby Turner on 9/14/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "PhotoDataSource.h"


@implementation PhotoDataSource

- (void)dealloc
{
   [data_ release], data_ = nil;
   [super dealloc];
}

- (id)init
{
   self = [super init];
   if (self) {
      data_ = [[NSMutableArray alloc] init];
      NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[UIImage imageNamed:@"IMG_0694_th.jpg"], @"thumbnail", [UIImage imageNamed:@"IMG_0694.JPG"], @"fullsize", nil];
      [data_ addObject:dict];
   }
   return self;
}

- (NSInteger)numberOfPhotos
{
   NSInteger count = 1000; [data_ count];
   return count;
}

// Implement either these, for synchronous images…
- (UIImage *)imageAtIndex:(NSInteger)index
{
   NSDictionary *dict = [data_ objectAtIndex:0];
   UIImage *image = [dict objectForKey:@"fullsize"];
   return image;
}

- (UIImage *)thumbImageAtIndex:(NSInteger)index
{
   NSDictionary *dict = [data_ objectAtIndex:0];
   UIImage *image = [dict objectForKey:@"thumbnail"];
   return image;
}


@end
