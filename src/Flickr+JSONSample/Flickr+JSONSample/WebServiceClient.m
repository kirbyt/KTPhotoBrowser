//
//  WebServiceClient.m
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "WebServiceClient.h"


@implementation WebServiceClient

+ (NSData *)fetchResponseWithURL:(NSURL *)URL
{
   NSURLRequest *request = [NSURLRequest requestWithURL:URL];
   NSURLResponse *response = nil;
   NSError *error = nil;
   NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
   return data;
}

@end
