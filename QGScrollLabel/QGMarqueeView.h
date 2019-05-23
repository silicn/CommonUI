//
//  QGMarqueeView.h
//  VirtualPayment
//
//  Created by silicn on 2019/5/20.
//  Copyright © 2019 bo.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^QGMarqueeClickEventBlock)(id obj);
typedef void(^QGMarqueeMessageCloseBlock)(void);

typedef NS_ENUM(NSInteger,QGMarqueeViewType){
    QGMarqueeViewTypeIndicator,  // 详情
    QGMarqueeViewTypeMessage,    // 消息
    QGMarqueeViewTypeWanring     // 警告
};

// 跑马灯效果Label
@interface QGMarqueeView : UIView
///content内容
@property (nonatomic,copy)NSString *text;
/// 字体颜色
@property (nonatomic, strong)UIColor *textColor;
///字体Font Default SystemFontSize:15.0f
@property (nonatomic, strong)UIFont *font;
/// 通知消息类型
@property (nonatomic, assign)QGMarqueeViewType type;
/// 点击消息触发的回调
@property (nonatomic, copy)QGMarqueeClickEventBlock clickEventBlock; 
/// 当且仅当type:QGMarqueeViewTypeMessage，关闭按钮触发
@property (nonatomic, copy)QGMarqueeMessageCloseBlock messageCloseBlock;

/// 额外外部参数,必定是QGMarqueeClickEventBlock中的obj
@property (nonatomic, strong, nullable) id obj;

@end

NS_ASSUME_NONNULL_END
