//
//  RootViewController.h
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"

@class FlickrPhotosDataSource;

@interface RootViewController : KTThumbsViewController 
{
@private
   FlickrPhotosDataSource *photos_;
}

@end
