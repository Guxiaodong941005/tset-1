//
//  photoDetailViewController.m
//  photo
//
//  Created by gxd on 15/11/12.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import "photoDetailViewController.h"
#import "RDVTabBarController.h"
#import "UIImageView+WebCache.h"
@interface photoDetailViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *g_scrollView;

@end

@implementation photoDetailViewController
#pragma mark - viewLife cycle
- (void)viewDidLoad {
    [super viewDidLoad];
   
    __block  UIImageView * t_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.g_scrollView addSubview:t_imgView];
    [t_imgView setBackgroundColor:[UIColor redColor]];
    [t_imgView sd_setImageWithURL:[NSURL URLWithString:_g_photo.imageurl] placeholderImage:[UIImage imageNamed:@"屏幕快照 2015-11-05 11.40.43"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) {
            [t_imgView setImage:[UIImage imageNamed:@"屏幕快照 2015-11-05 11.40.43"]];
            image = [UIImage imageNamed:@"屏幕快照 2015-11-05 11.40.43"];
            t_imgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.g_scrollView.contentSize = image.size;
        }else{
            t_imgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            self.g_scrollView.contentSize = image.size;
        }
        
    }];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

}

#pragma mark - getter

@end
