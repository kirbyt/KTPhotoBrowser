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

@interface KTPhotoScrollViewController : UIViewController<UIScrollViewDelegate, UIActionSheetDelegate> {
   id <KTPhotoBrowserDataSource> dataSource_;
   UIScrollView *scrollView_;
   UIToolbar *toolbar_;
   NSUInteger startWithIndex_;
   NSInteger pageCount_;
   
   KTPhotoViewController *currentPhoto_;
   KTPhotoViewController *nextPhoto_;
   
   UIStatusBarStyle statusBarStyle_;
   UIBarStyle navigationBarStyle_;
   BOOL translucent_;   // for the navigation and toolbars.
   BOOL statusbarHidden_; // Determines if statusbar is hidden at initial load. In other words, statusbar remains hidden when toggling chrome.
   BOOL isChromeHidden_;
}

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) UIBarStyle navigationBarStyle;
@property (nonatomic, assign, getter=isTranslucent) BOOL translucent;
@property (nonatomic, assign, getter=isStatusbarHidden) BOOL statusbarHidden;

- (id)initWithDataSource:(id <KTPhotoBrowserDataSource>)dataSource andStartWithPhotoAtIndex:(NSUInteger)index;
- (void)toggleChromeDisplay;

@end
