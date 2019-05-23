//
//  RootViewController.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/8.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"

#import "TestViewController.h"
#import "QGCustomTabBar.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *vc = [[ViewController alloc]init];
    TestViewController *vc1 = [[TestViewController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    
    self.viewControllers = @[nav,nav1];
    
    QGCustomTabBar *tabBar = [[QGCustomTabBar alloc]init];
    
    QGTabBarItemModel *model = [[QGTabBarItemModel alloc]initWithTitle:@"主页" nomalImage:[UIImage imageNamed:@"image"] selectImage:nil];
    QGTabBarItemModel *model1 = [[QGTabBarItemModel alloc]initWithTitle:@"我的" nomalImage:[UIImage imageNamed:@"image"] selectImage:nil];
    tabBar.barItems = @[model,model1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        QGTabBarItemModel *model2 = [[QGTabBarItemModel alloc]initWithTitle:@"测试" nomalImage:[UIImage imageNamed:@"image-1"] selectImage:nil];
        QGTabBarItemModel *model3 = [[QGTabBarItemModel alloc]initWithTitle:@"外侧" nomalImage:[UIImage imageNamed:@"image-1"] selectImage:nil];
        QGTabBarItemModel *model4 = [[QGTabBarItemModel alloc]initWithTitle:@"内测" nomalImage:[UIImage imageNamed:@"image-1"] selectImage:nil];
        tabBar.barItems = @[model2,model3,model4];
        tabBar.textColor = [UIColor redColor];
        tabBar.font = [UIFont systemFontOfSize:14.0f];
    });
    
     [tabBar badgeValue:99 atIndex:1];
     [tabBar badgeValue:2 atIndex:0];
     tabBar.badgeColor = [UIColor blueColor];
    
     [self setValue:tabBar forKey:@"tabBar"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tabBar updateTabBarItemWithModel:model atIndex:0];
    });
    
    
//     [tabBar removeAllBadgeValue];
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
