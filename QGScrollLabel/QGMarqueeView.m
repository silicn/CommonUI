//
//  QGMarqueeView.m
//  VirtualPayment
//
//  Created by silicn on 2019/5/20.
//  Copyright © 2019 bo.zhang. All rights reserved.
//

#import "QGMarqueeView.h"
#import <Masonry.h>
#import "UIColor+QGColor.h"

#define kDisplayLinkTimes 1

@interface QGMarqueeView ()

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UIView *textContentView;

@property (nonatomic, strong)UILabel *textLabel;

@property (nonatomic, strong)UIButton *accessoryButton;

@property (nonatomic, strong)CADisplayLink *displayLink;

@property (nonatomic, assign)NSInteger time;

@property (nonatomic, assign)CGFloat textWidth;

//@property (nonatomic, assign)BOOL prepared;
//
//@property (nonatomic, strong)UILabel *reuseLabel;



@end


@implementation QGMarqueeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:16.0f];
        [self initCustomUI];
    }
    return self;
}


- (void)initCustomUI
{
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@(16.0f));
    }];
    
    [self addSubview:self.accessoryButton];
    [self.accessoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(26));
        make.height.equalTo(@(18));
    }];
    
    [self.accessoryButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.textContentView];
    [self.textContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).offset(10);
        make.right.equalTo(self.accessoryButton.mas_left).offset(-12);
        make.top.equalTo(self).offset(12);
        make.bottom.equalTo(self).offset(-12);
    }];
    
    [self.textContentView addSubview:self.textLabel];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.textContentView);
        make.top.bottom.equalTo(self.textContentView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UIGestureRecognizer *)tap
{
    NSLog(@"tap");
    if (self.clickEventBlock) {
        self.clickEventBlock(self.obj);
    }
}

- (void)btnAction:(UIButton *)btn
{
    NSLog(@"btnAction");
    if (self.type == QGMarqueeViewTypeMessage) {
        if (self.messageCloseBlock) {
            self.messageCloseBlock();
        }
    }
}

/**
 获取文字的宽度

 @param text NSString 内容文字
 @return CGFloat 单行文字的宽度
 */
- (CGFloat)getTextWidth:(NSString *)text
{
    if (text.length == 0) {
        return 0.0;
    }
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.font.lineHeight + 2) options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    return size.width;
    
    
}

/** 
 * 设置类型
 */
- (void)setType:(QGMarqueeViewType)type
{
    _type = type;
    if (type == QGMarqueeViewTypeIndicator) {
        self.backgroundColor = [UIColor colorWithHexString:@"F9F3DD"];
        self.textColor = [UIColor colorWithHexString:@"EBB45F"];
        [self.accessoryButton setImage:[UIImage imageNamed:@"notice_indicator"] forState:UIControlStateNormal];
        self.accessoryButton.hidden = NO;
    }else if (type == QGMarqueeViewTypeMessage){
        self.backgroundColor = [UIColor colorWithHexString:@"F9F3DD"];
        self.textColor = [UIColor colorWithHexString:@"EBB45F"];
        [self.accessoryButton setImage:[UIImage imageNamed:@"notice_close"] forState:UIControlStateNormal];
        self.accessoryButton.hidden = NO;
    }else if (type == QGMarqueeViewTypeWanring){
        self.backgroundColor = [UIColor colorWithHexString:@"F9DDDD"];
        self.textColor = [UIColor colorWithHexString:@"B44B4D"];
        self.accessoryButton.hidden = YES;
        [self.textContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(10);
            make.right.equalTo(self.mas_right).offset(-12); 
            make.top.equalTo(self).offset(12);
            make.bottom.equalTo(self).offset(-12);
        }];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.textLabel.font = font;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textWidth  = [self getTextWidth:text] + 2;
    self.textLabel.text = text;
    [self resetTextLabelWithText:text];
    if (self.textWidth > self.textContentView.bounds.size.width) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginMarquee) object:nil];
        [self performSelector:@selector(beginMarquee) withObject:nil afterDelay:3.0];
    }
}

/**
 重置textLabel的位置，以及时间
 */
- (void)resetTextLabelWithText:(NSString *)text
{
    if (_displayLink) {
         [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
    }];
    
//    [self.textContentView layoutIfNeeded];
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"micro_notice"];
        // do some setting 
    }
    return _imageView;
}

- (UIButton *)accessoryButton
{
    if (!_accessoryButton) {
        _accessoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // do some setting 
    }
    return _accessoryButton;
}

- (UIView *)textContentView
{
    if (!_textContentView) {
        _textContentView = [[UIView alloc]init];
        _textContentView.backgroundColor = [UIColor clearColor];
        _textContentView.clipsToBounds = YES;
    }
    return _textContentView;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.text = self.text;
        _textLabel.numberOfLines = 1;
        _textLabel.textColor = self.textColor ?: [UIColor blackColor];
        _textLabel.font = self.font;
        _textLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _textLabel;
}

#pragma mark — 计时器 滚动设置


- (void)displayLinkTime:(CADisplayLink *)displayLink
{
//    if (!self.prepared) return;
    self.time++;
    if (self.time >= 0) {  // 更新文字的位置，每秒10次
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0)).offset(-self.time); 
        }];
    }
    if (self.time == -2 * 60/kDisplayLinkTimes) { // 1秒之后重置文字的位置
        [self.textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(0)); 
        }];
    }
    
    if (self.textWidth - self.time < self.textContentView.frame.size.width) {
        self.time = -3 * 60/kDisplayLinkTimes; 
    }
    
}

/**
 文字开始滚动，跑马灯开始
 */
- (void)beginMarquee
{
    self.time = 0;
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)destoryMarquee
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}


- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTime:)];
        _displayLink.frameInterval = kDisplayLinkTimes;
    }
    return _displayLink;
}

- (void)dealloc
{
    [self destoryMarquee];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
