//
//  UIUpdateFromSession.h
//  cocurrency
//
//  Created by mstr on 9/29/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIUpdateFromSession <NSObject>

-(void) updateUI ;
-(void) updateUIOK ;

-(void) updateUIError;

@end
