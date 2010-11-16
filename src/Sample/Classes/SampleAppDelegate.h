//
//  SampleAppDelegate.h
//  Sample
//
//  Created by Kirby Turner on 2/8/10.
//  Copyright White Peak Software Inc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

