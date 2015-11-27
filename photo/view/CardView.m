//
//  CardView.m
//  photo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"
#import "UIImageView+WebCache.h"
#import "ProgressHUD.h"

@implementation CardView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

    // Corner Radius
    self.layer.cornerRadius = 10.0;
}
#pragma mark - set mothods
-(void)setG_photo:(photo *)g_photo{
    if (g_photo) {
        self.g_nickNameLable.text = g_photo.floor;
        self.g_contentLable.text = g_photo.content;
        [self.g_headImageView sd_setImageWithURL:[NSURL URLWithString:g_photo.imageurl] placeholderImage:[UIImage imageNamed:@"屏幕快照 2015-11-05 11.40.43.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        [self.g_contentImageView sd_setImageWithURL:[NSURL URLWithString:g_photo.imageurl] placeholderImage:[UIImage imageNamed:@"屏幕快照 2015-11-05 11.40.43.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }

}
- (IBAction)photoImgBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cardViewPhotoImgBtnClcik:andIndex:)]) {
        [self.delegate cardViewPhotoImgBtnClcik:sender andIndex:self.g_index];
    }
    
}
- (IBAction)personInfoBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cardViewPersonInfoBtnClcik:andIndex:)]) {
        [self.delegate cardViewPersonInfoBtnClcik:sender andIndex:self.g_index];
    }
    
}

#pragma mark - clickEvents

@end
