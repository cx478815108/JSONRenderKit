//
//  SSBaseRenderController.m
//  JSONRenderKit
//
//  Created by 陈雄 on 2017/7/3.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "SSBaseRenderController.h"
#import "SSJSContext.h"
#import "Spider.h"
#import "UIColor+SSRender.h"
#import "CXMacros.h"

@interface SSBaseRenderController ()
@property(nonatomic ,strong) NSDictionary            *config;
@property(nonatomic ,strong) UIActivityIndicatorView *indicatorView;
@end

@implementation SSBaseRenderController

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.jsContext = [SSJSContext context];
    [self startRender];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SSViewDidAppearNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:SSViewDidDisappearNotification object:nil];
    [self.jsContext evaluateScript:@"controller.viewDidUnmount()"];
}

-(void)didPressedRightItem
{
    [self.jsContext evaluateScript:@"controller.rightButtonClick()"];
}

-(void)didReceiveRenderJSON:(NSDictionary *)json{
    UIView *wrapperView = [self.jsContext renderWithJSON:json];
    [self.view addSubview:wrapperView];
    [self.view bringSubviewToFront:self.indicatorView];
    self.config = json[@"controller"];
    [self.jsContext evaluateScript:@"controller.viewDidMount()"];
}

#pragma mark - main actions
-(void)startRender
{
    if (!(self.url && [self.url hasPrefix:@"http"])) return;
    [self.indicatorView startAnimating];
    [SSJSContext setCurrentContext:self.jsContext];
    [Spider getWithURLString:self.url parameters:nil success:^(id responseObject) {
        [self.indicatorView stopAnimating];
        NSDictionary *json  = responseObject;
        [self didReceiveRenderJSON:json];
    } failure:^(NSError *netError) {
        [self.indicatorView stopAnimating];
        [self.jsContext evaluateScript:@"controller.viewMountFailed()"];
        NSLog(@"%@",netError);
    }];
}

#pragma mark - touch event 
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - setter
-(void)setConfig:(NSDictionary *)config
{
    _config = config;
    if (_config == nil) return;
    self.title=_config[@"title"]?:@"详情";
    NSString *bgColor = _config[@"backgroundColor"];
    if (bgColor) {
        self.view.backgroundColor=[UIColor ss_colorWithString:bgColor];
    }
    
    NSDictionary *rightButton = _config[@"rightButton"];
    if (!rightButton) return;
    
    NSString *rightItemTitle = rightButton[@"title"];
    if (rightItemTitle) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:rightItemTitle style:(UIBarButtonItemStylePlain) target:self action:@selector(didPressedRightItem)];
    }
}

#pragma mark - getter 
-(UIActivityIndicatorView *)indicatorView
{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.hidesWhenStopped = YES;
        _indicatorView.center=CGPointMake(kScreenWidth/2, (kScreenHeight)/2-64);
        [self.view addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark -
-(void)dealloc
{
    [_jsContext releaseObjcs];
    _jsContext = nil;
    [SSJSContext setCurrentContext:nil];
    CXDebugLog(@"SSBaseRenderController dead");
}

@end
