//
//  UIButton+Loading.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/15.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "UIButton+QGLoading.h"
#import "objc/message.h"

#define kCircle_Top_Margin 10
#define kCircle_Right_Margin 8

static const char *loadingShapeLayerKey = "loadingShapeLayerKey";
static const char *loadingNomalTitleKey = "loadingNomalTitleKey";
static const char *loadingEndAnimateKey = "loadingEndAnimateKey";

@interface UIButton ()<CAAnimationDelegate>
/// loadingLayer
@property (nonatomic, strong)CAShapeLayer *shapeLayer;
/// 记录Nomal状态的Title
@property (nonatomic, copy)NSString *nomalTitle;

@property (nonatomic, assign)BOOL canEndAnimate;


@end

@implementation UIButton (QGLoading)

- (void)setShapeLayer:(CAShapeLayer *)shapeLayer
{
    objc_setAssociatedObject(self, loadingShapeLayerKey, shapeLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)shapeLayer
{
    return objc_getAssociatedObject(self, loadingShapeLayerKey);
}

- (void)setNomalTitle:(NSString *)nomalTitle
{
    objc_setAssociatedObject(self, loadingNomalTitleKey, nomalTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)nomalTitle
{
    return objc_getAssociatedObject(self, loadingNomalTitleKey);
}

- (void)setCanEndAnimate:(BOOL)canEndAnimate
{
    objc_setAssociatedObject(self, loadingEndAnimateKey, @(canEndAnimate), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)canEndAnimate
{
    return [objc_getAssociatedObject(self, loadingEndAnimateKey) boolValue];
}

#pragma mark — Loading动画制作


- (void)beginLoadingWithLoadStateName:(NSString *)title
{
    NSParameterAssert(self.contentHorizontalAlignment != UIControlContentHorizontalAlignmentLeft);
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
        NSLog(@"contentHorizontalAlignment->Left 会使动画异常");
        return;
    }
    self.nomalTitle = self.titleLabel.text;
    if (title) {
         [self setTitle:title forState:UIControlStateNormal];
    }else{
        [self setTitle:@"提交中..." forState:UIControlStateNormal];
    }
    self.userInteractionEnabled  = NO;
    [self drawCircleAnimate];
}

/**
 绘制Loading动画
 */
- (void)drawCircleAnimate{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = (self.frame.size.height - 2 * kCircle_Top_Margin)/2;
    [self.titleLabel sizeToFit];
    CGRect textRect = self.titleLabel.frame;
    [path addArcWithCenter:center radius:radius startAngle:-M_PI_2 endAngle:M_PI clockwise:YES];
    if (self.shapeLayer == nil) {
       // 控制Button的width,如果width太小，loading 会显示不全
        if (self.frame.size.width/2 - (radius + textRect.size.width/2 + kCircle_Right_Margin) > 8) {
//          NSParameterAssert(self.frame.size.width/2 - (radius + textRect.size.width/2 + kCircle_Right_Margin) > 8);
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.frame = CGRectMake(-(radius + textRect.size.width/2) - kCircle_Right_Margin, 0, self.frame.size.width, self.frame.size.height);
            layer.fillColor = [UIColor clearColor].CGColor;
            layer.lineWidth = 2.0f;
            layer.lineCap = kCALineCapRound;
            layer.strokeColor = [UIColor whiteColor].CGColor;
            [self.layer addSublayer:layer];
            self.shapeLayer = layer;
        }
    }
     self.shapeLayer.path = path.CGPath;
     self.shapeLayer.hidden = NO;
    
    //添加动画组
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.beginTime = 0;
    animation.duration = 0.3;   // 持续时间
    animation.fromValue = @(0); // 从 0 开始
    animation.toValue = @(1);   // 到 1 结束
    // 保持动画结束时的状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 动画缓慢的进入，中间加速，然后减速的到达目的地。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *animationZ = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animationZ.fromValue = [NSNumber numberWithFloat:0];
    animationZ.toValue =[NSNumber numberWithFloat:M_PI * 2]; 
    animationZ.beginTime = 0.25f;
    animationZ.duration = 0.5;
    animationZ.removedOnCompletion = NO;
    animationZ.repeatCount = INFINITY;
    animationZ.fillMode = kCAFillModeForwards;
    animationZ.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animationZ.delegate = self;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = MAXFLOAT;
    group.animations = @[animation,animationZ];
    group.removedOnCompletion = NO;
    group.delegate = self;
    [self.shapeLayer addAnimation:group forKey:@"group"];
    
}

- (void)endLoading
{
    [self.shapeLayer removeAnimationForKey:@"group"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animation.duration = .15;   // 持续时间
    animation.fromValue = @(0); // 从 0 开始
    animation.toValue = @(1);   // 到 1 结束
    
    // 保持动画结束时的状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBackwards;
    // 动画缓慢的进入，中间加速，然后减速的到达目的地。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shapeLayer addAnimation:animation forKey:@"animationEnd"];
    //设置原title
    self.shapeLayer.hidden = YES;
    [self performSelector:@selector(resetNomalTitle) withObject:nil afterDelay:0.15];
   
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"animationDidStop %@ ",flag ? @"YES" :@"NO");
}

- (void)resetNomalTitle
{
    [self.shapeLayer removeAnimationForKey:@"animationEnd"];
     self.userInteractionEnabled = YES;
    self.titleLabel.text = self.nomalTitle;
     [self setTitle:self.nomalTitle forState:UIControlStateNormal];
}


@end
