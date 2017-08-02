//
//  ViewController.m
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/7/3.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "ViewController.h"
#import "SSBaseRenderController.h"
#import "CXMacros.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"JSON示例";
    self.view.backgroundColor                            = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = kColor(69, 200, 220);
    self.navigationController.navigationBar.tintColor    = [UIColor whiteColor];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.tableView.tableFooterView=[UIView new];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        SSBaseRenderController *obj = [[SSBaseRenderController alloc] init];
        obj.url=@"http://127.0.0.1:5000/appjson";
        [self.navigationController pushViewController:obj animated:YES];
    }
}
@end
