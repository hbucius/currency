//
//  DownloadInfo.m
//  cocurrency
//
//  Created by mstr on 9/28/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "DownloadInfo.h"

NSString * yahoolURL=@"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json&";

@interface DownloadInfo ()

@property(strong,nonatomic) NSDictionary *dictionary;

@end


@implementation DownloadInfo



-(instancetype) initWithDelegate:(id)delegate {
    self=[super init];
    if(self) {
        _session=[NSURLSession sharedSession];
        _delegate=delegate;
    }
    return self;
}

- (void) updateInfo {
    NSURLSessionDataTask *dataTask=[self.session dataTaskWithURL:[NSURL URLWithString:yahoolURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *string =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"the data is %@",string);
        NSLog(response.description);
        [self.delegate updateUI];
    }];
    [dataTask resume];
    
}
@end
