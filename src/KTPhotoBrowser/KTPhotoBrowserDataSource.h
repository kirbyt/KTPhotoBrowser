//
//  KTPhotoBrowserDataSource.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/7/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KTPhotoView;
@class KTThumbView;

@protocol KTPhotoBrowserDataSource <NSObject>
@required
- (NSInteger)numberOfPhotos;

@optional
- (void)deleteImageAtIndex:(NSInteger)index;
- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView;
- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView;
- (CGSize)thumbSize;
- (NSInteger)thumbsPerRow;

@end
