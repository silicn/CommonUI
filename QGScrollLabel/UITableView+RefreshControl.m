//
//  UITableView+RefreshControl.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/9.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "UITableView+RefreshControl.h"
#import "objc/message.h"
#import "MJRefresh.h"

#import "QGRefreshNomalHeader.h"


static const char *loadDataPageNumKey = "LoadDataPageNumKey";
static const char *loadDataPageCountKey = "LoadDataPageCountKey";
static const char *refreshLoadDataBlockKey = "refreshLoadDataBlockKey";

@interface UITableView ()

@property (nonatomic, copy)RefreshBlock refreshBlock;


@end

@implementation UITableView (RefreshControl)

- (void)setPageNum:(NSInteger)pageNum
{
    objc_setAssociatedObject(self, loadDataPageNumKey, @(pageNum), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)pageNum{
    return [objc_getAssociatedObject(self, loadDataPageNumKey) integerValue];
}

- (void)setPageCount:(NSInteger)pageCount
{
    objc_setAssociatedObject(self,loadDataPageCountKey , @(pageCount), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)pageCount{
    return [objc_getAssociatedObject(self, loadDataPageCountKey) integerValue];
}

- (void)setRefreshBlock:(RefreshBlock)refreshBlock
{
    objc_setAssociatedObject(self, refreshLoadDataBlockKey, refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (RefreshBlock)refreshBlock
{
    return objc_getAssociatedObject(self, refreshLoadDataBlockKey);
}

#pragma mark — 仅有下拉刷新的方法

- (void)initHeaderRefreshOnlyWithHandle:(RefreshBlock)refreshingBlock
{
    if (self.mj_header == nil) {
        QGRefreshNomalHeader *header = [QGRefreshNomalHeader headerWithRefreshingBlock:^{
            if (refreshingBlock) {refreshingBlock(YES);} 
        }];
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
        [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"松开刷新..." forState:MJRefreshStateWillRefresh];
        self.mj_header = header;
    }
}

- (void)beginHeaderRefresh
{
    if (self.mj_header) {
        [self.mj_header beginRefreshing];
    }
}

- (void)endHeaderRefreshWithBlock:(EndRefreshBlock)endBlock;
{
    if (self.mj_header) {
        [self.mj_header endRefreshingWithCompletionBlock:endBlock];
    }
}


#pragma mark — 仅有上拉加载的方法

- (void)initFooterRefreshOnlyWithHandle:(RefreshBlock)refreshingBlock
{
    self.pageNum = 0;
    self.refreshBlock = refreshingBlock;
}

- (void)initFooter
{
    if (self.mj_footer == nil) {
        __weak typeof(self) weakSelf = self;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.refreshBlock) {weakSelf.refreshBlock(YES);}
        }];
        self.mj_footer = footer;
        [footer setTitle:@"上拉加载"forState:MJRefreshStateIdle];
        [footer setTitle:@"没有数据了"  forState:MJRefreshStateNoMoreData];
        [footer setTitle:@"正在加载..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"松开拉取" forState:MJRefreshStateWillRefresh];
        [footer setTitle:@"松开拉取" forState:MJRefreshStatePulling];
    }
}


- (void)beginFooterLoadData
{
    if (self.mj_footer) {
        [self.mj_footer beginRefreshing];
    }
}

- (void)endFooterLoadDataWithBlock:(EndLoadDataBlock)endBlock
{
    if (self.mj_footer) {
        if (endBlock) {
            [self.mj_footer endRefreshing];
            int count = endBlock();
            if (self.pageCount > 0 && count >= self.pageCount) {
                self.pageNum += self.pageCount;
            }else{
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
    //加入数据列表比较少或者没有数据，Footer隐藏
    if (self.contentSize.height < self.frame.size.height) {
        [self removeFooterLoadData];
    }else{
        if (self.mj_footer == nil){
            [self initFooter];
        }
    }
}

- (void)removeFooterLoadData
{
    if (self.mj_footer) {
         [self.mj_footer removeFromSuperview];
         self.mj_footer = nil;
    }
    
}

- (void)initRefreshWithHandle:(RefreshBlock)refreshingBlock
{
    if (self.mj_header == nil) {
        QGRefreshNomalHeader *header = [QGRefreshNomalHeader headerWithRefreshingBlock:^{
            if (refreshingBlock) {refreshingBlock(YES);} 
        }];
        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
        [header setTitle:@"努力刷新中..." forState:MJRefreshStateRefreshing];
        [header setTitle:@"松开刷新" forState:MJRefreshStatePulling];
        [header setTitle:@"松开刷新..." forState:MJRefreshStateWillRefresh];
        self.mj_header = header;
    }
    
    if (self.mj_footer == nil) {
        self.pageNum = 0;
        self.refreshBlock = refreshingBlock;
    }
}

- (void)beginRefresh
{
    if (self.mj_header.state == MJRefreshStateRefreshing) {
        if (self.mj_footer.state == MJRefreshStateRefreshing) {
            [self.mj_footer endRefreshing];
        }
        [self.mj_header beginRefreshing];
    }
    
    if (self.mj_footer.state == MJRefreshStateRefreshing) {
        if (self.mj_header.state == MJRefreshStateRefreshing) {
            [self.mj_header endRefreshing];
        }
        [self.mj_footer beginRefreshing];
    }
}

- (void)endRefreshWithRefreshBlock:(EndRefreshBlock)refreshBlock loadDataBlock:(EndLoadDataBlock)loadDataBlock
{
    if (self.mj_header.state == MJRefreshStateRefreshing) {
        [self.mj_header endRefreshingWithCompletionBlock:refreshBlock];
    }
    
    if (self.mj_footer.state == MJRefreshStateRefreshing) {
        if (loadDataBlock) {
            int count = loadDataBlock();
            [self.mj_footer endRefreshing];
            if (self.pageCount > 0 && count >= self.pageCount) {
                self.pageNum += self.pageCount;
            }else{
                [self.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
    
    //加入数据列表比较少或者没有数据，Footer隐藏
    if (self.contentSize.height < self.frame.size.height) {
        [self removeFooterLoadData];
    }else{
        if (self.mj_footer == nil){
            [self initFooter];
        }
    }
}


@end
