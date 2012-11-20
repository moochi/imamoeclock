//
//  UIViewController+Extend.h
//  imamoeclock
//
//  Created by mochida rei on 12/11/20.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface UIViewController (Extend)

- (NSManagedObjectContext *)getManagedObjectContext;

@end
