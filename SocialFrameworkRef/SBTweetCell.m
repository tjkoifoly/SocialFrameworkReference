//
//  SBTweetCell.m
//  SocialFrameworkRef
//
//  Created by Stuart Breckenridge on 15/10/2013.
//  Copyright (c) 2013 Stuart Breckenridge. All rights reserved.
//

#import "SBTweetCell.h"
@import QuartzCore;

@implementation SBTweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    self.theAuthorProfileImage.layer.cornerRadius = self.theAuthorProfileImage.frame.size.width/2;
    self.theAuthorProfileImage.layer.masksToBounds = YES;
}

@end