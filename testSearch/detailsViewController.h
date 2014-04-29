//
//  detailsViewController.h
//  testSearch
//
//  Created by Ion Silviu-Mihai on 29/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface detailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *collectionImage;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (strong, nonatomic) NSDictionary *viewData;


@property (weak, nonatomic) IBOutlet UILabel *placeholder1Label;
@property (weak, nonatomic) IBOutlet UILabel *placeholder2Label;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitiIndicator1;


@end
