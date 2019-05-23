//
//  UIButton+Loading.h
//  QGScrollLabel
//
//  Created by silicn on 2019/5/15.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (QGLoading)

/**
 开始Loading动画

 @param title NSString  Default:"提交中..."
 */
- (void)beginLoadingWithLoadStateName:(NSString *)title;

/**
 结束Loading动画
 */
- (void)endLoading;

@end

NS_ASSUME_NONNULL_END
