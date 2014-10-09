//
//  currencyName.m
//  cocurrency
//
//  Created by hbucius on 10/9/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "currencyName.h"



@interface CurrencyName()

@property(strong,nonatomic) NSMutableDictionary *cocurrencyName;

@end


@implementation CurrencyName

- (instancetype) init{
    self=[super init];
    if (self) {
        self.cocurrencyName=[[NSMutableDictionary alloc]init];
        NSArray *array1=[[NSArray alloc] initWithObjects:@"CNY",@"人民币",@"USD",@"美元",@"HKD", @"港币",@"EUR", @"欧元", @"JPY",@"日元", @"GBP",@"英镑", @"TWD",@"新台币", nil];
        NSArray *array2=[[NSArray alloc]initWithObjects:@"MOP",@"澳门币",@"AUD",@"澳元",@"CAD",@"加拿大元",@"TWD",@"韩元",nil];
        NSArray *arrayAll=[[NSArray alloc]initWithObjects:array1,array2, nil];
        
        NSString *tempKey;
        for (int i=0; i<arrayAll.count; i++) {
            NSArray *tempArray=[arrayAll objectAtIndex:i];
            for (int j=0; j<tempArray.count; j++) {
                if(j%2==0) {
                    tempKey=[tempArray objectAtIndex:j];
                    continue;
                }
                else [self.cocurrencyName setValue:[tempArray objectAtIndex:j] forKey:tempKey];
            }
        }

        
    }
        return self;
    
}


-(NSString *) getFullCurrencyNameWith:(NSString*) currencyName{
    return [self.cocurrencyName valueForKey:currencyName];
    
}

@end
