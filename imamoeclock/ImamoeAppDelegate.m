//
//  ImamoeAppDelegate.m
//  imamoeclock
//
//  Created by mochida rei on 12/08/09.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "ImamoeAppDelegate.h"

#import "ImamoeViewController.h"
#import "Timer.h"

@implementation ImamoeAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    UIAlertView *alert =
    [[[UIAlertView alloc] initWithTitle:@"notification" message:notification.alertBody
                               delegate:self cancelButtonTitle:@"はい" otherButtonTitles:nil, nil] autorelease];
    [alert show];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 通知を処理
        // [self setManyNotifitions];
        NSDictionary *dic = [notification userInfo];
        NSString *uri = [dic objectForKey:OBJECT_KEY];
        
        [[UIApplication sharedApplication] cancelLocalNotification:notification];
        
        NSManagedObjectContext *context = [self managedObjectContext];
        NSPersistentStoreCoordinator *persistentStoreCoordinator = [context persistentStoreCoordinator];
        NSURL *url = [[NSURL alloc] initWithString:uri];
        NSManagedObjectID *objId = [persistentStoreCoordinator managedObjectIDForURIRepresentation:url];
        NSError *error = nil;
        Timer *timer = (Timer *)[context existingObjectWithID:objId error:&error];
        timer.activeFlag = @NO;
        
        [self saveContext];
        /*
        dispatch_async(dispatch_get_main_queue(), ^{
            // メインスレッドでのみ実行可能な処理
        });
         */
    });
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ImamoeViewController alloc] initWithNibName:@"ImamoeViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
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
     [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidBecomeActive" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//保存先ディレクトリ
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

//_persistentStoreCoordinatorがnilなら作って返す。
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                       initWithManagedObjectModel:[self managedObjectModel]];
        
        
        NSURL *url =  [NSURL fileURLWithPath:[[self applicationDocumentsDirectory]
                                              stringByAppendingPathComponent: @"ClockCoreData.sqlite"]];
        
        NSError *error = nil;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                       configuration:nil
                                                                 URL:url
                                                             options:nil error:&error])
        {
            //エラー処理
            NSLog(@"persistentStoreCoordinator: Error %@, %@", error, [error userInfo]);
        }
    }
    return _persistentStoreCoordinator;
}

//_managedObjectModelがnilなら作って返す。
-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return _managedObjectModel;
}

//_managedObjectContextがnilなら作って返す。
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] init];
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

//_managedObjectContextのデータを保存する。
- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
        //エラー処理
        NSLog(@"saveContext: %@", error.debugDescription);
    }
}


@end
