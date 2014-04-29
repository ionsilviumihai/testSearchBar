//
//  searchTableViewController.m
//  testSearch
//
//  Created by Ion Silviu-Mihai on 28/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "searchTableViewController.h"
#import "AppModel.h"
#import "customSearchTableViewCell.h"
#import "detailsViewController.h"
#import "staticTableViewController.h"
#import "placeholderTableViewCell.h"

@interface searchTableViewController ()
@property BOOL readyForNewSearch;
@property BOOL displaySearchingCell;

@end

@implementation searchTableViewController

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
    
    self.readyForNewSearch = YES;
    self.displaySearchingCell = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchHasReturnedAResult:) name:[AppModel searchResultReturned] object:AppModel.sharedModel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modelHasReturnedPhotos:) name:[AppModel imageDownloadFinished] object:AppModel.sharedModel];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    AppModel *sharedModel = [AppModel sharedModel];
    if (sharedModel.collections == nil || self.readyForNewSearch) {
        if (self.displaySearchingCell) {
            return 1;
        }
        else return 0;
    }
    else
    {
        NSLog(@"Vor fi un numar de %d cells", sharedModel.collections.count);
        return sharedModel.collections.count;
    }
   // else
    //{
    //    NSLog(@"Vor fi un numar de %d cells", sharedModel.collections.count);
     //   return sharedModel.collections.count;
    //}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.displaySearchingCell) {
        placeholderTableViewCell *cell = (placeholderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
        [cell.activityIndicator startAnimating];
        return cell;
    }
    else
    {
        customSearchTableViewCell *cell = (customSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"customCell1"];
        [cell setBackgroundColor:[UIColor colorWithRed:209 green:238 blue:252 alpha:1]];
        
        AppModel *sharedModel = [AppModel sharedModel];
    
        NSLog(@"%@, %@, %@",sharedModel.collections[indexPath.row][@"title"],sharedModel.collections[indexPath.row][@"collection_id"],sharedModel.collections[indexPath.row][@"collection_name"]);
    
        cell.titleFieldFromCell.text = sharedModel.collections[indexPath.row][@"title"];
        cell.idFieldFromCell.text = [NSString stringWithFormat:@"%@",sharedModel.collections[indexPath.row][@"collection_id"]];
        cell.nameFieldFromCell.text = sharedModel.collections[indexPath.row][@"collection_name"];
        /*
         if (sharedModel.images.count < indexPath.row + 1) {
        [cell.spinnerView startAnimating];
        [sharedModel getPhotosAtIndex:indexPath.row];
         }
         else
         {
        [cell.spinnerView stopAnimating];
        cell.imageFromCell.image = [UIImage imageWithData:sharedModel.images[indexPath.row]];
         }
         */
        if(![sharedModel.images objectForKey:sharedModel.collections[indexPath.row][@"id"]])
        {
            cell.imageFromCell.image = nil;
            [cell.spinnerView startAnimating];
            [sharedModel getPhotosAtIndex:indexPath.row];
        }
        else
        {
            [cell.spinnerView stopAnimating];
            cell.imageFromCell.image = [UIImage imageWithData:[sharedModel.images objectForKey:sharedModel.collections[indexPath.row][@"id"]]];
            cell.imageFromCell.contentMode = UIViewContentModeScaleAspectFill;
        }
        return cell;
    }
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - search field delegates

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Textul introdus este: %@", searchBar.text);
    self.displaySearchingCell = YES;
    [self.tableView reloadData];
    self.readyForNewSearch = YES;
    [self.tableView reloadData];
    self.readyForNewSearch = NO;
    
    AppModel *sharedModel = [AppModel sharedModel];
    [sharedModel requestDataFromServerWithParameter:searchBar.text];
    [searchBar resignFirstResponder];
}

-(void)searchHasReturnedAResult:(NSNotification *)notification;
{
    self.displaySearchingCell = NO;
    [self.tableView reloadData];
}
-(void)modelHasReturnedPhotos:(NSNotification *)notification;
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        NSNumber *n = [theData objectForKey:@"valoarePasata"];
        NSLog(@"Valoare pasata: %d", [n intValue]);
        NSArray *indexPaths = [NSArray arrayWithObjects:
                               [NSIndexPath indexPathForRow:[n intValue] inSection:0],
                               nil];
        //[self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailSegue"]) {
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        
        //NSString *urlString = [NSString stringWithFormat:@"https://www.google.ro/search?q=%@&oq=%@", [self.nearbyDeals[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"+"], [self.nearbyDeals[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
        //NSURL *dealURL = [NSURL URLWithString:urlString];
        //NSLog(@"URL built: %@",dealURL);
        
        NSLog(@"Row: %d", indexPath.row);
        AppModel *sharedModel = [AppModel sharedModel];
        staticTableViewController *detailVC = (staticTableViewController *)segue.destinationViewController;
        
        //detailVC.viewData = @{@"id": sharedModel.collections[indexPath.row][@"id"]};//,
                              //@"title": sharedModel.collections[indexPath.row][@"title"],
                             // //@"user_id": sharedModel.collections[indexPath.row][@"user_ide"],
                               // @"medium_image_url": sharedModel.collections[indexPath.row][@"medium_image_url"],
                             // @"collection_name": sharedModel.collections[indexPath.row][@"collection_name"]};
        
        detailVC.viewData = sharedModel.collections[indexPath.row];
        
        //deatailViewcontroller.hidesBottomBarWhenPushed = YES;
        //deatailViewcontroller.dealURL = dealURL;
        
    }
}

- (IBAction)clearTable:(id)sender {
    AppModel *sharedModel = [AppModel sharedModel];
    sharedModel.collections = nil;
    sharedModel.images = nil;
    [self.tableView reloadData];
    
}

- (IBAction)cancelRequest:(id)sender {
    AppModel *sharedModel = [AppModel sharedModel];
    sharedModel.collections = nil;
    sharedModel.images = nil;
    [self.tableView reloadData];
}
@end
