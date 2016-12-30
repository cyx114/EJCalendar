//
//  ViewController.m
//  Calendar
//
//  Created by xiacheng on 2016/12/20.
//  Copyright © 2016年 xiacheng. All rights reserved.
//

#import "ViewController.h"
#import "CalendarViewController.h"
#import "EJTimeParseTool.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dataLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataLabel.text = @"1970-1-1\n2016-12-20";
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)chooeDateAction:(id)sender {
    CalendarViewController *vc = [CalendarViewController new];
    vc.choosedBlock = ^(NSTimeInterval startDate, NSTimeInterval finishDate){
        NSString *startDateStr = [EJTimeParseTool changeTimeStampToStringWithFormat:@"yyyy-M-d" timeStamp:startDate * 1000];
        NSString *endDateStr = [EJTimeParseTool changeTimeStampToStringWithFormat:@"yyyy-M-d" timeStamp:finishDate * 1000];
        self.dataLabel.text = [NSString stringWithFormat:@"%@\n%@",startDateStr,endDateStr];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
