//
//  mainViewController.m
//  photo
//
//  Created by gxd on 15/11/12.
//  Copyright © 2015年 Zhixuan Lai. All rights reserved.
//

#import "mainViewController.h"
#import "ZLSwipeableView.h"
#import "CardView.h"
#import "IndexAndDirection.h"
#import "UIImageView+WebCache.h"
#import "extendMothods.h"
#import "AFNetworking.h"
#import "photoDetailViewController.h"
#import "RDVTabBarController.h"
#import "PhotoNetWork.h"
#import "ProgressHUD.h"
#define Lift @"左"
#define Right @"右"

@interface mainViewController ()<
ZLSwipeableViewDataSource,
ZLSwipeableViewDelegate,
UIActionSheetDelegate,
CardViewDelegate>
@property (strong, nonatomic) IBOutlet ZLSwipeableView *swipeableView;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;
@property (strong , nonatomic) NSMutableArray * g_dataArray;
@end

@implementation mainViewController

#pragma mark - viewLife cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.swipeableView.delegate = self;
    self.swipeableView.dataSource = self;
    [self getdata];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
}
-(void)viewDidAppear:(BOOL)animated{
// 判断是否是第一次加载本页面
    if (!judgeIsFirstLoadMainView()) {
//        [self.swipeableView reloadData];
        WhichKind t_kind = isBOOL;
        setNSUserDefaults(@"IsFirstLoadMainView", t_kind, @"1");
         self.swipeableView.center = CGPointMake(self.swipeableView.center.x, self.swipeableView.center.y + 20);
    }

}
-(void)viewWillDisappear:(BOOL)animated{
   

}
-(void)viewDidDisappear:(BOOL)animated{

}
#pragma mark - data Helper
-(void)updateDataWithIndexAndDirection:(IndexAndDirection *)t_Iad{
    if ([t_Iad.g_direction isEqualToString:Lift]) {
        // 表示刷新更早时间的数据
        
        [self getDataFromNetWorkWithKind:Right];
    }else{
        // 表示刷新最新的数据
        t_Iad.g_index = 0;
        [self getDataFromNetWorkWithKind:Lift];
    }
    
}
#pragma mark - NetWork
-(void)getdata{
    PhotoNetWork * t_photoNetWork = [PhotoNetWork netWork];
    [t_photoNetWork getActiveDataFromUrlPath:@"http://52.32.62.9/%E9%A3%8E%E6%99%AF.json" and:^(BOOL isSuss, id response, AFNetworkReachabilityStatus netWorkStatus) {
        NSDictionary * t_dict = (NSDictionary *)response;
        for (NSDictionary * dict in [t_dict objectForKey:@"data"]) {
            photo * g_photo = [photo setdataWithDict:dict];
            [self.g_dataArray addObject:g_photo];
        }
        [self.swipeableView reloadData];
    }];
    
}
- (void)getDataFromNetWorkWithKind:(NSString *)t_kind{
    
    if ([t_kind isEqualToString:Lift]) {
        NSMutableArray * t_arr = [NSMutableArray array];
        for (int i = 0; i <6 ; i++) {
            [t_arr addObject:[NSString stringWithFormat:@" ++ %d ++",i]];
        }
        
        [t_arr addObjectsFromArray:_g_dataArray];
        [_g_dataArray removeAllObjects];
        [_g_dataArray addObjectsFromArray:t_arr];
        [self.swipeableView reloadData];
    }else{
        
        NSMutableArray * t_arr = [NSMutableArray array];
        for (int i = 10; i <16 ; i++) {
            [t_arr addObject:[NSString stringWithFormat:@" ++ %d ++",i]];
        }
        [_g_dataArray addObjectsFromArray:t_arr];
        [self.swipeableView reloadData];
    }
    
    
}
#pragma mark - assist methods

#pragma mark - delegate
#pragma mark - CardViewDelegate
-(void)cardViewPhotoImgBtnClcik:(UIView *)sender andIndex:(NSInteger)index{
    photoDetailViewController * t_vc = [[photoDetailViewController alloc] init];
    t_vc.g_photo = self.g_dataArray[index];
     t_vc.hidesBottomBarWhenPushed = YES;//隐藏tabbar
    [self.navigationController pushViewController:t_vc animated:YES];

}
-(void)cardViewPersonInfoBtnClcik:(UIView *)sender andIndex:(NSInteger)index{
   

}
#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView andIndexAndDirection:(IndexAndDirection *)indexAndDirection{
    if (indexAndDirection.g_index < self.g_dataArray.count) {
        
        CardView *contentView =
        [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                       owner:self
                                     options:nil] objectAtIndex:0];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.delegate = self;
        contentView.g_index = indexAndDirection.g_index;
        contentView.g_photo = _g_dataArray[indexAndDirection.g_index];
        
        return contentView;
    }else{
        
        [self updateDataWithIndexAndDirection:indexAndDirection];
        
    }
    return nil;
}
#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeView:(UIView *)view
          inDirection:(ZLSwipeableViewDirection)direction {
    NSLog(@"did swipe in direction: %zd", direction);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
    NSLog(@"did cancel swipe");
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
  didStartSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did start swiping at location: x %f, y %f", location.x, location.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
          swipingView:(UIView *)view
           atLocation:(CGPoint)location
          translation:(CGPoint)translation {
    NSLog(@"swiping at location: x %f, y %f, translation: x %f, y %f",
          location.x, location.y, translation.x, translation.y);
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
    didEndSwipingView:(UIView *)view
           atLocation:(CGPoint)location {
    NSLog(@"did end swiping at location: x %f, y %f", location.x, location.y);
}
/**
 *  拖动并且切换当前视图是的代理方法
 *
 *  @param direction 拖动的方向
 */
- (void)swipeableViewDidswipingDirection:(NSString *)direction{
    if ([direction isEqualToString:ZanMessage]) {
        [ProgressHUD showSuccess:@"赞这张照片！"];
    }else{
        [ProgressHUD showError:@"踩这张照片"];
    }
}
#pragma mark - setter

#pragma mark - getter
-(NSMutableArray *)g_dataArray{
    if (!_g_dataArray) {
        _g_dataArray = [NSMutableArray array];
    }
    return _g_dataArray;
}
@end
