//
//  DMUser.h
//  StackoverflowUsers
//
//  Created by Jian on 6/1/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "DMBase.h"
#import "DMBadge.h"



@interface DMUser : DMBase

+(instancetype)parseDictionary: (NSDictionary * _Nonnull)dict;

@property (nonatomic, readonly) NSInteger reputation;
@property (nonatomic, readonly) NSString *location;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) NSString *gravatarLink;

@property (nonatomic, readonly) DMBadge *badge;

@end
