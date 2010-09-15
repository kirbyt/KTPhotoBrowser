//
//  KTPhotoViewController.m
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoViewController.h"
#import "KTPhotoBrowserDataSource.h"
#import "KTPhotoScrollViewController.h"
#import "KTPhotoView.h"


@implementation KTPhotoViewController

@synthesize photoIndex = photoIndex_;
@synthesize scroller = scroller_;

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
   [super loadView];
   
   [[self view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
   
   CGRect frame = [[UIScreen mainScreen] bounds];
   KTPhotoView *newView = [[KTPhotoView alloc] initWithFrame:frame];
   [newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
   [newView setBackgroundColor:[UIColor clearColor]];

   [[self view] addSubview:newView];
   
   imageView_ = newView;
   [imageView_ retain];
   
   [newView release];
}

- (void)setPhotoIndex:(NSInteger)newPageIndex {
   photoIndex_ = newPageIndex;
   
   if (dataSource_ && photoIndex_ >=0 && photoIndex_ < [dataSource_ numberOfPhotos]) {
      if ([dataSource_ respondsToSelector:@selector(imageAtIndex:photoView:)] == NO) {
         UIImage *image = [dataSource_ imageAtIndex:photoIndex_];
         [imageView_ setImage:image];
      } else {
         [dataSource_ imageAtIndex:photoIndex_ photoView:imageView_];
      }
   }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
   if (scroller_) {
      [scroller_ toggleChromeDisplay];
   }
}

- (void)turnOffZoom
{
   [imageView_ turnOffZoom];
}

@end
