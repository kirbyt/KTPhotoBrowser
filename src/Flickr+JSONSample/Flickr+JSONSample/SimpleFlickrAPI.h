//
//  SimpleFlickrAPI.h
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleFlickrAPI : NSObject {
    
}

- (NSDictionary *)photoSetListWithUserId:(NSString *)userId;   // userId is the Flickr NSID of the user.
- (NSDictionary *)photosWithPhotoSetId:(NSString *)photoSetId;

@end
