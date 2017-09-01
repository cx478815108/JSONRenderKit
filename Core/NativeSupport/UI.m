//
//  UI.m
//  JSONRenderKit
//  Created by 陈雄 on 16/4/4.
//  Copyright © 2016年 com.feelings. All rights reserved.
//

#import "UI.h"
#import "CXMacros.h"
#import "SSBaseRenderController.h"

@interface UI()
@end

@implementation UI

#pragma mark - show UI infos

-(void)alertWithTitle:(NSString *)title
                  msg:(NSString *)msg
         actionTitles:(NSArray *)actionTitles
             callBack:(JSValue *)callBack
{
    [self showAlertControllerWithStyle:(UIAlertControllerStyleAlert)
                                 title:title
                                   msg:msg
                          actionTitles:actionTitles
                              callBack:callBack cancleButton:YES];
    
}

-(void)showSheetViewWithTitle:(NSString *)title
                          msg:(NSString *)msg
                 actionTitles:(NSArray *)actionTitles
                     callBack:(JSValue *)callBack
{
    [self showAlertControllerWithStyle:(UIAlertControllerStyleActionSheet)
                                 title:title
                                   msg:msg
                          actionTitles:actionTitles
                              callBack:callBack cancleButton:YES];
}

-(void)showAlertControllerWithStyle:(UIAlertControllerStyle)style title:(NSString *)title
                                msg:(NSString *)msg
                       actionTitles:(NSArray *)actionTitles
                           callBack:(JSValue *)callBack cancleButton:(BOOL)cancleButton
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
    
    for (NSString *title in actionTitles) {
        [alertController addAction:[UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (![callBack isUndefined]) {
                NSInteger index = [actionTitles indexOfObject:action.title];
                [callBack callWithArguments:@[@(index)]];
            }
        }]];
    }
    if (cancleButton) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            if (![callBack isUndefined]) {
                [callBack callWithArguments:@[@(-1)]];
            }
        }]];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


-(void)alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg?msg:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    @weakify(alert)
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
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
        renderController.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    }
    else if ([style isEqualToString:@"white"]) {
        renderController.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    else if ([style isEqualToString:@"gray"]){
        renderController.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
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

-(void)log:(NSString *)msg
{
    NSLog(@"%@",msg);
}

#pragma mark - device status
-(CGFloat)screenW
{
    return kScreenWidth;
}

-(CGFloat)screenH
{
    return kScreenHeight;
}

#pragma mark - rgb colors

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
