//
//  KTPhotoBrowserGlobal.m
//  Sample
//
//  Created by Kirby Turner on 2/11/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTPhotoBrowserGlobal.h"


///////////////////////

NSString * KTPathForBundleResource(NSString *relativePath) {
   NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
   return [resourcePath stringByAppendingPathComponent:relativePath];
}

///////////////////////

UIImage * KTLoadImageFromBundle(NSString *imageName) {
   NSString *relativePath = [NSString stringWithFormat:@"KTPhotoBrowser.bundle/images/%@", imageName];
   NSString *path  = KTPathForBundleResource(relativePath);
   NSData *data = [NSData dataWithContentsOfFile:path];
   return [UIImage imageWithData:data];
}