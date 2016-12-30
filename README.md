![效果图](https://github.com/xiachengaa/Calendar/blob/master/calendar.gif)

Calendar 是一个用来选择一个日期区间的UIViewController的子类。
###使用方法
```
CalendarViewController *vc = [CalendarViewController new];
//选择的开始时间和结束时间的时间戳，以秒为单位
vc.choosedBlock = ^(NSTimeInterval startDate, NSTimeInterval finishDate){
        NSString *startDateStr = [EJTimeParseTool changeTimeStampToStringWithFormat:@"yyyy-M-d" timeStamp:startDate * 1000];
        NSString *endDateStr = [EJTimeParseTool changeTimeStampToStringWithFormat:@"yyyy-M-d" timeStamp:finishDate * 1000];
        self.dataLabel.text = [NSString stringWithFormat:@"%@\n%@",startDateStr,endDateStr];
};
[self.navigationController pushViewController:vc animated:YES];
```
