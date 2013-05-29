//
//  FDViewController.m
//  Frida+DateSelect
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "FDViewController.h"
#import "TSQTACalendarRowCell.h"
#import <TimesSquare/TimesSquare.h>
#import <TimesSquare/TSQCalendarView.h>


@interface FDViewController ()

@end

@interface FDViewController ()

@property (nonatomic, retain) NSTimer *timer;

@end


@interface TSQCalendarView (AccessingPrivateStuff)

@property (nonatomic, readonly) UITableView *tableView;

@end

@implementation FDViewController



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad;
{
  [super viewDidLoad];

  TSQCalendarView *calendarView = [[TSQCalendarView alloc] init];
  calendarView.calendar = self.calendar;
  calendarView.rowCellClass = [TSQTACalendarRowCell class];
  calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
  calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 5];
  calendarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
  calendarView.pagingEnabled = YES;
  CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
  calendarView.contentInset = UIEdgeInsetsMake(50.0f, onePixel, 0.0f, onePixel);
  
  UIView *prodView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
  prodView.backgroundColor = [UIColor colorWithRed:62 green:62 blue:0 alpha:1];
  
  self.view = calendarView;
}

- (void)setCalendar:(NSCalendar *)calendar;
{
  _calendar = calendar;
  
  self.navigationItem.title = calendar.calendarIdentifier;
  self.tabBarItem.title = calendar.calendarIdentifier;
}

- (void)viewDidLayoutSubviews;
{
  // Set the calendar view to show today date on start
}

- (void)viewDidAppear:(BOOL)animated;
{
  [super viewDidAppear:animated];
  
  // Uncomment this to test scrolling performance of your custom drawing
  //    self.timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated;
{
  [self.timer invalidate];
  self.timer = nil;
}
/*
- (void)scroll;
{
  static BOOL atTop = YES;
  TSQCalendarView *calendarView = (TSQCalendarView *)self.view;
  UITableView *tableView = calendarView.tableView;
  
  [tableView setContentOffset:CGPointMake(0.f, atTop ? 10000.f : 0.f) animated:YES];
  atTop = !atTop;
}
*/

@end
