//
//  WPSThumbView.m
//  HelloBaby
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "KTThumbView.h"
#import <QuartzCore/QuartzCore.h>


@implementation KTThumbView

@synthesize delegate = delegate_;

- (void)dealloc {
   
   [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
   if (self = [super initWithFrame:frame]) {
      [self addTarget:self
               action:@selector(didTouch:)
     forControlEvents:UIControlEventTouchUpInside];
   }
   return self;
}

- (void)didTouch:(id)sender {
   if (delegate_ && [delegate_ respondsToSelector:@selector(didSelectThumbAtIndex:)]) {
      [delegate_ didSelectThumbAtIndex:[self tag]];
   }
}

- (void)setThumbImage:(UIImage *)newImage {
   [self setImage:newImage forState:UIControlStateNormal];
}

@end
