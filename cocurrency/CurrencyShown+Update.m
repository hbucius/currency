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
    NSArray __block *array;
   dispatch_sync([[Context SharedInstance]getCocurrentQueue], ^{
       NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrencyShown" inManagedObjectContext:[[Context SharedInstance]context]];
       NSFetchRequest *request=[[NSFetchRequest alloc]init];
       [request setEntity:entity];
       NSError *error;
       array=[[[Context SharedInstance] context] executeFetchRequest:request error:&error];
       
   });
    
    return array;
    
}

@end
