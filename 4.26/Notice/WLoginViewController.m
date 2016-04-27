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
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    WHomeViewController *homeVC = [[WHomeViewController alloc]init];
    WHobbyViewController *hobbyVC = [[WHobbyViewController alloc]init];
    tabBarController.viewControllers = @[homeVC,hobbyVC];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController =tabBarController;
    
}
- (IBAction)registerButton:(id)sender {
    
}
@end
