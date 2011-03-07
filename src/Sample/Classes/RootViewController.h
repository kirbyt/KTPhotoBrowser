//
//  RootViewController.h
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> 
{
@private
   UIWindow *window_;
}

@property (nonatomic, assign) UIWindow *window;

@end
