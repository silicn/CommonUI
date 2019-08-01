//
//  QGDateFormatter.h
//  QGScrollLabel
//
//  Created by silicn on 2019/7/30.
//  Copyright © 2019 Silicn. All rights reserved.
//


/**
 时间转化的单例
 For Example:
 
 DateManager().stringForTimestamp(32312312,"yyyy-MM-dd")
 或者
 QGDateManager.shareInstance.stringForTimestamp(32312312,"yyyy-MM-dd")
 
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGDateManager : NSObject

QGDateManager * DateManager(void);

+ (instancetype)shareInstance;

- (instancetype)shareInstance;

#pragma mark - stringForTimestamp
/// 时间戳转化成时间
@property (nonatomic, readonly,copy) NSString * (^stringForTimestamp)(double timestamp, NSString *formatter);
#pragma mark - defaultFormatterForTimestamp
/// 默认格式时间 yyyy-MM-dd 
@property (nonatomic, readonly,copy) NSString * (^defaultFormatterForTimestamp)(double timestamp);
#pragma mark - stringForDate
/// NSDate转化成时间
@property (nonatomic, readonly,copy) NSString * (^stringForDate)(NSDate * date, NSString *formatter);
#pragma mark - isMonthEqualTo
/// 比较两个时间是否月份相等
@property (nonatomic, readonly, copy) BOOL (^isMonthEqualTo)(NSDate *date,NSDate *other);
#pragma mark - isYearEqualTo
/// 比较两个时间是否是年份相等
@property (nonatomic, readonly, copy) BOOL (^isYearEqualTo)(NSDate *date,NSDate *other);
#pragma mark - isSameDay
/// 比较两个时间是否同一天
@property (nonatomic, readonly, copy) BOOL (^isSameDay)(NSDate *date,NSDate *other);





@end

NS_ASSUME_NONNULL_END
