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
  self.isPresented = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveProduct:) name:@"didReciveProduct" object:nil];
  //SocketIO *socket = [[SocketIO alloc] initWithDelegate:self];
  //[socket connectToHost:@"dev.fridafridge.com" onPort:82];
  
  //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDateSelector:) name:@"didReciveScan" object:nil];
	// Do any additional setup after loading the view.
}

-(void)didReciveProduct:(NSNotification*)notif {
  NSLog(@"Did recive: ");
  NSDictionary *obj = [notif.object objectAtIndex:0];
  
  
  UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
  
  FDViewController *viewController = [story instantiateViewControllerWithIdentifier:@"calSelect"];
  
  viewController.product = obj;
  viewController.parent = self;
  if(self.isPresented) {
    [self dismissViewControllerAnimated:YES completion:^{
      [self presentViewController:viewController animated:YES completion:nil];
      self.isPresented = YES;
    }];
  } else {
    [self presentViewController:viewController animated:YES completion:nil];
    self.isPresented = YES;
  }

  

  
  
  
  
  //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[obj objectForKey:@"name"] message:@"Scannet produkt!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
  //[alert show];
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
