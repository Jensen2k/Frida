//
//  FDViewController.h
//  Frida+DateSelect
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDWaitViewController.h"

@interface FDViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *calView;
@property (strong, nonatomic) NSDictionary *product;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)didClickClose:(id)sender;
-(id)initWithProduct:(NSDictionary*)prod;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) FDWaitViewController *parent;


@end
