//
//  CurrencyRate+Update.m
//  cocurrency
//
//  Created by mstr on 10/13/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "CurrencyRate+Update.h"
#import "AppDelegate.h"
@implementation CurrencyRate (Update)


+(void) updateCoreData:(NSDictionary*) dictionary{
    id currencyName;
    AppDelegate * delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context= delegate.managedObjectContext;
    for (currencyName in [dictionary allKeys]) {
        if([currencyName isKindOfClass:[NSString class]]){
            CurrencyRate *managedCurrency=[NSEntityDescription insertNewObjectForEntityForName:@"CurrencyRate" inManagedObjectContext:context];
            if(managedCurrency!=nil){
                managedCurrency.name=currencyName;
                managedCurrency.rate=(NSNumber *)[dictionary objectForKey:currencyName];
                [delegate saveContext];
            }
            
        }
    }
}
+(NSDictionary *) getRateFromCoreData{
    AppDelegate * delegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context= delegate.managedObjectContext;
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"CurrencyRate" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    NSError *erro;
    NSArray *array=[context executeFetchRequest:fetchRequest error:&erro];
    CurrencyRate *currencyRate;
    NSLog(@"the currency number is %lu" ,(unsigned long)array.count);
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    for (currencyRate in array) {
        [dic setObject:currencyRate.rate forKey:currencyRate.name];
    }
    return dic;
}

@end
