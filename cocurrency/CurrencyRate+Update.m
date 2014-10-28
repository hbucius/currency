//
//  CurrencyRate+Update.m
//  cocurrency
//
//  Created by mstr on 10/13/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "CurrencyRate+Update.h"
#import "AppDelegate.h"
#import "Context.h"
@implementation CurrencyRate (Update)


+(void) updateCoreData:(NSDictionary*) dictionary{
    dispatch_sync([[Context SharedInstance]getCocurrentQueue], ^{
        id currencyName;
        NSManagedObjectContext *context= [[Context SharedInstance]context];
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrencyRate" inManagedObjectContext:context];
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        [request setEntity:entity];
        for (currencyName in [dictionary allKeys]) {
            if([currencyName isKindOfClass:[NSString class]]){
                NSPredicate *predict=[NSPredicate predicateWithFormat:@"shortname=%@",currencyName];
                [request setPredicate:predict];
                NSError *error;
                NSArray *array=[context executeFetchRequest:request error:&error];
                if (array.count>=1) {
                    CurrencyRate *currencyRate=array[0];
                    float previourRate=[currencyRate.rate floatValue];
                    float lastestRate=[[dictionary valueForKey:currencyName] floatValue];
                    if(fabs(previourRate-lastestRate)>0.00000001){
                        currencyRate.rate=[dictionary valueForKey:currencyName];
                        NSLog(@"the rate for %@ is updated, last is %f ,now is %f",currencyRate.shortname,previourRate,lastestRate);
                    }
                    else{
                        NSLog(@"the rate for %@ don't need updated",currencyRate.shortname);
                    }
                   
                }
                else{
                    CurrencyRate *managedCurrency=[NSEntityDescription insertNewObjectForEntityForName:@"CurrencyRate" inManagedObjectContext:context];
                    if(managedCurrency!=nil){
                        managedCurrency.shortname=currencyName;
                        managedCurrency.rate=(NSNumber *)[dictionary objectForKey:currencyName];
                    }
                }
            }
        }
        [[Context SharedInstance] saveContext];
    });
}
+(NSArray *) getRateFromCoreData{
    NSArray __block *array=nil;
    dispatch_sync([[Context SharedInstance]getCocurrentQueue], ^{
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrencyRate" inManagedObjectContext:[[Context SharedInstance] context]];
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSError *error;
        array=[[[Context SharedInstance] context]executeFetchRequest:request error:&error];
    });
    
    return array;
}

@end
