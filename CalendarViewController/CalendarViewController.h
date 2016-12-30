//
//  CalendarViewController.h
//  Calendar
//
//  Created by xiacheng on 2016/12/20.
//  Copyright © 2016年 xiacheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarView.h"

//时间戳，单位为s
typedef void(^DateChoosedBlock)(NSTimeInterval startDate, NSTimeInterval finishDate);

@interface CalendarViewController :UIViewController

//选择的起始时间戳,单位s
@property (nonatomic, assign)  NSTimeInterval startDate;
//选择的结束时间戳，单位s
@property (nonatomic, assign)  NSTimeInterval finishDate;


@property (nonatomic, copy)  DateChoosedBlock choosedBlock;



@end
