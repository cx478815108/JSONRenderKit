//
//  ViewController.m
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/7/3.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "ViewController.h"
#import "SSBaseRenderController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
}


- (IBAction)didPressedBtn:(UIButton *)sender
{
    SSBaseRenderController *obj = [[SSBaseRenderController alloc] init];
    obj.url=@"http://127.0.0.1:5000/appjson";
    [self.navigationController pushViewController:obj animated:YES];
}


@end
