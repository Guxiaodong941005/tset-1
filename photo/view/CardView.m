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
#pragma mark - view life cycle
-(void)layoutSubviews{
    [super layoutSubviews];
    self.asImageView.frame = self.g_contentView.bounds;
    self.asHandimageView.frame = self.g_headView.bounds;
    
}
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
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoImgBtnClick:)];
    tap.numberOfTapsRequired = 1;
    [self.g_contentView addGestureRecognizer:tap];
    [self.g_headView addGestureRecognizer:tap];
    [self.g_contentView.layer addSublayer:self.placeHolderLayer];
    
}
#pragma mark - set mothods
-(void)setG_photo:(photo *)g_photo{
    if (g_photo) {
        self.g_nickNameLable.text = g_photo.floor;
        self.g_contentLable.text = g_photo.content;
        [self.g_contentImageView sd_setImageWithURL:[NSURL URLWithString:g_photo.imageurl] placeholderImage:[UIImage imageNamed:@"屏幕快照 2015-11-05 11.40.43.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.asImageView.image = image;
            
            [self.g_contentView.layer addSublayer:self.asImageView.layer];
            
        }];
       
    }

}
#pragma mark - Gesture mothods
- (void)photoImgBtnClick:(UITapGestureRecognizer *)sender {
    BOOL isContentView = self.g_contentView.frame.size.width > 80 ? YES:NO;
    
    if (isContentView) {
        if ([self.delegate respondsToSelector:@selector(cardViewPhotoImgBtnClcik:andIndex:)]) {
            [self.delegate cardViewPhotoImgBtnClcik:sender.view andIndex:self.g_index];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(cardViewPersonInfoBtnClcik:andIndex:)]) {
            [self.delegate cardViewPersonInfoBtnClcik:sender.view andIndex:self.g_index];
        }
        
    }
}
- (void)personInfoBtnClick:(UITapGestureRecognizer *)sender {
    
}
#pragma mark - getter

-(ASImageNode *)asImageView{
    if (!_asImageView) {
        _asImageView = [[ASImageNode alloc] init];
    }
    return _asImageView;
}
-(ASImageNode *)asHandimageView{
    if (_asHandimageView) {
        _asHandimageView = [[ASImageNode alloc] init];
    }
    return _asHandimageView;
}
-(CALayer *)placeHolderLayer{
    if (!_placeHolderLayer) {
        _placeHolderLayer = [[CALayer alloc] init];
        UIImage * t_img = [UIImage imageNamed:@"屏幕快照 2015-11-05 11.40.43.png"];
        _placeHolderLayer.contents = (id)t_img.CGImage;
        _placeHolderLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _placeHolderLayer;
}
-(UIImageView *)g_contentImageView{
    if (!_g_contentImageView) {
        _g_contentImageView = [[UIImageView alloc] init];
    }
    return _g_contentImageView;
}
-(UIImageView *)g_headImageView{
    if (!_g_headImageView) {
        _g_headImageView = [[UIImageView alloc] init];
    }
    return _g_headImageView;
}
@end
