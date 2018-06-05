//
//  UserViewModel.m
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "UserViewModel.h"
#import "DMUser.h"
#import "NWHttps.h"
#import "SelfMacros.h"
#import "Keys.h"
#import "Dispatch.h"



#define kDefaultPageSize    30

// reference:
// https://api.stackexchange.com/2.2/users?site=stackoverflow&page=1&pagesize=30

static NSString * const kSite     = @"stackoverflow";
static NSString * const kUsersAPI = @"https://api.stackexchange.com/2.2/users";



@interface UserViewModel()

@property (nonatomic, assign) float maxBadgeScore;

@property (nonatomic, assign) BOOL hasMoreUsers;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger quotaRemaining;
@property (nonatomic, strong) NSMutableArray *arrUsers;
@property (nonatomic, strong) NSArray *arrFilteredUsers;

@property (nonatomic, copy) VoidBlock updateBlock;
@property (nonatomic, copy) ErrorBlock errorBlock;

@end



@implementation UserViewModel

-(instancetype _Nonnull)initWithUpdateBlock: (VoidBlock _Nonnull)updateBlock
                                 errorBlock: (ErrorBlock _Nonnull)errorBlock
{
    self = [super init];
    
    if (self)
    {
        self.hasMoreUsers = YES;
        self.currentPage  = 0;
        self.quotaRemaining = 1;
        
        self.updateBlock = updateBlock;
        self.errorBlock  = errorBlock;
    }
    
    return self;
}

-(void)updateUsersWithArray: (NSArray *)arr
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        for (NSDictionary *dict in arr)
        {
            DMUser *user = [DMUser parseDictionary: dict];
            [self.arrUsers addObject: user];
            
            self.maxBadgeScore = MAX(self.maxBadgeScore, user.badge.score);
        }
        
        self.arrFilteredUsers = self.arrUsers;
    }
                        asyncToMainQueue: ^{
                           
                            self.updateBlock();
                        }];
}


// MARK: - # getter

-(NSMutableArray *)arrUsers
{
    if (!_arrUsers)
    {
        _arrUsers = [[NSMutableArray alloc] init];
    }
    
    return _arrUsers;
}

// MARK: - # fetch

-(void)usersAtPage: (NSInteger)page
      withPageSize: (NSInteger)pageSize
{
    NSString *urlString = [NSString stringWithFormat: @"%@?site=%@&page=%ld&pagesize=%ld", kUsersAPI, kSite, (long)page, (long)pageSize];
    NSURL    *url       = [NSURL URLWithString: urlString];
    
    weakify(self);
    
    [NWHttps getURL: url
      responseBlock: ^(NSDictionary * _Nonnull dictionary) {
          
          strongify(self);
          self.currentPage  = page;
          self.quotaRemaining = [dictionary[kQuotaRemaining] integerValue];
          self.hasMoreUsers = [dictionary[kHasMore] boolValue];
          
          [self updateUsersWithArray: dictionary[kItems]];
      }
         errorBlock: self.errorBlock];
}

-(void)fetchUsers
{
    if (!self.hasMoreUsers)
    {
        NSDictionary *dictUserInfo = @{NSLocalizedDescriptionKey: @"No more users."};
        NSError *error = [[NSError alloc] initWithDomain: kDomain
                                                    code: 0
                                                userInfo: dictUserInfo];
        self.errorBlock(error);
        
        return;
    }
    else if (self.quotaRemaining == 0)
    {
        NSDictionary *dictUserInfo = @{NSLocalizedDescriptionKey: @"No more fetch quota."};
        NSError *error = [[NSError alloc] initWithDomain: kDomain
                                                    code: -1
                                                userInfo: dictUserInfo];
        self.errorBlock(error);
        
        return;
    }
    
    [self usersAtPage: self.currentPage + 1
         withPageSize: kDefaultPageSize];
}


// MARK: - # user

-(NSInteger)numberOfUsers
{
    return self.arrFilteredUsers.count;
}

-(DMUser *)userAtIndex: (NSInteger)index
{
    DMUser *user = self.arrFilteredUsers[index];
    return user;
}

-(NSURL *)profileURLAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    NSURL *url = [NSURL URLWithString: user.gravatarLink ];
    
    return url;
}

-(NSString *)nameAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    return user.displayName;
}

-(NSString *)locationAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    return user.location;
}

-(NSString *)reputationAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    return [NSString stringWithFormat: @"%ld", (long)user.reputation];
}


// MARK: - # badge

-(NSInteger)numberOfGoldsAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    return user.badge.numOfGolds;
}

-(NSInteger)numberOfSilversAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    return user.badge.numOfSilvers;
}

-(NSInteger)numberOfBronzesAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    return user.badge.numOfBronzes;
}

-(float)badgeScoreAtIndex: (NSInteger)index
{
    DMUser *user = [self userAtIndex: index];
    return user.badge.score / self.maxBadgeScore;
}


// MARK: - # filter

-(void)filterUsersForName: (NSString *)name
{
    if (name.length == 0)
    {
        self.arrFilteredUsers = self.arrUsers;
        self.updateBlock();
        
        return;
    }
    
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"SELF.displayName CONTAINS[cd] %@", name];
        
        self.arrFilteredUsers = [self.arrUsers filteredArrayUsingPredicate: predicate];
    }
                        asyncToMainQueue: ^{
                            
                            self.updateBlock();
                        }];
}


// MARK: - # sort

-(void)sortByReputation
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey: kReputation
                                                                         ascending: NO];
        
        self.arrFilteredUsers = [self.arrFilteredUsers sortedArrayUsingDescriptors: @[sortDescriptor]];
    }
                        asyncToMainQueue: ^{
                          
                            self.updateBlock();
                        }];
}

-(void)sortByBadgeScore
{
    weakify(self);
    
    [Dispatch dispatchAsyncToGlobalQueue: ^{
        
        strongify(self);
        // FIXME: sorting incorrect
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey: @"badge.score"
                                                                         ascending: NO];
        
        self.arrFilteredUsers = [self.arrFilteredUsers sortedArrayUsingDescriptors: @[sortDescriptor]];
    }
                        asyncToMainQueue: ^{
                            
                            self.updateBlock();
                        }];
}

@end
