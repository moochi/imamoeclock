//
//  UIViewController+Extend.m
//  imamoeclock
//
//  Created by mochida rei on 12/11/20.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "UIViewController+Extend.h"
#import "ImamoeAppDelegate.h"

@implementation UIViewController (Extend)

- (NSManagedObjectContext *)getManagedObjectContext {
    NSManagedObjectContext *managedObjectContext = ((ImamoeAppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    
    return managedObjectContext;
}


@end
