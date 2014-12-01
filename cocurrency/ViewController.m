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
#import "SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIUpdateFromSession.h"
#import <QuartzCore/QuartzCore.h>
#import "UpdateTime+Update.h"
#import "CurrencyShown+Update.h"

@interface ViewController  ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *AddCurrency;
@property (weak, nonatomic) IBOutlet UIButton *Refresh;
@property (strong,nonatomic) NSMutableArray   * currencyShown;
@property (strong,nonatomic) NSMutableArray   * NumberShown;
@property (strong,nonatomic) NSMutableArray   * NumberShown_temp;
@property (strong,nonatomic) DownloadInfo * info;
@property (strong,nonatomic)  UITextField * firstResponder;
@property (weak, nonatomic) IBOutlet UINavigationItem *MainUITitle;
@property( assign,nonatomic) BOOL keyBoardShown;
@property (assign,nonatomic) CGFloat height;
@property (assign,nonatomic) BOOL deleteOnRow;
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
    [self addRefreshSupport];
 }

-(void) viewDidAppear:(BOOL)animated{
    [self.tableView triggerPullToRefresh];
    //[self setFirstResponder];
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
    self.tableView.backgroundColor=[UIColor whiteColor];
    self.navigationController.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    _height=70;
    self.navigationItem.rightBarButtonItem=self.editButtonItem;
    
}

- (void) initCurrencyShow{
     //_currencyShown=[[NSMutableArray alloc]initWithObjects:@"CNY",@"USD",@"EUR",@"HKD", @"JPY",@"KRW",@"GBP",@"TWD",@"MOP",@"CAD",nil];
    _currencyShown=[[CurrencyShown getCurrencyShown] mutableCopy];
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
        self.tableView.showsPullToRefresh=NO;
    }];
    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardDidHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        [self.tableview removeGestureRecognizer:tapRecognizer];
        self.keyBoardShown=NO;
        self.tableView.showsPullToRefresh=YES;

    }];
    
    
}




- (void)addRefreshSupport{
    ViewController __weak * weakSelf=self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshActionTriggerd];
        
    }];
    [self.tableView.pullToRefreshView setTitle:@"加载中......" forState:SVPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"释放更新" forState:SVPullToRefreshStateTriggered];
}


-(void) setFirstResponder{
    NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
    UITextField *filed=((UICustomCell*)[self.tableView cellForRowAtIndexPath:path]).inputText;
    [self setFirstResponder:filed];
}


- (void) refreshActionTriggerd{
    ViewController __weak * weakSelf=self;
    [weakSelf.info updateInfo];
}

-(void) updateUI {
    NSLog(@"UI is updated");
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self updateCellWithIndexPath:indexpath];
   
}
-(void) updateUIError{
    
    NSLog(@"UI Error is updated");
    dispatch_after([self refreshDelayTime],dispatch_get_main_queue(),^
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: [self UIErrorString] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
       
        [alert show];
        [self.tableView.pullToRefreshView stopAnimating];

    });

 }

-(NSString *) UIErrorString{
    NSMutableString *ret=[@"无法获取最新汇率，将使用" mutableCopy];
    NSDate *lastDate=[UpdateTime lastUpdateTime];
    NSDate *currentDate=[NSDate date];
    NSDateFormatter *lastDateFormatter=[[NSDateFormatter alloc]init];
    NSDateFormatter *currentDateFormatter=[[NSDateFormatter alloc]init];
    [lastDateFormatter setDateFormat:@"yyyyMMddHHmm"];
    [currentDateFormatter setDateFormat:@"yyyyMMddHHmm"];
    [lastDateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    [currentDateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString *lastUpdateTime=[lastDateFormatter stringFromDate:lastDate];
    NSString *currentTime= [currentDateFormatter stringFromDate:currentDate];
    if (![[lastUpdateTime substringToIndex:4] isEqualToString:[currentTime substringToIndex:4]]) {
        if ([[lastUpdateTime  substringToIndex:4] intValue]==0) {
            [ret appendString:@"上次"];
        }
        else [ret appendFormat:@"%d年%d月%d日",[[lastUpdateTime  substringToIndex:4] intValue],[[lastUpdateTime substringWithRange:NSMakeRange(4, 2)] intValue],[[lastUpdateTime substringWithRange:NSMakeRange(6, 2)] intValue]];
    }
    else {
        if ([[lastUpdateTime substringToIndex:8] isEqualToString:[currentTime substringToIndex:8]]) {
            int lastUpdateHour=[[lastUpdateTime substringWithRange:NSMakeRange(8, 2)] intValue];
            int lastUpdateMin=[[lastUpdateTime substringWithRange:NSMakeRange(10, 2)] intValue];
            [ret appendFormat:@"今天%d点%d分",lastUpdateHour,lastUpdateMin];
        }
        else{
            int currentMonth= [[currentTime substringWithRange:NSMakeRange(4, 2)] intValue];
            int lastUpdateMonth=[[lastUpdateTime substringWithRange:NSMakeRange(4, 2)] intValue];
            int currentDay= [[currentTime substringWithRange:NSMakeRange(6, 2)] intValue];
            int lastUpdateDay=[[lastUpdateTime substringWithRange:NSMakeRange(6, 2)] intValue];
            if (currentMonth==lastUpdateMonth && currentDay-lastUpdateDay==1) [ret appendString:@"昨天"];
                else [ret appendFormat:@"%d月%d日",lastUpdateMonth,lastUpdateDay];
            
        }
    }
    
    [ret appendString:@"获取的汇率进行换算"];
    return ret;
    
}

-(dispatch_time_t) refreshDelayTime{
    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0.1*NSEC_PER_SEC);
    return  time;
}

-(void) updateUIOK{
    NSLog(@"updateUI OK");
    dispatch_after([self refreshDelayTime],dispatch_get_main_queue(),^
                   {
                       [self.tableView.pullToRefreshView stopAnimating];
                       [self alertViewShowsWithRect:[self updateSuccessedAlertViewRect] String:@"汇率更新成功" duration:2.5];
                   });

}


-(void) alertViewShowsWithRect:(CGRect)rect String:(NSString*)text duration:(NSTimeInterval)time{
    UIView *alertView=[[UIView alloc]initWithFrame:rect];
    alertView.backgroundColor=[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.8];
    alertView.layer.cornerRadius=5;
    alertView.layer.masksToBounds=YES;
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    label.textAlignment=NSTextAlignmentCenter;
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc]initWithString:text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName   value:[UIFont fontWithName:nil size:15] range:NSMakeRange(0, attributedString.length)];
    label.attributedText=[attributedString copy];
    [alertView addSubview:label];
    [self.view addSubview:alertView];
    [UIView transitionWithView:alertView duration:time options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        alertView.alpha=0;
    } completion:^(BOOL finished){
        [alertView removeFromSuperview];
    }];
}

-(CGRect) updateSuccessedAlertViewRect{
    CGSize  alertViewSize=CGSizeMake(100, 30);
    CGSize  screenSize=[UIScreen mainScreen].bounds.size;
    int num=(screenSize.height-self.navigationController.navigationBar.frame.size.height)/self.height;
    CGFloat alertViewOrigineX=self.tableView.frame.size.width/2-alertViewSize.width/2;
    CGFloat alertViewOrigineY=self.height*(num-1)-alertViewSize.height;
    CGRect rect= CGRectMake(alertViewOrigineX, alertViewOrigineY, alertViewSize.width,alertViewSize.height);
    return rect;
}

#pragma mark table view data source

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *reuseIdentifier=@"tableCell";
    UICustomCell *cell=[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSString *currencyName=[self.currencyShown objectAtIndex:indexPath.row];
    NSLog(@"the currency name is %@, the row is %ld",currencyName,indexPath.row);
    cell.currencyImage.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png",currencyName]];
    NSMutableAttributedString *currencyNameMutableString=[[NSMutableAttributedString alloc]initWithString:currencyName];
    [currencyNameMutableString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0] range:NSMakeRange(0,currencyNameMutableString.length)];
    cell.currencyName.attributedText=currencyNameMutableString;
    
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
    return self.height;

}



- (void) updateCell:(UICustomCell *) cellA inputText:(float)currencyNumber{
    NSLog(@"updateCell is called");
    if(fabs((float)(int)currencyNumber-currencyNumber)<pow(10, -10))
        cellA.inputText.text=[NSString stringWithFormat:@"%.0f",currencyNumber];
    else
        cellA.inputText.text=[NSString stringWithFormat:@"%.2f",currencyNumber];
}

//delete ,move ,add
#pragma mark Edit


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [self dismissKeyboard];
    NSNumber *numberToMove=[self.NumberShown_temp objectAtIndex:sourceIndexPath.row];
    [self.NumberShown_temp removeObjectAtIndex:sourceIndexPath.row];
    [self.NumberShown_temp insertObject: numberToMove  atIndex:destinationIndexPath.row];
    
    NSString *currencyToMove=[self.currencyShown objectAtIndex:sourceIndexPath.row];
    [self.currencyShown removeObjectAtIndex:sourceIndexPath.row];
    [self.currencyShown insertObject: currencyToMove  atIndex:destinationIndexPath.row];
    
    return;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.deleteOnRow=NO;
    if(self.currencyShown.count>2)
        return UITableViewCellEditingStyleDelete;
    else return  UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(BOOL) tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{

    return YES;
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [self.NumberShown_temp removeObjectAtIndex:indexPath.row];
        [self.currencyShown removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}


//user driven event.
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    self.deleteOnRow=YES;
}

-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row>=0 && indexPath.row<self.currencyShown.count ) {
        [self setEditing:NO animated:YES];

    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    NSLog(@"set editing is called");
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    [self dismissKeyboard];
    if (editing) {
        //save and clear;
        if(!self.deleteOnRow)   [self clearAndSaveNumberStatus];
    }
    else {
        if(!self.deleteOnRow)   [self restoreStatus];
        [self saveCurrencyShown];
        [self saveFirstNumber];
        
    }
}

-(void) clearAndSaveNumberStatus{
    self.NumberShown_temp=[self.NumberShown mutableCopy];
    if(self.NumberShown_temp.count>0){
        [self.NumberShown replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:0]];
        NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
        UICustomCell *cell=(UICustomCell*)[self.tableView cellForRowAtIndexPath:path];
        [self updateCell:cell inputText:0];
        [self updateCellWithIndexPath:0];
        
    }
   
}

-(void) restoreStatus{
    self.NumberShown=[self.NumberShown_temp mutableCopy];
    [self refreshTableView];
    
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

//get the first number from the UI ,then it update all the data source and UI according that
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

- (void) saveCurrencyShown{
    NSLog(@"save Currency Shown is called");
    if(self.currencyShown.count>=1){
        [CurrencyShown updateCurrencyShown:self.currencyShown];
    }
}
@end
