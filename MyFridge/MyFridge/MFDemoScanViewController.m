//
//  MFDemoScanViewController.m
//  MyFridge
//
//  Created by Martin Jensen on 31.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "MFDemoScanViewController.h"

@interface MFDemoScanViewController ()

@end

@implementation MFDemoScanViewController
@synthesize reader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView {
  reader = nil;
  reader = [ZBarReaderViewController new];
  reader.readerDelegate = self;
  [reader.scanner setSymbology: ZBAR_QRCODE
                        config: ZBAR_CFG_ENABLE
                            to: 0];
  reader.readerView.zoom = 1.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
