//
//  AlarmSettingViewController.m
//  imamoeclock
//
//  Created by mochida rei on 12/11/20.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "AlarmSettingViewController.h"
#import "UIViewController+Extend.h"
#import "AlarmSettingTableViewController.h"

@interface AlarmSettingViewController ()
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AlarmSettingViewController

- (void)doneAction {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    NSDateComponents* components = [[NSCalendar currentCalendar]
                                    components: NSYearCalendarUnit |
                                    NSMonthCalendarUnit |
                                    NSDayCalendarUnit |
                                    NSHourCalendarUnit |
                                    NSMinuteCalendarUnit |
                                    NSSecondCalendarUnit
                                    fromDate:self.datePicker.date];
    
        
    self.timer.dateTime = [self.datePicker.date dateByAddingTimeInterval:-([components second])];
    self.timer.activeFlag = [NSNumber numberWithBool:YES];
    
    NSManagedObjectContext *managedObjectContext = [self getManagedObjectContext];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
    }
    else {
        
    }
    
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    NSDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[[[self.timer objectID] URIRepresentation] absoluteString] forKey:OBJECT_KEY];

    [notification setFireDate:self.timer.dateTime];
    [notification setTimeZone:[NSTimeZone systemTimeZone]];
    [notification setAlertBody:@"notification"];
    [notification setAlertAction:@"open"];
    [notification setSoundName:@"se_maoudamashii_chime03.caf"];
    [notification setUserInfo:dic];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [self.datePicker setDate:self.timer.dateTime];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_datePicker release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}
@end
