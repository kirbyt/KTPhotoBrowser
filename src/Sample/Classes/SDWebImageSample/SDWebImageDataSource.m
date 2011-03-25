//
//  SDWebImageDataSource.m
//  Sample
//
//  Created by Kirby Turner on 3/18/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import "SDWebImageDataSource.h"
#import "KTPhotoView+SDWebImage.h"
#import "KTThumbView+SDWebImage.h"

#define FULL_SIZE_INDEX 0
#define THUMBNAIL_INDEX 1

@implementation SDWebImageDataSource

- (void)dealloc {
   [images_ release], images_ = nil;
   [super dealloc];
}

- (id)init {
   self = [super init];
   if (self) {
      // Create a 2-dimensional array. First element of
      // the sub-array is the full size image URL and 
      // the second element is the thumbnail URL.
      images_ = [[NSArray alloc] initWithObjects:
                 [NSArray arrayWithObjects:@"http://farm5.static.flickr.com/4001/4439826859_19ba9a6cfa_o.jpg", @"http://farm5.static.flickr.com/4001/4439826859_4215c01a16_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm4.static.flickr.com/3427/3192205971_0f494a3da2_o.jpg", @"http://farm4.static.flickr.com/3427/3192205971_b7b18558db_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm2.static.flickr.com/1316/4722532733_6b73d00787_z.jpg", @"http://farm2.static.flickr.com/1316/4722532733_6b73d00787_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm2.static.flickr.com/1200/591574815_8a4a732d00_o.jpg", @"http://farm2.static.flickr.com/1200/591574815_29db79a63a_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm4.static.flickr.com/3610/3439180743_21b8799d82_o.jpg", @"http://farm4.static.flickr.com/3610/3439180743_b7b07df9d4_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm3.static.flickr.com/2721/4441122896_eec9285a67.jpg", @"http://farm3.static.flickr.com/2721/4441122896_eec9285a67_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm3.static.flickr.com/2734/4462272448_eeda644c04_o.jpg", @"http://farm3.static.flickr.com/2734/4462272448_5d659c536f_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm3.static.flickr.com/2760/4461918971_b190480c53_z.jpg", @"http://farm3.static.flickr.com/2760/4461918971_b190480c53_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5177/5541965370_fc5c3e30c1_z.jpg", @"http://farm6.static.flickr.com/5177/5541965370_fc5c3e30c1_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5099/5544635285_045fbda9f7_z.jpg", @"http://farm6.static.flickr.com/5099/5544635285_045fbda9f7_s.jpg", nil],

                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5181/5554192246_e7cf81fb00_z.jpg", @"http://farm6.static.flickr.com/5181/5554192246_e7cf81fb00_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5260/5554955879_01bfab9aeb_z.jpg", @"http://farm6.static.flickr.com/5260/5554955879_01bfab9aeb_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5051/5556628277_f883fa1078_z.jpg", @"http://farm6.static.flickr.com/5051/5556628277_f883fa1078_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5221/5554843179_2be90661ec_z.jpg", @"http://farm6.static.flickr.com/5221/5554843179_2be90661ec_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5030/5546017586_94da6b9c27_z.jpg", @"http://farm6.static.flickr.com/5030/5546017586_94da6b9c27_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5222/5556848624_5400841d38_z.jpg", @"http://farm6.static.flickr.com/5222/5556848624_5400841d38_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5013/5553303767_2dbc180914_z.jpg", @"http://farm6.static.flickr.com/5013/5553303767_2dbc180914_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5016/5549341045_ca70f83b6a_z.jpg", @"http://farm6.static.flickr.com/5016/5549341045_ca70f83b6a_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5060/5549231915_859c468676_z.jpg", @"http://farm6.static.flickr.com/5060/5549231915_859c468676_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5292/5547532792_57b59a9786_z.jpg", @"http://farm6.static.flickr.com/5292/5547532792_57b59a9786_s.jpg", nil],

                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5269/5555961464_18875648ce_z.jpg", @"http://farm6.static.flickr.com/5269/5555961464_18875648ce_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5099/5546705562_a59003f6ee_z.jpg", @"http://farm6.static.flickr.com/5099/5546705562_a59003f6ee_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5013/5540550656_bc2cb9f11e_z.jpg", @"http://farm6.static.flickr.com/5013/5540550656_bc2cb9f11e_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5300/5541641278_d74c34a3d6_z.jpg", @"http://farm6.static.flickr.com/5300/5541641278_d74c34a3d6_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5013/5540707992_bfd05eae3f_z.jpg", @"http://farm6.static.flickr.com/5013/5540707992_bfd05eae3f_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5018/5540479377_cf4f7fed07_z.jpg", @"http://farm6.static.flickr.com/5018/5540479377_cf4f7fed07_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5012/5539617805_6d1dd866a1_z.jpg", @"http://farm6.static.flickr.com/5012/5539617805_6d1dd866a1_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5298/5549141583_5811b90c39_z.jpg", @"http://farm6.static.flickr.com/5298/5549141583_5811b90c39_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5178/5543181781_5b2f127733_z.jpg", @"http://farm6.static.flickr.com/5178/5543181781_5b2f127733_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5029/5546482669_32a7f50f2e_z.jpg", @"http://farm6.static.flickr.com/5029/5546482669_32a7f50f2e_s.jpg", nil],

                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5291/5555545656_29e6104fe7_z.jpg", @"http://farm6.static.flickr.com/5291/5555545656_29e6104fe7_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5096/5556084853_8f91c0e0f4_z.jpg", @"http://farm6.static.flickr.com/5096/5556084853_8f91c0e0f4_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5310/5553370270_7f14ec94d8_z.jpg", @"http://farm6.static.flickr.com/5310/5553370270_7f14ec94d8_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5174/5539733424_1303522343_z.jpg", @"http://farm6.static.flickr.com/5174/5539733424_1303522343_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5190/5551470630_1bcb70e303_z.jpg", @"http://farm6.static.flickr.com/5190/5551470630_1bcb70e303_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5053/5546252265_76723297b6_z.jpg", @"http://farm6.static.flickr.com/5053/5546252265_76723297b6_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5066/5557813059_45c2b647e3_z.jpg", @"http://farm6.static.flickr.com/5066/5557813059_45c2b647e3_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5110/5558396988_e69fb927df_z.jpg", @"http://farm6.static.flickr.com/5110/5558396988_e69fb927df_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5023/5558364540_d118073c46_z.jpg", @"http://farm6.static.flickr.com/5023/5558364540_d118073c46_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5230/5557781153_afeb2e2955_o.jpg", @"http://farm6.static.flickr.com/5230/5557781153_49d9573357_s.jpg", nil],

                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5172/5557781215_c27fa24e32_o.jpg", @"http://farm6.static.flickr.com/5172/5557781215_bbedfa3df8_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5102/5557778597_a24f1ddbfd_z.jpg", @"http://farm6.static.flickr.com/5102/5557778597_a24f1ddbfd_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5264/5557768355_8d426b7989.jpg", @"http://farm6.static.flickr.com/5264/5557768355_8d426b7989_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5253/5557776163_c60ca33765_z.jpg", @"http://farm6.static.flickr.com/5253/5557776163_c60ca33765_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5014/5558304354_3a90b9d122_z.jpg", @"http://farm6.static.flickr.com/5014/5558304354_3a90b9d122_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm6.static.flickr.com/5058/5557683685_6dbce36153_z.jpg", @"http://farm6.static.flickr.com/5058/5557683685_6dbce36153_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm5.static.flickr.com/4049/4461687883_706e58af51_z.jpg?zz=1", @"http://farm5.static.flickr.com/4049/4461687883_706e58af51_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm5.static.flickr.com/4034/4461407363_4959f3f871_z.jpg?zz=1", @"http://farm5.static.flickr.com/4034/4461407363_4959f3f871_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm5.static.flickr.com/4046/4463617617_2b5d41c009_z.jpg", @"http://farm5.static.flickr.com/4046/4463617617_2b5d41c009_s.jpg", nil],
                 [NSArray arrayWithObjects:@"http://farm3.static.flickr.com/2756/4464013736_524526b2b2_z.jpg", @"http://farm3.static.flickr.com/2756/4464013736_524526b2b2_s.jpg", nil],

                 nil];
   }
   return self;
}


#pragma mark -
#pragma mark KTPhotoBrowserDataSource

- (NSInteger)numberOfPhotos {
   NSInteger count = [images_ count];
   return count;
}

- (void)imageAtIndex:(NSInteger)index photoView:(KTPhotoView *)photoView {
   NSArray *imageUrls = [images_ objectAtIndex:index];
   NSString *url = [imageUrls objectAtIndex:FULL_SIZE_INDEX];
   [photoView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}

- (void)thumbImageAtIndex:(NSInteger)index thumbView:(KTThumbView *)thumbView {
   NSArray *imageUrls = [images_ objectAtIndex:index];
   NSString *url = [imageUrls objectAtIndex:THUMBNAIL_INDEX];
   [thumbView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"photoDefault.png"]];
}


@end
