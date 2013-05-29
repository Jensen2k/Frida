//
//  FSViewController.m
//  FridaScanner
//
//  Created by Martin Jensen on 06.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "FSViewController.h"

@interface FSViewController ()

@end

@implementation FSViewController

@synthesize hud, reader, scannedItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
  scannedItems = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didPressScan:(id)sender {
  reader = nil;
  reader = [ZBarReaderViewController new];
  reader.readerDelegate = self;
  [reader.scanner setSymbology: ZBAR_QRCODE
                        config: ZBAR_CFG_ENABLE
                            to: 0];
  reader.readerView.zoom = 1.0;
  [self presentViewController:reader animated:YES completion:nil];
}

- (void) imagePickerController: (UIImagePickerController*)readerPicker
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
  hud = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
	[[[UIApplication sharedApplication] keyWindow]  addSubview:hud];
  [hud show:YES];
  //hud = [MBProgressHUD showHUDAddedTo:reader.view animated:YES];
  hud.labelText = @"Finner produkt";
  [reader.readerView stop];
  id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
  ZBarSymbol *symbol = nil;
  NSString *ean;
  for(symbol in results){
    ean = symbol.data;
  }
  
  [self getProductForCode:ean];
  NSLog(@"Scanned: %@", ean);

}

-(void)getProductForCode:(NSString*)ean
{
  AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://www.shapeupclub.com"]];
  [client setDefaultHeader:@"User-Agent" value:@"iShape/3.7.8 CFNetwork/609 Darwin/13.0.0"];
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.shapeupclub.com/SearchService.svc/searchBarcode?barcode=%@", ean]];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSLog(@"JSON: %@", NSStringFromClass([JSON class]));
    [self processFoodInfo:JSON withEan:ean];
  } failure:nil];
  [operation start];
}

-(void)processFoodInfo:(NSDictionary*)data withEan:(NSString*)ean {
  NSDictionary *foodData = [[data objectForKey:@"d"] objectForKey:@"food"];
  if (foodData == NULL) {
    return;
  }
  NSLog(@"Food: %@", foodData);
  NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:foodData];
  [dict setObject:ean forKey:@"ean"];
  hud.labelText = [foodData objectForKey:@"title"];
  [self performSelector:@selector(addFoodItem:) withObject:dict afterDelay:1];
  
}

-(void)addFoodItem:(NSDictionary*)foodItem {
  
  [self sendToServer:foodItem];
  [scannedItems addObject:foodItem];
  hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	hud.mode = MBProgressHUDModeCustomView;
	[hud hide:YES afterDelay:2];
  [reader dismissViewControllerAnimated:YES completion:nil];
  [self.tableView reloadData];
}

-(void)sendToServer:(NSDictionary*)foodItem {
  AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://fridafridge.com:8080/"]];
  [httpClient setParameterEncoding:AFFormURLParameterEncoding];
  NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                          path:@"http://fridafridge.com:8080/items"
                                                    parameters:@{@"name":[foodItem objectForKey:@"title"],
                                                                @"ean": [foodItem objectForKey:@"ean"]}];
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    // Print the response body in text
    NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
  [operation start];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"scannedCell" forIndexPath:indexPath];
  cell.textLabel.text = [[self.scannedItems objectAtIndex:indexPath.row] objectForKey:@"title"];
  cell.detailTextLabel.text = [[self.scannedItems objectAtIndex:indexPath.row] objectForKey:@"ean"];
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [scannedItems count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"Scannede produkter";
}

@end
