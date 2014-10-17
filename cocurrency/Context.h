//
//  Context.h
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
@interface Context : NSObject

+(NSManagedObjectContext *) context ;
+(AppDelegate*) delegate ;

@end
