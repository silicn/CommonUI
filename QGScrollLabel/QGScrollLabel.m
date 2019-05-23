//
//  OGScrollLabel.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/8.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "QGScrollLabel.h"


@interface QGScrollLabel ()


@end

@implementation QGScrollLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUps];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _interLabel.text = text;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _interLabel.font = font;
}

- (void)setUps 
{
    [self addSubview:self.interLabel];
    
}


- (UILabel *)interLabel{
    if (_interLabel == nil) {
        _interLabel = [[UILabel alloc]initWithFrame:self.bounds];
    }
    return _interLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
