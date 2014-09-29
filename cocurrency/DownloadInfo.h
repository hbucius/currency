//
//  DownloadInfo.h
//  cocurrency
//
//  Created by mstr on 9/28/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIUpdateFromSession.h"

@interface DownloadInfo : NSObject

@property(strong,nonatomic) NSURLSession * session;
@property(strong,nonatomic) NSDictionary * cocurrencyDictionary;
@property (strong,nonatomic) id <UIUpdateFromSession> delegate ;

-(instancetype) initWithDelegate:(id) delegate;
-(void) updateInfo ;

@end
