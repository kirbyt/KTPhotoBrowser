//
//  UIImageAdditions.m
//  Sample
//
//  Created by Kirby Turner on 2/7/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "UIImage+KTCategory.h"


@implementation UIImage (KTCategory)

- (UIImage *)scaleAndCropToMaxSize:(CGSize)newSize {
   // Disclaimer: The follow code is derived from the 
   // book iPhone SDK Development by Bill Dudney and 
   // Chris Adamson.
   
   CGSize imageSize = [self size];
   CGFloat scale = 1.0f;
   CGImageRef subimage = NULL;
   if(imageSize.width > imageSize.height) {
      // image height is smallest
      scale = newSize.height / imageSize.height;
      CGFloat offsetX = ((scale * imageSize.width - newSize.width) / 2.0f) / scale;
      CGRect subRect = CGRectMake(offsetX, 0.0f, 
                                  imageSize.width - (2.0f * offsetX), 
                                  imageSize.height);
      subimage = CGImageCreateWithImageInRect([self CGImage], subRect);
   } else {
      // image width is smallest
      scale = newSize.width / imageSize.width;
      CGFloat offsetY = ((scale * imageSize.height - newSize.height) / 2.0f) / scale;
      CGRect subRect = CGRectMake(0.0f, offsetY, imageSize.width, 
                                  imageSize.height - (2.0f * offsetY));
      subimage = CGImageCreateWithImageInRect([self CGImage], subRect);
   }
   // scale the image
   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   CGContextRef context = CGBitmapContextCreate(NULL, newSize.width, 
                                                newSize.height, 8, 0, colorSpace, 
                                                kCGImageAlphaPremultipliedFirst); 
   CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
   CGRect rect = CGRectMake(0.0f, 0.0f, newSize.width, newSize.height);
   CGContextDrawImage(context, rect, subimage);
   CGContextFlush(context);
   // get the scaled image
   CGImageRef scaledImage = CGBitmapContextCreateImage(context);
   UIImage *result = [UIImage imageWithCGImage:scaledImage];
   CGContextRelease (context);
   CGImageRelease(scaledImage);
   CGImageRelease(subimage);

   return result;
}

@end
