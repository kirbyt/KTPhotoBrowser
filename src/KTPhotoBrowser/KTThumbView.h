//
//  KTThumbView.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KTThumbViewDelegate;

@interface KTThumbView : UIButton {
   id delegate_;
}

@property (nonatomic, assign) id delegate;

- (void)setThumbImage:(UIImage *)newImage;

@end


@protocol KTThumbViewDelegate <NSObject>
@optional
- (void)didSelectThumbAtIndex:(NSUInteger)index;
@end
