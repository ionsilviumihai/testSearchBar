//
//  placeholderTableViewCell.m
//  testSearch
//
//  Created by Ion Silviu-Mihai on 29/04/14.
//  Copyright (c) 2014 sparktech. All rights reserved.
//

#import "placeholderTableViewCell.h"

@implementation placeholderTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
