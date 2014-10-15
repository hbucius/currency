//
//  CurrencyRate.h
//  cocurrency
//
//  Created by hbucius on 10/15/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CurrencyRate : NSManagedObject

@property (nonatomic, retain) NSString * shortname;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) NSString * fullname;

@end
