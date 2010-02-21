//
//  KTPhotoView.m
//  Sample
//
//  Created by Kirby Turner on 2/21/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoView.h"


@implementation KTPhotoView

@synthesize image = image_;

- (void)dealloc {
   [image_ release], image_ = nil;
   
   [super dealloc];
}

- (void)drawRect:(CGRect)rect {
   [image_ drawInRect:rect];
}

- (void)setImage:(UIImage *)newImage {
   if (image_ != newImage) {
      [image_ release];
      image_ = newImage;
      [image_ retain];
      [self setNeedsDisplay];
   }
}
@end
