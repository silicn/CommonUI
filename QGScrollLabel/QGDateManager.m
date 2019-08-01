//
//  QGDateFormatter.m
//  QGScrollLabel
//
//  Created by silicn on 2019/7/30.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "QGDateManager.h"

@interface QGDateManager()

@property (nonatomic, strong)NSDateFormatter *formatter;


@end

@implementation QGDateManager

+ (instancetype)shareInstance
{
    static QGDateManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

- (instancetype)shareInstance
{
    return [[self class] shareInstance];
}

QGDateManager * DateManager(){
    return [QGDateManager shareInstance];
}

- (NSString * (^)(double timestamp, NSString * formatter))stringForTimestamp
{
    return ^(double timestamp, NSString * formatter){
        self.formatter.dateStyle = NSDateFormatterMediumStyle;
        self.formatter.timeStyle = NSDateFormatterShortStyle;
        self.formatter.dateFormat = formatter;
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(timestamp)];
        NSString *confromTimespStr = [self.formatter stringFromDate:confromTimesp];
        return confromTimespStr;
    };
}

- (NSString * (^)(double timestamp))defaultFormatterForTimestamp
{
    return ^(double timestamp){
        self.formatter.dateStyle = NSDateFormatterMediumStyle;
        self.formatter.timeStyle = NSDateFormatterShortStyle;
        self.formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:(timestamp)];
        NSString *confromTimespStr = [self.formatter stringFromDate:confromTimesp];
        return confromTimespStr;
    };
}



- (NSString *(^)(NSDate *date,NSString *formatter))stringForDate
{
    return ^(NSDate *date, NSString * formatter){
        self.formatter.dateStyle = NSDateFormatterMediumStyle;
        self.formatter.timeStyle = NSDateFormatterShortStyle;
        self.formatter.dateFormat = formatter;
        
        NSString *confromTimespStr = [self.formatter stringFromDate:date];
        return confromTimespStr;
    };
}

- (BOOL (^)(NSDate *date,NSDate *other))isMonthEqualTo
{
    return ^(NSDate *date, NSDate *other){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlag = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay;
        NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date];
        NSDateComponents *comp2 = [calendar components:unitFlag fromDate:other];
        if (comp1.month == comp2.month) {
            return YES;
        }
        return NO;
    };
}

- (BOOL (^)(NSDate *date,NSDate *other))isYearEqualTo
{
    return ^(NSDate *date, NSDate *other){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlag = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay;
        NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date];
        NSDateComponents *comp2 = [calendar components:unitFlag fromDate:other];
        if (comp1.year == comp2.year) {
            return YES;
        }
        return NO;
    };
}

- (BOOL (^)(NSDate *date,NSDate *other))isSameDay
{
    return ^(NSDate *date, NSDate *other){
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlag = NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay;
        NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date];
        NSDateComponents *comp2 = [calendar components:unitFlag fromDate:other];
        if (comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day) {
            return YES;
        }
        return NO;
    };
}

- (NSDateFormatter *)formatter
{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc]init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
        [_formatter setTimeZone:timeZone];
    }
    return _formatter;
}

@end
