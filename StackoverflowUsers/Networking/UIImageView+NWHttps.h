//
//  UIImageView+NWHttps.h
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ImageBlock) (UIImage * _Nonnull image,
                            NSURL   * _Nonnull responseURL);



@interface UIImageView (NWHttps)

-(void)setImageURL: (NSURL *)url
   withPlaceholder: (UIImage *)placeholder;

@end
