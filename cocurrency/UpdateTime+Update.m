//
//  UpdateTime+Update.m
//  cocurrency
//
//  Created by hbucius on 11/2/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "UpdateTime+Update.h"
#import "Context.h"

@implementation UpdateTime (Update)

+(void) saveUpdateTime{
    NSDate * today=[NSDate date];
    [self updateTime:today];
}


+(void) updateTime:(NSDate*) time{
    NSManagedObjectContext *context=[Context SharedInstance].context;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpdateTime" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    dispatch_sync([Context SharedInstance].getCocurrentQueue, ^{
        NSError *error;
        NSArray *array=[context executeFetchRequest:request error:&error];
        UpdateTime *obj;
        if (array.count>=1) {
            obj=array[0];
        }
        else {
            obj=[NSEntityDescription insertNewObjectForEntityForName:@"UpdateTime" inManagedObjectContext:context];
            
        }
        obj.time=time;
        [[Context SharedInstance] saveContext];
        NSLog(@"save time succedd ,%@",time);
    });
}
+(NSDate *) lastUpdateTime{
    NSDate __block *date;
    NSManagedObjectContext *context=[Context SharedInstance].context;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"UpdateTime" inManagedObjectContext:context];
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entity];
    dispatch_sync([Context SharedInstance].getCocurrentQueue, ^{
        NSError *error;
        NSArray *array=[context executeFetchRequest:request error:&error];
        UpdateTime *obj;
        if (array.count>=1) {
            obj=array[0];
            date=obj.time;
        }
    });
    return date;
}

@end
