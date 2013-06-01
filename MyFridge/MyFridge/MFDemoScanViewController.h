//
//  MFDemoScanViewController.h
//  MyFridge
//
//  Created by Martin Jensen on 31.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "ZBarSDK.h"


@interface MFDemoScanViewController : UIViewController <ZBarReaderDelegate>

@property (strong, nonatomic) ZBarReaderViewController *reader;


@end
