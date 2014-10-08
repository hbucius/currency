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
#import "CurrencyName.h"

@interface ViewController  ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSMutableArray   * currencyShown;
@property (strong,nonatomic) DownloadInfo * info;
@property (strong,nonatomic) CurrencyName * currencyFullName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _tableview.dataSource=self;
    _tableview.delegate=self;
    [self initCurrencyShow];
    [self initCurrencyInfo];
    [self initCurrencyFullName];
    [self.info updateInfo];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initCurrencyShow{
    _currencyShown=[[NSMutableArray alloc]initWithObjects:@"CNY",@"USD",@"EUR",@"HKD", nil];
    
}

-(void) initCurrencyInfo{
    _info=[[DownloadInfo alloc]initWithDelegate:self];
}

-(void) initCurrencyFullName{
    _currencyFullName=[[CurrencyName alloc]init];
    
}

-(void) updateUI {
    NSLog(@"UI is updated");
}
-(void) updateUIError{
    
    NSLog(@"UI Error is updated");
}


#pragma mark table view data source

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier=@"tableCell";
    UICustomCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSString *currencyName=[self.currencyShown objectAtIndex:indexPath.row];
    cell.currencyImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",currencyName]];
    cell.currencyName.text=currencyName;
    cell.currencyFullName.text=[self.currencyFullName getFullCurrencyNameWith:currencyName];
    return cell;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.currencyShown count];
}

#pragma mark table view data delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.0;


}



@end
