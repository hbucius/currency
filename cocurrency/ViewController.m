//
//  ViewController.m
//  cocurrency
//
//  Created by mstr on 9/28/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "ViewController.h"
#import "DownloadInfo.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    DownloadInfo *info=[[DownloadInfo alloc]initWithDelegate:self];
    [info updateInfo];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateUI {
    NSLog(@"UI is updated");
}
-(void) updateUIError{
    
    NSLog(@"UI Error is updated");
}
@end
