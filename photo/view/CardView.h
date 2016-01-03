//
//  CardView.h
//  photo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "photo.h"
#import "IndexAndDirection.h"
#import "AsyncDisplayKit.h"
@class CardView;
@protocol CardViewDelegate <NSObject>

@required
-(void)cardViewPhotoImgBtnClcik:(UIView *)sender andIndex:(NSInteger )index;
-(void)cardViewPersonInfoBtnClcik:(UIView *)sender andIndex:(NSInteger )index;
@end
@interface CardView : UIView
@property (strong, nonatomic) IBOutlet UIView *g_contentView;
@property (strong, nonatomic) IBOutlet UIView *g_headView;

@property (strong, nonatomic)  UIImageView *g_contentImageView;
@property (strong, nonatomic)  UIImageView *g_headImageView;

@property (strong, nonatomic) IBOutlet UILabel *g_nickNameLable;
@property (strong, nonatomic) IBOutlet UILabel *g_contentLable;

@property (strong , nonatomic) photo * g_photo;
@property (strong , nonatomic) IndexAndDirection * iAd;

@property (nonatomic ,weak) id<CardViewDelegate>delegate;
@property (nonatomic ,assign) NSInteger g_index;// 记录当前view是顺序

@property (strong , nonatomic) ASImageNode * asImageView;
@property (strong , nonatomic) ASImageNode * asHeadimageView;
@property (strong , nonatomic) CALayer * placeHolderLayer;
@property (strong , nonatomic) CardView * cardview;
-(CardView *)getCardViewFromdequeueReusableView;
@end
