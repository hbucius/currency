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
@property (weak, nonatomic) IBOutlet UIButton *AddCurrency;
@property (weak, nonatomic) IBOutlet UIButton *Refresh;
@property (strong,nonatomic) NSMutableArray   * currencyShown;
@property (strong,nonatomic) NSMutableArray   * NumberShown;
@property (strong,nonatomic) DownloadInfo * info;
@property (strong,nonatomic) CurrencyName * currencyFullName;
@property (strong,nonatomic)  UITextField * firstResponder;
@property (weak, nonatomic) IBOutlet UINavigationItem *MainUITitle;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initCurrencyInfo];
    [self initMainFrameUI];
    [self initCurrencyFullName];
    [self initCurrencyShow];
    [self initNumberShow];
    [self setDelegateAndSource];
    [self.info updateInfo];
    [self setupForDismissKeyboard];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark init functions

-(void) setDelegateAndSource{
    
    _tableview.dataSource=self;
    _tableview.delegate=self;
}

-(void)initMainFrameUI{
    self.MainUITitle.title=@"汇率换算";
    
    self.tableview.allowsSelection=false;
    
}

- (void) initCurrencyShow{
    _currencyShown=[[NSMutableArray alloc]initWithObjects:@"CNY",@"USD",@"EUR",@"HKD", @"JPY",@"KRW",@"GBP",@"TWD",@"MOP",@"CAD",nil];
    //_currencyShown=[[NSMutableArray alloc]initWithObjects:@"CNY",@"USD",@"EUR",@"HKD",nil];
 
}
- (void) initNumberShow{
    _NumberShown=[[NSMutableArray alloc]init];
    for (int i=0; i<_currencyShown.count; i++) {
        [_NumberShown addObject:[NSNumber numberWithFloat:0]];
    }
   
    NSLog(@"initNumberShown finished") ;
}

-(void) initCurrencyInfo{
    _info=[[DownloadInfo alloc]initWithDelegate:self];
}

-(void) initCurrencyFullName{
    _currencyFullName=[[CurrencyName alloc]init];
    
}

-(void) setupForDismissKeyboard{
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.view addGestureRecognizer:tapRecognizer];
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardDidHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.view removeGestureRecognizer:tapRecognizer];
    }];
    
    
}

-(void) updateUI {
    NSLog(@"UI is updated");
    int row_remain_unchanged=0;
    int row_number_remain_unchanged=1000;
    [_NumberShown replaceObjectAtIndex:row_remain_unchanged withObject:[NSNumber numberWithFloat:row_number_remain_unchanged]];
    UICustomCell *cell=(UICustomCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row_remain_unchanged inSection:row_number_remain_unchanged]];
    [self updateCell:cell inputText:row_number_remain_unchanged];
    [self updateOtherCellByRow:row_remain_unchanged];
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
}
-(void) updateUIError{
    
    NSLog(@"UI Error is updated");
}


#pragma mark table view data source

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier=@"tableCell";
    UICustomCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSString *currencyName=[self.currencyShown objectAtIndex:indexPath.row];
    NSLog(@"the currency name is %@, the row is %ld",currencyName,indexPath.row);
    cell.currencyImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",currencyName]];
    cell.currencyName.text=currencyName;
    cell.currencyFullName.text=[self.currencyFullName getFullCurrencyNameWith:currencyName];
    float currencyNumber=[(NSNumber*)self.NumberShown[indexPath.row] floatValue];
    [self updateCell:cell inputText:currencyNumber];
    return cell;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.currencyShown count];
}

#pragma mark table view  delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.0;


}

- (void) updateCell:(UICustomCell *) cellA inputText:(float)currencyNumber{
    NSLog(@"updateCell is called");
    if(fabs((float)(int)currencyNumber-currencyNumber)<pow(10, -10))
        cellA.inputText.text=[NSString stringWithFormat:@"%.0f",currencyNumber];
    else
        cellA.inputText.text=[NSString stringWithFormat:@"%.2f",currencyNumber];
}



- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UICustomCell *cell=(UICustomCell*)[self.tableview cellForRowAtIndexPath:indexPath];
    cell.highlighted=NO;
}




- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"enter into scrollViewWillBeginDragging");
    [self dismissKeyboard];

}
#pragma mark UI update actions


- (IBAction)inputField:(UITextField *)sender {
   // NSLog([[[[[sender superview] superview]superview] class] debugDescription]);
    float OSversion=[[[UIDevice currentDevice] systemVersion] floatValue];
    UIView *view;
    if(OSversion >7.0 && OSversion<8.0)
         view=[[[sender superview] superview]superview];
    else if (OSversion>=8.0)
        view=[[sender superview]superview];
    else return ;
    if([view isKindOfClass:[UICustomCell class]]){
        UICustomCell *hotCell=(UICustomCell*)view;
        NSIndexPath *indexpath=[self.tableview indexPathForCell:hotCell];
        NSLog(@"the %ld",indexpath.row);
        [self updateCellWithIndexPath:indexpath];
    }
}




- (IBAction)inputFieldBeginEdit:(UITextField *)sender {
    self.firstResponder=sender;
    NSLog(@"firstResponder exists22 ,%p",self.firstResponder);

}



// update other cell 's data source and Text Field Shown , not update itself
// To use this function ,the data source[row] must be newest
-  (void) updateOtherCellByRow:(NSUInteger) row {
    float oldCurrencyNumbr=[[self.NumberShown objectAtIndex:row]floatValue];
    NSString *oldCurrencyName=self.currencyShown[row];
    for (int i=0; i<self.currencyShown.count; i++) {
        if(row==i) continue;
        NSString *newCurrencyName=self.currencyShown[i];
        float currencyNumber=[self.info exchangeToCurrency:newCurrencyName withNumber:oldCurrencyNumbr oldCurrency:oldCurrencyName];
        [self.NumberShown replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:currencyNumber]];
        UICustomCell *cell_new=(UICustomCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [self updateCell:cell_new inputText:currencyNumber];
        NSLog(@"cell is updated to %f",currencyNumber);
    }
}

-  (void) updateCellWithIndexPath:(NSIndexPath*)indexPath{
    UICustomCell *cell_old=(UICustomCell*)[self.tableview cellForRowAtIndexPath:indexPath];
    float oldCurrencyNumbr=[cell_old.inputText.text floatValue];
    [self.NumberShown replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:oldCurrencyNumbr]];
    [self updateOtherCellByRow:indexPath.row];
 
}

#pragma mark help functions

- (void) dismissKeyboard{
    if(self.firstResponder) {
        [self.firstResponder resignFirstResponder];
        
        self.firstResponder=nil;
    }
}

-(void) refreshTableView{
    
    [self.tableview reloadData];
}

@end
