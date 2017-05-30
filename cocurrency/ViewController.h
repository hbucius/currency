//
//  ViewController.h
//  cocurrency
//
//  Created by mstr on 9/28/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "UIUpdateFromSession.h"

@interface ViewController : UITableViewController <UIUpdateFromSession,UITableViewDataSource,UITableViewDelegate>

- (void) saveFirstNumber;

@end

