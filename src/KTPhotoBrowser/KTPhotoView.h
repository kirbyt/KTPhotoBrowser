//
//  KTPhotoView.h
//  Sample
//
//  Created by Kirby Turner on 2/24/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KTPhotoView : UIScrollView <UIScrollViewDelegate>
{
   UIImageView *imageView_;
}

- (void)setImage:(UIImage *)newImage;
- (void)turnOffZoom;

@end
