//
//  CalendarView.h
//  Calendar
//
//  Created by xiacheng on 2016/12/20.
//  Copyright © 2016年 xiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//c语言实现
//为什么用c
//为了通用性，将日期操作以及月历操作全部使用c函数，有利于移植到android系统
//因为ios和android都支持c函数

#ifdef ANDROID_VERSION

struct _CGPoint {
    float x;
    float y;
}CGPoint;


/* Sizes. */
struct _CGSize {
    float width;
    float height;
}CGSize;

/* Rectangles. */
struct _CGRect {
    CGPoint origin;
    CGSize size;
}CGRect;

#endif

#pragma mark - SDate Defination

typedef struct _date
{
    int year;
    int month;
    int day;
} SDate;

void date_set(SDate* date,int year,int month,int day);   //创建一个指定date
void date_get_now(SDate* date);                          //获取现在的date
bool date_is_equal(const SDate* left,const SDate* right); //两个date 是否相等
time_t date_get_time_t(const SDate* d);                   //获取日期对应的时间戳，以s为单位  ?
void date_get_next_month(SDate* date, int delta);         //获取date在delta个月后的date
void date_get_prev_month(SDate* date, int delta);         //获取date在delta个月之前的date
int  date_get_week(const SDate* date);                    //获取星期几,0~6,代表周日到周六
int  date_get_month_of_day(int year, int month);          //获取此月份的天数

int  date_get_leap(int year);                             //如果year是闰年，则返回1，否则返回0
int  date_get_month_count_from_year_range(int startYear,int endYear);   //两个年份之间相差的月数
void date_map_index_to_year_month(SDate* to,int startYear,int idx);     //根据起始年份，和index，计算出该index的年份和月份



#pragma mark - SCalendar Defination

typedef struct _calendar
{
    CGRect  inset;       //偏移?
    CGSize  size;        //?
    SDate   date;        //?
    
    float   yearMonthSectionHeight;  //显示年月label的高度
    float   weekSectionHegiht;       //显示week的label的高度
    
    //blf:计算出来的结果，第三方不要设置这些变量
    float daySectionHeight;
    int   dayBeginIdx;
    int   dayCount;
    
}SCalendar;

void calendar_init(SCalendar* calendar,CGSize ownerSize,float yearMonthHeight,float weekHeight); //创建一个calendar对象
void calendar_set_year_month(SCalendar* calendar,int year,int month);                            //设置calendar的年份和月份
void calendar_get_year_month(SCalendar* calendar,int* year,int* month);                          //calendar目前的年份和月份
void calendar_get_year_month_section_rect(const SCalendar* calendar,CGRect* rect);               //获取此calendar 的年月label的rect
void calendar_get_week_section_rect(const SCalendar* calendar,CGRect* rect);                     //获取此calendar 的星期label的rect
void calendar_get_day_section_rect(const SCalendar* calendar,CGRect* rect);                      //获取此calendar 的日期模块的rect
void calendar_get_week_cell_rect(const SCalendar* calendar,CGRect* rect,int idx);                //获取星期的每个index的位置 rect
void calendar_get_day_cell_rect(const SCalendar* calendar,CGRect* rect,int rowIdx,int columIdx); //(二维坐标)获取一个day模块中每个item位置的rect
void calendar_get_day_cell_rect_by_index(const SCalendar* calendar,CGRect* rect,int idx);        //(一维坐标)获取一个day模块中每个item位置的rect
int  calendar_get_hitted_day_cell_index(const SCalendar* calendar, CGPoint localPt);             //获取day模块中被点击到的item的一维坐标,其中localPt是转化为calendar所在view后的坐标

#pragma mark - CalendarView
@interface CalendarView : UIControl

-(void) setYearMonth : (int) year month : (int) month;

@property (weak, nonatomic) id  calendarDelegate;

@end

