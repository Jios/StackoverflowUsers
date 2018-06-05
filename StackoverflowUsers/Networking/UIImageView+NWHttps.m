//
//  UIImageView+NWHttps.m
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "UIImageView+NWHttps.h"
#import "NWHttps.h"
#import "Keys.h"

#import <objc/runtime.h>



@interface UIImageView ()

@property (nonatomic, strong) NSURL   *url;
@property (nonatomic, strong) UIImage *placeholder;

@end



@implementation UIImageView (NWHttps)

// MARK: - # ＜Associated Objects＞

// MARK: # getters

-(NSURL *)url
{
    return objc_getAssociatedObject(self, @selector(url));
}

-(UIImage *)placeholder
{
    return objc_getAssociatedObject(self, @selector(placeholder));
}


// MARK: # setters

-(void)setUrl:(NSURL *)object
{
    objc_setAssociatedObject(self, @selector(url), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)setPlaceholder: (UIImage *)object
{
    objc_setAssociatedObject(self, @selector(placeholder), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// MARK: - # public

-(void)setImageURL: (NSURL *)url
   withPlaceholder: (UIImage *)placeholder
{
    self.url         = url;
    self.placeholder = placeholder;
    self.image       = self.placeholder;
    
    UIActivityIndicatorView *actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [actIndicator startAnimating];
    actIndicator.center = CGPointMake(CGRectGetWidth(self.frame)  * 0.5,
                                      CGRectGetHeight(self.frame) * 0.5);
    
    [self addSubview: actIndicator];
    
    weakify(self);
    
    [UIImageView setImageURL: url
                  imageBlock: ^(UIImage *image, NSURL *responseURL) {
                      
                      strongify(self);
                      
                      if ([self.url.absoluteString isEqualToString: responseURL.absoluteString])
                      {
                          self.image = image;
                      }
                      
                      [actIndicator removeFromSuperview];
                  }
                  errorBlock: ^(NSError * _Nonnull error) {
                      
                      [actIndicator removeFromSuperview];
                  }];
}

+(void)setImageURL: (NSURL *)url
        imageBlock: (ImageBlock)imageBlock
        errorBlock: (ErrorBlock)errorBlock
{
    [NWHttps downloadURL: url
           responseBlock: ^(NSDictionary *response) {

               NSURL *responseURL = response[kResponseURL];

               [Dispatch dispatchAsyncToGlobalQueue: ^{

                   NSData  *data  = response[kData];
                   UIImage *image = [UIImage imageWithData: data];

                   if (!image)
                   {
//                       [Dispatch dispatchErrorCode: -1
//                                           message: @"Cannot parse image data."
//                                         andDomain: kKalayKitDomain
//                                     viaErrorBlock: errorBlock];
                   }
                   else if (image && imageBlock)
                   {
                       [Dispatch dispatchAsyncToMainQueue: ^{

                           imageBlock(image, responseURL);
                       }];
                   }
               }];
           }
              errorBlock: errorBlock];
}

@end
