//
//  RootViewController.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"
#import "LocalImageRootViewController.h"
#import "SDWebImageRootViewController.h"
#import "FlickrRootViewController.h"


#define LOCAL_IMAGE_SAMPLE 0
#define FLICKR_SAMPLE 1
#define SDWEBIMAGE_SAMPLE 2

@implementation RootViewController

@synthesize window = window_;

- (void)dealloc 
{
   [super dealloc];
}

- (void)viewDidLoad 
{
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

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
   return YES;
}


#pragma mark -
#pragma mark Show Samples

- (void)showLocalImageSample 
{
   LocalImageRootViewController *newController = [[LocalImageRootViewController alloc] init];
   [[self navigationController] pushViewController:newController
                                          animated:YES];
   [newController release]; 
}

- (void)showSDWebImageSample 
{
   SDWebImageRootViewController *newController = [[SDWebImageRootViewController alloc] init];
   [[self navigationController] pushViewController:newController animated:YES];
   [newController release];
}

- (void)showFlickrSample 
{
   FlickrRootViewController *newController = [[FlickrRootViewController alloc] init];
   [[self navigationController] pushViewController:newController animated:YES];
   [newController release];
}



#pragma mark -
#pragma mark TableView Events

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section 
{
   return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
   
   static NSString *CellIdentifier = @"RootViewControllerCellCache";
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   if(cell == nil) {
      cell = [[[UITableViewCell alloc]
               initWithStyle: UITableViewCellStyleSubtitle
               reuseIdentifier:CellIdentifier] autorelease];
      [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
   }

   switch ([indexPath row]) {
      case LOCAL_IMAGE_SAMPLE:
         [[cell textLabel] setText:@"Local Image Sample"];
         [[cell detailTextLabel] setText:@"Images stored locally, with add/remove."];
         break;
      case SDWEBIMAGE_SAMPLE:
         [[cell textLabel] setText:@"SDWebImage Sample"];
         [[cell detailTextLabel] setText:@"Web images, asynchronous with cache."];
         break;
      case FLICKR_SAMPLE:
         [[cell textLabel] setText:@"Flickr Sample"];
         [[cell detailTextLabel] setText:@"Web images, synchronous with cache."];
         break;
   }
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
   switch ([indexPath row]) {
      case LOCAL_IMAGE_SAMPLE:
         [self showLocalImageSample];
         break;
      case SDWEBIMAGE_SAMPLE:
         [self showSDWebImageSample];
         break;
      case FLICKR_SAMPLE:
         [self showFlickrSample];
         break;
   }
   [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES]; 
}


@end
