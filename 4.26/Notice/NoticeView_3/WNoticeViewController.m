//
//  WNoticeViewController.m
//  Notice
//
//  Created by w3dian0 on 4/12/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "WNoticeViewController.h"

@interface WNoticeViewController ()


@end

@implementation WNoticeViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"通知";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.tabBarItem.title = @"通知";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar3"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"tabBarClick3"];    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控制器的automaticallyAdjustsScrollViewInsets属性为YES(default)时, 若控制器的view及其子控件有唯一的一个UIScrollView(或其子类), 那么这个UIScrollView(或其子类)会被调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 配置banner
}

- (void)addNewItem:(id)sender{
    
}

@end
