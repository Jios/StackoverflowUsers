//
//  NWHttps.m
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "NWHttps.h"
#import "NWBase_Protected.h"
#import "Keys.h"



@interface NWHttps()
@end



@implementation NWHttps

#pragma mark - /// singleton

+(NWHttps *)sharedInstance
{
    static NWHttps *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}


// MARK: - #

+(void)getURL: (NSURL * _Nonnull)url
responseBlock: (DictionaryBlock)responseBlock
   errorBlock: (ErrorBlock)errorBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    request.HTTPMethod = @"GET";
    request.URL        = url;
    
    [[NWHttps sharedInstance] dataTaskWithRequest: request
                                    responseBlock: responseBlock
                                       errorBlock: errorBlock];
}

+(void)downloadURL: (NSURL * _Nonnull)url
     responseBlock: (DictionaryBlock)responseBlock
        errorBlock: (ErrorBlock)errorBlock
{
    [Dispatch dispatchAsyncToGlobalQueue: ^{
    
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url];
        [request setHTTPMethod: @"GET"];
        
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest: request];
        
        if (cachedResponse.data)
        {
            NSDictionary *dict = @{kData: cachedResponse.data,
                                   kResponseURL: request.URL};
            
            [Dispatch dispatchObject: dict
                            viaBlock: responseBlock];
        }
        else
        {
            [[NWHttps sharedInstance] downloadRequest: request
                                        responseBlock: responseBlock
                                           errorBlock: errorBlock];
        }
    }];
}

@end
