//
//  PhotoPickerController.m
//  Sample
//
//  Created by Kirby Turner on 2/2/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "PhotoPickerController.h"

#define BUTTON_TAKEPHOTO 0
#define BUTTON_USELIBRARY 1
#define BUTTON_CANCEL 2

@interface PhotoPickerController (Private)
- (UIImagePickerController *)imagePicker;
- (id)popoverController;
- (void)showWithCamera;
- (void)showWithPhotoLibrary;
@end

@implementation PhotoPickerController

- (void)dealloc {
   [imagePicker_ release], imagePicker_ = nil;
   [popoverController_ release], popoverController_ = nil;
   
   [super dealloc];
}

- (id)initWithDelegate:(id)delegate {
   self = [super init];
   if (self) {
      delegate_ = delegate;
   }
   return self;
}

- (void)show {
   // If the camera is supported on the device then prompt user to select
   // camera or photo library. If camera is not support then go straight
   // to the photo library.
   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
      UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel button text.")
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:NSLocalizedString(@"Take Photo", @"Take Photo button text."), 
                                                                        NSLocalizedString(@"Choose From Library", @"Button text."), 
                                                                        nil];
      if ([delegate_ respondsToSelector:@selector(view)]) {
         [actionSheet showInView:[delegate_ view]];
      }
   } else {
      [self showWithPhotoLibrary];
   }
}

- (void)showImagePicker {
   // Check for popover class. Use it if available and device is an iPad
   // otherwise show it the old fashion way.
   Class popoverControllerClass = NSClassFromString(@"UIPopoverController");
   if (popoverControllerClass && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      UIBarButtonItem *button = [[delegate_ navigationItem] rightBarButtonItem];
      [[self popoverController] presentPopoverFromBarButtonItem:button 
                                       permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                       animated:YES];
   } else {
      if ([delegate_ respondsToSelector:@selector(presentModalViewController:animated:)]) {
         [delegate_ presentModalViewController:imagePicker_ animated:YES];
      }
   }
}

- (void)showWithCamera {
   isFromCamera_ = YES;
   [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypeCamera];
   
   [self showImagePicker];
}

- (void)showWithPhotoLibrary {
   isFromCamera_ = NO;
   [[self imagePicker] setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
   [self showImagePicker];
}

- (UIImagePickerController *)imagePicker {
   if (imagePicker_) {
      return imagePicker_;
   }
   
   imagePicker_ = [[UIImagePickerController alloc] init];
   [imagePicker_ setDelegate:self];
   [imagePicker_ setAllowsEditing:NO];
   return imagePicker_;
}

- (id)popoverController {
   if (popoverController_) {
      return popoverController_;
   }
   
   Class popoverControllerClass = NSClassFromString(@"UIPopoverController");
   if (popoverControllerClass && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      popoverController_ = [[popoverControllerClass alloc] initWithContentViewController:[self imagePicker]];
   }
   
   return popoverController_;
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
   [picker dismissModalViewControllerAnimated:YES];

   UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
   if ([delegate_ respondsToSelector:@selector(photoPickerController:didFinishPickingWithImage:isFromCamera:)]) {
      [delegate_ photoPickerController:self didFinishPickingWithImage:newImage isFromCamera:isFromCamera_];
   }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
   switch (buttonIndex) {
      case BUTTON_TAKEPHOTO:
         [self showWithCamera];
         break;
      case BUTTON_USELIBRARY:
         [self showWithPhotoLibrary];
         break;
      case BUTTON_CANCEL:
         // Do nothing.
         break;
      default:
#ifdef DEBUG
         NSLog(@"Unexpected button index.");
#endif
         break;
   }
}


@end
