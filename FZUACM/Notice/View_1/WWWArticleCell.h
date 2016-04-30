//
//  WWWArticleCell.h
//  Notice
//
//  Created by W3DIAN0 on 4/30/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWWArticleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;
@property (weak, nonatomic) IBOutlet UILabel *articleTitle;

@property (weak, nonatomic) IBOutlet UILabel *articleSubTitle;
@end
