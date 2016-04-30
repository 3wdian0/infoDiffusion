//
//  WPersonalViewController.m
//  Notice
//
//  Created by w3dian0 on 4/12/16.
//  Copyright © 2016 fzuacm. All rights reserved.
//

#import "WPersonalViewController.h"

#import "WWWFavoriteTVC.h"
#import "WWWFollowVC.h"

@interface WPersonalViewController ()
@property(nonatomic,strong) NSArray *array;
@end

@implementation WPersonalViewController


- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
        self.navigationItem.title = @"我";
        
        self.tabBarItem.title = @"我";
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar4"];
        UIImage* selectedImage0 = [UIImage imageNamed:@"tabBarClick4.png"];
        selectedImage0 = [selectedImage0 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.tabBarItem.selectedImage =selectedImage0;
        
        
        // self.tableView.backgroundColor = [UIColor lightGrayColor];
        // self.tableView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *arr1 = @[@"我"];
    NSArray *arr2 = @[@"我的收藏",@"我的粉丝",@"我的关注"];
    NSArray *arr3 = @[@"信息平台"];
    NSArray *arr4 = @[@"设置"];

    self.array = @[arr1,arr2,arr3,arr4];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
    [self.tableView setTableFooterView:v];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.array[section] count];

}

//   节头标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    if (indexPath.section == 0) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.height/2.0;
        imageView.image = [UIImage imageNamed:@"头像.png"];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 200, 35)];
        nameLabel.text = @"W3DIAN0";
        
        UILabel *idLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 200, 35)];
        idLabel.text = @"ID:13599488868";
        idLabel.font =[UIFont boldSystemFontOfSize:11.0];
        idLabel.textColor = [UIColor grayColor];

        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:idLabel];
        return cell;
    }else{
        
        NSString *str = self.array[indexPath.section][indexPath.row];
        cell.textLabel.text = str;
        cell.imageView.image = [UIImage imageNamed:str];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
        
        return cell;}


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return 85;
    }else{
    return 50;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:
            NSLog(@"section=%ld",(long)section);
            break;
        case 1:
        { NSLog(@"section=%ld",(long)section);
            switch (row) {
                case 0:
                {   NSLog(@"row=%ld",(long)row);
                    WWWFavoriteTVC *detailViewController = [[WWWFavoriteTVC alloc] init];
                    detailViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detailViewController
                                                         animated:YES];
                    
                }
                    break;
                case 1:
                { NSLog(@"row=%ld",(long)row);


                }
                    
                    break;
                case 2:
                {NSLog(@"row=%ld",(long)row);
                    WWWFollowVC *detailViewController = [[WWWFollowVC alloc] init];
                    detailViewController.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:detailViewController
                                                         animated:YES];}
                    break;
                    
                default:
                    break;
            }
        
        }
            break;
        case 2:
            NSLog(@"section=%ld",(long)section);
            break;
        case 3:
            NSLog(@"section=%ld",(long)section);
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
