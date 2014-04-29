//
//  customSearchTableViewCell.h
//  testSearch
//
//  Created by Ion Silviu-Mihai on 28/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customSearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageFromCell;
@property (weak, nonatomic) IBOutlet UILabel *titleFieldFromCell;
@property (weak, nonatomic) IBOutlet UILabel *idFieldFromCell;
@property (weak, nonatomic) IBOutlet UILabel *nameFieldFromCell;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinnerView;

@end
