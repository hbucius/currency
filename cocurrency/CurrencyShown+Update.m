//
//  CurrencyShown+Update.m
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "CurrencyShown+Update.h"
#import "Context.h"

@implementation CurrencyShown (Update)


+(void) updateCurrencyShown:(NSArray*) array{
    
}
+(NSArray *) getCurrencyShown{
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrencyShown" inManagedObjectContext:[Context context]];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    NSError *error;
    NSArray *array=[[Context context] executeFetchRequest:request error:&error];
    return array;    
    
}

@end
