//
//  QGRotationCircleView.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/13.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "QGRotationCircleView.h"


@interface QGRotationCircleView()
///左半图
@property (nonatomic, strong)UIImageView *leftIV;
///右半图
@property (nonatomic, strong)UIImageView *rightIV;
///打钩Layer
@property (nonatomic, strong)CAShapeLayer *shapeLayer;

@property (nonatomic, strong)UIColor *mostColor;


@end

@implementation QGRotationCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        UIImageView *leftIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 31, 31)];
        UIImage *image =  [[UIImage imageNamed:@"circle_up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        leftIV.image = image;
        self.mostColor = [self mostColorWith:image];
        [self addSubview:leftIV];
        leftIV.center = center;
    
        UIImageView *rightIV = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2, 0, 31, 31)];
        rightIV.image = [[UIImage imageNamed:@"circle_down"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self addSubview:rightIV];
        rightIV.center = center;
        
    }
    return self;
}

- (void)prepareDrawComplete
{
    [self removeCompleteLayer];
    [self drawComplete];
}

- (void)removeCompleteLayer 
{
    if (self.shapeLayer) {
        [self.shapeLayer removeFromSuperlayer];
        self.shapeLayer = nil;
    } 
}

- (void)drawComplete 
{
    UIBezierPath *path =[UIBezierPath bezierPath];
    
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    [path moveToPoint:CGPointMake(center.x - 9, center.y)];
    [path addLineToPoint:CGPointMake(center.x - 3, center.y + 6)];
    [path addLineToPoint:CGPointMake(center.x + 8, center.y - 6)];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 3.0f;
    layer.lineCap = kCALineCapRound;
    layer.strokeColor = [UIColor colorWithRed:252/255.0 green:107/255.0 blue:96/255.0 alpha:1.0].CGColor;
    layer.path = path.CGPath;
    [self.layer addSublayer:layer];
    
    layer.strokeStart = 0.0f;
    layer.strokeEnd = 0.f;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.6f;   // 持续时间
    animation.fromValue = @(0); // 从 0 开始
    animation.toValue = @(1);   // 到 1 结束
    // 保持动画结束时的状态
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 动画缓慢的进入，中间加速，然后减速的到达目的地。
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:animation forKey:@""];
    
    self.shapeLayer = layer;
}


//根据图片获取图片的主色调
-(UIColor*)mostColorWith:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(image.size.width/2, image.size.height/2);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (red==255&&green==255&&blue==255) {//去除白色
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
                
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}


@end
