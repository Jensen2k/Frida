//
//  Groceries.h
//  MyFridge
//
//  Created by Martin Jensen on 30.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Groceries : NSManagedObject

@property (nonatomic, retain) NSString * item_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * expire;
@property (nonatomic, retain) NSNumber * identifier;

@end
