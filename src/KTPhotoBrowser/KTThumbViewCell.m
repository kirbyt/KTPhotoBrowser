//
//  KTThumbViewCell.m
//  Sample
//
//  Created by Constantine Fry on 2/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "KTThumbViewCell.h"
#import "KTThumbView.h"


@implementation KTThumbViewCell
@synthesize thumbs = _thumbs;

static NSString *s = @"thumbs";
+(NSString*)reuseIdentifier{
    return  s;
}

- (id)initWithThumbSize:(CGSize)thumbSize
              spaceSize:(CGSize)spaceSize
                 perRow:(int)perRow
             withBorder:(BOOL)thumbsHaveBorder
         withController:(KTThumbsViewController*)ctrl
{
    self = [super initWithStyle:UITableViewCellStyleDefault 
                reuseIdentifier:[KTThumbViewCell reuseIdentifier]];
    if (self) {
        _thumbs = [[NSMutableArray alloc] initWithCapacity:perRow];
        for (int i = 0; i<=perRow; i++) {
            KTThumbView *thumbView = [[KTThumbView alloc] initWithFrame:
                                      CGRectMake((i+ 1)*spaceSize.width+ i*thumbSize.width, 
                                                 spaceSize.height,
                                                 thumbSize.width, 
                                                 thumbSize.height) 
                                                           andHasBorder:thumbsHaveBorder];
            [thumbView setController:ctrl];
            [_thumbs addObject:thumbView];
            [self.contentView addSubview:thumbView];
            [thumbView release];
        }
        
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    [_thumbs release];
    [super dealloc];
}

@end
