//
//  DMUser.m
//  StackoverflowUsers
//
//  Created by Jian on 6/1/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "DMUser.h"
#import "Keys.h"



@interface DMUser()

@property (nonatomic, strong) NSString *accountID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *gravatarLink;
@property (nonatomic, assign) NSInteger reputation;

@property (nonatomic, strong) DMBadge *badge;

@end



@implementation DMUser

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict
{
    DMUser *user = [[DMUser alloc] init];
    [user updateWithDictionary: dict];
    
    return user;
}

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    if (dict[kBadgeCounts])
    {
        _badge = [DMBadge parseDictionary: dict[kBadgeCounts]];
    }

    _accountID    = [dict[kAccountID] stringValue];
    _userID       = [dict[kUserID] stringValue];
    
    _displayName  = dict[kDisplayName];
    _reputation   = [dict[kReputation] integerValue];
    _gravatarLink = dict[kProfileImage];
}


#pragma mark - # setters


@end
