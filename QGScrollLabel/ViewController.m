//
//  ViewController.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/8.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "ViewController.h"
#import "MyViewCell.h"

#import "UITableView+RefreshControl.h"

#import "QGRotationCircleView.h"

#import "UIButton+QGLoading.h"

#import "SLCircleView.h"

#import "QGDateManager.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;

//    self.tableView.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyViewCell" bundle:nil] forCellReuseIdentifier:@"MyViewCell"];
    __weak typeof(self) weakSelf = self;
    
    
    NSArray *dataSource = @[@"nihao",@"ceshi "];

    self.tableView.pageCount = 10;
    [self.tableView initRefreshWithHandle:^(BOOL isRefresh) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView endRefreshWithRefreshBlock:^{
                NSLog(@"呵呵呵呵");
            } count:4];
            [self.tableView reloadData];
      });
    }];
    

    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 40);
    btn.center = self.view.center;
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor colorWithRed:252/255.0 green:107/255.0 blue:80/255.0 alpha:1.0];
    btn.layer.cornerRadius = 20;
    btn.clipsToBounds = YES;
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    SLCircleView *circle = [[SLCircleView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//    circle.backgroundColor = [UIColor blueColor];
    circle.center = self.view.center;
    [self.view addSubview:circle];

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("silicn", 0);
    dispatch_queue_t queue1 = dispatch_queue_create("silicn", 0);
    
    NSLog(@"%@ %@",queue,queue1);
    
    dispatch_async(queue, ^{
        NSLog(@"test queue = %@",[NSThread currentThread]);
    });
    
    dispatch_async(queue1, ^{
        NSLog(@"test queue1 = %@",[NSThread currentThread]);
    });
    
    //A耗时操作
  __block  NSInteger number = 0;
    //B网络请求
//    dispatch_group_enter(group);
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
     NSLog(@"代码执行  1");
   dispatch_group_enter(group);
//    dispatch_group_async(group,queue, ^{
        NSLog(@"queue执行 %@  1 ",[NSThread currentThread]);
        [self sendRequestWithCompletion:^(id response) {
            NSLog(@"dispatch_group_complete 1");
            number += [response integerValue];
            dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
        } flag:1];
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    });
    

    
    
    NSLog(@"代码执行  2");
    dispatch_group_enter(group);
//    dispatch_group_async(group,queue, ^{
         NSLog(@"queue执行 %@  2",[NSThread currentThread]);
        [self sendRequestWithCompletion:^(id response) {
            NSLog(@"dispatch_group_complete 2");
            number += [response integerValue];
                        dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
        } flag:2];
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_group_enter(group);
//    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"代码执行  3");
    dispatch_group_enter(group);
//    dispatch_group_async(group,queue, ^{
         NSLog(@"queue执行 %@  3",[NSThread currentThread]);
        [self sendRequestWithCompletion:^(id response) {
            NSLog(@"dispatch_group_complete 3");
            number += [response integerValue];
                        dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
        } flag:3];
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//        dispatch_group_enter(group);
//    });
    
    NSLog(@"代码执行  4");
    dispatch_group_enter(group);
//    dispatch_group_async(group,queue, ^{
         NSLog(@"queue执行 %@  4",[NSThread currentThread]);
        [self sendRequestWithCompletion:^(id response) {
            NSLog(@"dispatch_group_complete 4");
            number += [response integerValue];
                        dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
        } flag:4];
//        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//         dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
//    });
   
  
//    dispatch_group_async(group, queue, ^{
//        NSLog(@"group 触发 %@",[NSThread currentThread]);
//        [self sendRequestWithCompletion:^(id response) {
//            number += [response integerValue];
////            dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
//        } flag:1];
//         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    });

    
    //C网络请求

//    dispatch_group_enter(group);
//    NSLog(@"进入 group  2");
//    dispatch_group_async(group, queue, ^{
//        [self sendRequestWithCompletion:^(id response) {
//            number += [response integerValue];
//
//            dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
//        } flag:2] ;
//         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    });
//
//    dispatch_group_enter(group);
//    NSLog(@"进入 group  3");
//    dispatch_group_async(group, queue, ^{
//        [self sendRequestWithCompletion:^(id response) {
//            number += [response integerValue];
//
//            dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
//        } flag:3] ;
//         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    });
//
//
//    dispatch_group_enter(group);
//    NSLog(@"进入 group  4");
//    dispatch_group_async(group, queue, ^{
//        [self sendRequestWithCompletion:^(id response) {
//            number += [response integerValue];
//
//            dispatch_group_leave(group);
//            dispatch_semaphore_signal(sema);
//        } flag:4] ;
//         dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    });
//
    
  
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        NSLog(@"%zd", number);
    });
    
//    self.tableView.tableFooterView = [[UIView alloc]init];
    

  
    
    // Do any additional setup after loading the view.
}


- (void)testCondition
{
    NSConditionLock *lock = [[NSConditionLock alloc]init];
    
    NSMutableArray *products = [NSMutableArray array];
    NSUInteger pdt_cnt_state_0 = 0;  // 初始条件
    NSUInteger pdt_cnt_state_1 = 1;  // 当前有数据量是4
    NSUInteger pdt_cnt_state_2 = 2;  // 当前有数据是12
    NSUInteger pdt_cnt_state_3 = 3;  // 当前数据是  18
    
    
    
    
    // 这里主要是为了自增数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            [lock lockWhenCondition:pdt_cnt_state_0];
            NSLog(@"add product -----  ");
            [products addObject:[[NSObject alloc] init]];
            [products addObject:[[NSObject alloc] init]];
            [products addObject:[[NSObject alloc] init]];
            [products addObject:[[NSObject alloc] init]];
            NSLog(@"----------   total product,数组总数量 =  %zi",products.count);
            if (products.count == 4) {
                // 达到第一个条件,释放条件信号
                [lock unlockWithCondition:pdt_cnt_state_1];
            }else if (products.count == 10){
                // 达到第二个条件,释放条件信号
                [lock unlockWithCondition:pdt_cnt_state_2];
            }else if (products.count == 16){
                // 达到第三个条件,释放条件信号
                [lock unlockWithCondition:pdt_cnt_state_3];
            }else{
                // 释放条件信息, 即继续addObject
                [lock unlockWithCondition:pdt_cnt_state_0];
            }
            
            sleep(1);
        }
    });
    
    // 条件一
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            
            [lock lockWhenCondition:pdt_cnt_state_1];
            NSLog(@"****进入条件一 state_1");
            // 删除两条数据
            [products removeObjectAtIndex:0];
            [products removeObjectAtIndex:0];
            NSLog(@"state_1  current = %zi",products.count);
            // 返回继续增加数据
            [lock unlockWithCondition:pdt_cnt_state_0];
            sleep(1);
        }
    });
    
    // 条件二
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            
            [lock lockWhenCondition:pdt_cnt_state_2];
            NSLog(@"****进入条件二 state_2");
            // 删除两条数据
            [products removeObjectAtIndex:0];
            [products removeObjectAtIndex:0];
            NSLog(@"state_2  current = %zi",products.count);
            // 返回继续增加数据
            [lock unlockWithCondition:pdt_cnt_state_0];
            sleep(1);
        }
    });
    
    // 条件三
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            
            [lock lockWhenCondition:pdt_cnt_state_3];
            NSLog(@"****into state_3");
            // 删除两条数据
            [products removeObjectAtIndex:0];
            [products removeObjectAtIndex:0];
            NSLog(@"state_3  current = %zi",products.count);
            // 返回继续增加数据
            [lock unlockWithCondition:pdt_cnt_state_0];
            sleep(1);
        }
    });
}


- (void)sendRequestWithCompletion:(void (^)(id response))completion flag:(NSInteger)flag {
    //模拟一个网络请求
    sleep(2);
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//         NSLog(@"group 执行 %@  %d",[NSThread currentThread],flag);
//
//         if (completion) completion(@1111);
//        dispatch_async(dispatch_get_main_queue(), ^{
//             NSLog(@"dispatch_group_complete %ld",flag);
//        });
//    });

}

- (void)btnAction:(UIButton *)btn
{
    [btn beginLoadingWithLoadStateName:@"提交中..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [btn endLoading];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyViewCell"];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *vc  = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIImage *)circleImageWithColor:(UIColor *)color
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(36*scale, 36*scale);
    // 开始图形上下文，NO代表透明
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [color setFill];
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillEllipseInRect(ctx,rect);
    CGContextClip(ctx);
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}


@end
