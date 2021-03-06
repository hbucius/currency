//
//  DownloadInfo.m
//  cocurrency
//
//  Created by mstr on 9/28/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "DownloadInfo.h"
#import <CoreData/CoreData.h>
#import "Context.h"
#import "CurrencyRate+Update.h"
NSString * yahoolURL=@"https://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json";

@interface DownloadInfo ()
- (NSDictionary *) getDicFromObject :(NSData *) data;
@property(strong,nonatomic) NSDictionary *currency;
@property(strong,nonatomic) NSDictionary *currencyName;

@end


@implementation DownloadInfo



-(instancetype) initWithDelegate:(id)delegate {
    self=[super init];
    if(self) {
        _session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _delegate=delegate;
        [self currency];
     }
    return self;
}

-(NSDictionary* ) currency{
    if(_currency==nil){
        NSArray *array=[CurrencyRate getRateFromCoreData];
        _currency=[[NSMutableDictionary alloc]init];
        _currencyName=[[NSMutableDictionary alloc]init];
        for (CurrencyRate *rate  in array  ){
            [_currency setValue:rate.rate forKey:rate.shortname];
            [_currencyName setValue:rate.fullname forKey:rate.shortname];
            NSLog(@"full name is %@",rate.fullname);
        }

    }
    return _currency;
    
    
}


- (void) updateInfo {
    dispatch_async([[Context SharedInstance] getCocurrentQueue], ^{
        NSURLSessionDataTask *dataTask=[self.session dataTaskWithURL:[NSURL URLWithString:yahoolURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *string =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"the data is %@",string);
            NSDictionary *dic=[self getDicFromObject:data];
            if (dic!=nil && dic.count>0)
            {
                self.currency=dic;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate updateUI];
                    [self.delegate updateUIOK];
                });
                [CurrencyRate updateCoreData:self.currency];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate updateUIError];
                });
            }
            data=nil;
        }];
        [dataTask resume];
        
    });   
    
}

- (NSDictionary *) getDicFromObject: (NSData *) data{
    NSError * error2;
    NSMutableDictionary *mutableDiction=[[NSMutableDictionary alloc]init];
    id jsonObject= [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error2];
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
                    mutableDiction[@"USD/USD"] = @(1);
                    return mutableDiction;
                }
                
            }
        
        
    }
    return nil;
}

-(float) exchangeToCurrency:(NSString*) newCurrencyName withNumber:(float) number oldCurrency:(NSString*) oldCurrencyName{
    float value1=[[self.currency valueForKey:[NSString stringWithFormat:@"USD/%@",oldCurrencyName]] floatValue];
    float value2=[[self.currency valueForKey:[NSString stringWithFormat:@"USD/%@",newCurrencyName]] floatValue];
    NSLog(@"the old currency name is %@ ,the new currency name is %@",oldCurrencyName,newCurrencyName);
    if(value1!=0)
        return value2*number/value1;
    else
        return 0;
}



-(NSString *) getFullCurrencyNameWith:(NSString*) currencyName{
    NSString *currencyFullName=[NSString stringWithFormat:@"USD/%@",currencyName];
    return [self.currencyName valueForKey:currencyFullName];
    
}
@end
