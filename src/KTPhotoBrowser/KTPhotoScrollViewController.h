//
//  KTPhotoScrollViewController.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/4/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTPhotoViewController;
@protocol KTPhotoBrowserDataSource;

@interface KTPhotoScrollViewController : UIViewController<UIScrollViewDelegate> {
   id <KTPhotoBrowserDataSource> dataSource_;
   UIScrollView *scrollView_;
   NSUInteger startWithIndex_;
   
   KTPhotoViewController *currentPhoto_;
   KTPhotoViewController *nextPhoto_;
}

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index;

@end
