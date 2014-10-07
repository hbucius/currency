//
//  ViewController.m
//  cocurrency
//
//  Created by mstr on 9/28/14.
//  Copyright (c) 2014 com.hbu.com. All rights reserved.
//

#import "ViewController.h"
#import "DownloadInfo.h"
#import "UICustomCell.h"

@interface ViewController  ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tableview.dataSource=self;
    _tableview.delegate=self;
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


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier=@"tableCell";
    UICustomCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    cell.currencyImage.image=[UIImage imageNamed:@"CNY.png"];
    cell.currencyName.text=@"CHN";
    
    
    
    return cell;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}



@end
