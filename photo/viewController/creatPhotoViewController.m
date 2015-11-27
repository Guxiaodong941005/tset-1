//
//  creatPhotoViewController.m
//  photo
//
//  Created by gxd on 15/11/12.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import "creatPhotoViewController.h"
#import "RDVTabBarController.h"
#import "extendMothods.h"
@interface creatPhotoViewController ()

@end

@implementation creatPhotoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self drawMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drawMainView{
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];
    NSMutableArray * t_arr = [NSMutableArray array];
    for (int i; i < 8; i++) {
        AwesomeMenuItem * starMenuItem = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil
                                          itemViewFrame:CGSizeMake(60, 60)];
        [t_arr addObject:starMenuItem];
    }
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:t_arr];
    //    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem menuItems:menuItems];
    menu.delegate = self;
    menu.startPoint = CGPointMake(MAINSCREEN.size.width/2, MAINSCREEN.size.height/2);
    [self.view addSubview:menu];
}
#pragma mark - AwesomeMenu delegate
- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx{
    NSLog(@"Select the index : %ld",(long)idx);
}

- (void)awesomeMenuDidFinishAnimationClose:(AwesomeMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)awesomeMenuDidFinishAnimationOpen:(AwesomeMenu *)menu {
    NSLog(@"Menu is open!");
}



@end
