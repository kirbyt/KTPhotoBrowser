//
//  SampleAppDelegate.m
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright White Peak Software Inc 2010. All rights reserved.
//

#import "SampleAppDelegate.h"

@implementation SampleAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
