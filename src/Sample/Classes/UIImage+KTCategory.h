//
//  UIImageAdditions.h
//  HeyPeanut
//
//  Created by Kirby Turner on 2/7/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (WPSCategory)

- (UIImage *)scaleAndCropToMaxSize:(CGSize)newSize;

@end
