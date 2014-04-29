
//  searchTableViewController.h
//  testSearch
//
//  Created by Ion Silviu-Mihai on 28/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchTableViewController : UITableViewController <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)clearTable:(id)sender;
- (IBAction)cancelRequest:(id)sender;


@end
