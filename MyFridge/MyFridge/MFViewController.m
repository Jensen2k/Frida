//
//  MFViewController.m
//  MyFridge
//
//  Created by Martin Jensen on 08.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "MFViewController.h"

@interface MFViewController ()

@end

@implementation MFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDoor) name:@"fridge:door" object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTemp) name:@"fridge:temp" object:nil];
  
  [self loadTemp];
  [self loadDoor];
  
}

-(void)loadTemp {
  
  NSURL *url = [NSURL URLWithString:@"http://dev.fridafridge.com:82/fridges/1/temp"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSLog(@"JSON: %@", NSStringFromClass([JSON class]));
    NSLog(@"Data: %@", JSON);
    
    [self.tempLabel setText:[NSString stringWithFormat:@"%@˚C", [JSON objectForKey:@"temp"]]];
    
  } failure:nil];
  
  [operation start];
  
}

-(void)loadDoor {
  NSURL *url = [NSURL URLWithString:@"http://dev.fridafridge.com:82/fridges/1/door"];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSLog(@"JSON: %@", NSStringFromClass([JSON class]));
    NSLog(@"Data: %@", JSON);
    NSInteger doorStatus = [[JSON objectForKey:@"door"] intValue];
    
    NSLog(@"Status: %i", doorStatus);
    
    NSString *doorString;
    
    if(doorStatus == 0) {
      [self.doorLabel setText:@"Lukket"];
    }
    if(doorStatus == 1) {
      [self.doorLabel setText:@"Åpen"];
    }
    
    
  } failure:nil];
  
  [operation start];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
