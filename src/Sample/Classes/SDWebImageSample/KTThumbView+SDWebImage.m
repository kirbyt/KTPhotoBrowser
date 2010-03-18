//
//  KTThumbView+SDWebImage.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbView+SDWebImage.h"
#import "SDWebImageManager.h"

@implementation KTThumbView (SDWebImage)

- (void)setImageWithURL:(NSURL *)url {
   [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
   SDWebImageManager *manager = [SDWebImageManager sharedManager];
   
   // Remove in progress downloader from queue
   [manager cancelForDelegate:self];
   
   UIImage *cachedImage = [manager imageWithURL:url];
   
   if (cachedImage) {
      [self setThumbImage:cachedImage];
   }
   else {
      if (placeholder) {
         [self setThumbImage:placeholder];
      }
      
      [manager downloadWithURL:url delegate:self];
   }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
   [self setThumbImage:image];
}

@end
