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
    SSBaseRenderController *obj = [[SSBaseRenderController alloc] init];
    if (indexPath.row==0) {
        obj.url=@"http://127.0.0.1:5000/todo";
    }
    else if (indexPath.row==1) {
        obj.url=@"http://127.0.0.1:5000/appjson";
    }
    else if (indexPath.row==2) {
        obj.url=@"http://127.0.0.1:5000/trans";
    }
    [self.navigationController pushViewController:obj animated:YES];
}
@end
