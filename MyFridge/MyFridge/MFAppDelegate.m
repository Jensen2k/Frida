//
//  MFAppDelegate.m
//  MyFridge
//
//  Created by Martin Jensen on 08.05.13.
//  Copyright (c) 2013 Martin Jensen. All rights reserved.
//

#import "MFAppDelegate.h"

@implementation MFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
  [self setApperarance];
  self.items = [[NSMutableArray alloc] initWithArray:@[@{@"name": @"Tine lettmelk 1.5L", @"group": @"Melk"},
                 @{@"name": @"Tine lettmelk 1.5L", @"group": @"Melk"},
                 @{@"name": @"Stabburet Leverpostei Orginal", @"group": @"Pålegg"},
                 @{@"name": @"Tine Jarlsberg 1kg", @"group": @"Ost"},
                 @{@"name": @"Nora Appelsinmarmelade", @"group": @"Syltetøy"},
                 @{@"name": @"Nordfjord Bacon", @"group": @"Kjøttpålegg"},
                 @{@"name": @"Rema1000 Mais i boks", @"group": @"Mais"},
                 @{@"name": @"Tunfisk i lake", @"group": @"Pålegg"},
                 @{@"name": @"Stabburet Makrell i tomat", @"group": @"Pålegg"},
                 @{@"name": @"Q-Meieriene Rømme", @"group": @"Melk"},
                 @{@"name": @"God Morgen Yogurt", @"group": @"Yogurt"},
                 @{@"name": @"Stabburet Salami", @"group": @"Pålegg"}]];
  
  self.shoppingList = [[NSMutableArray alloc] initWithArray:@[@"Melk", @"Brød", @"Leverpostei", @"Juice"]];
  
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)setupRestkit
{
  
  RKObjectManager *objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:@"http://193.157.242.91:3000"]];
  
  [RKObjectManager setSharedManager:objectManager];
  
  NSError *error = nil;
  NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"MyFridge" ofType:@"momd"]];
  // NOTE: Due to an iOS 5 bug, the managed object model returned is immutable.
  NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
  RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
  
  // Initialize the Core Data stack
  [managedObjectStore createPersistentStoreCoordinator];
  
  NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
  NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
  
  [managedObjectStore createManagedObjectContexts];
  
  // Set the default store shared instance
  [RKManagedObjectStore setDefaultStore:managedObjectStore];  objectManager.requestSerializationMIMEType = RKMIMETypeJSON;
  
  
  RKMapping *groceriesMapping = [RKEntityMapping mappingForEntityForName:@"RMHousehold"
                                                     inManagedObjectStore:[RKObjectManager sharedManager].managedObjectStore];;
  RKManagedObjectStore *objectStore;
  
  RKEntityMapping* mapping = [RKEntityMapping
                              mappingForEntityForName:@"Groceries"
                              inManagedObjectStore:objectStore];
  mapping.identificationAttributes = @[@"identifier"] ;
  
  [mapping addAttributeMappingsFromDictionary:@{
   @"id": @"identifier",
   @"expiration": @"expire",
   @"item_id": @"item_id",
   @"name": @"name"
   }];
  

  [objectManager.mappingProvider setObjectMapping:venueMapping forResourcePathPattern:@"/api/nor/venues.json"];
  

}

-(void)setApperarance {
  //[[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithRed:67 green:67 blue:67 alpha:1.0]];
  [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"top.png"] forBarMetrics:UIBarMetricsDefault];
  [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
}

- (UIImage *)imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

#pragma mark - Core Data stack





#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}






@end
