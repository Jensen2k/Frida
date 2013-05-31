//
//  FDViewController.h
//  Frida+DateSelect
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthTableViewController.h"
#import "TKCalendarMonthView.h"
#import "TKCalendarMonthViewController.h"

@interface FDViewController : UIViewController
@property (nonatomic, strong) NSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIView *calView;


@end
