//
//  Context.m
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "Context.h"

@interface Context ()

@property dispatch_queue_t queue;
@property NSManagedObjectContext * managedContext;


@end


static Context *contextInstance;


@implementation Context

+(Context*) SharedInstance{
    static dispatch_once_t token;
    dispatch_once(&token,^{
        contextInstance=[[Context alloc]init];
    
    });
    return contextInstance;
}

-(NSManagedObjectContext *) context {
    
    if(_managedContext==nil){
        dispatch_sync([self getCocurrentQueue], ^{
            NSPersistentStoreCoordinator *coordinator=((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentStoreCoordinator;
            _managedContext=[[NSManagedObjectContext alloc]init];
            [_managedContext setPersistentStoreCoordinator:coordinator];
        });

    }
    return _managedContext;
    
}

- (void)saveContext {
    dispatch_sync([self getCocurrentQueue], ^{
        NSManagedObjectContext *managedObjectContext = self.managedContext;
        if (managedObjectContext != nil) {
            NSError *error = nil;
            if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
              //  abort();
            }
        }
        
    });

}



-(dispatch_queue_t) getCocurrentQueue{
    
    if (_queue==nil) {
        _queue=dispatch_queue_create("hbucius.cocurrency.coredata", DISPATCH_QUEUE_CONCURRENT);
    }
    return _queue;
    
}


@end
