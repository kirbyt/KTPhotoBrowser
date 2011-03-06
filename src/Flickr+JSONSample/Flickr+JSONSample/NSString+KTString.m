//
//  NSString+KTString.m
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/6/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import "NSString+KTString.h"


@implementation NSString (NSString_KTString)

+ (NSString *)stringWithData:(NSData *)data
{
   NSString *result = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
   return [result autorelease];
}

@end
