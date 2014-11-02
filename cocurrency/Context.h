//
//  Context.h
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;
@interface Context : NSObject

+(Context*) SharedInstance;
-(NSManagedObjectContext *) context ;
-(dispatch_queue_t) getCocurrentQueue;
- (void)saveContext ;

@end
