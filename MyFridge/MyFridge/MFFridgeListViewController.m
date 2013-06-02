//
//  MFFridgeListViewController.m
//  MyFridge
//
//  Created by Martin Jensen on 27.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "MFFridgeListViewController.h"
#import "MFAppDelegate.h"

@interface MFFridgeListViewController ()

@end

@implementation MFFridgeListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    NSLog(@"App: %@", [AppDelegate items]);
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"groceries:update" object:nil];
  
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
  

  UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                      init];
  [refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = refreshControl;
  
    
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



-(void)loadData {
  [[RKObjectManager sharedManager] getObjectsAtPath:@"/groceries" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    self.groceries = [[mappingResult dictionary] objectForKey:@"groceries"];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.refreshControl endRefreshing];
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    [self.refreshControl endRefreshing];
  }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.groceries count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FridgeListItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.groceries objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.detailTextLabel.text = [[self.groceries  objectAtIndex:indexPath.row] valueForKey:@"producer"];

    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(void)deleteItem:(NSManagedObject*)object {
  NSLog(@"Delete with ID: %@", [object valueForKey:@"identifier"]);
  NSMutableArray *arr = [NSMutableArray array];
  for (NSManagedObject *obj in self.groceries) {
    if(obj != object) {
      [arr addObject:obj];
    }
  }
  NSString *path = [NSString stringWithFormat:@"/groceries/%@", [object valueForKey:@"identifier"]];
  [[RKObjectManager sharedManager] deleteObject:object path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
    NSLog(@"Mapping: %@", mappingResult);
  } failure:^(RKObjectRequestOperation *operation, NSError *error) {
    
  }];
  
  self.groceries = [NSArray arrayWithArray:arr];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
      [self deleteItem:[self.groceries objectAtIndex:indexPath.row]];
      
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

      
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
