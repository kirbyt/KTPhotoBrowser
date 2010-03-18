//
//  RootViewController.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "LocalImageRootViewController.h"


@implementation RootViewController

@synthesize window = window_;

- (void)dealloc {
   [super dealloc];
}

- (void)viewDidLoad {
   [super viewDidLoad];
   
   [self setTitle:@"Samples"];
   
   UITableView *tableView = (UITableView*)[self view];
   [tableView setDelegate:self];
   [tableView setDataSource:self];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Show Samples

- (void)showLocalImageSample {
   LocalImageRootViewController *newController = [[LocalImageRootViewController alloc] initWithWindow:window_];
   [[self navigationController] pushViewController:newController
                                          animated:YES];
   [newController release]; 
}



#pragma mark -
#pragma mark TableView Events

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
   return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
   static NSString *CellIdentifier = @"RootViewControllerCellCache";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if(cell == nil) {
      cell = [[[UITableViewCell alloc]
               initWithStyle: UITableViewCellStyleValue1 
               reuseIdentifier:CellIdentifier] autorelease];
      [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
   }

   switch ([indexPath row]) {
      case 0:
         [[cell textLabel] setText:@"Local Image Sample"];
         break;
      case 1:
         [[cell textLabel] setText:@"Web Image Sample using SDWebImage"];
         break;
   }
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   switch ([indexPath row]) {
      case 0:
         [self showLocalImageSample];
         break;
   }
   [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES]; 
}


@end
