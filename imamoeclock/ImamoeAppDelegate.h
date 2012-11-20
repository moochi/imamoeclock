//
//  ImamoeAppDelegate.h
//  imamoeclock
//
//  Created by mochida rei on 12/08/09.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class ImamoeViewController;

@interface ImamoeAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ImamoeViewController *viewController;

// CoreData
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
