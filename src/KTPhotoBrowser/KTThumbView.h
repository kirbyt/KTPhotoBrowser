//
//  KTThumbView.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTThumbsViewController;

@interface KTThumbView : UIButton {
   KTThumbsViewController *controller_;
}

@property (nonatomic, assign) KTThumbsViewController *controller;

- (id)initWithFrame:(CGRect)frame andHasBorder:(BOOL)hasBorder;
- (void)setThumbImage:(UIImage *)newImage;

@end

