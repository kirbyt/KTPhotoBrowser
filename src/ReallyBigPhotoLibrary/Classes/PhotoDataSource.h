//
//  PhotoDataSource.h
//  ReallyBigPhotoLibrary
//
//  Created by Kirby Turner on 9/14/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"


@interface PhotoDataSource : NSObject <KTPhotoBrowserDataSource>
{
   NSMutableArray *data_;
}

@end
