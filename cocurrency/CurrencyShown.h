//
//  CurrencyShown.h
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CurrencyShown : NSManagedObject

@property (nonatomic, retain) NSString * shortname;
@property (nonatomic, retain) NSNumber * index;

@end
