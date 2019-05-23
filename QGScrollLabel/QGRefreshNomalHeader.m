//
//  QGRefreshNomalHeader.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/13.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "QGRefreshNomalHeader.h"
#import "UIView+MJExtension.h"
#import "QGRotationCircleView.h"

#pragma mark - 实现父类的方法

@interface QGRefreshNomalHeader() <CAAnimationDelegate>
///旋转视图 loadingView
@property (nonatomic,strong)QGRotationCircleView *circleView;
///旋转动画
@property (nonatomic, strong) CABasicAnimation *rotationAnimationZ;

@end



@implementation QGRefreshNomalHeader

#pragma mark — 重写父类方法

- (void)prepare{
    [super prepare];
   
    self.lastUpdatedTimeLabel.hidden = YES;
    if (self.textColor) self.stateLabel.textColor = self.textColor;
   
}
- (void)endRefreshing
{
    //停止旋转
    [self endRotationAnimation];
    //准备绘制打钩动画
    [self.circleView prepareDrawComplete];
    //等待动画绘制完成
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super endRefreshing];
    });
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    //根据拉取进度旋转
    if (self.state != MJRefreshStateRefreshing) {
         self.circleView.transform = CGAffineTransformMakeRotation(pullingPercent * 2*M_PI);
    }
    
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat x = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        x -= stateWidth / 2 + self.labelLeftInset;
    }
    CGFloat y = self.mj_h * 0.5;
    if (self.circleView.center.x > x || self.circleView.center.x <= self.circleView.mj_w * 0.5) {
        self.circleView.center = CGPointMake(x,y);
    }
    
}

- (void)setState:(MJRefreshState)state
{
    [super setState:state];
    if (state == MJRefreshStateRefreshing ) {
        [self startRotationAnimation];
    }else {
        [self endRotationAnimation];
        [self.circleView removeCompleteLayer];
    }
}


/**
 监听手势变化

 @param change 手势状态变化
 */
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
//    NSInteger state = [change[@"new"] integerValue];
//    if (state == UIGestureRecognizerStateBegan) {
//        [self.circleView removeCompleteLayer];
//    }
}
/**
 开始旋转
 */
- (void)startRotationAnimation
{
    if (![self.circleView.layer animationForKey:@"rotationAnimation"]) {
        [self.circleView.layer addAnimation:self.rotationAnimationZ forKey:@"rotationAnimation"];
    }
}
/**
 结束旋转
 */
- (void)endRotationAnimation 
{
    if ([self.circleView.layer animationForKey:@"rotationAnimation"]) {
         [self.circleView.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

- (QGRotationCircleView *)circleView
{
    if (!_circleView) {
        _circleView = [[QGRotationCircleView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _circleView.backgroundColor = [UIColor whiteColor];
         [self addSubview:_circleView];
    }
    return _circleView;
}

//旋转动画
- (CABasicAnimation *)rotationAnimationZ {
    if (_rotationAnimationZ == nil) {
        _rotationAnimationZ = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimationZ.byValue = [NSNumber numberWithFloat:M_PI * 2];
        _rotationAnimationZ.duration = 0.5;
        _rotationAnimationZ.removedOnCompletion = NO;
        [_rotationAnimationZ setAutoreverses:NO];
        _rotationAnimationZ.repeatCount = INT_MAX;
        _rotationAnimationZ.fillMode = kCAFillModeForwards;
        _rotationAnimationZ.delegate = self;
        _rotationAnimationZ.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    }
    return _rotationAnimationZ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
