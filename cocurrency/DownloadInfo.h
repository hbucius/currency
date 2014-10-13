//
//  DownloadInfo.h
//  cocurrency
//
//  Created by mstr on 9/28/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIUpdateFromSession.h"
#import <CoreData/CoreData.h>

@interface DownloadInfo : NSObject

@property(strong,nonatomic) NSURLSession * session;
@property (strong,nonatomic) id <UIUpdateFromSession> delegate ;
@property(strong,nonatomic,readonly) NSDictionary *currency;

-(instancetype) initWithDelegate:(id) delegate;
-(void) updateInfo ;
-(float) exchangeToCurrency:(NSString*) newCurrencyName withNumber:(float) number oldCurrency:(NSString*) oldCurrencyName;

@end
