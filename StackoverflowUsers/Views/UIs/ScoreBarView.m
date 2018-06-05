//
//  ScoreBarView.m
//  StackoverflowUsers
//
//  Created by Jian on 6/4/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "ScoreBarView.h"
#import "Colors.h"



@interface ScoreBarView ()

@property (nonatomic, strong) UIView *barView;

@end



@implementation ScoreBarView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
        self.backgroundColor = kColor(235, 235, 235);
        
        [self addSubview: self.barView];
    }
    
    return self;
}

-(UIView *)barView
{
    if (!_barView)
    {
        _barView = [[UIView alloc] initWithFrame: CGRectZero];
        _barView.backgroundColor = kStackOverflowColor;
        
        [self addSubview: _barView];
    }
    
    return _barView;
}

-(void)setScore: (float)score
{
    self.barView.frame = CGRectMake(0, 0,
                                    CGRectGetWidth(self.frame) * score,
                                    CGRectGetHeight(self.frame));
}


@end
