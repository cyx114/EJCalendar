//
//  CalendarViewController.m
//  Calendar
//
//  Created by xiacheng on 2016/12/20.
//  Copyright © 2016年 xiacheng. All rights reserved.
//
/*可以优化:
 1. 可以动态设置其起始时间和结束时间，并且可以以月为最小单位,现在只能设置年为最小单位
*/
#import "CalendarViewController.h"
#import "CalendarDelegate.h"

#define MYSWAP(x,y,type)    \
{                           \
type t = x;             \
x = y;                  \
y = t;                  \
}


@interface CalendarViewController ()<UITableViewDataSource,UITableViewDelegate,CalendarDelegate>
{
    //用于计算出多少个月历，具体见下面代码
    int      _startYear;
    int      _endYear;
    
    //每个月历控件的高度，上面的个数和此地的高度，就可以计算整个UITableView的高度以及进行定位操作
    float    _calendarHeight;
    
    //用于选中操作时候，时间范围的比较（time_t实际是个64位的整型值，适合做比较操作，具体看实现代码），用来存储两次点击的所在的时间，不保证startTime的时间比endTime早
    time_t   _startTime;
    time_t   _endTime;
}
@property  (nonatomic, strong) UIBarButtonItem  *rightBarItem; //右边确认按钮

//选中值的年月表示方式，方便显示而已，实际操作都转换成time_t类型
@property  (nonatomic,assign)  SDate  begDate;
@property  (nonatomic,assign)  SDate  endDate;

//点击计数器，用于确定当前点击的奇偶性，因此改月历控件涉及两次操作，用于区域选择
@property (nonatomic)  int  hitCounter;

//作为Calendar的父容器，用于处理滑动以及cell重用
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation CalendarViewController


#pragma mark - life cycle


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择日期";
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取当前的年月
    SDate date;
    date_get_now(&date);
    
    //这里是可以选择的时间范围,默认是去年、今年、明年,共3年
    _startYear   = date.year-1;
    _endYear     = date.year+1;
    
    //touch 计数器
    _hitCounter  = 0;
    
    float scale = 0.6F;//硬编码，最好由外部设置0.6
    _calendarHeight  = self.tableView.frame.size.height * scale;
    
    //default定位显示当前月份
    if (self.begDate.year == 0) {
        self.begDate = date;
        [self showCalendarAtYearMonth:date];
    }else{
        //当然你也可以设置具体月份重点显示
        [self showCalendarAtYearMonth:self.begDate];
    }
}

#pragma mark - delegates
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int ret = [self calcCalendarCount];
    return ret;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* calendarID = @"calendarID";
    
    float width = self.tableView.frame.size.width;
    
    //从行索引号映射到年月
    SDate date = [self mapIndexToYearMonth:(int)indexPath.row];
    
    //获取重用的cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:calendarID ];
    
    //如果为null，说明不存在，创建该cell
    if(cell == nil)
    {
        //可以在此断点，查看一下具体生成了多少个calendarView(我这里生成了3个）
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:calendarID];
        [cell setTag:10];
        //手动创建CalendarView
        CalendarView* calendarView = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, width, _calendarHeight)];
        //设置CalednarDelegate
        calendarView.calendarDelegate = self;
        //给定一个tag号，用于重用时获得该view
        [calendarView setTag:1000];
        [cell.contentView addSubview:calendarView];
    }
    
    //通过tag号，获取view
    CalendarView* view =(CalendarView*) [cell.contentView viewWithTag:1000];
    
    //设置CalendarView的年月
    [view setYearMonth:date.year month:date.month];
    
    return cell;
}

#pragma mark  Table view data delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return _calendarHeight;
    return [self p_cellHeightForIndexPath:indexPath];
}


#pragma mark - custom delegates
#pragma mark CalendarDelegate
-(int) calcCalendarCount
{
    SDate date;
    date_get_now(&date);
    
    //计算出当前的年月到n年前的1月份的月数
    //假设当前为2016年8月，n为5，则月份范围为［2011年1月－－－2016年8月 总计月数为］
    int diff = _endYear - _startYear + 1;
    diff = diff * 12;
    diff -= (12 - date.month);
    return diff;
}

-(SDate) mapIndexToYearMonth : (int) index
{
    SDate ret;
    date_map_index_to_year_month(&ret, _startYear, index);
    return ret;
}

-(int) mapYearMonthToIndex:(SDate)date
{
    int yearDiff = date.year - _startYear;
    int index = yearDiff * 12;
    index += date.month;
    index -= 1;
    return index;
}

-(void) showCalendarAtYearMonth:(SDate)date
{
    if(date.year < _startYear || date.year > _endYear)
        return;
    
    int idx = [self mapYearMonthToIndex:date];
    
    //当index = calendarViews.length-1时，可能存在超过整个UITableView ContentSize.height情况，此时，UITableView会自动调整contentOffset的值，使其符合定位到最底端，android listview也是如此。
    self.tableView.contentOffset = CGPointMake(0.0F, idx * _calendarHeight );
}

//由于UITableView采用了cell重用机制，因此仅有和屏幕rect相交的cell存在
//所以是cells一直轮替交换，所以我们必须在每次自绘时候判断当前的cell中的月历的每个日期是否处于选中状态
//而本函数就是起到这样的作用，判断月历中某个日期是否处于选中的区间范围
-(BOOL)isInSelectedDateRange : (SDate) date
{
    time_t curr = date_get_time_t(&date);
    
    if(curr < _startTime || curr > _endTime)
        return NO;
    
    return YES;
}

//判断是否是开始日期或者是结束日期
- (BOOL)isStartOrEndDate:(SDate)date
{
    time_t curr = date_get_time_t(&date);
    if (curr == _startTime || curr == _endTime) {
        return YES;
    }
    return NO;
}


-(void)setSelectedDateRangeStart:(SDate)start end:(SDate)end
{
    
    //将date转换为time_t
    _startTime = date_get_time_t(&start);
    _endTime   = date_get_time_t(&end);
    
    //如果起始时间大于结束时间，说明先点击后一天，再点击前一天，绘制时的逻辑不正确，需要交换一下时间
    if(_startTime > _endTime)
    {
        MYSWAP(_startTime,_endTime,time_t);
        
        //纪录下年月表示起始结束date
        self.begDate = end;
        self.endDate = start;
        
    }else{
        
        self.begDate = start;//记录日期
        self.endDate = end;
    }
}

-(void)setEndSelectedDate:(SDate)end
{
    //同上，只是针对第二次点击而已
    _endTime = date_get_time_t(&end);
    if(_startTime > _endTime)
    {
        MYSWAP(_startTime,_endTime,time_t);
        self.endDate = _begDate;
        self.begDate = end;
    }else{
        self.endDate = end;
    }
}

-(void) repaintCalendarViews
{
    //[self.tableView setNeedsDisplay];
    
    for(UIView * subview in self.tableView.subviews)
    {
        
        for(UIView* view2 in subview.subviews)
        {
            UITableViewCell* cell = (UITableViewCell*)view2;
            CalendarView* cview  =(CalendarView*) [cell.contentView.subviews objectAtIndex:0];
            [cview setNeedsDisplay];
        }
    }
}

-(void) updateHitCounter
{
    _hitCounter++;
}

-(int) getHitCounter
{
    return _hitCounter;
}



#pragma mark - event responses


#pragma mark - private methods
/* int year;
 int month;
 int day;
 */
- (NSTimeInterval)p_translateSDateToNSTimeInterval:(SDate)date
{
    NSString *dateStr = [NSString stringWithFormat:@"%i-%i-%i",date.year,date.month,date.day];
    NSString *dateFormat = @"YY-M-d";
    NSTimeInterval interval = [self changeTimeStringToStampWithFomat:dateFormat timeString:dateStr];
    return interval;
}

- (NSTimeInterval)changeTimeStringToStampWithFomat:(NSString *)format timeString:(NSString *)timeStr
{
    NSDateFormatter *timeFormat=[[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:format];
    NSDate *fromdate=[timeFormat dateFromString:timeStr];
    NSTimeInterval time = [fromdate timeIntervalSince1970];
    return time;
}

#pragma mark - getters and setters

- (void)setBegDate:(SDate)begDate
{
    _begDate = begDate;
    self.startDate = [self p_translateSDateToNSTimeInterval:_begDate];
}

- (void)setEndDate:(SDate)endDate
{
    _endDate = endDate;
    self.finishDate = [self p_translateSDateToNSTimeInterval:_endDate];
}

//计算cell显示的高度，多出的空白部分被隐藏
- (float)p_cellHeightForIndexPath:(NSIndexPath *)indexPath
{
    SDate date = [self mapIndexToYearMonth:(int)indexPath.row];
    int week = date_get_week(&date);
    float singlePercent = 0.8 / 6.0;
    int totalLine = 1;
    int dayCount = date_get_month_of_day(date.year, date.month);
    //去掉第一行显示的天数
    dayCount -= (7 - week);
    int addLine = dayCount / 7;
    int moreLine = (dayCount % 7) > 0 ? 1 : 0;
    totalLine = totalLine + addLine + moreLine;
    float height = _calendarHeight * (1 - (6-totalLine) * singlePercent);
    return height;
}



#pragma mark - rightBarItem
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
}
- (UIBarButtonItem *)rightBarItem
{
    if (!_rightBarItem) {
        _rightBarItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    }
    return _rightBarItem;
}

- (void)rightBarItemClicked
{
    if (self.startDate == self.finishDate) {
        //        [self.view makeToast:@"请选择一个时间区间" duration:1 position:CSToastPositionCenter];
        NSLog(@"请选择一个时间区间");
    }else{
        if (self.choosedBlock) {
            self.choosedBlock(self.startDate,self.finishDate);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
