//
//  GravatarView.m
//  StackoverflowUsers
//
//  Created by Jian on 6/3/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "GravatarView.h"
#import "Colors.h"
#import "UIImageView+NWHttps.h"



#define kOffset 3



@interface GravatarView ()

@property (nonatomic, strong) UIImageView *imgView;

@end



@implementation GravatarView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder: aDecoder];
    
    if (self)
    {
        [self setupSubwiews];
    }
    
    return self;
}

-(UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0,
                                                                  CGRectGetWidth(self.frame) - kOffset,
                                                                  CGRectGetHeight(self.frame) - kOffset)];
        
        _imgView.center = CGPointMake(CGRectGetWidth(self.frame)  * 0.5,
                                      CGRectGetHeight(self.frame) * 0.5);
        
        _imgView.layer.cornerRadius  = CGRectGetWidth(_imgView.frame) * 0.5;
        _imgView.layer.masksToBounds = YES;
    }
    
    return _imgView;
}

-(void)setupSubwiews
{
    self.backgroundColor = kStackOverflowColor;
    [self addSubview: self.imgView];

    self.layer.cornerRadius  = CGRectGetWidth(self.frame) * 0.5;
    self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setImageURL: (NSURL * _Nonnull)url
{
    [self.imgView setImageURL: url
              withPlaceholder: [UIImage imageNamed: @"avatar"]];
}

@end
