//
//  TeamListViewController.m
//  ReboundRumble
//
//  Created by Kris Pettinger on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TeamListViewController.h"
#import "TeamDetailViewController.h"
#import "TeamData.h"
#import "DataManager.h"

@implementation TeamListViewController
@synthesize managedObjectContext, fetchedResultsController;
@synthesize headerView;
@synthesize dataChange;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSError *error = nil;
    if (!managedObjectContext) {
        DataManager *dataManager = [DataManager new];
        managedObjectContext = [dataManager managedObjectContext];
    }
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. 
         You should not use this function in a shipping application, 
         although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }		
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,768,50)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    headerView.opaque = YES;

	UILabel *teamLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 50)];
	teamLabel.text = @"Team";
    teamLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:teamLabel];

	UILabel *orientationLabel = [[UILabel alloc] initWithFrame:CGRectMake(145, 0, 200, 50)];
	orientationLabel.text = @"Orientation";
    orientationLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:orientationLabel];
    
 	UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(287, 0, 200, 50)];
	balanceLabel.text = @"Balance";
    balanceLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:balanceLabel];
    
	UILabel *modingLabel = [[UILabel alloc] initWithFrame:CGRectMake(422, 0, 200, 50)];
	modingLabel.text = @"Moding";
    modingLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:modingLabel];

	UILabel *brakesLabel = [[UILabel alloc] initWithFrame:CGRectMake(542, 0, 200, 50)];
	brakesLabel.text = @"Brakes";
    brakesLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:brakesLabel];
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Team List viewWillAppear");
    self.title = @"Team List";
    dataChange = NO;
   [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [ self.tableView indexPathForCell:sender];
    
    TeamDetailViewController *detailViewController = [segue destinationViewController];
    detailViewController.team = [fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)showTeam:(TeamData *)team animated:(BOOL)animated {
    NSLog(@"Show Team");
    // Create a detail view controller, set the team, then push it.
 //   TeamDetailViewController *detailViewController = [[TeamDetailViewController alloc] 
 //                                                     initWithNibName:@"TeamDetailViewController" bundle:nil];
 //   detailViewController.team = team;
    
 //   [self.navigationController pushViewController:detailViewController animated:animated];
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return headerView;    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    TeamData *info = [fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"name = %@", info.name);
    // Configure the cell...
    // Set a background for the cell
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    UIImage *image = [UIImage imageNamed:@"Blue Fade.gif"];
    imageView.image = image;
    cell.backgroundView = imageView;
    
	UILabel *numberLabel = (UILabel *)[cell viewWithTag:10];
	numberLabel.text = [NSString stringWithFormat:@"%d", [info.number intValue]];;
    
	UILabel *orientationLabel = (UILabel *)[cell viewWithTag:20];
    int number = 0;//[info.orientation intValue];
    switch (number) {
        case 0: orientationLabel.text = @"Long"; break;
        case 1: orientationLabel.text = @"Wide"; break;
        case 2: orientationLabel.text = @"Square"; break;
        case 3: orientationLabel.text = @"Other"; break;
        default: orientationLabel.text = @""; break;
    }
	UILabel *balanceLabel = (UILabel *)[cell viewWithTag:30];
    number = 0; //[info.balance intValue];
    switch (number) {
        case 0: balanceLabel.text = @"None"; break;
        case 1: balanceLabel.text = @"Stinger"; break;
        case 2: balanceLabel.text = @"Other"; break;
        default: balanceLabel.text = @""; break;
    }
    
	UILabel *modingLabel = (UILabel *)[cell viewWithTag:40];
    number = 0; //[info.moding intValue];
    switch (number) {
        case 0: modingLabel.text = @"Rams"; break;
        case 1: modingLabel.text = @"Slap"; break;
        case 2: modingLabel.text = @"None"; break;
        case 3: modingLabel.text = @"Other"; break;
        default: modingLabel.text = @""; break;
    }
    
	UILabel *brakesLabel = (UILabel *)[cell viewWithTag:50];
    number = 0; // [info.brakes intValue];
    switch (number) {
        case 0: brakesLabel.text = @"No"; break;
        case 1: brakesLabel.text = @"Yes"; break;
        default: brakesLabel.text = @""; break;
    }
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:60];
    nameLabel.text = info.name;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:@"TeamList"];
    NSLog(@"IndexPath =%@", indexPath);
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	TeamData *team = (TeamData *)[fetchedResultsController objectAtIndexPath:indexPath];
    
//    [self showTeam:team animated:YES];
//}

#pragma mark -
#pragma mark Team List Management

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (fetchedResultsController == nil) {
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"TeamData" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        // Edit the sort key as appropriate.
        NSSortDescriptor *numberDescriptor = [[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:numberDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:20];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = 
        [[NSFetchedResultsController alloc] 
         initWithFetchRequest:fetchRequest 
         managedObjectContext:managedObjectContext 
         sectionNameKeyPath:nil 
         cacheName:@"Root"];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
    }
	
	return fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            NSLog(@"NSFetchedResultsChangeUpdate");
            dataChange = YES;
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}


@end