//
//  EJTimeParseTool.m
//  DaDaGo
//
//  Created by xiacheng on 16/5/27.
//  Copyright © 2016年 xiacheng. All rights reserved.
//

#import "EJTimeParseTool.h"

/*
 1. [NSDate date] 获取的时间是相对于当前时区的时间。
 2.
 */

@implementation EJTimeParseTool

#pragma mark - 由NSDate 返回星期信息
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
//    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: [NSTimeZone systemTimeZone]];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

#pragma mark 根据生日计算年龄  //返回的是取整后的年份，不会四舍五入,如果不到岁则会自动算一岁
+ (float)ageWithBirthdayStamp:(long long)stamp
{
    NSDate *today =[NSDate date];
    NSDate *birthday = [self changeTimeStampToDateWithSystemZone:stamp];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSCalendarUnit unitFlags = NSCalendarUnitYear;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:birthday toDate:today options:0];
    //距现在多少年
    NSInteger age = [components year];
    if (age < 1) {
        age = 1;
    }
    return age;
}

#pragma mark - 根据生日计算年龄，如果不满一岁，则计算月份，直接返回字符串
+ (NSString *)ageStringWithBirthdayStamp:(long long)birth
{
    long long todayStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    //年份
    long year = [self intervalDaysWithStartTimeStamp:birth endTimeStamp:todayStamp calendarUnit:NSCalendarUnitYear];
    if (year >= 1) {
        NSString *yearStr = [NSString stringWithFormat:@"%li岁",year];
        return yearStr;
    }
    //如果不满一年，则计算月份
    long month = [self intervalDaysWithStartTimeStamp:birth endTimeStamp:todayStamp calendarUnit:NSCalendarUnitMonth];
    //不满一个月按一个月算
    if (month < 1) {
        month = 1;
    }
    NSString *monthStr = [NSString stringWithFormat:@"%li个月",month];
    return monthStr;
}

#pragma mark - 计算剩余天数 //TD  是否需要改进，会不会有显示0天的情况？这样不太好。
//只用来计算剩余天数
+ (NSInteger)surplusDyasWithTimeStamp:(long long)stamp
{
    NSDate *today = [NSDate date];
    NSDate *endDate = [self changeTimeStampToDateWithSystemZone:stamp];//时区问题
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone: [NSTimeZone systemTimeZone]];
    NSCalendarUnit unitFlags = NSCalendarUnitDay;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:today toDate:endDate options:0];
    //距现在多少天
    NSInteger days = [components day];
    if (days < 0) {
        return 0;
    }else{
        days += 1;
    }
    return days;
}

#pragma mark - 计算两个时间间隔的天数，主要用来计算宠物宠物时间
+ (NSInteger)intervalDaysWithStartTimeStamp:(long long)startStamp endTimeStamp:(long long)endTimeStamp
{
    NSDate *startDate = [self changeTimeStampToDateWithSystemZone:startStamp];
    NSDate *endDate = [self changeTimeStampToDateWithSystemZone:endTimeStamp];//时区问题
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone: [NSTimeZone systemTimeZone]];
    NSCalendarUnit unitFlags = NSCalendarUnitDay;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    NSInteger days = [components day];
    
    if (!days) {
        return 0;
    }
    
    return days;
}


#pragma mark - 计算两个时间间隔的时间，
//可以指定不同的unit 
//可以用@"year",@"month",@"day",@"hour",@"minute" 为时间单位
+ (long)intervalDaysWithStartTimeStamp:(long long)startStamp endTimeStamp:(long long)endTimeStamp calendarUnit:(NSCalendarUnit)flag
{
    NSDate *startDate = [self changeTimeStampToDateWithSystemZone:startStamp];
    NSDate *endDate = [self changeTimeStampToDateWithSystemZone:endTimeStamp];//时区问题
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setTimeZone: [NSTimeZone systemTimeZone]];
    NSCalendarUnit unitFlags = flag;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    long result = -100;
    switch (flag) {  //不用管他，只用到这么多。
        case NSCalendarUnitYear:
            result =[components year];
            break;
        case NSCalendarUnitMonth:
            result =[components month];
            break;
        case NSCalendarUnitDay:
            result =[components day];
            break;
        case NSCalendarUnitHour:
            result =[components hour];
            break;
        case NSCalendarUnitMinute:
            result =[components minute];
            break;
    }
    
    return result;
}


#pragma mark - 字符串转换成时间戳
+ (long long)changeTimeStringToStampWithFomat:(NSString *)format timeString:(NSString *)timeStr
{
    NSDateFormatter *timeFormat=[[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:format];
    NSDate *fromdate=[timeFormat dateFromString:timeStr];
    NSTimeInterval time = (long)[fromdate timeIntervalSince1970];
    long long result = (long long)(time * 1000);
    return result;
}

#pragma mark - 时间戳转换成字符串
+ (NSString *)changeTimeStampToStringWithFormat:(NSString *)format timeStamp:(long long)stamp
{
    NSDate *date = [self changeTimeStampToDateWithSystemZone:stamp];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:format];
    NSString* timeStr = [dateFormat stringFromDate:date];
    return timeStr;
}

#pragma mark - 时间戳转换成date(当前地区)
+ (NSDate*)changeTimeStampToDateWithSystemZone:(long long)timeStamp{
    NSTimeInterval secStamp = (NSTimeInterval)(timeStamp / 1000.0f);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secStamp];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:confromTimesp];
//    NSDate *localeDate = [confromTimesp  dateByAddingTimeInterval: interval];
    NSDate *localeDate = date;
    return localeDate;
}

#pragma mark - 字符串转换成NSDate
+ (NSDate *)changeTimeStringToDateWithFormat:(NSString *)format timeString:(NSString *)timeStr
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:format];
    NSDate *date = [dateFormat dateFromString:timeStr];
    return date;
}


@end
