//
//  FDWaitViewController.m
//  Frida+DateSelect
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "FDWaitViewController.h"
#import "FDViewController.h"

@interface FDWaitViewController ()

@end

@implementation FDWaitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDateSelector:) name:@"didReciveScan" object:nil];
	// Do any additional setup after loading the view.
}



-(void)showDateSelector:(NSString*)data {
  FDViewController *calView = [[FDViewController alloc] init];
  [self presentViewController:calView animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickDelete:(id)sender {
  [self performSelector:@selector(showDateSelector:) withObject:@"" afterDelay:10.0];
}
@end
