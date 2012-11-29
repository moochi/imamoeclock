//
//  ImamoeViewController.m
//  imamoeclock
//
//  Created by mochida rei on 12/08/09.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "ImamoeViewController.h"
#import "AlarmSettingTableViewController.h"

@interface ImamoeViewController ()
@property (retain, nonatomic) IBOutlet UIView *secondView;
@property (retain, nonatomic) JDGroupedFlipNumberView *secondFlip;
@property (retain, nonatomic) IBOutlet UIView *minuteView;
@property (retain, nonatomic) JDGroupedFlipNumberView *minuteFlip;
@property (retain, nonatomic) IBOutlet UIView *hourView;
@property (retain, nonatomic) JDGroupedFlipNumberView *hourFlip;
@property (retain, nonatomic) NSTimer *ctimer;
@property (retain, nonatomic) IBOutlet UIView *pickerBaseView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datepicker;
@property (assign, nonatomic) BOOL observFlag;

@end

@implementation ImamoeViewController
@synthesize hourView;
@synthesize minuteView;
@synthesize secondView;


- (IBAction)pickerDoneAction:(id)sender {
    [self.pickerBaseView setHidden:YES];
    NSLog(@"%@",self.datepicker.date);
    
    UILocalNotification *notification = [[[UILocalNotification alloc] init] autorelease];
    [notification setFireDate:self.datepicker.date];
    [notification setTimeZone:[NSTimeZone systemTimeZone]];
    [notification setAlertBody:@"notification"];
    [notification setAlertAction:@"open"];
    //[notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setSoundName:@"se_maoudamashii_chime03.caf"];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"count:%d",[notifications count]);

}

- (IBAction)pickerUpAction:(id)sender {
    /*
    [self.datepicker setDate:[NSDate date] animated:NO];
    [self.pickerBaseView setHidden:NO];
     */
    AlarmSettingTableViewController *view = [[[AlarmSettingTableViewController alloc] initWithNibName:@"AlarmSettingTableViewController" bundle:nil] autorelease];
    UINavigationController *navi = [[[UINavigationController alloc] initWithRootViewController:view] autorelease];
    [self presentModalViewController:navi animated:YES];
}

- (void)setClock {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit |
                                   NSMonthCalendarUnit  |
                                   NSDayCalendarUnit    |
                                   NSHourCalendarUnit   |
                                   NSMinuteCalendarUnit |
                                   NSSecondCalendarUnit
                                              fromDate:date];
    
    
    if (self.secondFlip) {
        [self.secondFlip animateToValue:dateComps.second withDuration:1.f];
    }

    if (self.minuteFlip) {
        [self.minuteFlip animateToValue:dateComps.minute withDuration:1.f];
    }
    
    if (self.hourFlip) {
        [self.hourFlip animateToValue:dateComps.hour withDuration:1.f];
    }
}

- (void)applicationDidBecomeActive {
    [self setClock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.observFlag = NO;
    

    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit |
                                   NSMonthCalendarUnit  |
                                   NSDayCalendarUnit    |
                                   NSHourCalendarUnit   |
                                   NSMinuteCalendarUnit |
                                   NSSecondCalendarUnit
                                              fromDate:date];

    self.secondFlip = [[[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2] autorelease];
    self.secondFlip.delegate = self;
    [self.secondFlip setFrame:CGRectMake(0, 0, self.secondView.frame.size.width, self.secondView.frame.size.height)];
    [self.secondFlip setIntValue:dateComps.second];
    [self.secondFlip setMaximumValue:59];
    [self.secondView addSubview: self.secondFlip];
    
    self.minuteFlip = [[[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2] autorelease];
    self.minuteFlip.delegate = self;
    [self.minuteFlip setFrame:CGRectMake(0, 0, self.minuteView.frame.size.width, self.minuteView.frame.size.height)];
    [self.minuteFlip setIntValue:dateComps.minute];
    [self.minuteFlip setMaximumValue:59];
    [self.minuteView addSubview:self.minuteFlip];

    self.hourFlip = [[[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2] autorelease];
    self.hourFlip.delegate = self;
    [self.hourFlip setFrame:CGRectMake(0, 0, self.hourView.frame.size.width, self.hourView.frame.size.height)];
    [self.hourFlip setIntValue:dateComps.hour];
    [self.hourFlip setMaximumValue:23];
    [self.hourView addSubview:self.hourFlip];
    NSLog(@"%d",dateComps.hour);


    self.ctimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                              target:self
                                            selector:@selector(timerDidEnd)
                                            userInfo:nil
                                             repeats:YES];
    
    NSBundle *bundle = [NSBundle mainBundle];
    [bundle loadNibNamed:@"dateTimeSetting" owner:self options:nil];
    [self.pickerBaseView setHidden:YES];
    [self.view addSubview:self.pickerBaseView];
    [self.datepicker setTimeZone:[NSTimeZone systemTimeZone]];
    [self.datepicker setLocale:[NSLocale currentLocale]];
    
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSLog(@"count:%d",[notifications count]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.observFlag == NO) {
        // バックグラウンド復帰時の時計合わせ処理
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:@"applicationDidBecomeActive"
                                                   object:nil];
        self.observFlag = YES;
    }
}

- (void)timerDidEnd
{
    //タイマー動作
    //TODO
    [self.secondFlip animateToNextNumber];
}

- (void) groupedFlipNumberView: (JDGroupedFlipNumberView*) groupedFlipNumberView willChangeToValue: (NSUInteger) newValue {
    //NSLog(@"hoge:%d",newValue);
    if (newValue == 0) {
        if ([groupedFlipNumberView isEqual:self.secondFlip]) {
            // next minute
            [self.minuteFlip animateToNextNumber];
        }
        if ([groupedFlipNumberView isEqual:self.minuteFlip]) {
            // next hour
            [self.hourFlip animateToNextNumber];
        }
    }
}

- (void)viewDidUnload
{
    [self setSecondView:nil];
    [self setMinuteView:nil];
    [self setHourView:nil];
    [self setPickerBaseView:nil];
    [self setDatepicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [secondView release];
    [minuteView release];
    [hourView release];
    
    //タイマーの停止
    if (self.ctimer) {
        if ([self.ctimer isValid]) {
            [self.ctimer invalidate];
            //停止時にはnilにすること
            [self setCtimer:nil];
        }
    }
    
    [_pickerBaseView release];
    [_datepicker release];
    
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidBecomeActive" object:nil];
    
    [super dealloc];
}
@end
