//
//  UICustomCell.h
//  cocurrency
//
//  Created by hbucius on 10/7/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *currencyImage;

@property (weak, nonatomic) IBOutlet UITextField *inputText;

@property (weak, nonatomic) IBOutlet UILabel *currencyName;
@property (weak, nonatomic) IBOutlet UILabel *currencyFullName;

@end
