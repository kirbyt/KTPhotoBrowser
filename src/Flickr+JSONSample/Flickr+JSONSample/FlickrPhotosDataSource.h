//
//  FlickrPhotosDataSource.h
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"


@interface FlickrPhotosDataSource : NSObject <KTPhotoBrowserDataSource>
{
@private
   NSArray *photos_;
}

- (void)fetchPhotos;

@end
