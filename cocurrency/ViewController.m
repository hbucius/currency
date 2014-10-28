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
#import "FirstNumber+Update.h"
@interface ViewController  ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *AddCurrency;
@property (weak, nonatomic) IBOutlet UIButton *Refresh;
@property (strong,nonatomic) NSMutableArray   * currencyShown;
@property (strong,nonatomic) NSMutableArray   * NumberShown;
@property (strong,nonatomic) DownloadInfo * info;
@property (strong,nonatomic)  UITextField * firstResponder;
@property (weak, nonatomic) IBOutlet UINavigationItem *MainUITitle;
@property( assign,nonatomic) BOOL keyBoardShown;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initCurrencyShow];
    [self initCurrencyInfo];
    [self initMainFrameUI];
    [self setDelegateAndSource];
    [self setupForDismissKeyboard];

 }

-(void) viewDidAppear:(BOOL)animated{
    [self.info updateInfo];

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
    self.MainUITitle.title=@"常用汇率换算";
    
    self.tableview.allowsSelection=false;
    
}

- (void) initCurrencyShow{
    _currencyShown=[[NSMutableArray alloc]initWithObjects:@"CNY",@"USD",@"EUR",@"HKD", @"JPY",@"KRW",@"GBP",@"TWD",@"MOP",@"CAD",nil];
    //_currencyShown=[[NSMutableArray alloc]initWithObjects:@"CNY",@"USD",@"EUR",@"HKD",nil];
 
}
- (NSMutableArray *)  NumberShown  {
    if(_NumberShown==nil){
        _NumberShown=[[NSMutableArray alloc]init];
        NSNumber *firstNumber=[FirstNumber getFirstNumber];
        [_NumberShown addObject:firstNumber];
        float value=[firstNumber floatValue];
        NSString *firstName=self.currencyShown[0];
        for (int i=1; i<self.currencyShown.count; i++) {
            float newCurrencyValue=[self.info exchangeToCurrency:self.currencyShown[i] withNumber:value oldCurrency:firstName];
            [_NumberShown addObject:[NSNumber numberWithFloat:newCurrencyValue]];
        }
    }
    return _NumberShown;
    
}

-(void) initCurrencyInfo{
    _info=[[DownloadInfo alloc]initWithDelegate:self];
}


-(void) setupForDismissKeyboard{
    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableview addGestureRecognizer:tapRecognizer];
        self.keyBoardShown=YES;
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardDidHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableview removeGestureRecognizer:tapRecognizer];
        self.keyBoardShown=NO;
    }];
    
    
}

-(void) updateUI {
    NSLog(@"UI is updated");
    /**
    NSInteger row_remain_unchanged=0;
    float row_number_remain_unchanged=[self.NumberShown[0] floatValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.firstResponder) return;
        [_NumberShown replaceObjectAtIndex:row_remain_unchanged withObject:[NSNumber numberWithFloat:row_number_remain_unchanged]];
        UICustomCell *cell=(UICustomCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row_remain_unchanged inSection:row_number_remain_unchanged]];
        [self updateCell:cell inputText:row_number_remain_unchanged];
        [self updateOtherCellByRow:row_remain_unchanged];
        [self refreshTableView];
        
    });
     **/
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self updateCellWithIndexPath:indexpath];
   
}
-(void) updateUIError{
    
    NSLog(@"UI Error is updated");
    dispatch_async(dispatch_get_main_queue(),^
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新错误，将使用上次更新的汇率" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    });
 }

-(void) updateUIOK{
    NSLog(@"updateUI OK");
    dispatch_async(dispatch_get_main_queue(),^
                   {
                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"汇率更新成功" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                       [alert show];
                   });


}



#pragma mark table view data source

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier=@"tableCell";
    UICustomCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSString *currencyName=[self.currencyShown objectAtIndex:indexPath.row];
    NSLog(@"the currency name is %@, the row is %ld",currencyName,indexPath.row);
    cell.currencyImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png",currencyName]];
    cell.currencyName.text=currencyName;
    cell.currencyFullName.text=[self.info getFullCurrencyNameWith:currencyName];
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



/**

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"enter into scrollViewWillBeginDragging");
    //first detect whether it is trigger by people
   
    [self dismissKeyboard];

}

**/

#pragma mark UI update actions

- (IBAction)inputField:(UITextField *)sender {
    // NSLog([[[[[sender superview] superview]superview] class] debugDescription]);
    NSLog(@"input Field is called");
    float OSversion=[[[UIDevice currentDevice] systemVersion] floatValue];
    UIView *view;
    if(OSversion >=7.0 && OSversion<8.0)
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

- (IBAction)TouchDown:(UITextField *)sender {
    NSLog(@"I am touching down");
  //  BOOL abc=[sender becomeFirstResponder];
  //  if (abc) {
  //      NSLog(@"abc is true");
  ///  }
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
        if (cell_new==nil) {
            NSLog(@"cell new is nil");
        }
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
    NSLog(@"I am tring to dismiss Keyboard");
    if(self.firstResponder && self.keyBoardShown) {
       [self.firstResponder resignFirstResponder];
        
        self.firstResponder=nil;
    }
}

-(void) refreshTableView{
    
    [self.tableview reloadData];
    
}

- (void) saveFirstNumber{
    NSLog(@"save First Number is called");
    if(self.NumberShown.count>=1){
        [FirstNumber updateFirstNumber:self.NumberShown[0]];
    }
}
@end
