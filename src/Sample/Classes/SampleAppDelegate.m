//
//  SampleAppDelegate.m
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright White Peak Software Inc 2010. All rights reserved.
//

#import "SampleAppDelegate.h"
#import "RootViewController.h"

@implementation SampleAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    

   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
   
   RootViewController *newController = [[RootViewController alloc] initWithWindow:window];
   UINavigationController *newNavController = [[UINavigationController alloc] initWithRootViewController:newController];
   [[newNavController navigationBar] setBarStyle:UIBarStyleBlack];
   [[newNavController navigationBar] setTranslucent:YES];
   [newController release];

   [window addSubview:[newNavController view]];
   
   
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
