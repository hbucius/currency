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
- (NSDictionary *) getDicFromObject :(NSData *) data;

@property(strong,nonatomic) NSDictionary *currency;


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
        self.currency=[self getDicFromObject:data];
        [self.delegate updateUI];
    }];
    [dataTask resume];
    
}

- (NSDictionary *) getDicFromObject: (NSData *) data{
    NSError * error2;
    NSMutableDictionary *mutableDiction=[[NSMutableDictionary alloc]init];
    id jsonObject= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
    NSLog(@"the class is %@",[jsonObject class]);
    if([jsonObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dictionary =(NSDictionary *) jsonObject;
        id mdic=[dictionary valueForKey:@"list"];
        if([mdic isKindOfClass:[NSDictionary class]])
            {
                id resourceArray=[(NSDictionary*)mdic valueForKey:@"resources"];
                
                if([resourceArray isKindOfClass:[NSArray class]]){
                    NSArray *array=(NSArray *)resourceArray;
                    //NSLog(array.description);
                    for (int i=0; i<[array count]; i++) {
                        id resourceInArray=array[i];
                        if ([resourceInArray isKindOfClass:[NSDictionary class]]) {
                            id resource=[(NSDictionary *)resourceInArray valueForKey:@"resource"];
                            if([resourceInArray isKindOfClass:[NSDictionary class]]){
                                id fieldsInResource=[(NSDictionary *) resource valueForKey:@"fields"];
                                if([fieldsInResource isKindOfClass:[NSDictionary class]]){
                                    NSString *name=[(NSDictionary *)fieldsInResource valueForKey:@"name"];
                                    if([name rangeOfString:@"GOLD"].location !=NSNotFound || [name rangeOfString:@"SILVER"].location !=NSNotFound || [name rangeOfString:@"COPPER"].location !=NSNotFound || [name rangeOfString:@"PLATIN"].location !=NSNotFound || [name rangeOfString:@"PALLADIUM"].location !=NSNotFound)
                                        continue;
                                    NSString *price_string=[(NSDictionary*)fieldsInResource valueForKey:@"price"];
                                    NSNumber *price_number=[NSNumber numberWithFloat:[price_string floatValue]];
                                    [mutableDiction setValue:price_number forKey:name];
                                }
                            }
                            
                        }
                    }
                    return mutableDiction;
                }
                
            }
        
        
    }
    return nil;
}




-(float) exchangeToCurrency:(NSString*) newCurrencyName withNumber:(float) number oldCurrency:(NSString*) oldCurrencyName{
    
    return number;
}


@end
