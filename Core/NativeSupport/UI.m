//
//  UI.m
//  SSRenderKit
//
//  Created by 陈雄 on 2017/6/19.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "UI.h"
#import "CXMacros.h"
#import "SSBaseRenderController.h"
@implementation UI

-(void)log:(NSString *)msg
{
    NSLog(@"%@",msg);
}

-(void)alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg?msg:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    @weakify(alert)
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
        @strongify(alert)
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

-(void)showIndicatorWithStyle:(NSString *)style
{
    SSBaseRenderController *renderController = [SSBaseRenderController currentController];
    if ([style isEqualToString:@"whitelarge"]) {
        renderController.indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
    }
    else if ([style isEqualToString:@"white"]) {
        renderController.indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhite;
    }
    else if ([style isEqualToString:@"gray"]){
        renderController.indicatorView.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    }
    [renderController showIndicator];
}

-(void)hideIndicatorDelay:(NSInteger)delay
{
    SSBaseRenderController *renderController = [SSBaseRenderController currentController];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [renderController hideIndicator];
    });
}

-(CGFloat)screenW
{
    return kScreenWidth;
}

-(CGFloat)screenH
{
    return kScreenHeight;
}

-(NSString *)themeColor{
    return @"rgb(69, 200, 220)";
}

-(NSString *)cyanColor{
    return @"rgb(167, 213, 154)";
}

-(NSString *)orangeColor{
    return @"rgb(252, 171, 83)";
}

-(NSString *)pinkRedColor
{
    return @"rgb(255, 51, 102)";
}

-(NSString *)pureColor{
    return @"rgb(140, 136, 255)";
}

-(NSString *)lightCyanColor{
    return @"rgb(0, 185, 255)";
}

-(NSString *)blueColor{
    return @"rgb(69, 200, 220)";
}

-(NSString *)lightOrgangeColor{
    return @"rgb(248, 232, 28)";
}

@end
