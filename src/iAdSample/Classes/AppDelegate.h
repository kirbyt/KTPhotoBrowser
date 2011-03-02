//
//  iAdSampleAppDelegate.h
//  iAdSample
//
//  Created by Kirby Turner on 3/2/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> 
{
   UIWindow *window_;
   UINavigationController *navController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

