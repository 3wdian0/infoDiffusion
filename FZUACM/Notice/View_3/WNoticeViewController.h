//
//  WNoticeViewController.h
//  Notice
//
//  Created by w3dian0 on 4/12/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WNoticeViewController : UIViewController


// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime;
+ (void)cancelLocalNotificationWithKey:(NSString *)key;


@end
