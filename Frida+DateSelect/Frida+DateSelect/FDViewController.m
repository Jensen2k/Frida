//
//  FDViewController.m
//  Frida+DateSelect
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "FDViewController.h"

@implementation FDViewController



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad;
{
  [super viewDidLoad];
  self.calView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:NO];
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
