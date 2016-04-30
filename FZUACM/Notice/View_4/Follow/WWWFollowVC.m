//
//  WWWFollowVC.m
//  Notice
//
//  Created by W3DIAN0 on 4/30/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "WWWFollowVC.h"
#import "WWWFollowCell.h"

#import "WWWNoticeDetailVC.h"

@interface WWWFollowVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) NSMutableArray *dicData;

@end

@implementation WWWFollowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // Load the NIB file
    UINib *nib = [UINib nibWithNibName:@"WWWFollowCell" bundle:nil];
    
    [self loadData];
    // Register this NIB, which contains the cell
    [self.tView registerNib:nib
         forCellReuseIdentifier:@"WWWFollowCell"];
    
    
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width , 0)];
    [self.tView setTableFooterView:v];
    [self.tView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [self.listData count];
    return [self.dicData count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Get a new or recycled cell
    WWWFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWWFollowCell" forIndexPath:indexPath];
    
    
    // Configure the cell with the WWWItem model
    
    // [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:self.listData[indexPath.row][@"photourl"]] placeholderImage:[UIImage imageNamed:@"302"]];
    cell.folloImage.image = [UIImage imageNamed:self.dicData[indexPath.row][@"image"]];
    cell.folloImage.layer.masksToBounds = YES;
    cell.folloImage.layer.cornerRadius = cell.folloImage.bounds.size.height/2.0;
    
    
    // cell.articleTitle.text = self.listData[indexPath.row][@"title"];
    
    cell.followName.text = self.dicData[indexPath.row][@"name"];
    
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
    return 60.0;
}

-(void)loadData{
    
    self.dicData = [[NSMutableArray alloc]init];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"fav_1",@"image",@"时尚先生",@"name", nil];
    self.dicData =[[NSMutableArray alloc]initWithObjects:dic,dic, nil];
    NSLog(@"%@",self.dicData);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
