//
//  PhotoList.h
//  HelloBaby
//
//  Created by Kirby Turner on 2/2/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PhotoList : NSObject {
   NSString *documentPath_;
   NSString *photoPath_;
   NSString *thumbnailPath_;
   
   // 2-dimensonal array. Contains 2-element array where the
   // first element is the photo path and the second element 
   // is the thumbnail path.
   NSMutableArray *photos_;
}

- (NSString *)documentPath;
- (NSString *)photoPath;
- (NSString *)thumbnailPath;
- (NSArray *)photos;
- (void)savePhoto:(UIImage *)photo withName:(NSString *)name addToPhotoAlbum:(BOOL)addToPhotoAlbum;

@end
