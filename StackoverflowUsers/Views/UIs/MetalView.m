//
//  MetalView.m
//  StackoverflowUsers
//
//  Created by Jian on 6/4/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "MetalView.h"
#import "Colors.h"



@interface MetalView ()

@property (nonatomic, strong) UIView *metal;
@property (nonatomic, strong) UILabel *numberOfMetal;

@end



@implementation MetalView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubwiews];
    }
    
    return self;
}

-(void)setupSubwiews
{
    [self addSubview: self.metal];
    [self addSubview: self.numberOfMetal];
}

-(UIView *)metal
{
    if (!_metal)
    {
        CGFloat height = CGRectGetHeight(self.frame);
        _metal = [[UIView alloc] initWithFrame: CGRectMake(0, 0,
                                                           height,
                                                           height)];
        _metal.layer.cornerRadius = height * 0.5;
        _metal.layer.masksToBounds = YES;
    }
    
    return _metal;
}

-(UILabel *)numberOfMetal
{
    if (!_numberOfMetal)
    {
        CGFloat offset = CGRectGetMaxX(self.metal.frame) + 5;
        _numberOfMetal = [[UILabel alloc] initWithFrame: CGRectMake(offset, 0,
                                                            CGRectGetWidth(self.frame) - offset,
                                                            CGRectGetHeight(self.frame))];
        
        _numberOfMetal.textColor = [UIColor lightGrayColor];
        _numberOfMetal.font = [UIFont systemFontOfSize: 12.0];
    }
    
    return _numberOfMetal;
}

-(void)setMetals: (NSInteger)metals
            type: (MetalType)type
{
    self.numberOfMetal.text = [NSString stringWithFormat: @"%ld", (long)metals];
    
    switch (type)
    {
        case GoldMetal:
            self.metal.backgroundColor = kGoldColor;
            break;
        case SilverMetal:
            self.metal.backgroundColor = kSilverColor;
            break;
        case BronzeMetal:
            self.metal.backgroundColor = kBronzeColor;
            break;
    }
}

@end
