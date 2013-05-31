//
//  FDViewController.m
//  Frida+DateSelect
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "FDViewController.h"
#import "CKCalendarView.h"

@interface FDViewController () <CKCalendarDelegate>

@property(nonatomic, strong) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;

@end

@implementation FDViewController

- (IBAction)didClickClose:(id)sender {
  [self.parent dismissViewControllerAnimated:YES completion:NO];
}

-(id)initWithProduct:(NSDictionary*)prod {
  self = [super init];
  if (self) {
    self.product = prod;
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)viewDidLoad;
{
  [super viewDidLoad];
  CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
  self.calendar = calendar;
  calendar.delegate = self;
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
  self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
  
  self.disabledDates = @[
                         [self.dateFormatter dateFromString:@"05/01/2013"],
                         [self.dateFormatter dateFromString:@"06/01/2013"],
                         [self.dateFormatter dateFromString:@"07/01/2013"]
                         ];
  
  calendar.onlyShowCurrentMonth = NO;
  calendar.adaptHeightToNumberOfWeeksInMonth = YES;
  
  calendar.frame = CGRectMake(0, 0, 480, 100);
  [self.view addSubview:calendar];
  self.titleLabel.title = [self.product objectForKey:@"name"];
  
  self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
  //[self.view addSubview:self.dateLabel];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
  

}

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];

  
  

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

- (void)localeDidChange {
  [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
  for (NSDate *disabledDate in self.disabledDates) {
    if ([disabledDate isEqualToDate:date]) {
      return YES;
    }
  }
  return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
  // TODO: play with the coloring if we want to...
  if ([self dateIsDisabled:date]) {
    dateItem.backgroundColor = [UIColor redColor];
    dateItem.textColor = [UIColor whiteColor];
  }

}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
  return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
  self.dateLabel.text = [self.dateFormatter stringFromDate:date];
  [self.parent dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
  if ([date laterDate:self.minimumDate] == date) {
    self.calendar.backgroundColor = [UIColor whiteColor];
    return YES;
  } else {
    self.calendar.backgroundColor = [UIColor whiteColor];
    return NO;
  }

}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
  NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
  [self.view bringSubviewToFront:self.toolBar];
}
	

@end
