//
//  WWTableViewPage.m
//  Notice
//
//  Created by w3dian0 on 4/17/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "WWTableViewPage.h"
#import "WWWebViewController.h"
#import "UIImageView+WebCache.h"

#import "WWWNoticeDetailVC.h"
#import "WWWArticleCell.h"




@interface WWTableViewPage ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSArray *imageArr;
@property(nonatomic, strong)NSMutableArray *titleArr;
@property(nonatomic, strong)NSMutableArray *subTitleArr;

@property (weak, nonatomic) IBOutlet UITableView *tView;


//////
@property (nonatomic, strong) WWWebViewController *webViewController;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;
//////
//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

//接收从服务器返回数据。
@property (strong,nonatomic) NSMutableData *datas;
@end

@implementation WWTableViewPage


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self startRequest];
    [self loadData];
    
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"WWWArticleCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib
         forCellReuseIdentifier:@"WWWArticleCell"];

    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 0)];
    [self.tableView setTableFooterView:v];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    //初始化UIRefreshControl
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;
    
    
    
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}

-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        //查询请求数据
        //[self startRequest];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.listData count];
    return [self.imageArr count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get a new or recycled cell
    WWWArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWWArticleCell" forIndexPath:indexPath];
    
    
    // Configure the cell with the WWWItem model

    // [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:self.listData[indexPath.row][@"photourl"]] placeholderImage:[UIImage imageNamed:@"302"]];
    cell.articleImage.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.articleImage.layer.masksToBounds = YES;
    cell.articleImage.layer.cornerRadius = 2.0;
    
    // cell.articleTitle.text = self.listData[indexPath.row][@"title"];
    
    cell.articleTitle.text = self.titleArr[indexPath.row];
    cell.articleSubTitle.text = self.subTitleArr[indexPath.row];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    WWWebViewController *wvc = [[WWWebViewController alloc] init];
    self.webViewController = wvc;
    
    // 每个人都不一样
    NSString *tokenStr = @"test001e2349481313ba7797cc0016517708a85";
    NSString *str=[NSString stringWithFormat:@"http://59.77.134.146:8080/RS_WEB/apiartcontent?accesstoken=%@&articleid=%@",tokenStr,self.listData[indexPath.row][@"articleid"]];
    NSURL *URL = [NSURL URLWithString:str];
    // NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com"];
    
    self.webViewController.title = @"title";
    self.webViewController.URL = URL;
    
    self.webViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:self.webViewController
                                         animated:YES];
    self.webViewController.hidesBottomBarWhenPushed=NO;
    //并在push后设置self.webViewController.hidesBottomBarWhenPushed=NO;
    //这样back回来的时候，tabBar会恢复正常显示。
 */
    
    
    
    WWWNoticeDetailVC *detailViewController = [[WWWNoticeDetailVC alloc] init];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}





/*
 * 开始请求Web Service
 */
-(void)startRequest
{
    
    // 每个人都不一样
    NSString *tokenStr = @"test001e2349481313ba7797cc0016517708a85";
    NSString *requestString = [NSString stringWithFormat:@"http://59.77.134.146:8080/RS_WEB/apiartlist?accesstoken=%@&categoryid=%@",tokenStr,self.categoryid];
    NSLog(@"categoryid=%@",self.categoryid);
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
    
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成...");
    
    NSMutableArray* arr = [NSJSONSerialization JSONObjectWithData:_datas options:NSJSONReadingAllowFragments error:nil];
    
    
    [self reloadView:arr];
    
}


//重新加载表视图
-(void)reloadView:(NSMutableArray *)res
{
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    }
    
    // NSLog(@"listData%@",res);
    self.listData = res;
    [self.tableView reloadData];
    
    
}



- (void)loadData{
    self.titleArr = [NSMutableArray arrayWithObjects:@"人在宇宙中会变高？宇宙最奇异真相难以置信",@"超级黑洞疯狂吞噬星云 超新星系被撕裂",@"虚拟现实之父 在1957年制造出第一台VR机器",@"3D打印机造出可独立行走的机器人" ,nil];
    self.subTitleArr = [NSMutableArray arrayWithObjects:@"人在宇宙中会变高？宇宙最奇异真相难以置信。人在地球上受地球引力的作用，身高往往",@"超级黑洞疯狂吞噬星云，超新星系被撕裂。超级黑洞具备常人难以想象的强大吸食能力",@"2016年，虚拟现实成人片迅速发展，而Heilig好像比人们更早洞悉他们想要什么。或许你", @"麻省理工一组研究人员采用“可打印液压”的新3D打印技术制作出了可行走的机器人",nil];
    self.imageArr = @[@"阅读001",@"阅读002",@"阅读003",@"阅读004"];
    
    
}



@end



/*
#import "WWTableViewPage.h"
#import "WWWebViewController.h"
#import "UIImageView+WebCache.h"





@interface WWTableViewPage ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)NSArray *imageArr;
@property(nonatomic, strong)NSMutableArray *titleArr;
@property(nonatomic, strong)NSMutableArray *subTitleArr;

@property (weak, nonatomic) IBOutlet UITableView *tView;


//////
@property (nonatomic, strong) WWWebViewController *webViewController;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;
//////
//保存数据列表
@property (nonatomic,strong) NSMutableArray* listData;

//接收从服务器返回数据。
@property (strong,nonatomic) NSMutableData *datas;
@end

@implementation WWTableViewPage


- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self startRequest];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [self.tableView setTableFooterView:v];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    //初始化UIRefreshControl
    UIRefreshControl *rc = [[UIRefreshControl alloc] init];
    rc.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    [rc addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = rc;


    
}
-(void)viewDidAppear:(BOOL)animated{

}

-(void) refreshTableView
{
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"加载中..."];
        //查询请求数据
        [self startRequest];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 80, 60)];
    // imageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.listData[indexPath.row][@"photourl"]] placeholderImage:[UIImage imageNamed:@"302"]];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 2.0;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 200, 35)];
    nameLabel.text = self.listData[indexPath.row][@"title"];
    
    UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 35, 200, 40)];
    idLabel.numberOfLines = 0;
    idLabel.text = self.listData[indexPath.row][@"content"];
    idLabel.font =[UIFont boldSystemFontOfSize:11.0];
    idLabel.textColor = [UIColor grayColor];
    
    [cell.contentView addSubview:imageView];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:idLabel];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WWWebViewController *wvc = [[WWWebViewController alloc] init];
    self.webViewController = wvc;

    // 每个人都不一样
    NSString *tokenStr = @"test001e2349481313ba7797cc0016517708a85";
    NSString *str=[NSString stringWithFormat:@"http://59.77.134.146:8080/RS_WEB/apiartcontent?accesstoken=%@&articleid=%@",tokenStr,self.listData[indexPath.row][@"articleid"]];
    NSURL *URL = [NSURL URLWithString:str];
    // NSURL *URL = [NSURL URLWithString:@"http://www.baidu.com"];
    
    self.webViewController.title = @"title";
    self.webViewController.URL = URL;

    self.webViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:self.webViewController
                                         animated:YES];
    self.webViewController.hidesBottomBarWhenPushed=NO;
    //并在push后设置self.webViewController.hidesBottomBarWhenPushed=NO;
    //这样back回来的时候，tabBar会恢复正常显示。
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}





// 开始请求Web Service
 
-(void)startRequest
{
    
    // 每个人都不一样
    NSString *tokenStr = @"test001e2349481313ba7797cc0016517708a85";
    NSString *requestString = [NSString stringWithFormat:@"http://59.77.134.146:8080/RS_WEB/apiartlist?accesstoken=%@&categoryid=%@",tokenStr,self.categoryid];
    NSLog(@"categoryid=%@",self.categoryid);
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
    
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    NSLog(@"请求完成...");
    
    NSMutableArray* arr = [NSJSONSerialization JSONObjectWithData:_datas options:NSJSONReadingAllowFragments error:nil];
    
    
        [self reloadView:arr];
    
}


//重新加载表视图
-(void)reloadView:(NSMutableArray *)res
{
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
         self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    }

    // NSLog(@"listData%@",res);
        self.listData = res;
        [self.tableView reloadData];
    

}
@end
 
*/