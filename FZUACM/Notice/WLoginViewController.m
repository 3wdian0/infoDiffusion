//
//  WLoginViewController.m
//  Notice
//
//  Created by w3dian0 on 4/12/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//



// RGB: 53 181 240  textField中的颜色
//      60 210 255  登录界面背景颜色值
#import "WLoginViewController.h"

#import "WHomeViewController.h"
#import "WHobbyViewController.h"
#import "WNoticeViewController.h"
#import "WPersonalViewController.h"


@interface WLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)loginButton:(id)sender;
- (IBAction)registerButton:(id)sender;

@end

@implementation WLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.accountField.delegate = self;
    self.passwordField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    
    [self.view endEditing:YES];
    
}

- (IBAction)loginButton:(id)sender {
    
    
    
    WHomeViewController *homeVC = [[WHomeViewController alloc]init];
    UINavigationController *navHome = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [self chushihua:navHome.navigationBar];
    
    
    WHobbyViewController *hobbyVC = [[WHobbyViewController alloc]init];
    UINavigationController *navHobby = [[UINavigationController alloc]initWithRootViewController:hobbyVC];
    
    
    WNoticeViewController *noticeVC = [[WNoticeViewController alloc]init];
    UINavigationController *navNotice = [[UINavigationController alloc]initWithRootViewController:noticeVC];
    [self chushihua:navNotice.navigationBar];
    
    /*
     navNotice.navigationBar.barTintColor = [UIColor colorWithRed:60.0/255.0 green:210.0/255.0 blue:255.0/255.0 alpha:1];
     navNotice.navigationBar.tintColor = [UIColor whiteColor];
     navNotice.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
     */
    
    
    
    WPersonalViewController *personalVC = [[WPersonalViewController alloc]init];
    UINavigationController *navPersonal = [[UINavigationController alloc]initWithRootViewController:personalVC];
    [self chushihua:navPersonal.navigationBar];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.viewControllers = @[navHome,navNotice,navPersonal];
    [tabBarController.tabBar setTintColor:[UIColor colorWithRed:60.0/255.0 green:210.0/255.0 blue:255.0/255.0 alpha:1]];

    // self.window.rootViewController =tabBarController;
    

    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController =tabBarController;
    
}
- (IBAction)registerButton:(id)sender {
    
}



-(void)chushihua:(UINavigationBar*)navBar{
    navBar.barTintColor = [UIColor colorWithRed:60.0/255.0 green:210.0/255.0 blue:255.0/255.0 alpha:1];
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    
    
}

@end
