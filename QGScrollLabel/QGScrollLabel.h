//
//  OGScrollLabel.h
//  QGScrollLabel
//
//  Created by silicn on 2019/5/8.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ScrollLabeDirection){
    ScrollLabeDirectionLeft = 0,
    ScrollLabeDirectionRight,
    ScrollLabeDirectionCircle,
    ScrollLabeDirectionUp,
    ScrollLabeDirectionDown
};

NS_ASSUME_NONNULL_BEGIN

@interface QGScrollLabel : UIView
///文本内容
@property (nonatomic, copy)NSString *text;
///文本颜色
@property (nonatomic, strong)UIColor *textColor;
///背景颜色
@property (nonatomic, strong)UIColor *backgroundColor;
///字体大小
@property (nonatomic, strong)UIFont *font;
///内置label
@property (nonatomic, strong)UILabel *interLabel;
///滚动速度
@property (nonatomic, assign)CGFloat speed;
///滚动方向
@property (nonatomic, assign)ScrollLabeDirection direction;



@end

NS_ASSUME_NONNULL_END
