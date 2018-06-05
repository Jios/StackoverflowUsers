//
//  TitleView.m
//  StackoverflowUsers
//
//  Created by Jian on 6/3/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "TitleView.h"
#import "Colors.h"



@interface TitleView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *lblTitle;

@end



@implementation TitleView

-(instancetype)initWithImage: (UIImage *)image
                       title: (NSString *)title
{
    self = [super init];
    
    if (self)
    {
        [self setupSubview];
        
        self.imgView.image = image;
        self.lblTitle.text = title;
        
        [self sizeToFit];
    }
    
    return self;
}

-(void)setupSubview;
{
    [self addSubview: self.imgView];
    [self addSubview: self.lblTitle];
}

-(void)sizeToFit
{
    [super sizeToFit];
    
    [self.lblTitle sizeToFit];
    
    CGFloat imgWidth  = self.imgView.image.size.width;
    CGFloat imgHeight = self.imgView.image.size.height;
    
    self.imgView.frame = CGRectMake(0, 0,
                                    imgWidth,
                                    imgHeight);
    
    CGFloat xOffset = imgWidth + 5;
    self.lblTitle.frame = CGRectMake(xOffset, 0,
                                     CGRectGetWidth(self.lblTitle.frame),
                                     imgHeight);
    
    self.frame = CGRectMake(0, 0,
                            CGRectGetMaxX(self.lblTitle.frame),
                            imgHeight);
}


// MARK: # getter

-(UIImageView *)imgView
{
    if (!_imgView)
    {
        _imgView = [[UIImageView alloc] init];
    }
    
    return _imgView;
}

-(UILabel *)lblTitle
{
    if (!_lblTitle)
    {
        _lblTitle = [[UILabel alloc] init];
    }
    
    return _lblTitle;
}


@end
