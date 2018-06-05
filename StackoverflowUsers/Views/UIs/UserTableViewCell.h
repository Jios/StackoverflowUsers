//
//  UserTableViewCell.h
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetalView.h"
#import "ScoreBarView.h"



@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet MetalView *goldMetalView;
@property (weak, nonatomic) IBOutlet MetalView *silverMetalView;
@property (weak, nonatomic) IBOutlet MetalView *bronzeMetalView;

@property (weak, nonatomic) IBOutlet ScoreBarView *scoreBarView;

-(void)setGravatarURL: (NSURL * _Nonnull)url;
-(void)setName: (NSString * _Nonnull)name;
-(void)setReputation: (NSString * _Nonnull)reputation;

@end
