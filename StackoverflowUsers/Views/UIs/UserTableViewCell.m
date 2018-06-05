//
//  UserTableViewCell.m
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "UserTableViewCell.h"
#import "GravatarView.h"



@interface UserTableViewCell ()

@property (weak, nonatomic) IBOutlet GravatarView *gravatarView;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblReputation;

@end



@implementation UserTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
    [super setSelected:selected
              animated:animated];

    // Configure the view for the selected state
}


-(void)setGravatarURL:(NSURL * _Nonnull)url
{
    [self.gravatarView setImageURL: url];
}

-(void)setName: (NSString * _Nonnull)name
{
    self.lblName.text = name;
}

-(void)setReputation: (NSString * _Nonnull)reputation
{
    self.lblReputation.text = [NSString stringWithFormat: @"Reputation: %@", reputation];
}


@end
