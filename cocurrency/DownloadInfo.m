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
NSString * yahoolURL=@"http://finance.yahoo.com/webservice/v1/symbols/allcurrencies/quote?format=json&";

@interface DownloadInfo ()
- (NSDictionary *) getDicFromObject :(NSData *) data;
-(NSDictionary *) getCurrencyRateFromCoreData;
@property(strong,nonatomic) NSDictionary *currency;


@end


@implementation DownloadInfo



-(instancetype) initWithDelegate:(id)delegate {
    self=[super init];
    if(self) {
        _session=[NSURLSession sharedSession];
        _delegate=delegate;
        _currency=[self getCurrencyRateFromCoreData];
     }
    return self;
}

-(NSDictionary *) getCurrencyRateFromCoreData{
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrencyRate" inManagedObjectContext:[Context context]];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error;
    NSArray *array=[[Context context]executeFetchRequest:request error:&error];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    for (CurrencyRate *rate  in array  ){
        [dic setValue:rate.rate forKey:rate.shortname];
    }
    return dic;
    
}


- (void) updateInfo {
    dispatch_queue_t queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURLSessionDataTask *dataTask=[self.session dataTaskWithURL:[NSURL URLWithString:yahoolURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSString *string =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"the data is %@",string);
            NSLog(@"the data 's address is %@",data);
            self.currency=[self getDicFromObject:data];
            if (self.currency!=nil) [self.delegate updateUI];
            else [self.delegate updateUIError];
            
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


@end
