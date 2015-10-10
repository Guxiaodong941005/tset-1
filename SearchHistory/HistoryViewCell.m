//
//  HistoryViewCell.m
//  SearchHistory
//
//  Created by 植梧培 on 15/8/25.
//  Copyright (c) 2015年 机智的新手. All rights reserved.
//

#import "HistoryViewCell.h"
CGFloat heightForCell = 35;
@interface HistoryViewCell ()


@end
@implementation HistoryViewCell

- (void)awakeFromNib {
    // Initialization code
    self.clipsToBounds = YES;
    self.layer.cornerRadius = heightForCell / 2;
}

- (void)setKeyword:(NSString *)keyword {
    if (keyword.length > 6) {
       
        self.titleLabel.font = [UIFont systemFontOfSize:11];
    }if (keyword.length > 8) {
         self.titleLabel.font = [UIFont systemFontOfSize:9];
    }
    
    _keyword = keyword;
    _titleLabel.text = _keyword;
    [self layoutIfNeeded];
    [self updateConstraintsIfNeeded];
    
   
}
-(void)setColor:(UIColor *)color{

    self.layer.borderColor=color.CGColor;
    
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;

}

- (CGSize)sizeForCell {
   
    return CGSizeMake([_titleLabel sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + heightForCell, heightForCell);
}
@end
