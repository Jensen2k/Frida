//
//  FSViewController.h
//  FridaScanner
//
//  Created by Martin Jensen on 06.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

@interface FSViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,  ZBarReaderDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) ZBarReaderViewController *reader;
@property (strong, nonatomic) NSMutableArray *scannedItems;
- (IBAction)didPressScan:(id)sender;


@end
