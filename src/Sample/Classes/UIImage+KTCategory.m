//
//  UIImageAdditions.m
//  Sample
//
//  Created by Kirby Turner on 2/7/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "UIImage+KTCategory.h"


@implementation UIImage (KTCategory)

- (UIImage *)imageScaleAspectToMaxSize:(CGFloat)newSize {
   CGSize size = [self size];
   CGFloat ratio;
   if (size.width > size.height) {
      ratio = newSize / size.width;
   } else {
      ratio = newSize / size.height;
   }
   
   CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
   UIGraphicsBeginImageContext(rect.size);
   [self drawInRect:rect];
   UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
   return scaledImage;
}

- (UIImage *)imageScaleAndCropToMaxSize:(CGSize)newSize {
   CGFloat largestSize = (newSize.width > newSize.height) ? newSize.width : newSize.height;
   CGSize imageSize = [self size];
   
   // Scale the image while mainting the aspect and making sure the 
   // the scaled image is not smaller then the given new size. In
   // other words we calculate the aspect ratio using the largest
   // dimension from the new size and the small dimension from the
   // actual size.
   CGFloat ratio;
   if (imageSize.width > imageSize.height) {
      ratio = largestSize / imageSize.height;
   } else {
      ratio = largestSize / imageSize.width;
   }
   
   CGRect rect = CGRectMake(0.0, 0.0, ratio * imageSize.width, ratio * imageSize.height);
   UIGraphicsBeginImageContext(rect.size);
   [self drawInRect:rect];
   UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
   
   // Crop the image to the requested new size maintaining
   // the inner most parts of the image.
   CGFloat offsetX = 0;
   CGFloat offsetY = 0;
   if (imageSize.width < imageSize.height) {
      offsetY = (imageSize.height / 2) - (imageSize.width / 2);
   } else {
      offsetX = (imageSize.width / 2) - (imageSize.height / 2);
   }
   
   CGRect cropRect = CGRectMake(offsetX, offsetY,
                                imageSize.width - (offsetX * 2),
                                imageSize.height - (offsetY * 2));
   
   CGImageRef croppedImageRef = CGImageCreateWithImageInRect([scaledImage CGImage], cropRect);
   UIImage *newImage = [UIImage imageWithCGImage:croppedImageRef];
   CGImageRelease(croppedImageRef);
   
   return newImage;
}

- (UIImage *)old_imageScaleAndCropToMaxSize:(CGSize)newSize {

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
