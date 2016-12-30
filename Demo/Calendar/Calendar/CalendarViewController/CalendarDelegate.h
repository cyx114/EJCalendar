//
//  CalendarDelegate.h
//  Calendar
//
//  Created by xiacheng on 2016/12/20.
//  Copyright © 2016年 xiacheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarView.h"

@protocol CalendarDelegate <NSObject>

//计算全部需要展示的月份数，以确定需要多少个cell
-(int)    calcCalendarCount;

//index 所对应的年、月份
-(SDate)  mapIndexToYearMonth : (int) index;

//年、月份所对应的index
-(int)    mapYearMonthToIndex : (SDate) date;

//显示年、月份所在的cell
-(void)   showCalendarAtYearMonth : (SDate) date;

//是否在选择的范围内
-(BOOL)   isInSelectedDateRange : (SDate) date;

//是否是选择的起始时间或者结束时间
- (BOOL)  isStartOrEndDate:(SDate)date;

//设置选中的起始和结束时间
-(void)   setSelectedDateRangeStart : (SDate) start end : (SDate) end;
//设置结束时间
-(void)   setEndSelectedDate : (SDate) end;

//重绘CalendarViews
-(void)   repaintCalendarViews;

//点击的次数，奇数和偶数的响应方法不一样
-(void)   updateHitCounter;

//获取当前的点击次数，
-(int)    getHitCounter;


@end

