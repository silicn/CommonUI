//
//  QGBaseTabBar.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/8.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "QGCustomTabBar.h"
#import <SDWebImageDownloader.h>


@interface QGTabBarItemModel ()


@end

@implementation QGTabBarItemModel

- (instancetype)initWithTitle:(nullable NSString *)title 
                   nomalImage:(nullable UIImage *)nomalImage 
                  selectImage:(nullable UIImage *)selectImage;
{
    self = [super init];
    if (self) {
        self.title = title;
        self.nomalImage = nomalImage;
        self.selectImage = selectImage;
    }
    return self;
}

@end



@interface QGCustomTabBar ()

@property (nonatomic, assign) UIEdgeInsets oldSafeAreaInsets;

@property (nonatomic, strong)NSMutableDictionary *badges;


@end

@implementation QGCustomTabBar


- (instancetype)initWithFrame:(CGRect)frame barItems:(NSArray<QGTabBarItemModel *> *)barItems
{
    self = [super initWithFrame:frame];
    if (self) {
        self.oldSafeAreaInsets = UIEdgeInsetsZero;
        self.barItems = barItems;
    }
    return self;
}
- (void)updateTabBarItemWithModel:(QGTabBarItemModel *)model atIndex:(NSInteger)index
{
    if (index < 0 || index > self.barItems.count) return;
    NSMutableArray *itmes = [NSMutableArray arrayWithArray:self.barItems];
    [itmes replaceObjectAtIndex:index withObject:model];
    self.barItems = [itmes copy];
    [self setNeedsLayout];
}

- (void)setBarItems:(NSArray<QGTabBarItemModel *> *)barItems
{
    _barItems = barItems;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < self.items.count; i++) {
        UITabBarItem *item = self.items[i];
        QGTabBarItemModel *model = self.barItems[i];
        if (model.nomalImage) {
            item.image = [model.nomalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        if (model.selectImage) {
            item.selectedImage = [model.selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else{
            item.selectedImage = item.image;
        }
        item.title = model.title;
        item.badgeColor = self.badgeColor;
        NSString *badge = [[self.badges objectForKey:[NSString stringWithFormat:@"%d",i]] stringValue];
        item.badgeValue = badge;
    }
}


- (void)setFont:(UIFont *)font
{
    _font = font;
    if (self.textColor) {
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:self.textColor} forState:UIControlStateNormal];
    }else{
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:font} forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    if (self.font) {
         [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:self.font} forState:UIControlStateNormal];
    }else{
         [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor} forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}

- (void)badgeValue:(NSInteger)badge atIndex:(NSInteger)index
{
    if (index < 0) return;
    [self.badges setObject:@(badge) forKey:[NSString stringWithFormat:@"%ld",(long)index]];
}

- (void)removeAllBadgeValue
{
    [self.badges removeAllObjects];
}


#pragma mark — 网络更新TabBarItem


//- (void)requestTabBarItemsFormServer
//{
//    NSMutableArray *items = [NSMutableArray array];
//    
//    for (NSDictionary *dic in items) {
//        NSString *title = dic[@"text"];
//        NSString *nomalImageURL = dic[@"imgUrl"];
//        NSString *selectImageURL = dic[@"imgUrlActive"];
//        QGTabBarItemModel *model = [[QGTabBarItemModel alloc]init];
//        model.title = title;
//        model.nomalImageName = nomalImageURL;
//        model.selectImageName = selectImageURL;
//        
//        [items addObject:model];
//    }
//}
//
//- (void)updatetabBarItemWitURL:(NSString *)url  model:(QGTabBarItemModel *)model isNomal:(BOOL)isNomal
//{
//    SDWebImageDownloader *downLoad = [SDWebImageDownloader sharedDownloader];
//    
//    [downLoad downloadImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        if (finished) {
//            UIImage *compactImage = [self compressImageWith:image];
//            
//        }
//    }];
//}

/** 
 压缩图片到指定尺寸
 */
- (UIImage *)compressImageWith:(UIImage *)image{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(40 * scale, 40 * scale);
    UIGraphicsBeginImageContext(size);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}



#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.oldSafeAreaInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.oldSafeAreaInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    
    if (!UIEdgeInsetsEqualToEdgeInsets(self.oldSafeAreaInsets, self.safeAreaInsets)) {
        [self invalidateIntrinsicContentSize];
        
        if (self.superview) {
            [self.superview setNeedsLayout];
            [self.superview layoutSubviews];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    
    if (@available(iOS 11.0, *)) {
        float bottomInset = self.safeAreaInsets.bottom;
        if (bottomInset > 0 && size.height < 50 && (size.height + bottomInset < 90)) {
            size.height += bottomInset;
        }
        
    }
    
    
    return size;
}

- (void)setFrame:(CGRect)frame {
    if (self.superview) {
        if (frame.origin.y + frame.size.height != self.superview.frame.size.height) {
            frame.origin.y = self.superview.frame.size.height - frame.size.height;
        }
    }
    [super setFrame:frame];
}

- (NSMutableDictionary *)badges
{
    if (_badges == nil) {
        _badges = [NSMutableDictionary dictionary];
    }
    return _badges;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
