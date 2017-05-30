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


+(void) updateCurrencyShown:(NSArray*) arr{
    NSLog(@"udpate currency Shown is called");
    NSManagedObjectContext *context=[[Context SharedInstance]context];
    dispatch_sync([[Context SharedInstance]getCocurrentQueue], ^{
        NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrencyShown" inManagedObjectContext:[[Context SharedInstance]context]];
        NSFetchRequest *request=[[NSFetchRequest alloc]init];
        [request setEntity:entity];
        NSError *error;
        NSArray *array=[context executeFetchRequest:request error:&error];
        for (int i=0; i<array.count; i++) {
            NSManagedObject *obj=array[i];
            [context deleteObject:obj];
        }
        for (int i=0; i<arr.count; i++) {
            CurrencyShown *obj=[NSEntityDescription insertNewObjectForEntityForName:@"CurrencyShown" inManagedObjectContext:context];
            obj.shortname=arr[i];
            obj.index=[NSNumber numberWithInt:i];
        }
        [context save:&error];
         
    });
}
+(NSArray *) getCurrencyShown{
    NSArray __block *array;
   dispatch_sync([[Context SharedInstance] getCocurrentQueue], ^{
       NSEntityDescription *entity=[NSEntityDescription entityForName:@"CurrencyShown" inManagedObjectContext:[[Context SharedInstance]context]];
       NSFetchRequest *request=[[NSFetchRequest alloc]init];
       [request setEntity:entity];
       NSError *error;
       array=[[[Context SharedInstance] context] executeFetchRequest:request error:&error];
       
   });
    
    NSMutableArray *ret=[[NSMutableArray alloc]init];
    NSArray *sortArray=[array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        int s1=[((CurrencyShown*)obj1).index intValue];
        int s2=[((CurrencyShown*)obj2).index intValue];
        if(s1>s2) return NSOrderedDescending;
            else if (s1==s2)  return NSOrderedSame;
                else    return NSOrderedAscending;
    }];
    for (int i=0; i<sortArray.count; i++) {
        CurrencyShown * shown=((CurrencyShown*)sortArray[i]);
        NSLog(@"short name is %@,index is %d",shown.shortname,[shown.index intValue]);
    }

    for (int i=0; i<sortArray.count; i++) {
        [ret addObject:((CurrencyShown*)sortArray[i]).shortname];
    }
    
    return [ret copy];
    
}

@end
