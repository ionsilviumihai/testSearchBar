//
//  bidirectionalViewController.m
//  testSearch
//
//  Created by Ion Silviu-Mihai on 30/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "BidirectionalViewController.h"
#import "StaticTableViewController.h"
#import "detailsViewController.h"
#import "AppModel.h"

@interface BidirectionalViewController ()

@end

@implementation BidirectionalViewController

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
    
    self.title = @"Details View";
    [self createSegmentedButtonsAndPutThemOnTheNavBar];
    

    
    //detailsViewController *detailsVC = [[detailsViewController alloc] init];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)createSegmentedButtonsAndPutThemOnTheNavBar
{
    NSArray *segmentTextContet = [NSArray arrayWithObjects:@"New",@"Old",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContet];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    segmentedControl.frame = CGRectMake(0, 0, 70, 15);
    [segmentedControl addTarget:self action:@selector(onSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    //defaultTintColor = [segmentedControl.tintColor retain];   // keep track of this for later

    segmentedControl.tintColor = [UIColor colorWithRed:236.0/255 green:240.0/255 blue:241.0/255 alpha:1];
    segmentedControl.alpha = 0.8;
    
    UIBarButtonItem *seg = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
    self.navigationItem.rightBarButtonItem = seg;
    [self onSegmentChanged:segmentedControl];
}

- (void)onSegmentChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    AppModel *sharedModel = [AppModel sharedModel];

    if (segment.selectedSegmentIndex == 1) {
        
        for (int i = 0; i < [[self.addViewToAddViewController subviews] count]; i++ ) {
            [[[self.addViewToAddViewController subviews] objectAtIndex:i] removeFromSuperview];
        }
        detailsViewController *detailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailsViewController"];
        detailsVC.viewData = sharedModel.collections[self.indexPath.row];
        detailsVC.view.frame = self.addViewToAddViewController.bounds;
        [self.addViewToAddViewController addSubview:detailsVC.view];
        [detailsVC didMoveToParentViewController:self];
        [self addChildViewController:detailsVC];

    }
    else if (segment.selectedSegmentIndex == 0) {
        
        for (int i = 0; i < [[self.addViewToAddViewController subviews] count]; i++ ) {
            [[[self.addViewToAddViewController subviews] objectAtIndex:i] removeFromSuperview];
        }
        
        StaticTableViewController *staticVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StaticTableViewController"];
        staticVC.viewData = sharedModel.collections[self.indexPath.row];
        staticVC.view.frame = self.addViewToAddViewController.bounds;
        [self.addViewToAddViewController addSubview:staticVC.view];
        [staticVC didMoveToParentViewController:self];
        [self addChildViewController:staticVC];
        
    }

}
@end
