//
//  KTReusableThumbsView.m
//  Sample
//
//  Created by Constantine Fry on 2/9/11.
//  Copyright 2011 Home. All rights reserved.
//

#import "KTReusableThumbsView.h"
#import "KTThumbView.h"
#import "KTThumbViewCell.h"

@implementation KTReusableThumbsView
@synthesize controller = controller_;

- (id)initWithFrame:(CGRect)frame  
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        table_ = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        table_.delegate = self;
        table_.dataSource = self;
        table_.allowsSelection  = NO;
        table_.separatorStyle = UITableViewCellSeparatorStyleNone;
        table_.backgroundColor = [UIColor clearColor];
        [table_ setContentInset:UIEdgeInsetsMake(50,0,0,0)];
        [table_ setScrollIndicatorInsets:UIEdgeInsetsMake(50,0,0,0)];
        [self addSubview:table_];
        [table_ release];
    }
    return self;
}

-(void)reload{
    [table_ reloadData];
}

- (void)setDataSource:(id <KTPhotoBrowserDataSource>)newDataSource{
    dataSource_ = newDataSource;
    
    int viewWidth = self.bounds.size.width;
    thumbnailWidth = 75.0;
    thumbnailHeight = 75.0;
    if ([dataSource_ respondsToSelector:@selector(thumbSize)]) {
        CGSize customThumbSize = [dataSource_ thumbSize];
        thumbnailWidth = customThumbSize.width;
        thumbnailHeight = customThumbSize.height;
    }
    
    
    thumbsHaveBorder = YES;
    if ([dataSource_ respondsToSelector:@selector(thumbsHaveBorder)]) {
        thumbsHaveBorder = [dataSource_ thumbsHaveBorder];
    }
    
    if ([dataSource_ respondsToSelector:@selector(thumbsPerRow)]) {
        itemsPerRow_ = [dataSource_ thumbsPerRow];
    } else { 
        itemsPerRow_ = floor(viewWidth / thumbnailWidth);
    }
    
    CGFloat spaceWidth = roundf((viewWidth - thumbnailWidth * itemsPerRow_) / (itemsPerRow_ + 1));
    CGFloat spaceHeight = spaceWidth/2;
    table_.rowHeight = thumbnailHeight + spaceHeight*2;
    spaceSize = CGSizeMake(spaceWidth, spaceHeight);
    thumbSize = CGSizeMake(thumbnailWidth,thumbnailHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int a = [dataSource_ numberOfPhotos]%itemsPerRow_;
    if (a) {
        return [dataSource_ numberOfPhotos]/itemsPerRow_ +1;
    }
    return [dataSource_ numberOfPhotos]/itemsPerRow_;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KTThumbViewCell *cell = (KTThumbViewCell*)
    [tableView dequeueReusableCellWithIdentifier:[KTThumbViewCell reuseIdentifier]];
    if (cell == nil) {

        cell = [[[KTThumbViewCell alloc]initWithThumbSize:thumbSize
                                                spaceSize:spaceSize
                                                   perRow:itemsPerRow_
                                               withBorder:thumbsHaveBorder
                                           withController:controller_] autorelease];
    }
    
    int startIndex = indexPath.row * itemsPerRow_;
    int stopIndex = startIndex + itemsPerRow_;
    if (stopIndex > [dataSource_ numberOfPhotos]) {
        stopIndex = [dataSource_ numberOfPhotos];   
    }
    
    
    for (int i = startIndex; i< stopIndex; i++) {
        KTThumbView *thumbView = [cell.thumbs objectAtIndex:i-startIndex];
        [thumbView setTag:i];
        
        if ([dataSource_ respondsToSelector:@selector(thumbImageAtIndex:thumbView:)] == NO) {
            UIImage *thumbImage = [dataSource_ thumbImageAtIndex:i];
            [thumbView setThumbImage:thumbImage];
        } else {
            [dataSource_ thumbImageAtIndex:i thumbView:thumbView];
        }
    }
    
    return cell;
}

- (void)dealloc
{
    [super dealloc];
}

@end
