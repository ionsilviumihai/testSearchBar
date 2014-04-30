//
//  staticTableViewController.m
//  testSearch
//
//  Created by Ion Silviu-Mihai on 29/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "StaticTableViewController.h"

@interface StaticTableViewController ()

@end

@implementation StaticTableViewController

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
    self.idLabel.text = [NSString stringWithFormat:@"%@",[self.viewData objectForKey:@"id"]];
    self.titleLabel.text = [self.viewData objectForKey:@"title"];
    self.userIDLabel.text = [NSString stringWithFormat:@"%@",[self.viewData objectForKey:@"user_id"]];
    self.collectionNameLabel.text = [self.viewData objectForKey:@"collection_name"];
    self.userNameLabel.text = self.viewData[@"user"][@"display_name"];
    
    if (!self.collectionImage.image) {
        // Do any additional setup after loading the view.
        
        // set default user image while image is being downloaded
        // download the image asynchronously
        [self.activitiIndicator1 startAnimating];
        [self.userImage setImage:[UIImage imageNamed:@"user_avatar.jpg"]];
        self.userImage.contentMode = UIViewContentModeScaleAspectFit;
        self.collectionImage.contentMode = UIViewContentModeScaleAspectFit;
        [self downloadImageWithURL:[NSURL URLWithString:self.viewData[@"medium_image_url"]] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [self.activitiIndicator1 stopAnimating];
                self.placeholder2Label.hidden = YES;
                self.placeholder1Label.hidden = YES;
                [self.collectionImage setImage:image];
            }
        }];
        
        [self downloadImageWithURL:[NSURL URLWithString:self.viewData[@"user"][@"image_url"]] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
                [self.userImage setImage:image];
            }
        }];
    }

    
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

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    
//}

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end
