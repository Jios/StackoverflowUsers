//
//  NWBase.m
//  StackoverflowUsers
//
//  Created by Jian on 6/2/18.
//  Copyright © 2018 Jian. All rights reserved.
//

#import "NWBase.h"
#import "Keys.h"



@interface NWBase()
<
    NSURLSessionDelegate
>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSession *downloadSession;

@end



@implementation NWBase

// MARK: - # getters

- (NSURLSession *)session
{
    if (!_session)
    {
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.maxConcurrentOperationCount = 5;
        operationQueue.name = @"Default operation queue";
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration: configuration
                                                 delegate: self
                                            delegateQueue: operationQueue];
    }
    
    return _session;
}

-(NSURLSession *)downloadSession
{
    if (!_downloadSession)
    {
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        operationQueue.name = @"Download operation queue";
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _downloadSession = [NSURLSession sessionWithConfiguration: configuration
                                                         delegate: self
                                                    delegateQueue: operationQueue];
    }
    
    return _downloadSession;
}


// MARK: - #

-(void)dataTaskWithRequest: (NSURLRequest * _Nonnull)request
             responseBlock: (DictionaryBlock)responseBlock
                errorBlock: (ErrorBlock)errorBlock
{
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest: request
                                                 completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                                                          
                                                     NSDictionary *json;
                                                     
                                                     if (data)
                                                     {
                                                         json = [NSJSONSerialization JSONObjectWithData: data
                                                                                                options: kNilOptions
                                                                                                  error: &error];
                                                     }
                                                     
                                                     if (error)
                                                     {
                                                         [Dispatch dispatchObject: error
                                                                         viaBlock: errorBlock];
                                                     }
                                                     else
                                                     {
                                                         [Dispatch dispatchObject: json
                                                                         viaBlock: responseBlock];
                                                     }
                                                 }];

    [task resume];
}

-(void)downloadRequest: (NSURLRequest * _Nonnull)request
         responseBlock: (DictionaryBlock)responseBlock
            errorBlock: (ErrorBlock)errorBlock
{
    NSURLSessionTask *task = [self.downloadSession dataTaskWithRequest: request
                                                     completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                         
                                                         if (error)
                                                         {
                                                             [Dispatch dispatchObject: error
                                                                             viaBlock: errorBlock];
                                                         }
                                                         else if (data)
                                                         {
                                                             NSDictionary *dict = @{kData: data,
                                                                                    kResponseURL: request.URL};
                                                             
                                                             [Dispatch dispatchObject: dict
                                                                             viaBlock: responseBlock];
                                                         }
                                                     }];
    
    [task resume];
}


// MARK: - # helpers for delegate methods

-(NSString * _Nullable)certificateNameByHostName: (NSString * _Nonnull)hostName
{
    NSString *certName;
    
    if ([hostName isEqualToString: @"api.stackexchange.com"])
    {
        certName = kStackExchangeCertFileName;
    }
    
    return certName;
}

-(NSData * _Nullable)certificateDataByFilename: (NSString * _Nullable)certName
{
    NSString *cerPath  = [[NSBundle mainBundle] pathForResource: certName
                                                         ofType: @"cer"];
    NSData   *certData = [NSData dataWithContentsOfFile: cerPath];
    
    return certData;
}


// MARK: - # delegate

-(void)     URLSession: (NSURLSession *)session
   didReceiveChallenge: (NSURLAuthenticationChallenge *)challenge
     completionHandler: (void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    // Using NSURLSession with SSL public key pinning
    // https://gist.github.com/edwardmp/df8517aa9f1752e73353
    
    NSURLSessionAuthChallengeDisposition  disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential                      *credential  = nil;
    
    // certificate from server
    SecTrustRef        serverTrust           = challenge.protectionSpace.serverTrust;
    SecCertificateRef  certificate           = SecTrustGetCertificateAtIndex(serverTrust, 0);
    NSData            *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
    
    // certificate from bundle
    NSString *certName      = [self certificateNameByHostName: challenge.protectionSpace.host];
    NSData   *localCertData = [self certificateDataByFilename: certName];
    
    // compare certificates
    if ([remoteCertificateData isEqualToData: localCertData])
    {
        credential = [NSURLCredential credentialForTrust: serverTrust];
        
        [[challenge sender] useCredential: credential
               forAuthenticationChallenge: challenge];
        
        disposition = NSURLSessionAuthChallengeUseCredential;
    }
    else
    {
        [[challenge sender] cancelAuthenticationChallenge: challenge];
        
        disposition = NSURLSessionAuthChallengeRejectProtectionSpace;
    }
    
    completionHandler(disposition, credential);
}


@end
