//
//  NWHttps.h
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "NWBase.h"



@interface NWHttps : NWBase

+(void)getURL: (NSURL * _Nonnull)url
responseBlock: (DictionaryBlock)responseBlock
   errorBlock: (ErrorBlock)errorBlock;

+(void)downloadURL: (NSURL * _Nonnull)url
     responseBlock: (DictionaryBlock)responseBlock
        errorBlock: (ErrorBlock)errorBlock;

@end
