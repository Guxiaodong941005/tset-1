//
//  ViewController.m
//  SearchHistory
//
//  Created by 植梧培 on 15/8/25.
//  Copyright (c) 2015年 机智的新手. All rights reserved.
//

#import "ViewController.h"
#import "HistoryViewCell.h"
@interface ViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewWithUserChoose;
@property (strong, nonatomic) IBOutlet UIScrollView *g_scrollview;
@property (strong, nonatomic) IBOutlet UILabel *g_chooselable;

@property (strong, nonatomic) IBOutlet UILabel *g_tipsLable;
@property (nonatomic, strong) HistoryViewCell *cell;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic , strong) NSMutableArray * userChooseArr;
@property (nonatomic , strong) UIView * t_view;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _data = [NSMutableArray arrayWithArray:@[@"测试数据云标",@"云标签",@"历史记录",@"测试",@"妈妈",@"机智的手哥",@"测",@"云标",@"历史记",@"试",@"妈妈长",@"机智哥"]];
    
//    _userChooseArr = [NSMutableArray arrayWithArray:@[@"机智的手哥",@"测试数据",@"云标签"]];
    _userChooseArr = [NSMutableArray array];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryViewCell"];
    [_collectionViewWithUserChoose registerNib:[UINib nibWithNibName:@"HistoryViewCell" bundle:nil] forCellWithReuseIdentifier:@"HistoryViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionViewWithUserChoose.delegate = self;
    _collectionViewWithUserChoose.dataSource = self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    1.1 提示显示
    if (_userChooseArr.count == 0 || _userChooseArr == nil) {
        self.g_tipsLable.hidden = NO;
    }else{
        self.g_tipsLable.hidden = YES;
    }
    

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == _collectionViewWithUserChoose) {
       return _userChooseArr.count;
    }else{
     return _data.count;
    
    }
   
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{

    return UIEdgeInsetsMake(5, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView == _collectionViewWithUserChoose) {
        HistoryViewCell *cell = [_collectionViewWithUserChoose dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
        cell.keyword = _userChooseArr[indexPath.row];
        cell.color = [UIColor redColor];
        
        
        
        if (indexPath.row == 0) {
            [self setFrameWithUserChooseCollection];
        }
        
        return cell;
    }else{
        HistoryViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"HistoryViewCell" forIndexPath:indexPath];
        cell.keyword = _data[indexPath.row];
        cell.color = [UIColor colorWithRed:0.34117647f green:0.6627451f blue:0.94117647f alpha:1];
        if (indexPath.row == 0) {
              [self setFrameWithCollection];
        }
        return cell;
    
    }
    
  
}
-(void)setFrameWithCollection{
    NSLog(@"setFrameWithCollection");
    CGRect t_rect = self.collectionView.frame;
    self.collectionView.frame = CGRectMake(t_rect.origin.x, t_rect.origin.y, t_rect.size.width, self.collectionView.contentSize.height);
    
    CGFloat t_sizeHight = self.collectionView.frame.origin.y + self.collectionView.contentSize.height;
    if (t_rect.size.height < self.collectionView.contentSize.height + 10) {
        self.g_scrollview.contentSize = CGSizeMake(self.g_scrollview.frame.size.width, t_sizeHight);
    }else{
        self.g_scrollview.contentSize = CGSizeMake(self.view.frame.size.width, t_sizeHight);
    
    }
    

}
-(void)setFrameWithUserChooseCollection{
   
    if (_userChooseArr.count == 0 || _userChooseArr == nil) {
        self.g_tipsLable.hidden = NO;
    }else{
        self.g_tipsLable.hidden = YES;
    }
    CGRect t_rect = self.collectionViewWithUserChoose.frame;
    self.collectionViewWithUserChoose.frame = CGRectMake(t_rect.origin.x, t_rect.origin.y, t_rect.size.width, self.collectionViewWithUserChoose.contentSize.height);
    
    float t_margin = self.collectionViewWithUserChoose.contentSize.height - t_rect.size.height ;
    
    if (t_margin > 0) {
//        设置 scrollview 的 contentSize
//        self.g_scrollview.contentSize = CGSizeMake(self.g_scrollview.frame.size.width, self.g_scrollview.frame.size.height + t_margin + 30);
//         移动tipslable 和 collectionView
        self.g_chooselable.frame = CGRectMake(self.g_chooselable.frame.origin.x, self.g_chooselable.frame.origin.y + t_margin, self.g_chooselable.frame.size.width, self.g_chooselable.frame.size.height);
        
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y + t_margin, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    }else if (t_margin < -10){
        //        设置 scrollview 的 contentSize
//        self.g_scrollview.contentSize = CGSizeMake(self.g_scrollview.frame.size.width, self.g_scrollview.frame.size.height + t_margin + 30);
        //         移动tipslable 和 collectionView
        self.g_chooselable.frame = CGRectMake(self.g_chooselable.frame.origin.x, self.g_chooselable.frame.origin.y + t_margin, self.g_chooselable.frame.size.width, self.g_chooselable.frame.size.height);
        
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y + t_margin, self.collectionView.frame.size.width, self.collectionView.frame.size.height);
        
    }else{
//   self.g_scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 30);
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_cell == nil) {
        _cell = [[NSBundle mainBundle]loadNibNamed:@"HistoryViewCell" owner:nil options:nil][0];
    }
    
    if (collectionView == _collectionViewWithUserChoose) {
     _cell.keyword = _userChooseArr[indexPath.row];
    }else{
     _cell.keyword = _data[indexPath.row];
    }
   
    
    CGSize t_size = [_cell sizeForCell];
    
    if (t_size.width > 99) {
        _cell.titleLabel.font = [UIFont systemFontOfSize:6];
    }
    return CGSizeMake(99.0f, 35.f);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _collectionViewWithUserChoose) {

      
        NSInteger t_inter = [indexPath row];
        
        NSLog(@"%ld",(long)t_inter);
        NSArray * t_arr = [self.collectionViewWithUserChoose subviews];
    
        
        NSString * t_str = [self.userChooseArr objectAtIndex:indexPath.row];
      __block  UIView * showView;
        
        [t_arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            if ([[(HistoryViewCell *)obj keyword] isEqualToString:t_str]) {
                showView = obj;
                *stop = YES;
            }
            
        }];
        
        
        //    1.1 用户删除添加数据
        [_data addObject:_userChooseArr[indexPath.row]];
        [_userChooseArr removeObjectAtIndex:indexPath.row];
        
     
        [self selectViewWithAnimationWithSelectView:showView andAnimationKind:0];
     
    
    }else{
        //    1.1 用户添加数据
        [_userChooseArr addObject:_data[indexPath.row]];
        
        [_data removeObjectAtIndex:indexPath.row];
        [_collectionViewWithUserChoose reloadData];
        [_collectionView reloadData];
        
    }
    
    
}
-(void)selectViewWithAnimationWithSelectView:(UIView *)t_selectView andAnimationKind:(NSInteger )t_kind{
    
     [self.view setUserInteractionEnabled:NO];
    
    float t_test = t_selectView.frame.origin.y + self.collectionViewWithUserChoose.frame.origin.y;
    t_selectView.frame = CGRectMake(t_selectView.frame.origin.x, t_test, t_selectView.frame.size.width, t_selectView.frame.size.height);
    
   
    
    [self.view addSubview:t_selectView];
    [self.view bringSubviewToFront:t_selectView];
 
     t_selectView.hidden = NO;
    [UIView animateWithDuration:2 animations:^{

       
        
        float t_tovalue = self.view.frame.size.width/2;
        float t_tovalueY = self.collectionView.frame.origin.y;
        
        
        t_selectView.alpha = 0;
        
        
        t_selectView.center = CGPointMake(t_tovalue, t_tovalueY);
        
        
        
    } completion:^(BOOL finished) {
        
        [t_selectView removeFromSuperview];
        [_collectionViewWithUserChoose reloadData];
        [_collectionView reloadData];
        
        //    1.1 提示显示
        if (_userChooseArr.count == 0 || _userChooseArr == nil) {
            self.g_tipsLable.hidden = NO;
        }else{
            self.g_tipsLable.hidden = YES;
        }
        
        [self.view setUserInteractionEnabled:YES];
        
    }];
    
    
}
@end
