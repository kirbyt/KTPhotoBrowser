//
//  RootViewController.m
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "FlickrPhotosDataSource.h"
#import "SimpleFlickrAPI.h"

@interface RootViewController ()
- (FlickrPhotosDataSource *)photos;
- (NSString *)photoSetIdWithTitle:(NSString *)title photoSets:(NSArray *)photoSets;
@end

@implementation RootViewController

- (void)dealloc
{
   [super dealloc];
}

- (void)viewDidLoad 
{
   [super viewDidLoad];
   
   SimpleFlickrAPI *flickr = [[SimpleFlickrAPI alloc] init];
   NSString *userId = [flickr userIdForUsername:@"Kirby Turner"];
   NSArray *photoSets = [flickr photoSetListWithUserId:userId];
   NSString *photoSetId = [self photoSetIdWithTitle:@"Rowan" photoSets:photoSets];
   NSArray *photos = [flickr photosWithPhotoSetId:photoSetId];
   [flickr release];

   NSLog(@"%@", photos);
   
   [self setDataSource:[self photos]];
   [self setTitle:[NSString stringWithFormat:@"%i Photos", [[self photos] numberOfPhotos]]];
   
   // Label back button as "Back".
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back button title") style:UIBarButtonItemStylePlain target:nil action:nil];
   [[self navigationItem] setBackBarButtonItem:backButton];
   [backButton release];
}

- (FlickrPhotosDataSource *)photos
{
   if (photos_) {
      return photos_;
   }
   
   return nil;
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

@end
