//
//  KTPhotoView.m
//  Sample
//
//  Created by Kirby Turner on 2/21/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoView.h"
#import <QuartzCore/QuartzCore.h>


@implementation KTPhotoView

@synthesize image = image_;

- (void)dealloc {
   [image_ release], image_ = nil;
   
   [super dealloc];
}

- (void)setImage:(UIImage *)newImage {
   if (image_ != newImage) {
      [image_ release];
      image_ = newImage;
      [image_ retain];

      CALayer *layer = [self layer];
      [layer setContentsGravity:kCAGravityResizeAspectFill];
      [layer setMasksToBounds:YES];
      [layer setContents:(id)[image_ CGImage]];
   }
}
@end
