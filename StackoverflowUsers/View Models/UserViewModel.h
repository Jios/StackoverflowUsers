//
//  UserViewModel.h
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Blocks.h"



@interface UserViewModel : NSObject

-(instancetype _Nonnull)initWithUpdateBlock: (VoidBlock _Nonnull)updateBlock
                                 errorBlock: (ErrorBlock _Nonnull)errorBlock;

-(void)fetchUsers;

-(NSInteger)numberOfUsers;

-(NSURL * _Nonnull)profileURLAtIndex: (NSInteger)index;
-(NSString * _Nonnull)nameAtIndex: (NSInteger)index;
-(NSString * _Nonnull)locationAtIndex: (NSInteger)index;
-(NSString * _Nonnull)reputationAtIndex: (NSInteger)index;

-(NSInteger)numberOfGoldsAtIndex: (NSInteger)index;
-(NSInteger)numberOfSilversAtIndex: (NSInteger)index;
-(NSInteger)numberOfBronzesAtIndex: (NSInteger)index;
-(float)badgeScoreAtIndex: (NSInteger)index;

-(void)filterUsersForName: (NSString * _Nonnull)name;

-(void)sortByName;
-(void)sortByReputation;
-(void)sortByBadgeScore;

@end
