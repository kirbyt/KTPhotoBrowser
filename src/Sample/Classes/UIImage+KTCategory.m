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

   CGFloat offsetX = 0;
   CGFloat offsetY = 0;

   // Crop the image based on the new size aspect ratio.
   CGSize imageSize = [self size];
   if (imageSize.width < imageSize.height) {
      offsetY = (imageSize.height / 2) - (imageSize.width / 2);
   } else {
      offsetX = (imageSize.width / 2) - (imageSize.height / 2);
   }

   CGRect cropRect = CGRectMake(offsetX, offsetY,
                                imageSize.width - (offsetX * 2),
                                imageSize.height - (offsetY * 2));

   CGImageRef croppedImageRef = CGImageCreateWithImageInRect([self CGImage], cropRect);

   // Draw a scaled version of the image.
   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   CGContextRef context = CGBitmapContextCreate(NULL, 
                                                newSize.width,
                                                newSize.height,
                                                8, 0, colorSpace,
                                                kCGImageAlphaPremultipliedFirst);
   CGColorSpaceRelease(colorSpace);

   switch ([self imageOrientation]) {
      case UIImageOrientationDown:
         CGContextTranslateCTM(context, newSize.width, newSize.height);
         CGContextRotateCTM(context, 180 * (M_PI/180));
         break;
      case UIImageOrientationLeft:
         CGContextTranslateCTM(context, newSize.height, 0);
         CGContextRotateCTM(context, 90 * (M_PI/180));
         break;
      case UIImageOrientationRight:
         CGContextTranslateCTM(context, 0, newSize.width);
         CGContextRotateCTM(context, -90 * (M_PI/180));
         break;
      default:
         break;
   }
   
   CGContextDrawImage(context, CGRectMake(0, 0, newSize.width, newSize.height), croppedImageRef);
   CGContextFlush(context);
   CGImageRef scaledImageRef = CGBitmapContextCreateImage(context);
   CGContextRelease(context);

   UIImage *newImage = [UIImage imageWithCGImage:scaledImageRef];
   
   CGImageRelease(croppedImageRef);
   CGImageRelease(scaledImageRef);
   
   return newImage;
}

@end
