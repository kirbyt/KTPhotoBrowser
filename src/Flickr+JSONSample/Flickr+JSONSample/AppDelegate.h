//
//  Flickr_JSONSampleAppDelegate.h
//  Flickr+JSONSample
//
//  Created by Kirby Turner on 3/5/11.
//  Copyright 2011 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : NSObject <UIApplicationDelegate> 
{
@private
   UIWindow *window_;
   UINavigationController *navController_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
