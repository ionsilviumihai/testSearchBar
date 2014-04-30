//
//  searchTableViewController.m
//  testSearch
//
//  Created by Ion Silviu-Mihai on 28/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "SearchTableViewController.h"
#import "AppModel.h"
#import "customSearchTableViewCell.h"
#import "detailsViewController.h"
#import "StaticTableViewController.h"
#import "placeholderTableViewCell.h"

#import "BidirectionalViewController.h"

@interface SearchTableViewController ()

@property (nonatomic) BOOL readyForNewSearch;
@property (nonatomic) BOOL displaySearchingCell;

@end

@implementation SearchTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //navigation button

    UIImage *buttonA_image = [UIImage imageNamed:@"clearicon"];
    UIImage *buttonB_image = [UIImage imageNamed:@"blueCross"];
/*
    //prima varianta
    //UIButton
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithImage:buttonA_image style:UIBarButtonItemStylePlain target:self action:@selector(cancelRequest:)];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc] initWithImage:buttonB_image style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightButton1, rightButton2, nil];
*/
    
//----------- Adding 2 buttons on the right side of the nav bar
    UIButton *rightButtonA = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButtonA.bounds = CGRectMake(0, 0, buttonA_image.size.width, buttonA_image.size.height);
    [rightButtonA setImage:buttonA_image forState:UIControlStateNormal];
    rightButtonA.showsTouchWhenHighlighted = YES;
    [rightButtonA addTarget:self action:@selector(clearTable:) forControlEvents:UIControlEventTouchUpInside];
    //rightButtonA.imageEdgeInsets = UIEdgeInsetsMake(-50, -50, -50, -50);
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonA];
    UIButton *rightButtonB = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButtonB.bounds = CGRectMake(0, 0, buttonB_image.size.width, buttonB_image.size.height);
    [rightButtonB setImage:buttonB_image forState:UIControlStateNormal];
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc] initWithCustomView:rightButtonB];

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightButton1, rightButton2, nil];
//----------- Adding 2 buttons on the right side of the nav bar

    
/*
//----------- Add refresh control for table view
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refresh addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
//------
*/

    
     
     
    self.readyForNewSearch = YES;
    self.displaySearchingCell = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(searchHasReturnedAResult:)
                                                 name:[AppModel searchResultReturned]
                                               object:AppModel.sharedModel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(modelHasReturnedPhotos:)
                                                 name:[AppModel imageDownloadFinished]
                                               object:AppModel.sharedModel];
    
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
    if (sharedModel.collections == nil || self.readyForNewSearch)
    {
        if (self.displaySearchingCell)
        {
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
    if (self.displaySearchingCell)
    {
        placeholderTableViewCell *cell = (placeholderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];
        [cell.activityIndicator startAnimating];
        return cell;
    }
    else
    {
        customSearchTableViewCell *cell = (customSearchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"customCell1"];
        
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
            NSLog(@"S-A VERIFICAT DACA EXISTA POZA LA ID:%@", sharedModel.collections[indexPath.row][@"id"]);
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

#pragma mark Table View delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![cell isKindOfClass:[placeholderTableViewCell class]])
    {
        UIImage *image = [UIImage imageNamed:@"disclosureArrow"];
        UIControl *control = [[UIControl alloc] initWithFrame:(CGRect){CGPointZero, image.size}];
        control.layer.contents = (id)image.CGImage;
        [control addTarget:self action:@selector(accessoryButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = control;
    }
    
    
    [cell setBackgroundColor:[UIColor colorWithRed:107.0f / 255.0f
                                             green:185.0f / 255.0f
                                              blue:240.0f / 255.0f
                                             alpha:1]];
    
    UIView *bgColorView = [[UIView alloc] init];

    bgColorView.backgroundColor = [UIColor colorWithRed:37.0/255
                                                  green:116.0/255
                                                   blue:169.0/255
                                                  alpha:1.0];

    bgColorView.layer.cornerRadius = 7;
    bgColorView.layer.masksToBounds = YES;
    [cell setSelectedBackgroundView:bgColorView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.displaySearchingCell) ? 460.0 : 84.0;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Cell tap");
    /*
    StaticTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"StaticTableViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
     */
}

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"Accessory tap");
//}

#pragma mark - search field delegates

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Textul introdus este: %@", searchBar.text);
    self.displaySearchingCell = YES;
    [self.tableView reloadData];
    self.tableView.scrollEnabled = NO;
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
    self.tableView.scrollEnabled = YES;
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


//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"detailSegue"]) {
//        UITableViewCell *cell = (UITableViewCell *)sender;
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
//        
//        
//        //NSString *urlString = [NSString stringWithFormat:@"https://www.google.ro/search?q=%@&oq=%@", [self.nearbyDeals[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"+"], [self.nearbyDeals[indexPath.row] stringByReplacingOccurrencesOfString:@" " withString:@"+"]];
//        //NSURL *dealURL = [NSURL URLWithString:urlString];
//        //NSLog(@"URL built: %@",dealURL);
//        
//        NSLog(@"Row: %d", indexPath.row);
//        AppModel *sharedModel = [AppModel sharedModel];
//        StaticTableViewController *detailVC = (StaticTableViewController *)segue.destinationViewController;
//        
//        //detailVC.viewData = @{@"id": sharedModel.collections[indexPath.row][@"id"]};//,
//                              //@"title": sharedModel.collections[indexPath.row][@"title"],
//                             // //@"user_id": sharedModel.collections[indexPath.row][@"user_ide"],
//                               // @"medium_image_url": sharedModel.collections[indexPath.row][@"medium_image_url"],
//                             // @"collection_name": sharedModel.collections[indexPath.row][@"collection_name"]};
//        
//        detailVC.viewData = sharedModel.collections[indexPath.row];
//        
//        //deatailViewcontroller.hidesBottomBarWhenPushed = YES;
//        //deatailViewcontroller.dealURL = dealURL;
//        
//    }
//}

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

- (void)accessoryButtonTapped:(id)sender event:(id)event
{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint: currentTouchPosition];
    if (indexPath != nil) {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"S-a tapat la index path row:%d", indexPath.row );
//    StaticTableViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StaticTableViewController"];
//    AppModel *sharedModel = [AppModel sharedModel];
//    detailVC.viewData = sharedModel.collections[indexPath.row];
//    [self.navigationController pushViewController:detailVC animated:YES];
    
    BidirectionalViewController *biVC = [self.storyboard instantiateViewControllerWithIdentifier:@"BidirectionalViewController"];
    biVC.indexPath = indexPath;
    [self.navigationController pushViewController:biVC animated:YES];
    
}
@end
