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

@property (nonatomic, strong) UIView *scoreBar;
@property (nonatomic, strong) UILabel *lblScore;

@end



@implementation ScoreBarView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
        self.backgroundColor = kColor(235, 235, 235);
        
        [self addSubview: self.scoreBar];
    }
    
    return self;
}

-(UIView *)scoreBar
{
    if (!_scoreBar)
    {
        _scoreBar = [[UIView alloc] initWithFrame: CGRectZero];
        _scoreBar.backgroundColor = kStackOverflowColor;
        
        [self addSubview: _scoreBar];
    }
    
    return _scoreBar;
}

-(UILabel *)lblScore
{
    if (!_lblScore)
    {
        _lblScore = [[UILabel alloc] initWithFrame: self.bounds];
        _lblScore.backgroundColor = [UIColor clearColor];
        _lblScore.font            = [UIFont systemFontOfSize: 10];
        _lblScore.textColor       = [UIColor whiteColor];
        _lblScore.textAlignment   = NSTextAlignmentCenter;
        
        [self addSubview: _lblScore];
    }
    
    return _lblScore;
}

-(void)setScore: (float)score
{
    self.scoreBar.frame = CGRectMake(0, 0,
                                    CGRectGetWidth(self.frame) * score,
                                    CGRectGetHeight(self.frame));
    self.lblScore.text = [NSString stringWithFormat: @" Badge Score: %.02f%%", score * 100];
    [self.lblScore sizeToFit];
}


@end
