//
//  WebServiceClient.h
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WebServiceClient : NSObject 
{
    
}

+ (NSData *)fetchResponseWithURL:(NSURL *)URL;

@end
