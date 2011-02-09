//
//  KTThumbViewCell.h
//  FanApp
//
//  Created by Constantine Fry on 2/9/11.
//  Copyright 2011 FanTrail. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KTThumbsViewController;
@interface KTThumbViewCell : UITableViewCell {
    NSMutableArray *_thumbs;
//    CGSize spaceSize;
}

+(NSString*)reuseIdentifier;

@property (nonatomic,readonly)NSArray * thumbs;
- (id)initWithThumbSize:(CGSize)thumbSize
              spaceSize:(CGSize)spaceSize
                 perRow:(int)perRow
             withBorder:(BOOL)thumbsHaveBorder
         withController:(KTThumbsViewController*)ctrl;

@end
