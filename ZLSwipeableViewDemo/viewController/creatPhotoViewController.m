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
    
    // Default Menu
    AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem4 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem5 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem6 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
    AwesomeMenuItem *starMenuItem7 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                           highlightedImage:storyMenuItemImagePressed
                                                               ContentImage:starImage
                                                    highlightedContentImage:nil];
        AwesomeMenuItem *starMenuItem8 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
        AwesomeMenuItem *starMenuItem9 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed
                                                                   ContentImage:starImage
                                                        highlightedContentImage:nil];
    
    NSArray *menuItems = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5,starMenuItem6,starMenuItem7, nil];
    
    //    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc] initWithImage:[UIImage imageNamed:@"bg-addbutton.png"]
    //                                                       highlightedImage:[UIImage imageNamed:@"bg-addbutton-highlighted.png"]
    //                                                           ContentImage:[UIImage imageNamed:@"icon-plus.png"]
    //                                                highlightedContentImage:[UIImage imageNamed:@"icon-plus-highlighted.png"]];
    
    
    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds menus:menuItems];
    //    AwesomeMenu *menu = [[AwesomeMenu alloc] initWithFrame:self.view.bounds startItem:startItem menuItems:menuItems];
    menu.delegate = self;
    menu.startPoint = CGPointMake(MAINSCREEN.size.width/2, MAINSCREEN.size.height/2);
    
    

     
    
    
    [self.view addSubview:menu];
}

/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
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
