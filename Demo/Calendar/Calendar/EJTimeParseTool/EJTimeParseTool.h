//
//  EJTimeParseTool.h
//  DaDaGo
//
//  Created by xiacheng on 16/5/27.
//  Copyright © 2016年 xiacheng. All rights reserved.
//

//**********************************
//这里时间戳的单位统一换算成 毫秒(ms)  ,数据类型用long， long
//所有的时间戳都是GMT时区, 但是转化为date和字符串时会用当地时区的转换
//包括date 和 字符 转换成时间戳时
//**********************************

#import <Foundation/Foundation.h>

@interface EJTimeParseTool : NSObject

#pragma mark - 由NSDate 返回星期信息
/**
 *  yyyy-MM-dd HH:mm:ss HH24小时制)
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

#pragma mark - 计算剩余天数
+ (NSInteger)surplusDyasWithTimeStamp:(long long)stamp;

#pragma mark - 根据生日计算年龄 //返回的是取整后的年份，不会四舍五入,如果不到1岁则会自动算一岁
/**
 *  yyyy-MM-dd HH:mm:ss HH24小时制)
 */
+ (float )ageWithBirthdayStamp:(long long)stamp;

#pragma mark - 根据生日计算年龄，如果不满一岁，则计算月份，直接返回字符串
+ (NSString *)ageStringWithBirthdayStamp:(long long)birth;

#pragma mark - 计算两个时间间隔的天数，主要用来计算宠物宠物时间
+ (NSInteger)intervalDaysWithStartTimeStamp:(long long)startStamp endTimeStamp:(long long)endTimeStamp;

#pragma mark - 计算两个时间间隔的时间，只能设置单个flag，多个时可能会出问题
//可以用@"year",@"month",@"day",@"hour",@"minute" 为时间单位(直接用NSCalendarUnit)
+ (long)intervalDaysWithStartTimeStamp:(long long)startStamp endTimeStamp:(long long)endTimeStamp calendarUnit:(NSCalendarUnit)flag;

#pragma mark - 字符串转换成时间戳
/**
 *  yyyy-MM-dd HH:mm:ss HH24小时制)
 */
+ (long long)changeTimeStringToStampWithFomat:(NSString *)format timeString:(NSString *)timeStr;


#pragma mark - 时间戳转换成字符串
/**
 *  yyyy-MM-dd HH:mm:ss HH24小时制)
 */
+ (NSString *)changeTimeStampToStringWithFormat:(NSString *)format timeStamp:(long long)stamp;

#pragma mark - 时间戳转换成NSDate
/**
 *  yyyy-MM-dd HH:mm:ss HH24小时制)
 */
+ (NSDate *)changeTimeStampToDateWithSystemZone:(long long)timeStamp;

#pragma mark - 字符串转换成NSData
/**
 *  yyyy-MM-dd HH:mm:ss HH24小时制)
 */
+ (NSDate *)changeTimeStringToDateWithFormat:(NSString *)format timeString:(NSString *)timeStr;
@end
