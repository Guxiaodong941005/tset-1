//
//  ZLSwipeableView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "ZLSwipeableView.h"
#import "ZLPanGestureRecognizer.h"
#import "CardView.h"
#define MAINSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define MAINSCREENHEIGTH  [UIScreen mainScreen].bounds.size.height
const NSUInteger ZLPrefetchedViewsNumber = 1;

ZLSwipeableViewDirection
ZLDirectionVectorToSwipeableViewDirection(CGVector directionVector) {
    ZLSwipeableViewDirection direction = ZLSwipeableViewDirectionNone;
    if (ABS(directionVector.dx) > ABS(directionVector.dy)) {
        if (directionVector.dx > 0) {
            direction = ZLSwipeableViewDirectionRight;
        } else {
            direction = ZLSwipeableViewDirectionLeft;
        }
    } else {
        if (directionVector.dy > 0) {
            direction = ZLSwipeableViewDirectionDown;
        } else {
            direction = ZLSwipeableViewDirectionUp;
        }
    }

    return direction;
}

@interface ZLSwipeableView () <UICollisionBehaviorDelegate,
                               UIDynamicAnimatorDelegate>

// UIDynamicAnimators
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UISnapBehavior *swipeableViewSnapBehavior;
@property (strong, nonatomic)
    UIAttachmentBehavior *swipeableViewAttachmentBehavior;
@property (strong, nonatomic)
    UIAttachmentBehavior *anchorViewAttachmentBehavior;
// AnchorView
@property (strong, nonatomic) UIView *anchorContainerView;
@property (strong, nonatomic) UIView *anchorView;
@property (nonatomic) BOOL isAnchorViewVisible;
// ContainerView
@property (strong, nonatomic) UIView *reuseCoverContainerView;
@property (strong, nonatomic) UIView *containerView;
// GXD add+++
@property (assign , nonatomic) CGPoint g_LocationRect;

@end

@implementation ZLSwipeableView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    self.animator.delegate = self;
    self.anchorContainerView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [self addSubview:self.anchorContainerView];
    self.isAnchorViewVisible = NO;
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.containerView];
    self.reuseCoverContainerView = [[UIView alloc] initWithFrame:self.bounds];
    self.reuseCoverContainerView.userInteractionEnabled = false;
    [self addSubview:self.reuseCoverContainerView];

    // Default properties
    self.isRotationEnabled = YES;
    self.rotationDegree = 1;
    self.rotationRelativeYOffsetFromCenter = 0.3;

    self.direction = ZLSwipeableViewDirectionAll;
    self.pushVelocityMagnitude = 1000;
    self.escapeVelocityThreshold = 750;
    self.relativeDisplacementThreshold = 0.25;

    self.programaticSwipeRotationRelativeYOffsetFromCenter = -0.2;
    self.swipeableViewsCenter =
        CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.swipeableViewsCenterInitial =
        CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    self.collisionRect = [self defaultCollisionRect];
    self.g_indexDirection = [[IndexAndDirection alloc] init];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.anchorContainerView.frame = CGRectMake(0, 0, 1, 1);
    self.containerView.frame = self.bounds;
    self.reuseCoverContainerView.frame = self.bounds;
    self.swipeableViewsCenterInitial = CGPointMake(
        self.bounds.size.width / 2 + self.swipeableViewsCenterInitial.x -
            self.swipeableViewsCenter.x,
        self.bounds.size.height / 2 + self.swipeableViewsCenterInitial.y -
            self.swipeableViewsCenter.y);
    self.swipeableViewsCenter =
        CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

- (void)setSwipeableViewsCenter:(CGPoint)swipeableViewsCenter {
    _swipeableViewsCenter = swipeableViewsCenter;
    [self animateSwipeableViewsIfNeeded];
}

#pragma mark - Properties

- (void)setDataSource:(id<ZLSwipeableViewDataSource>)dataSource {
    _dataSource = dataSource;
//    [self loadNextSwipeableViewsIfNeeded];
}
- (void)reloadData{
    [self discardAllSwipeableViews];
    [self loadNextSwipeableViewsIfNeededWithDirection:ZLSwipeableViewDirectionNone];

}
#pragma mark - DataSource

- (void)discardAllSwipeableViews {
    [self.animator removeBehavior:self.anchorViewAttachmentBehavior];
    for (UIView *view in self.containerView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)loadNextSwipeableViewsIfNeeded {
    NSInteger numViews = self.containerView.subviews.count;
    NSMutableSet *newViews = [NSMutableSet set];
    for (NSInteger i = numViews; i < ZLPrefetchedViewsNumber; i++) {
        UIView *nextView = [self nextSwipeableView];
        if (nextView) {
            [self.containerView addSubview:nextView];
            [self.containerView sendSubviewToBack:nextView];
            nextView.center = self.swipeableViewsCenterInitial;
            [newViews addObject:nextView];
            
        }
    }

   
    [self animateSwipeableViewsIfNeeded];
}

- (void)animateSwipeableViewsIfNeeded {
    UIView *topSwipeableView = [self topSwipeableView];
    if (!topSwipeableView) {
        return;
    }

    for (UIView *cover in self.containerView.subviews) {
        cover.userInteractionEnabled = NO;
    }
    topSwipeableView.userInteractionEnabled = YES;

    for (UIGestureRecognizer *recognizer in topSwipeableView
             .gestureRecognizers) {
        if (recognizer.state != UIGestureRecognizerStatePossible) {
            return;
        }
    }

    if (self.isRotationEnabled) {
        // rotation
        NSUInteger numSwipeableViews = self.containerView.subviews.count;
        if (numSwipeableViews >= 1) {
            
//            CGPoint t_center = self.containerView.subviews[0].center;
//            
////            self.containerView.subviews[0].center = CGPointMake(0, 100);
//            CGPoint t_center1 = self.swipeableViewsCenter;
//            
//            CGRect t_rect = self.bounds;
            [self.animator removeBehavior:self.swipeableViewSnapBehavior];
            
           
            self.swipeableViewSnapBehavior = [self
                snapBehaviorThatSnapView:self.containerView.subviews[numSwipeableViews - 1]
                                 toPoint:self.swipeableViewsCenter];
            [self.animator addBehavior:self.swipeableViewSnapBehavior];
        }
        CGPoint rotationCenterOffset = {
            0, CGRectGetHeight(topSwipeableView.frame) *
                   self.rotationRelativeYOffsetFromCenter};
        if (numSwipeableViews >= 2) {
            [self rotateView:self.containerView.subviews[numSwipeableViews - 2]
                         forDegree:self.rotationDegree
                atOffsetFromCenter:rotationCenterOffset
                          animated:YES];
        }
        if (numSwipeableViews >= 3) {
            [self rotateView:self.containerView.subviews[numSwipeableViews - 3]
                         forDegree:-self.rotationDegree
                atOffsetFromCenter:rotationCenterOffset
                          animated:YES];
        }
    }
}

#pragma mark - Action


- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CGPoint location = [recognizer locationInView:self];
    
   
    UIView *swipeableView = recognizer.view;

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self createAnchorViewForCover:swipeableView
                               atLocation:location
            shouldAttachAnchorViewToPoint:YES];

        if ([self.delegate respondsToSelector:@selector(swipeableView:
                                                  didStartSwipingView:
                                                           atLocation:)]) {
            
            self.g_LocationRect = location;
            [self.delegate swipeableView:self
                     didStartSwipingView:swipeableView
                              atLocation:location];
        }
    }

    if (recognizer.state == UIGestureRecognizerStateChanged) {
        self.anchorViewAttachmentBehavior.anchorPoint = location;
        if ([self.delegate respondsToSelector:@selector(swipeableView:
                                                          swipingView:
                                                           atLocation:
                                                          translation:)]) {
            [self.delegate swipeableView:self
                             swipingView:swipeableView
                              atLocation:location
                             translation:translation];
        }
    }

    if (recognizer.state == UIGestureRecognizerStateEnded ||
        recognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint velocity = [recognizer velocityInView:self];
        CGFloat velocityMagnitude =
            sqrtf(powf(velocity.x, 2) + powf(velocity.y, 2));
        CGPoint normalizedVelocity = CGPointMake(
            velocity.x / velocityMagnitude, velocity.y / velocityMagnitude);
        CGFloat scale = velocityMagnitude > self.escapeVelocityThreshold
                            ? velocityMagnitude
                            : self.pushVelocityMagnitude;
        CGFloat translationMagnitude = sqrtf(translation.x * translation.x +
                                             translation.y * translation.y);
        CGVector directionVector =
            CGVectorMake(translation.x / translationMagnitude * scale,
                         translation.y / translationMagnitude * scale);

        if ((ZLDirectionVectorToSwipeableViewDirection(directionVector) &
             self.direction) > 0 &&
            (ABS(translation.x) > self.relativeDisplacementThreshold *
                                      self.bounds.size.width || // displacement
             velocityMagnitude > self.escapeVelocityThreshold) && // velocity
            (signum(translation.x) == signum(normalizedVelocity.x)) && // sign X
            (signum(translation.y) == signum(normalizedVelocity.y))    // sign Y
            ) {
/*            处理动画的方法  */
            [self pushAnchorViewForCover:swipeableView
                             inDirection:directionVector
                        andCollideInRect:self.collisionRect];
            
        } else {
            [self.animator removeBehavior:self.swipeableViewAttachmentBehavior];
            [self.animator removeBehavior:self.anchorViewAttachmentBehavior];

            [self.anchorView removeFromSuperview];
            self.swipeableViewSnapBehavior =
                [self snapBehaviorThatSnapView:swipeableView
                                       toPoint:self.swipeableViewsCenter];
            [self.animator addBehavior:self.swipeableViewSnapBehavior];

            if ([self.delegate respondsToSelector:@selector(swipeableView:
                                                           didCancelSwipe:)]) {
                [self.delegate swipeableView:self didCancelSwipe:swipeableView];
            }
        }

        if ([self.delegate respondsToSelector:@selector(swipeableView:
                                                    didEndSwipingView:
                                                           atLocation:)]) {
            [self.delegate swipeableView:self
                       didEndSwipingView:swipeableView
                              atLocation:location];
        }
    }
}

- (void)swipeTopViewToLeft {
    [self swipeTopViewToDirection:ZLSwipeableViewDirectionLeft];
}

- (void)swipeTopViewToRight {
    [self swipeTopViewToDirection:ZLSwipeableViewDirectionRight];
}

- (void)swipeTopViewToUp {
    [self swipeTopViewToDirection:ZLSwipeableViewDirectionUp];
}

- (void)swipeTopViewToDown {
    [self swipeTopViewToDirection:ZLSwipeableViewDirectionDown];
}

- (void)swipeTopViewToDirection:(ZLSwipeableViewDirection)direction {
    UIView *topSwipeableView = [self topSwipeableView];
    if (!topSwipeableView) {
        return;
    }

    CGPoint location = CGPointMake(
        topSwipeableView.center.x,
        topSwipeableView.center.y *
            (1 + self.programaticSwipeRotationRelativeYOffsetFromCenter));
    [self createAnchorViewForCover:topSwipeableView
                           atLocation:location
        shouldAttachAnchorViewToPoint:YES];
    CGVector directionVector;
    switch (direction) {
    case ZLSwipeableViewDirectionLeft:
        directionVector = CGVectorMake(-self.pushVelocityMagnitude, 0);
        break;
    case ZLSwipeableViewDirectionRight:
        directionVector = CGVectorMake(self.pushVelocityMagnitude, 0);
        break;
    case ZLSwipeableViewDirectionUp:
        directionVector = CGVectorMake(0, -self.pushVelocityMagnitude);
        break;
    case ZLSwipeableViewDirectionDown:
        directionVector = CGVectorMake(0, self.pushVelocityMagnitude);
        break;
    default:
        directionVector = CGVectorMake(0, 0);
        break;
    }
    [self pushAnchorViewForCover:topSwipeableView
                     inDirection:directionVector
                andCollideInRect:self.collisionRect];
}

#pragma mark - UIDynamicAnimationHelpers

- (UICollisionBehavior *)collisionBehaviorThatBoundsView:(UIView *)view
                                                  inRect:(CGRect)rect {
    if (!view) {
        return nil;
    }
    UICollisionBehavior *collisionBehavior =
        [[UICollisionBehavior alloc] initWithItems:@[ view ]];
    UIBezierPath *collisionBound = [UIBezierPath bezierPathWithRect:rect];
    [collisionBehavior addBoundaryWithIdentifier:@"c" forPath:collisionBound];
    collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
    return collisionBehavior;
}

- (UIPushBehavior *)pushBehaviorThatPushView:(UIView *)view
                                 toDirection:(CGVector)direction {
    if (!view) {
        return nil;
    }
    UIPushBehavior *pushBehavior =
        [[UIPushBehavior alloc] initWithItems:@[ view ]
                                         mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.pushDirection = direction;
    return pushBehavior;
}

- (UISnapBehavior *)snapBehaviorThatSnapView:(UIView *)view
                                     toPoint:(CGPoint)point {
    if (!view) {
        return nil;
    }
    UISnapBehavior *snapBehavior =
        [[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
    snapBehavior.damping = 0.5; /* Medium oscillation */
    return snapBehavior;
}

- (UIAttachmentBehavior *)attachmentBehaviorThatAnchorsView:
                              (UIView *)aView toView:(UIView *)anchorView {
    if (!aView) {
        return nil;
    }
    CGPoint anchorPoint = anchorView.center;
    CGPoint p = [self convertPoint:aView.center toView:self];
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc]
            initWithItem:aView
        offsetFromCenter:UIOffsetMake(-(p.x - anchorPoint.x),
                                      -(p.y - anchorPoint.y))
          attachedToItem:anchorView
        offsetFromCenter:UIOffsetMake(0, 0)];
    attachment.length = 0;
    return attachment;
}

- (UIAttachmentBehavior *)attachmentBehaviorThatAnchorsView:(UIView *)aView
                                                    toPoint:(CGPoint)aPoint {
    if (!aView) {
        return nil;
    }

    CGPoint p = aView.center;
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc]
            initWithItem:aView
        offsetFromCenter:UIOffsetMake(-(p.x - aPoint.x), -(p.y - aPoint.y))
        attachedToAnchor:aPoint];
    attachmentBehavior.damping = 100;
    attachmentBehavior.length = 0;
    return attachmentBehavior;
}

- (void)createAnchorViewForCover:(UIView *)swipeableView
                       atLocation:(CGPoint)location
    shouldAttachAnchorViewToPoint:(BOOL)shouldAttachToPoint {
    [self.animator removeBehavior:self.swipeableViewSnapBehavior];
    self.swipeableViewSnapBehavior = nil;

    self.anchorView =
        [[UIView alloc] initWithFrame:CGRectMake(location.x - 500,
                                                 location.y - 500, 1000, 1000)];
    [self.anchorView setBackgroundColor:[UIColor blueColor]];
    [self.anchorView setHidden:!self.isAnchorViewVisible];
    [self.anchorContainerView addSubview:self.anchorView];
    UIAttachmentBehavior *attachToView =
        [self attachmentBehaviorThatAnchorsView:swipeableView
                                         toView:self.anchorView];
    [self.animator addBehavior:attachToView];
    self.swipeableViewAttachmentBehavior = attachToView;

    if (shouldAttachToPoint) {
        UIAttachmentBehavior *attachToPoint =
            [self attachmentBehaviorThatAnchorsView:self.anchorView
                                            toPoint:location];
        [self.animator addBehavior:attachToPoint];
        self.anchorViewAttachmentBehavior = attachToPoint;
    }
}

- (void)pushAnchorViewForCover:(UIView *)swipeableView
                   inDirection:(CGVector)directionVector
              andCollideInRect:(CGRect)collisionRect {
    ZLSwipeableViewDirection direction =
        ZLDirectionVectorToSwipeableViewDirection(directionVector);

    if ([self.delegate respondsToSelector:@selector(swipeableView:
                                                     didSwipeView:
                                                      inDirection:)]) {
        [self.delegate swipeableView:self
                        didSwipeView:swipeableView
                         inDirection:direction];
    }

//        [self getUserHandlePanDirection:ZLDirectionVectorToSwipeableViewDirection(directionVector)];
    
    [self.animator removeBehavior:self.anchorViewAttachmentBehavior];

    UICollisionBehavior *collisionBehavior =
        [self collisionBehaviorThatBoundsView:self.anchorView
                                       inRect:collisionRect];
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];

    UIPushBehavior *pushBehavior =
        [self pushBehaviorThatPushView:self.anchorView
                           toDirection:directionVector];
    [self.animator addBehavior:pushBehavior];

    [self.reuseCoverContainerView addSubview:self.anchorView];
    [self.reuseCoverContainerView addSubview:swipeableView];
    [self.reuseCoverContainerView sendSubviewToBack:swipeableView];

    self.anchorView = nil;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
          [self loadNextSwipeableViewsIfNeededWithDirection:direction];
    });
    
  
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior *)behavior
       endedContactForItem:(id<UIDynamicItem>)item
    withBoundaryIdentifier:(id<NSCopying>)identifier {
    NSMutableSet *viewsToRemove = [[NSMutableSet alloc] init];

    for (id aBehavior in self.animator.behaviors) {
        if ([aBehavior isKindOfClass:[UIAttachmentBehavior class]]) {
            NSArray *items = ((UIAttachmentBehavior *)aBehavior).items;
            if ([items containsObject:item]) {
                [self.animator removeBehavior:aBehavior];
                [viewsToRemove addObjectsFromArray:items];
            }
        }
        if ([aBehavior isKindOfClass:[UIPushBehavior class]]) {
            NSArray *items = ((UIPushBehavior *)aBehavior).items;
            if ([((UIPushBehavior *)aBehavior).items containsObject:item]) {
                if ([items containsObject:item]) {
                    [self.animator removeBehavior:aBehavior];
                    [viewsToRemove addObjectsFromArray:items];
                }
            }
        }
        if ([aBehavior isKindOfClass:[UICollisionBehavior class]]) {
            NSArray *items = ((UICollisionBehavior *)aBehavior).items;
            if ([((UICollisionBehavior *)aBehavior).items
                    containsObject:item]) {
                if ([items containsObject:item]) {
                    [self.animator removeBehavior:aBehavior];
                    [viewsToRemove addObjectsFromArray:items];
                }
            }
        }
    }

    for (UIView *view in viewsToRemove) {
        for (UIGestureRecognizer *aGestureRecognizer in view
                 .gestureRecognizers) {
            if ([aGestureRecognizer
                    isKindOfClass:[ZLPanGestureRecognizer class]]) {
                [view removeGestureRecognizer:aGestureRecognizer];
            }
        }
        [view removeFromSuperview];
    }
}

#pragma mark - ()

- (CGFloat)degreesToRadians:(CGFloat)degrees {
    return degrees * M_PI / 180;
}

- (CGFloat)radiansToDegrees:(CGFloat)radians {
    return radians * 180 / M_PI;
}

int signum(CGFloat n) { return (n < 0) ? -1 : (n > 0) ? +1 : 0; }

- (CGRect)defaultCollisionRect {
    CGSize viewSize = [UIScreen mainScreen].applicationFrame.size;
    CGFloat collisionSizeScale = 6;
    CGSize collisionSize = CGSizeMake(viewSize.width * collisionSizeScale,
                                      viewSize.height * collisionSizeScale);
    CGRect collisionRect =
        CGRectMake(-collisionSize.width / 2 + viewSize.width / 2,
                   -collisionSize.height / 2 + viewSize.height / 2,
                   collisionSize.width, collisionSize.height);
    return collisionRect;
}
- (UIView *)nextSwipeableView {
    UIView *nextView = nil;
    if ([self.dataSource
            respondsToSelector:@selector(nextViewForSwipeableView:andIndexAndDirection:)]) {
        
        UIView * t_view = [self.dataSource nextViewForSwipeableView:self andIndexAndDirection:self.g_indexDirection];
        if (t_view) {
              nextView = [self getnexrViewForSwipeableViewFromInit:t_view];
        }else{
            return nextView;
        }
      
        
        
    }
    if (nextView) {
        [nextView
            addGestureRecognizer:[[ZLPanGestureRecognizer alloc]
                                     initWithTarget:self
                                             action:@selector(handlePan:)]];
    }
    return nextView;
}

- (void)rotateView:(UIView *)view
             forDegree:(float)degree
    atOffsetFromCenter:(CGPoint)offset
              animated:(BOOL)animated {
    float duration = animated ? 0.4 : 0;
    float rotationRadian = [self degreesToRadians:degree];
    [UIView animateWithDuration:duration
                     animations:^{
                       view.center = self.swipeableViewsCenter;
                       CGAffineTransform transform =
                           CGAffineTransformMakeTranslation(offset.x, offset.y);
                       transform =
                           CGAffineTransformRotate(transform, rotationRadian);
                       transform = CGAffineTransformTranslate(
                           transform, -offset.x, -offset.y);
                       view.transform = transform;
                     }];
}

- (UIView *)topSwipeableView {
    return self.containerView.subviews.lastObject;
}
#pragma mark -- GXD add +++  gxd getUserHandlePanDirection
-(NSString *)getUserHandlePanDirection:(ZLSwipeableViewDirection )t_direction{
    
    NSString * t_str = nil;
    switch (t_direction) {
        case ZLSwipeableViewDirectionLeft:
            self.swipeableViewsCenterInitial = CGPointMake([UIScreen mainScreen].bounds.size.width, self.g_LocationRect.y);
            t_str = @"左";
            self.g_indexDirection.g_index++;
            break;
        case ZLSwipeableViewDirectionRight:
            self.swipeableViewsCenterInitial = CGPointMake(0, self.g_LocationRect.y);
            t_str = @"右";
               self.g_indexDirection.g_index--;
            break;
        case ZLSwipeableViewDirectionDown:
            self.swipeableViewsCenterInitial = CGPointMake(self.g_LocationRect.x, 0);
            t_str = @"上";
            self.g_indexDirection.g_index++;
            break;
        case ZLSwipeableViewDirectionUp:
            
            self.swipeableViewsCenterInitial = CGPointMake(self.g_LocationRect.x,MAINSCREENHEIGTH);
            t_str = @"下";
            self.g_indexDirection.g_index++;
            break;
        case ZLSwipeableViewDirectionNone:
            t_str = nil;
            self.swipeableViewsCenterInitial = CGPointMake(MAINSCREENWIDTH,0);
           
            break;
        default:
            break;
    }
    return t_str;

}
//// 弹出提示
-(void)showUIAlertView:(NSString *)t_alert{
    UILabel * t_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    t_lable.center = self.center;
    t_lable.text = [NSString stringWithFormat:@"%@ 这张照片成功",t_alert];
    [self addSubview:t_lable];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [t_lable removeFromSuperview];
    });
}
#pragma mark  获取手势方向
- (void)loadNextSwipeableViewsIfNeededWithDirection:(ZLSwipeableViewDirection )t_direction{
    //    1. 获取用户手势方向 以及 序号
    self.g_indexDirection.g_direction = [self getUserHandlePanDirection:t_direction];
  
    NSInteger numViews = self.containerView.subviews.count;
    NSMutableSet *newViews = [NSMutableSet set];
    for (NSInteger i = numViews; i < ZLPrefetchedViewsNumber; i++) {
        UIView *nextView = [self nextSwipeableView];
        if (nextView) {
            [self.containerView addSubview:nextView];
            [self.containerView sendSubviewToBack:nextView];
            nextView.center = self.swipeableViewsCenterInitial;
            [newViews addObject:nextView];
            
        }
    }
    
    
    [self animateSwipeableViewsIfNeeded];
    
    
}
// 初始化即将更新到主页面的视图
-(UIView *)getnexrViewForSwipeableViewFromInit:(UIView *)t_view{
  CardView *view = [[CardView alloc] initWithFrame:self.bounds];
    [view addSubview:t_view];
    
    //             This is important:
    //             https://github.com/zhxnlai/ZLSwipeableView/issues/9
    NSDictionary *metrics = @{
                              @"height" : @(view.bounds.size.height),
                              @"width" : @(view.bounds.size.width)
                              };
    NSDictionary *views = NSDictionaryOfVariableBindings(t_view);
    [view addConstraints:
     [NSLayoutConstraint
      constraintsWithVisualFormat:@"H:|[t_view(width)]"
      options:0
      metrics:metrics
      views:views]];
    [view addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:
                          @"V:|[t_view(height)]"
                          options:0
                          metrics:metrics
                          views:views]];
    
    return view;

}

@end
