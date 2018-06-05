//
//  MetalView.h
//  StackoverflowUsers
//
//  Created by Jian on 6/4/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, MetalType)
{
    GoldMetal,
    SilverMetal,
    BronzeMetal,
};



@interface MetalView : UIView

-(void)setMetals: (NSInteger)metals
            type: (MetalType)type;

@end
