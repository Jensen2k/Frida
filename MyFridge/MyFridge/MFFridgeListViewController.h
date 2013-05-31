//
//  MFFridgeListViewController.h
//  MyFridge
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SocketIO.h>
#import <SocketIOPacket.h>

@interface MFFridgeListViewController : UITableViewController <SocketIODelegate>

@property (nonatomic, strong) SocketIO *socketIO;
@property (nonatomic, strong) NSArray *groceries;

@end
