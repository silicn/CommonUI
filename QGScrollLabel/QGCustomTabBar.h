//
//  QGBaseTabBar.h
//  QGScrollLabel
//
//  Created by silicn on 2019/5/8.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGTabBarItemModel : NSObject

//标题
@property (nonatomic, copy)NSString *title;
//默认图片名字
@property (nonatomic, strong)UIImage *nomalImage;
//选中图片名字
@property (nonatomic, strong)UIImage *selectImage;

/**
 初始化TabBarItemModel

 @param  title           TabBarItem.title          标题
 @param  nomalImage  TabBarItem.image          默认图片名字
 @param  selectImage TabBarItem.SelectImage    选中图片名字
 @return TabBarItemModel Object
 */
- (instancetype)initWithTitle:(nullable NSString *)title 
                   nomalImage:(nullable UIImage *)nomalImage 
                  selectImage:(nullable UIImage *)selectImage;

@end

/**
 用于修复苹果针对iPhone X产生的bug
 */

@interface QGCustomTabBar : UITabBar


- (instancetype)initWithFrame:(CGRect)frame barItems:(NSArray *)barItems;

///TabBarItemModels: QGTabBarItemModel
@property (nonatomic, copy)NSArray<QGTabBarItemModel *> *barItems;
///设置字体大小
@property (nonatomic, strong)UIFont *font;
///设置字体颜色
@property (nonatomic, strong)UIColor *textColor;
///badgeValue颜色
@property (nonatomic, strong)UIColor *badgeColor;

/**
 更新某个位置的TabBarItem

 @param model QGTabBarItemModel
 @param index 将要更新的位置index
 */
- (void)updateTabBarItemWithModel:(QGTabBarItemModel *)model atIndex:(NSInteger)index;

/**
 设置badgeValue

 @param badge NSInteger 0 代表无
 @param index NSInteger from 0.... ,if index > items.count 无效
 */
- (void)badgeValue:(NSInteger)badge atIndex:(NSInteger)index;

/** 
 删除所有的badgeValue
 */
- (void)removeAllBadgeValue;



@end

NS_ASSUME_NONNULL_END
