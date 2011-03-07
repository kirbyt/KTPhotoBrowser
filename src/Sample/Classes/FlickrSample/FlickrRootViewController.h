//
//  SDWebImageRootViewController.h
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"

@class FlickrDataSource;

@interface FlickrRootViewController : KTThumbsViewController 
{
@private
   FlickrDataSource *images_;
   UIActivityIndicatorView *activityIndicator_;
}


@end
