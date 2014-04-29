//
//  detailsViewController.m
//  testSearch
//
//  Created by Ion Silviu-Mihai on 29/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController

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
     self.idLabel.text = [NSString stringWithFormat:@"%@",[self.viewData objectForKey:@"id"]];
    self.titleLabel.text = [self.viewData objectForKey:@"title"];
    self.userIDLabel.text = [NSString stringWithFormat:@"%@",[self.viewData objectForKey:@"user_id"]];
    self.collectionNameLabel.text = [self.viewData objectForKey:@"collection_name"];
    self.userNameLabel.text = self.viewData[@"user"][@"display_name"];
    
    if (!self.collectionImage.image) {
    // set default user image while image is being downloaded
        // download the image asynchronously
        [self.activitiIndicator1 startAnimating];
        [self.userImage setImage:[UIImage imageNamed:@"user_avatar.jpg"]];
        self.userImage.contentMode = UIViewContentModeScaleAspectFit;
        self.collectionImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self downloadImageWithURL:[NSURL URLWithString:self.viewData[@"medium_image_url"]] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded)
            {
                // change the image in the cell
                [self.activitiIndicator1 stopAnimating];
                self.placeholder2Label.hidden = YES;
                self.placeholder1Label.hidden = YES;
                [self.collectionImage setImage:image];                // cache the image for use later (when scrolling up)
            }
        }];
        [self downloadImageWithURL:[NSURL URLWithString:self.viewData[@"user"][@"image_url"]] completionBlock:^(BOOL succeeded, UIImage *image) {
            if (succeeded) {
            // change the image in the cell
            [self.userImage setImage:image];                // cache the image for use later (when scrolling up)
        }
    }];
        
    }
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
