//
//  AlarmSettingViewController.m
//  imamoeclock
//
//  Created by mochida rei on 12/11/20.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "AlarmSettingViewController.h"
#import "UIViewController+Extend.h"

@interface AlarmSettingViewController ()
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AlarmSettingViewController

- (void)doneAction {
    self.timer.dateTime = self.datePicker.date;
    
    NSManagedObjectContext *managedObjectContext = [self getManagedObjectContext];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
    }
    else {
        
    }
   
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
