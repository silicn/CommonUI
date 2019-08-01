//
//  UITableView+RefreshControl.h
//  QGScrollLabel
//
//  Created by silicn on 2019/5/9.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshBlock)(BOOL isRefresh);

typedef void (^EndRefreshBlock)(void);

typedef int (^EndLoadDataBlock)(void);

@interface UITableView (RefreshControl)
/// 下次DataList的PageNum
@property (nonatomic, assign)NSInteger pageNum;
/// 每页的获取的DataList数量
@property (nonatomic, assign) NSInteger pageCount;

/**
 适合类型：初始化下拉刷新，并且仅有下拉刷新 返回的isRefresh:YES
 
 @param refreshingBlock 下拉刷新时将要执行的action 
 @discuss isRefresh always is YES
 */
- (void)initHeaderRefreshOnlyWithHandle:(RefreshBlock)refreshingBlock;

/**
 开始下拉刷新
 */
- (void)beginHeaderRefresh;

/**
 结束下拉刷新

 @param endBlock 结束下拉刷新之后执行endBlock
 */
- (void)endHeaderRefreshWithBlock:(EndRefreshBlock)endBlock;

/**
 适合类型：初始化上拉加载更多，并且仅有上拉加载更多  返回的isRefresh:YES

 @param refreshingBlock 上拉加载更多将要执行的action
 @discuss isRefresh always is YES
 */
- (void)initFooterRefreshOnlyWithHandle:(RefreshBlock)refreshingBlock;

/**
 结束上拉加载更多Data

 @param endBlock 结束加载数据之后执行endBlock
 */
- (void)endFooterLoadDataWithBlock:(EndLoadDataBlock)endBlock;

/**
 删除下拉加载更多Data
 */
- (void)removeFooterLoadData;


/**
 适合类型：同时具有下拉加载(isRefresh:YES)和上拉加载更多(isRefresh:NO) 

 @param refreshingBlock 下拉刷新或者上拉加载更多将要执行的action
 @discuss isRefresh 下拉刷新：YES  上拉加载更多：NO
 */
- (void)initRefreshWithHandle:(RefreshBlock)refreshingBlock;



/**
 结束下拉刷新或者上拉加载更多

 @param refreshBlock 结束下拉刷新之后执行refreshBlock
 */
- (void)endRefreshWithRefreshBlock:(EndRefreshBlock)refreshBlock    count:(NSInteger)count;


@end

NS_ASSUME_NONNULL_END
