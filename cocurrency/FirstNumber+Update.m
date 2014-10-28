//
//  FirstNumber+Update.m
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "FirstNumber+Update.h"
#import "Context.h"
@implementation FirstNumber (Update)




+(void) updateFirstNumber:(NSNumber *) number{
    NSManagedObjectContext *context=[[Context SharedInstance] context];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"FirstNumber" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    dispatch_sync([[Context SharedInstance] getCocurrentQueue], ^{
        NSError *error;
        NSArray *array=[context executeFetchRequest:request error:&error];
        if(array.count>=1){
            if([array[0] isKindOfClass:[FirstNumber class]]){
                FirstNumber *oldnumber=(FirstNumber*)array[0];
                float oldValue=[oldnumber.number floatValue];
                float newValue=[number floatValue];
                if(fabs(oldValue-newValue)>=0.001){
                    oldnumber.number=number;
                    NSLog(@"First Number Saved now it is %f",newValue);
                }
                else  NSLog(@"First Number,Don't need to save");
            }
        }
        else {
            FirstNumber *newInsertNumber=[NSEntityDescription insertNewObjectForEntityForName:@"FirstNumber" inManagedObjectContext:context];
            newInsertNumber.number=number;
            NSLog(@"First number, inserted");
        }
        [[Context SharedInstance]saveContext];
        
    });
}
+(NSNumber *) getFirstNumber{
    NSArray * __block array;
    NSManagedObjectContext *context=[[Context SharedInstance] context];
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"FirstNumber" inManagedObjectContext:context];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    dispatch_sync([[Context SharedInstance]getCocurrentQueue], ^{
        NSError  *error;
        array=[context executeFetchRequest:fetchRequest error:&error];
    });

    if(array.count!=0 && [array[0] isKindOfClass:[FirstNumber class]])
        return ((FirstNumber*)array[0]).number ;
    return [NSNumber numberWithInt:1000];
}


@end
