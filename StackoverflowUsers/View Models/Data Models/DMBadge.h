//
//  DMBadge.h
//  StackoverflowUsers
//
//  Created by Jian on 6/1/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "DMBase.h"



@interface DMBadge : DMBase

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict;

@property (nonatomic, readonly) NSInteger numOfBronzes;
@property (nonatomic, readonly) NSInteger numOfSilvers;
@property (nonatomic, readonly) NSInteger numOfGolds;

@property (nonatomic, readonly) float score;;

@end
