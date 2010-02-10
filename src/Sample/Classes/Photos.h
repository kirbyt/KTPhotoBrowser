//
//  Photos.h
//  Sample
//
//  Created by Kirby Turner on 2/10/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"

@interface Photos : NSObject <KTPhotoBrowserDataSource> {
   NSString *documentPath_;
   NSString *photosPath_;
   NSString *thumbnailsPath_;
   
   NSArray *fileNames_;
   NSMutableDictionary *photoCache_;
   NSMutableDictionary *thumbnailCache_;
}

- (void)flushCache;
- (void)savePhoto:(UIImage *)photo withName:(NSString *)name addToPhotoAlbum:(BOOL)addToPhotoAlbum;

@end
