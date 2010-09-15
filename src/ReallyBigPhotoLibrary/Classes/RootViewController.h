//
//  RootViewController.h
//  ReallyBigPhotoLibrary
//
//  Created by Kirby Turner on 9/14/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"

@class PhotoDataSource;

@interface RootViewController : KTThumbsViewController 
{
   PhotoDataSource *data_;
}

@end
