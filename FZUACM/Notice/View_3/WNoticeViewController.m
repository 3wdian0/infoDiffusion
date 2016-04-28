//
//  WNoticeViewController.m
//  Notice
//
//  Created by w3dian0 on 4/12/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "WNoticeViewController.h"
#import "WWWNoticeDetailVC.h"
/////
#import "ZYBannerView.h"


#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kNavigationBarHeight  64.0
#define kBannerHeight 150.0

#define MAXCOUNT 2

/////
@interface WNoticeViewController ()<ZYBannerViewDataSource, ZYBannerViewDelegate>
{
        NSTimer *Timer;
    int pageNo;
}
@property (nonatomic, strong) ZYBannerView *banner;
@property (nonatomic, strong) NSArray *dataArray;

/////
@property(nonatomic, strong)NSArray *imageArr;
@property(nonatomic, strong)NSMutableArray *titleArr;
@property(nonatomic, strong)NSMutableArray *subTitleArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


//接收从服务器返回数据。
@property (strong,nonatomic) NSMutableData *datas;
@property (nonatomic,strong) NSMutableArray* listData;


@property (strong,nonatomic) NSString *str;
////
@end

@implementation WNoticeViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"通知";
      
        
        ////
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"通知.png"]
                          forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"通知.png"] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(scheduleStart:)
         forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 44, 44);
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = menuButton;
        /////
        
        
        self.tabBarItem.title = @"通知";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar2"];
        
    
        UIImage* selectedImage0 = [UIImage imageNamed:@"tabBarClick2.png"];
        selectedImage0 = [selectedImage0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage =selectedImage0;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控制器的automaticallyAdjustsScrollViewInsets属性为YES(default)时, 若控制器的view及其子控件有唯一的一个UIScrollView(或其子类), 那么这个UIScrollView(或其子类)会被调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 配置banner
    [self setupBanner];
    
    [self loadData];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [self.tableView setTableFooterView:v];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];

    
 }

-(void)viewDidAppear:(BOOL)animated{
    
    pageNo =0;
    
    Timer=[NSTimer scheduledTimerWithTimeInterval:10
                                           target:self
                                         selector:@selector(mapShow)
                                         userInfo:nil
                                          repeats:YES];

}

-(void)mapShow{
    pageNo++;
   // [self startRequest];
    NSLog(@"每10秒，查询%d次",pageNo);
   // [self scheduleStart:@""];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    NSLog(@"计时结束");
    [Timer invalidate];
    
}
- (void)setupBanner
{
    // 初始化
    self.banner = [[ZYBannerView alloc] init];
    self.banner.dataSource = self;
    self.banner.delegate = self;
    [self.view addSubview:self.banner];
    
    // 设置frame
    self.banner.frame = CGRectMake(0,
                                   kNavigationBarHeight,
                                   kScreenWidth,
                                   kBannerHeight);
}

#pragma mark - ZYBannerViewDataSource

// 返回Banner需要显示Item(View)的个数
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner
{
    return self.dataArray.count;
}

// 返回Banner在不同的index所要显示的View (可以是完全自定义的view, 且无需设置frame)
- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index
{
    // 取出数据
    NSString *imageName = self.dataArray[index];
    
    // 创建将要显示控件
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return imageView;
}


// 在这里实现点击事件的处理
- (void)banner:(ZYBannerView *)banner didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%ld个项目", (long)index);
}

// 在这里实现拖动footer后的事件处理
- (void)bannerFooterDidTrigger:(ZYBannerView *)banner
{
    NSLog(@"触发了footer");
}
/*

#pragma mark -
#pragma mark Demo banner property setting (无需关心此部分逻辑)

- (IBAction)switchValueChanged:(UISwitch *)aSwitch
{
    switch (aSwitch.tag) {
        case 0: // Should Loop
            self.banner.shouldLoop = aSwitch.isOn;
            break;
            
        case 1: // Show Footer
            self.banner.showFooter = aSwitch.isOn;
            break;
            
        case 2: // Auto Scroll
            self.banner.autoScroll = aSwitch.isOn;
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Scroll Interval
    self.banner.scrollInterval = textField.text.integerValue;
}
*/



#pragma mark Getter

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"ad_0.jpg", @"ad_1.jpg", @"ad_2.jpg"];
    }
    return _dataArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.imageArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 40, 40)];
    imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.bounds.size.height/2.0;
    
    
    
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 5, 200, 40)];
    idLabel.numberOfLines = 0;
    idLabel.text = self.subTitleArr[indexPath.row];
    idLabel.font =[UIFont boldSystemFontOfSize:13.0];
    idLabel.textColor = [UIColor grayColor];
    
    [cell.contentView addSubview:imageView];

    [cell.contentView addSubview:idLabel];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWWNoticeDetailVC *detailViewController = [[WWWNoticeDetailVC alloc] init];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}




- (void)loadData{
   
    self.subTitleArr = [NSMutableArray arrayWithObjects:@"人在最奇身高往往",@"超级黑洞疯狂吞噬星云，超能力",@"2016年，虚拟现实成人", @"麻省理工压”的新3D的机器人" ,@"麻省理工压”的新3D的机器人",nil];
    self.imageArr = @[@"FZU.png",@"DBL.png",@"数计.png",@"经管",@"物信.png"];
    
    
}






- (void)scheduleStart:(id)sender{
    NSLog(@"推送");
    [WNoticeViewController registerLocalNotification:4];// 4秒后
}


-(void)startRequest
{
    
    // 每个人都不一样
    NSString *tokenStr = @"test001e2349481313ba7797cc0016517708a85";
    NSString *requestString = [NSString stringWithFormat:@"http://59.77.134.146:8080/RS_WEB/apiartlist?accesstoken=%@&categoryid=%@",tokenStr,@"1"];
    // NSLog(@"categoryid=%@",self.categoryid);
    NSURL *url = [NSURL URLWithString:requestString];
    //  NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    
    NSString *post;
    
    NSData *postData  = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    
    if (connection) {
        _datas = [NSMutableData new];
    }

}



#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_datas appendData:data];
}


-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    self.str = [error localizedDescription];
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成...");
    
    NSMutableArray* arr = [NSJSONSerialization JSONObjectWithData:_datas options:NSJSONReadingAllowFragments error:nil];
    
    self.listData = arr;
    // [self reloadView:arr]
    
    
}






// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  @"该起床了...";
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:@"开始学习iOS开发了" forKey:@"key"];
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    }
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

// 取消某个本地推送通知
+ (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}


@end
