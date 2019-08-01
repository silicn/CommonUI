//
//  QGRotationCircleView.h
//  QGScrollLabel
//
//  Created by silicn on 2019/5/13.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGRotationCircleView : UIView

/**
 加载完成，准备绘制
 */
- (void)prepareDrawComplete;

/**
 删除绘制的打钩✓
 */
- (void)removeCompleteLayer;


- (void)changeColor:(UIColor *)color;



@end

NS_ASSUME_NONNULL_END
