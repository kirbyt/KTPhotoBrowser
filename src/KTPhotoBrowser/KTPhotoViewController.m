//
//  KTPhotoViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoViewController.h"
#import "KTPhotoBrowserDataSource.h"


@implementation KTPhotoViewController

@synthesize photoIndex = photoIndex_;

- (void)dealloc {
   [imageView_ release], imageView_ = nil;
   
   [super dealloc];
}

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource {
   if (self = [super init]) {
      dataSource_ = dataSource;

      // Make sure to set wantsFullScreenLayout or the photo
      // will not display behind the status bar.
      [self setWantsFullScreenLayout:YES];
   }
   return self;
}

- (void)loadView {
   CGRect frame = [[UIScreen mainScreen] bounds];
   UIImageView *newView = [[UIImageView alloc] initWithFrame:frame];
   [newView setBackgroundColor:[UIColor clearColor]];
   [newView setContentMode:UIViewContentModeScaleAspectFit];
   
   [self setView:newView];
   
   imageView_ = newView;
   [imageView_ retain];
   
   [newView release];
}

- (void)setPhotoIndex:(NSInteger)newPageIndex {
   photoIndex_ = newPageIndex;
   
   if (dataSource_ && photoIndex_ >=0 && photoIndex_ < [dataSource_ numberOfPhotos]) {
      UIImage *image = [dataSource_ imageAtIndex:photoIndex_];
      [imageView_ setImage:image];
   }
}

@end
