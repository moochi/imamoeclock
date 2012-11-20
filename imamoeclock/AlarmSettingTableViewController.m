//
//  AlarmSettingTableViewController.m
//  imamoeclock
//
//  Created by mochida rei on 12/11/20.
//  Copyright (c) 2012年 mochida rei. All rights reserved.
//

#import "AlarmSettingTableViewController.h"
#import "ImamoeAppDelegate.h"
#import "Timer.h"
#import "AlarmSettingViewController.h"
#import "UIViewController+Extend.h"

@interface AlarmSettingTableViewController ()

@property (nonatomic,retain) NSMutableArray *itemArray;

@end

@implementation AlarmSettingTableViewController

- (void)doneAction {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)addAction {
    NSManagedObjectContext *managedObjectContext = [self getManagedObjectContext];
    
    Timer *timer = (Timer *)[NSEntityDescription insertNewObjectForEntityForName:@"Timer" inManagedObjectContext:managedObjectContext];
    timer.dateTime  = [NSDate date];
    timer.activeFlag    = NO;
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
    }
    else {
        
    }

    [self timerLoad];

    [self.tableView reloadData];
}

- (void)timerLoad {
    NSManagedObjectContext *managedObjectContext = [self getManagedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *tmpPhoto = [NSEntityDescription entityForName:@"Timer" inManagedObjectContext:managedObjectContext];
	[request setEntity:tmpPhoto];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"dateTime" ascending:NO] autorelease];
	NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
	[request setSortDescriptors:sortDescriptors];
    
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	self.itemArray = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (self.itemArray == nil) {
		// Handle the error.
	}
    NSLog(@"count:%d",[self.itemArray count]);
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self timerLoad];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.itemArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    NSDateFormatter *format = [[[NSDateFormatter alloc] init] autorelease];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    Timer *timer = [self.itemArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[format stringFromDate:timer.dateTime]];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Timer *timer = [self.itemArray objectAtIndex:indexPath.row];
        NSManagedObjectContext *managedObjectContext = [self getManagedObjectContext];
        [managedObjectContext deleteObject:timer];
        
        NSError *error = nil;
        if (![managedObjectContext save:&error]) {
			// Handle the error.
		}
        
        [self timerLoad];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    AlarmSettingViewController *view = [[AlarmSettingViewController alloc] initWithNibName:@"AlarmSettingViewController" bundle:nil];
    view.timer = [self.itemArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:view animated:YES];
}


@end
