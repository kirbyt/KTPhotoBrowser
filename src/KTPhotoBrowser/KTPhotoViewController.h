//
//  KTPhotoViewController.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KTPhotoBrowserDataSource;
@class KTPhotoScrollViewController;
@class KTPhotoView;

@interface KTPhotoViewController : UIViewController {
   id <KTPhotoBrowserDataSource> dataSource_;
   KTPhotoScrollViewController *scroller_;
   NSInteger photoIndex_;
   KTPhotoView *imageView_;
}

@property (nonatomic) NSInteger photoIndex;
@property (nonatomic, assign) KTPhotoScrollViewController *scroller;

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource;

@end
