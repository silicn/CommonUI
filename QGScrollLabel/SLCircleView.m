//
//  SLCircleView.m
//  QGScrollLabel
//
//  Created by silicn on 2019/6/19.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "SLCircleView.h"

@implementation SLCircleView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawCircle];
    }
    return self;
}


- (void)drawCircle
{
    CAShapeLayer *shaperLayer = [CAShapeLayer layer];
    shaperLayer.frame = self.bounds;
    
    CGPoint center  = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGFloat radius = self.frame.size.width > self.frame.size.height ? self.frame.size.height/2:self.frame.size.width/2;
    
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer1.startPoint = CGPointMake(0, 1);
    gradientLayer1.endPoint = CGPointMake(0, 0);
    gradientLayer1.locations = @[@0.1,@1.0];
    gradientLayer1.colors = @[(id)[UIColor whiteColor].CGColor,(id)[UIColor colorWithRed:253/255.0 green:111/255.0 blue:118/255.0 alpha:1.0f].CGColor];

    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(0, 1);
    gradientLayer2.locations = @[@0.1,@1.0];
    gradientLayer2.colors =@[(id)[UIColor whiteColor].CGColor,(id)[UIColor colorWithRed:253/255.0 green:111/255.0 blue:118/255.0 alpha:1.0f].CGColor];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:radius - 5 startAngle:M_PI_2 + 0.1 endAngle:M_PI+M_PI_2-0.1  clockwise:YES];
    shaperLayer.lineWidth = 8;
    shaperLayer.strokeColor = [UIColor blueColor].CGColor;
    shaperLayer.lineCap = kCALineCapRound;
    shaperLayer.path = path.CGPath;
    shaperLayer.fillColor = [UIColor clearColor].CGColor;
    
    [gradientLayer1 setMask:shaperLayer];
    
    [self.layer addSublayer:gradientLayer1];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
     [path2 addArcWithCenter:center radius:radius - 5 startAngle:-M_PI_2 + 0.1 endAngle:M_PI_2 - 0.1  clockwise:YES];
    
    CAShapeLayer *shapelayer2 = [CAShapeLayer layer];
    shapelayer2.frame = self.bounds;
    shapelayer2.lineWidth = 8;
    shapelayer2.strokeColor = [UIColor colorWithRed:253/255.0 green:111/255.0 blue:118/255.0 alpha:1.0f].CGColor;
    shapelayer2.lineCap = kCALineCapRound;
    shapelayer2.path = path2.CGPath;
    shapelayer2.fillColor = [UIColor clearColor].CGColor;
    
    [gradientLayer2 setMask:shapelayer2];
    
    [self.layer addSublayer:gradientLayer2];
    
    
    
    
    
}


/**
 根据HexString创建颜色
 */
- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
