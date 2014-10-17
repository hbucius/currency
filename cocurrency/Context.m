//
//  Context.m
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "Context.h"

@implementation Context

+(NSManagedObjectContext *) context {
    
    return [Context delegate].managedObjectContext;
    
}
+(AppDelegate*) delegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


@end
