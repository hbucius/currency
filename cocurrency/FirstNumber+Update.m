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




+(void) updateFirstNumber:(NSDictionary*) dictionary{    
    
 
    
}
+(NSNumber *) getFirstNumber{
    
    NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"FirstNumber" inManagedObjectContext:[Context context]];
    NSFetchRequest *fetchRequest=[[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entityDescription];
    NSError *erro;
    NSArray *array=[[Context context] executeFetchRequest:fetchRequest error:&erro];
    NSLog(@"the array count  is %lu in first number table" ,(unsigned long)array.count);
    if(array.count!=0 && [array[0] isKindOfClass:[FirstNumber class]])
        return ((FirstNumber*)array[0]).number ;
    return [NSNumber numberWithInt:1000];
}


@end
