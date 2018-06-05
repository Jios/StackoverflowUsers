//
//  DMBadge.m
//  StackoverflowUsers
//
//  Created by Jian on 6/1/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "DMBadge.h"
#import "Keys.h"



@interface DMBadge ()

@property (nonatomic, assign) NSInteger numOfBronzes;
@property (nonatomic, assign) NSInteger numOfSilvers;
@property (nonatomic, assign) NSInteger numOfGolds;

@property (nonatomic, assign) float score;

@end



@implementation DMBadge

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict
{
    DMBadge *badge = [[DMBadge alloc] init];
    [badge updateWithDictionary: dict];
    
    return badge;
}

-(void)updateWithDictionary: (NSDictionary * _Nonnull)dict
{
    _numOfBronzes = [dict[kBronze] integerValue];
    _numOfSilvers = [dict[kSilver] integerValue];
    _numOfGolds   = [dict[kGold]   integerValue];
    
    _score = _numOfGolds * 0.5 + _numOfSilvers * 0.3 + _numOfBronzes * 0.2;
}


@end
