//
//  KTPhotoView.m
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoView.h"
#import <QuartzCore/QuartzCore.h>

@interface KTPhotoView (KTPrivateMethods)
- (void)loadSubviewsWithFrame:(CGRect)frame;
@end

@implementation KTPhotoView

- (void)dealloc 
{
   [imageView_ release], imageView_ = nil;
   [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
   if (self) {
      [self setDelegate:self];
      [self setMaximumZoomScale:5.0];
      [self loadSubviewsWithFrame:frame];
   }
   return self;
}

- (void)loadSubviewsWithFrame:(CGRect)frame
{
   imageView_ = [[UIImageView alloc] initWithFrame:frame];
   [imageView_ setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
   [imageView_ setContentMode:UIViewContentModeScaleAspectFit];
   [self addSubview:imageView_];
}

- (void)setImage:(UIImage *)newImage 
{
   [imageView_ setImage:newImage];
//   CALayer *layer = [self layer];
//   [layer setContentsGravity:kCAGravityResizeAspect];
//   [layer setMasksToBounds:YES];
//   [layer setContents:(id)[newImage CGImage]];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center 
{
   
   CGRect zoomRect;
   
   // the zoom rect is in the content view's coordinates. 
   //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
   //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
   zoomRect.size.height = [self frame].size.height / scale;
   zoomRect.size.width  = [self frame].size.width  / scale;
   
   // choose an origin so as to get the right center.
   zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
   zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
   
   return zoomRect;
}

- (void)zoomToLocation:(CGPoint)location
{
   float newScale;
   CGRect zoomRect;
   if ([self zoomScale] > [self minimumZoomScale]) {
      newScale = 1.0;
      zoomRect = [self bounds];
   } else {
      newScale = [self maximumZoomScale];
      zoomRect = [self zoomRectForScale:newScale withCenter:location];
   }
   
   [self zoomToRect:zoomRect animated:YES];
}

- (void)turnOffZoom
{
   if ([self zoomScale] > [self minimumZoomScale]) {
      [self zoomToLocation:CGPointZero];
   }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
   UITouch *touch = [touches anyObject];
   
   if ([touch view] == self) {
      if ([touch tapCount] == 2) {
         [self zoomToLocation:[touch locationInView:self]];
      }
   }
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
   UIView *viewToZoom = imageView_;
   return viewToZoom;
}


@end
