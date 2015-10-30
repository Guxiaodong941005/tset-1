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
@interface ViewController () <ZLSwipeableViewDataSource,
                              ZLSwipeableViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic) NSUInteger colorIndex;

@property (nonatomic) BOOL loadCardFromXib;
@end

@implementation ViewController
#pragma mark -- viewLife
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.colorIndex = 0;
    self.colors = @[
        @"Turquoise",
        @"Green Sea",
        @"Emerald",
        @"Nephritis",
        @"Peter River",
        @"Belize Hole",
        @"Amethyst",
        @"Wisteria",
        @"Wet Asphalt",
        @"Midnight Blue",
        @"Sun Flower",
        @"Orange",
        @"Carrot",
        @"Pumpkin",
        @"Alizarin",
        @"Pomegranate",
        @"Clouds",
        @"Silver",
        @"Concrete",
        @"Asbestos"
    ];

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

#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {
    if (swipeableView.g_indexDirection.g_index < self.colors.count) {

            CardView *contentView =
                [[[NSBundle mainBundle] loadNibNamed:@"CardContentView"
                                               owner:self
                                             options:nil] objectAtIndex:0];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
        contentView.g_nickNameLable.text = [NSString stringWithFormat:@" ++ %ld ++ ",(long)swipeableView.g_indexDirection.g_index];
        contentView.g_contentLable.text = @"fsadkjfijabgiabgifabgijafbgijafbgijfdabgijbgjbseigbijabgijadbgijadgijahighaighaighiahgiaudhgiuahgiahiughaigha";

        return contentView;
    }else{
        swipeableView.g_indexDirection.g_index = 0;
       
        [self.swipeableView discardAllSwipeableViews];
        [self.swipeableView loadNextSwipeableViewsIfNeeded];
    
    }
    return nil;
}

#pragma mark - ()

- (UIColor *)colorForName:(NSString *)name {
    NSString *sanitizedName =
        [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *selectorString =
        [NSString stringWithFormat:@"flat%@Color", sanitizedName];
    Class colorClass = [UIColor class];
    return [colorClass performSelector:NSSelectorFromString(selectorString)];
    
}

@end
