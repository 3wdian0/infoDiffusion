//
//  WWWFavoriteCell.h
//  Notice
//
//  Created by W3DIAN0 on 4/30/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WWWFavoriteCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *favoImage;
@property (weak, nonatomic) IBOutlet UILabel *favoNmae;
@property (weak, nonatomic) IBOutlet UILabel *favoTag;
@property (weak, nonatomic) IBOutlet UILabel *favoTitle;
@property (weak, nonatomic) IBOutlet UILabel *favoNumber;

@end
