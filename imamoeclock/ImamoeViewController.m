//
//  ImamoeViewController.m
//  imamoeclock
//
//  Created by mochida rei on 12/08/09.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "ImamoeViewController.h"

@interface ImamoeViewController ()
@property (retain, nonatomic) IBOutlet UIView *secondView;
@property (retain, nonatomic) JDGroupedFlipNumberView *secondFlip;
@property (retain, nonatomic) IBOutlet UIView *minuteView;
@property (retain, nonatomic) JDGroupedFlipNumberView *minuteFlip;
@property (retain, nonatomic) IBOutlet UIView *hourView;
@property (retain, nonatomic) JDGroupedFlipNumberView *hourFlip;

@end

@implementation ImamoeViewController
@synthesize hourView;
@synthesize minuteView;
@synthesize secondView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    [self.secondFlip setIntValue:dateComps.second];
    [self.secondFlip animateUpWithTimeInterval:1];
    [self.secondFlip setMaximumValue:59];
    [self.secondFlip setFrame:CGRectMake(0, 0, self.secondView.frame.size.width, self.secondView.frame.size.height)];
    [self.secondView addSubview: self.secondFlip];
    
    self.minuteFlip = [[[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2] autorelease];
    self.minuteFlip.delegate = self;
    [self.minuteFlip setIntValue:dateComps.minute];
    [self.minuteFlip setMaximumValue:59];
    [self.minuteFlip setFrame:CGRectMake(0, 0, self.minuteView.frame.size.width, self.minuteView.frame.size.height)];
    [self.minuteView addSubview:self.minuteFlip];

    self.hourFlip = [[[JDGroupedFlipNumberView alloc] initWithFlipNumberViewCount: 2] autorelease];
    self.hourFlip.delegate = self;
    [self.hourFlip setIntValue:dateComps.hour];
    [self.hourFlip setMaximumValue:23];
    [self.hourFlip setFrame:CGRectMake(0, 0, self.hourView.frame.size.width, self.hourView.frame.size.height)];
    [self.hourView addSubview:self.hourFlip];

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
    [super dealloc];
}
@end
