//
//  UpdateTime+Update.h
//  cocurrency
//
//  Created by hbucius on 11/2/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "UpdateTime.h"

@interface UpdateTime (Update)

+(void) updateTime:(NSDate*) time;
+(NSDate *) lastUpdateTime;
+(void) saveUpdateTime;

@end
