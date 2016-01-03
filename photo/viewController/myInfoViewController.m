//
//  myInfoViewController.m
//  photo
//
//  Created by gxd on 15/11/12.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import "myInfoViewController.h"
#import "RDVTabBarController.h"
#import "UIImageView+WebCache.h"
@interface myInfoViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imgview;
@end

@implementation myInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.imgview sd_setImageWithURL:[NSURL URLWithString:@"http://imgsrc.baidu.com/forum/w%3D580/sign=1cabbf10e8c4b7453494b71efffd1e78/79f40ad162d9f2d341d21dd6aaec8a136227ccc3.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
