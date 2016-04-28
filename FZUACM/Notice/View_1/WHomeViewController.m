//
//  WHomeViewController.m
//  Notice
//
//  Created by w3dian0 on 4/12/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "WHomeViewController.h"
#import "SXTitleLable.h"
#import "WWTableViewPage.h"



@interface WHomeViewController ()< UIScrollViewDelegate>

/* 标题栏 */
@property (weak, nonatomic) IBOutlet UIScrollView *smallScrollView;

/** 下面的内容栏 */
@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;
@property(nonatomic,strong) SXTitleLable *oldTitleLable;
@property (nonatomic,assign) CGFloat beginOffsetX;



/* 新闻接口的数组 */
@property (nonatomic, strong) NSArray *arrayLists;


@property(nonatomic,strong) WWTableViewPage *needScrollToTopPage;

///////
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;
////



@end

@implementation WHomeViewController

#pragma mark - ******************** 懒加载
- (NSArray *)arrayLists
{
    if (_arrayLists == nil) {
        _arrayLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"NewsURLs.plist" ofType:nil]];
    }
    return _arrayLists;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"FZU";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.tabBarItem.title = @"阅读";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar1.png"];
        
        UIImage* selectedImage0 = [UIImage imageNamed:@"tabBarClick1.png"];
        selectedImage0 = [selectedImage0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage =selectedImage0;
        
        /////////////////////////////////////////////////////////////
        NSURLSessionConfiguration *config =
        [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config
                                                 delegate:nil
                                            delegateQueue:nil];
        // [self fetchFeed];
        /////////////////////////////////////////////////////////////////
        
    }
    return self;
}


- (void)fetchFeed
{
    // 每个人都不一样
    NSString *tokenStr = @"test001e2349481313ba7797cc0016517708a85";
    NSString *requestString = [NSString stringWithFormat:@"http://59.77.134.146:8080/RS_WEB/apicategory?accesstoken=%@",tokenStr];
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask =
    [self.session dataTaskWithRequest:req
                    completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
         self.courses = [NSJSONSerialization JSONObjectWithData:data
                                                                    options:0
                                                                      error:nil];
         // NSLog(@"%@", self.courses);
         
         dispatch_async(dispatch_get_main_queue(), ^{
             // [self.tableView reloadData];
         });
     }];
    [dataTask resume];
}

- (void)doSomethingInSegment:(UISegmentedControl *)Seg {
    
    NSLog(@"index %d ", Seg.selectedSegmentIndex);
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.smallScrollView.scrollsToTop = NO;
    self.bigScrollView.scrollsToTop = NO;
    self.bigScrollView.delegate = self;

    
    [self addController];
    [self addLable];
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    SXTitleLable *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = 1.0;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    

    
    
    self.needScrollToTopPage = self.childViewControllers[0];
    
    
    
    

}


- (void)viewWillAppear:(BOOL)animated
{
    /*
    [super viewWillAppear:animated];
    [self.tableView reloadData];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ******************** 添加方法

/** 添加子控制器 */
- (void)addController
{   // 在新闻主页的 smallScrollView，有8个子标题，对应8个 子视图控制器，这8个子视图控制器都添加在 SXMainViewController 控制器
    for (int i=0 ; i<self.arrayLists.count ;i++){
        // WWTableViewPage *vc1 = [[WWTableViewPage alloc]init];
        WWTableViewPage *vc1 = [[WWTableViewPage alloc] initWithStyle:UITableViewStylePlain];
        vc1.title = self.arrayLists[i][@"categoryname"];
        // vc1.urlString = self.arrayLists[i][@"urlString"];
        vc1.categoryid = self.arrayLists[i][@"categoryid"];
        [self addChildViewController:vc1];
    }
}

/** 添加标题栏 */
- (void)addLable
{
    for (int i = 0; i < self.arrayLists.count; i++) {
        CGFloat lblW = 70;
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        SXTitleLable *lbl1 = [[SXTitleLable alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text =vc.title;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [self.smallScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    self.smallScrollView.contentSize = CGSizeMake(70 * 8, 0);
    
}


/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    SXTitleLable *titlelable = (SXTitleLable *)recognizer.view;
    
    CGFloat offsetX = titlelable.tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    [self setScrollToTopWithTableViewIndex:titlelable.tag];
}



#pragma mark - ScrollToTop

- (void)setScrollToTopWithTableViewIndex:(NSInteger)index
{
    self.needScrollToTopPage.tableView.scrollsToTop = NO;
    self.needScrollToTopPage = self.childViewControllers[index];
    self.needScrollToTopPage.tableView.scrollsToTop = YES;
}



#pragma mark - ******************** scrollView代理方法

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    // 滚动标题栏
    SXTitleLable *titleLable = (SXTitleLable *)self.smallScrollView.subviews[index];
    
    CGFloat offsetx = titleLable.center.x - self.smallScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
    [self.smallScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    WWTableViewPage *newsVc = self.childViewControllers[index];
    newsVc.index = index;
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            SXTitleLable *temlabel = self.smallScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    [self setScrollToTopWithTableViewIndex:index];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    SXTitleLable *labelLeft = self.smallScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        SXTitleLable *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}



-(void)addNewItem:(id)sender{
    
}


@end
