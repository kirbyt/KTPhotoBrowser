//
//  FlickrPhotosDataSource.m
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "FlickrPhotosDataSource.h"
#import "SimpleFlickrAPI.h"
#import "KTPhotoView+SDWebImage.h"
#import "KTThumbView+SDWebImage.h"


@interface FlickrPhotosDataSource ()
@property (nonatomic, retain) NSArray *photos;
@end

@implementation FlickrPhotosDataSource

@synthesize photos = photos_;

- (void)dealloc
{
   [photos_ release], photos_ = nil;
   [super dealloc];
}

- (id)init
{
   self = [super init];
   if (self) {

   }
   return self;
}

- (NSString *)photoSetIdWithTitle:(NSString *)title photoSets:(NSArray *)photoSets
{
   NSString *result;
   for (NSDictionary *photoSet in photoSets) {
      NSDictionary *titleDict = [photoSet objectForKey:@"title"];
      NSString *titleContent = [titleDict objectForKey:@"_content"];
      if ([titleContent isEqualToString:title]) {
         result = [photoSet objectForKey:@"id"];
         break;
      }
   }
   
   return result;
}

- (void)fetchPhotos
{
   SimpleFlickrAPI *flickr = [[SimpleFlickrAPI alloc] init];
   NSString *userId = [flickr userIdForUsername:@"Kirby Turner"];
   NSArray *photoSets = [flickr photoSetListWithUserId:userId];
   NSString *photoSetId = [self photoSetIdWithTitle:@"Rowan" photoSets:photoSets];
   NSArray *photos = [flickr photosWithPhotoSetId:photoSetId];
   [flickr release];
   
   [self setPhotos:photos];
}


#pragma -
#pragma KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos
{
   NSInteger count = [[self photos] count];
   return count;
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView {
   NSDictionary *photo = [[self photos] objectAtIndex:index];
//   NSString *url = [imageUrls objectAtIndex:FULL_SIZE_INDEX];
//   [photoView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView {
   NSDictioonary *photo = [[self photos] objectAtIndex:index];
//   NSString *url = [imageUrls objectAtIndex:THUMBNAIL_INDEX];
//   [thumbView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

@end
