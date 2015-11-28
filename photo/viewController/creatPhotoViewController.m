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
  
    NSMutableArray * t_arr = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
          UIImage *starImage = [self getImageFromColor:nil];
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

#pragma mark - private mothods
- (UIImage *)getImageFromColor:(UIColor *)color{
    color = [self randomColor];
    CGRect rect = CGRectMake(0, 0, 60, 60);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
-(UIColor *)randomColor{
     CGFloat hue = ( arc4random() % 256 / 256.0 );  //0.0 to 1.0

     CGFloat saturation = (arc4random() % 128 / 256.0 ) + 0.5;  // 0.5 to 1.0,away from white

     CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //0.5 to 1.0,away from black

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f];
}
@end
