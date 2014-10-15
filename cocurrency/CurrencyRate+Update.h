//
//  CurrencyRate+Update.h
//  cocurrency
//
//  Created by mstr on 10/13/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "CurrencyRate.h"

@interface CurrencyRate (Update)
+(void) updateCoreData:(NSDictionary*) dictionary;
+(NSDictionary *) getRateFromCoreData;

@end
