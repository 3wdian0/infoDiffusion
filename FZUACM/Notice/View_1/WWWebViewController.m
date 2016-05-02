//
//  WWWebViewController.m
//  Notice
//
//  Created by w3dian0 on 4/26/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "WWWebViewController.h"


@interface WWWebViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *moveRecognizer;
@property (strong, nonatomic)  UIWebView *webView;

@property(nonatomic,strong)NSString *actionTime;
@property(nonatomic,strong)NSString *beginTime;
@property(nonatomic,strong)NSString *endTime;

@property NSInteger upCount;
@property NSInteger downCount;
@property NSInteger readLong;
@property NSInteger readMax;

@end

@implementation WWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _upCount=0;
    _downCount=0;
    _readLong = self.view.bounds.size.height;   NSLog(@"viewHeight=%ld",(long)_readLong);
    _readMax  = self.view.bounds.size.height;
    
    self.webView.scalesPageToFit = YES;
    self.webView = [[UIWebView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self.webView loadRequest: [NSURLRequest requestWithURL:_URL]];
    [self.view addSubview:self.webView];

    self.moveRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLine:)];
    self.moveRecognizer.delegate = self;
    self.moveRecognizer.cancelsTouchesInView = NO;
    [self.webView addGestureRecognizer:self.moveRecognizer];
    
    
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)other
{
    if (gestureRecognizer == self.moveRecognizer) {
        return YES;
    }
    return NO;
}

- (void)moveLine:(UIPanGestureRecognizer *)gr
{
    
    
    switch (gr.state) {
    case UIGestureRecognizerStateBegan: // 开始触发手势
        break;
    case UIGestureRecognizerStateEnded: // 手势结束
        {
            //注：应该改进 在webView加载完成后，计算contentSize
            CGFloat webContentHeight = self.webView.scrollView.contentSize.height;
            NSLog(@"%f",webContentHeight);
            
            CGPoint translation = [gr translationInView:self.webView];
            if (translation.y<0) {
                _downCount++;
                NSLog(@"手势向上拖动%f",-translation.y);
            /*目前，以滑动距离来计算阅读长度。忽略了滑动的速度，待改进*/
                _readLong +=-translation.y;
                if (_readLong>=webContentHeight) {
                    _readLong = webContentHeight;
                    NSLog(@"阅读完成时，为最大阅读长度=%ld",(long)_readLong);
                }
                 NSLog(@"此时阅读长度=%ld",(long)_readLong);
                
            }else{
                _upCount++;
                NSLog(@"手势向下%f",-translation.y);
         
                /* 不用算向上距离，只需要算向下距离
                _readLong +=-translation.y;
                if (_readLong<=self.view.bounds.size.height) {
                    _readLong = self.view.bounds.size.height;
                    NSLog(@"阅读完成后，返回：%ld",(long)_readLong);
                }
                NSLog(@"此时阅读长度=%ld",(long)_readLong);
                 */
                
            }
        }
        break;
    default:
        break;
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.beginTime=[dateformatter stringFromDate:senddate];
    NSLog(@"beginTime:%@",self.beginTime);
    
  
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"---------细粒度行为数据---------");

    
    NSArray *arr = [self.beginTime componentsSeparatedByString:@" "];
    self.actionTime = arr[0];
    NSLog(@"阅读时间点：%@",self.actionTime); 
    
    
    // 退出文章，end 时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.endTime=[dateformatter stringFromDate:senddate];
    // NSLog(@"endTime:%@",self.endTime);
    
    // 退出文章，计算 阅读时长，actionTime
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *cal=[NSCalendar currentCalendar];
    unsigned int unitFlags=NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
    NSDateComponents *d = [cal components:unitFlags fromDate:[date dateFromString:self.beginTime] toDate:[date dateFromString:self.endTime] options:0];


    NSLog(@"阅读时长=%d秒",[d minute]*60+[d second]);
    
    NSLog(@"回滚次数（往后，回滚次数）upCount=%ld",(long)_upCount);
    NSLog(@"拖动次数 (往前，向下拖动）downCount=%ld",(long)_downCount);
    
    CGFloat webContentHeight = self.webView.scrollView.contentSize.height;
    NSLog(@"阅读百分比=%f",_readLong/webContentHeight);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
