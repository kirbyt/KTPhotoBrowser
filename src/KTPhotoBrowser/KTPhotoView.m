//
//  KTPhotoView.m
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoView.h"
#import <QuartzCore/QuartzCore.h>

@implementation KTPhotoView

- (void)dealloc {
   [super dealloc];
}

- (void)setImage:(UIImage *)newImage {
   CALayer *layer = [self layer];
   [layer setContentsGravity:kCAGravityResizeAspect];
   [layer setMasksToBounds:YES];
   [layer setContents:(id)[newImage CGImage]];
}


@end
