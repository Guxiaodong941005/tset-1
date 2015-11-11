//
//  ViewController.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "ViewController.h"
#import "ZLSwipeableView.h"
#import "UIColor+FlatColors.h"
#import "CardView.h"
#import "IndexAndDirection.h"
#import "UIImageView+WebCache.h"
#define Lift @"左"
#define Right @"右"
@interface ViewController () <ZLSwipeableViewDataSource,
                              ZLSwipeableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;
@property (strong , nonatomic) NSMutableArray * g_dataArray;
@property (nonatomic) BOOL loadCardFromXib;
@end

@implementation ViewController
#pragma mark - viewLife cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.colorIndex = 0;
   

    
    
    // Optional Delegate
    self.swipeableView.delegate = self;
    self.swipeableView.dataSource = self;
}

- (void)viewDidLayoutSubviews {
  
   
}
-(void)viewDidAppear:(BOOL)animated{
    [self.swipeableView reloadData];

}

#pragma mark - Action

- (IBAction)swipeLeftButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToLeft];
}

- (IBAction)swipeRightButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToRight];
}
- (IBAction)swipeUpButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToUp];
}
- (IBAction)swipeDownButtonAction:(UIButton *)sender {
    [self.swipeableView swipeTopViewToDown];
}

- (IBAction)reloadButtonAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                 initWithTitle:@"Load Cards"
                      delegate:self
             cancelButtonTitle:@"Cancel"
        destructiveButtonTitle:nil
             otherButtonTitles:@"Programmatically", @"From Xib", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.loadCardFromXib = buttonIndex == 1;

    self.colorIndex = 0;
 [self.swipeableView reloadData];
    
//    [self.swipeableView discardAllSwipeableViews];
//    [self.swipeableView loadNextSwipeableViewsIfNeeded];
}


#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView andIndexAndDirection:(IndexAndDirection *)indexAndDirection{
    if (indexAndDirection.g_index < self.g_dataArray.count) {

        CardView *contentView =
        [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                       owner:self
                                     options:nil] objectAtIndex:0];
        contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.g_photo = _g_dataArray[indexAndDirection.g_index];
        
        return contentView;
    }else{
        
        [self updateDataWithIndexAndDirection:indexAndDirection];
    
    }
    return nil;
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


#pragma mark - setter

#pragma mark - getter
-(NSMutableArray *)g_dataArray{
    if (!_g_dataArray) {
        _g_dataArray = [NSMutableArray array];
        NSString * t_filePath = [[NSBundle mainBundle] pathForResource:@"百度贴吧副本" ofType:@"json"];
        NSData * t_data = [NSData dataWithContentsOfFile:t_filePath];
        
        NSError * error;
        NSDictionary * t_dict = [NSJSONSerialization JSONObjectWithData:t_data options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"%@",t_dict);
        
        for (NSDictionary * dict in [t_dict objectForKey:@"data"]) {
            photo * g_photo = [photo setdataWithDict:dict];
            [_g_dataArray addObject:g_photo];
        }
     
    }
    return _g_dataArray;
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
@end
