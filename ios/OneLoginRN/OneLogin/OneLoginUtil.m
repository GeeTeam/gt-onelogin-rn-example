//
//  OneLoginUtil.m
//  Runner
//
//  Created by noctis on 2019/10/21.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "OneLoginUtil.h"
#import <OneLoginSDK/OneLoginSDK.h>
#import <React/RCTBridgeModule.h>
#import "OneLoginProgressHUD.h"

@interface OneLoginUtil () <OneLoginDelegate, RCTBridgeModule>

@end

@implementation OneLoginUtil

RCT_EXPORT_MODULE(OneLoginUtil);

RCT_EXPORT_METHOD(normalLogin) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *controller = [OneLoginUtil keyWindow].rootViewController;
        [self normalLogin:controller];
    });
}

RCT_EXPORT_METHOD(floatWindowLogin) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *controller = [OneLoginUtil keyWindow].rootViewController;
    [self floatWindowLogin:controller];
  });
}

RCT_EXPORT_METHOD(popupLogin) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *controller = [OneLoginUtil keyWindow].rootViewController;
    [self popupLogin:controller];
  });
}

RCT_EXPORT_METHOD(landscapeLogin) {
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *controller = [OneLoginUtil keyWindow].rootViewController;
    [self landscapeLogin:controller];
  });
}


+ (UIWindow *)keyWindow {
    UIWindow *keyWindow = nil;
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if (window.isKeyWindow) {
            keyWindow = window;
            break;
        }
    }
    return keyWindow;
}

- (CGFloat)ol_screenWidth {
    return MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (CGFloat)ol_screenHeight {
    return MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (BOOL)needPreGetToken {
    return ![OneLogin isPreGettedTokenValidate];
}

- (void)normalLogin:(UIViewController *)controller {
    // 若不需要自定义UI，可不设置任何参数，使用SDK默认配置即可
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    // -------------- 自定义UI设置 -----------------
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            
        }
    };
    
    // --------------状态栏设置 -------------------
    viewModel.statusBarStyle = UIStatusBarStyleLightContent;
    
    // -------------- 授权页面背景图片设置 -------------------
    //    viewModel.backgroundImage = [UIImage imageNamed:@"login_back"];
    //    viewModel.landscapeBackgroundImage = [UIImage imageNamed:@"login_back_landscape"];
    viewModel.backgroundColor = UIColor.lightGrayColor;
    
    // -------------- 导航栏设置 -------------------
    viewModel.naviTitle = [[NSAttributedString alloc] initWithString:@"一键登录"
                                                          attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
                                                                       NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                                       }];  // 导航栏标题
    viewModel.naviBgColor = UIColor.greenColor; // 导航栏背景色
    viewModel.naviBackImage = [UIImage imageNamed:@"back"]; // 导航栏返回按钮
    viewModel.backButtonHidden = NO; // 是否隐藏返回按钮，默认不隐藏
    OLRect backButtonRect = {0, 0, 0, 0, 0, 0, {0, 0}}; // 返回按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.backButtonRect = backButtonRect;
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    viewModel.naviRightControl = rightBarButton;    // 导航栏右侧控制视图
    
    // -------------- logo设置 -------------------
    viewModel.appLogo = [UIImage imageNamed:@"网关取号_logo"];  // 自定义logo图片
    OLRect logoRect = {0, 0, 0, 20, 0, 0, {0, 0}}; // logo偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置，logo大小默认为图片大小
    viewModel.logoRect = logoRect;
    viewModel.logoHidden = NO; // 是否隐藏logo，默认不隐藏
    viewModel.logoCornerRadius = 0; // logo圆角，默认为0
    
    // -------------- 手机号设置 -------------------
    viewModel.phoneNumColor = UIColor.redColor; // 颜色
    viewModel.phoneNumFont = [UIFont boldSystemFontOfSize:25]; // 字体
    OLRect phoneNumRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // 手机号偏移设置，手机号不支持设置宽高
    viewModel.phoneNumRect = phoneNumRect;
    
    // -------------- 切换账号设置 -------------------
    viewModel.switchButtonColor = UIColor.brownColor; // 切换按钮颜色
    viewModel.switchButtonFont = [UIFont systemFontOfSize:15];  // 切换按钮字体
    viewModel.switchButtonText = @"自定义切换按钮文案";  // 切换按钮文案
    viewModel.switchButtonHidden = NO; // 是否隐藏切换按钮，默认不隐藏
    OLRect switchButtonRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // 切换按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.switchButtonRect = switchButtonRect;
    
    // -------------- 授权登录按钮设置 -------------------
    viewModel.authButtonImages = @[
                                   [UIImage imageNamed:@"bg_logo_launch"],
                                   [UIImage imageNamed:@"bg_logo_launch"],
                                   [UIImage imageNamed:@"bg_logo_launch"]
                                   ];   // 授权按钮背景图片
    viewModel.authButtonTitle = [[NSAttributedString alloc] initWithString:@"授权登录"
                                                                attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
                                                                             NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                                             }];  // 导航栏标题
    OLRect authButtonRect = {0, 0, 0, 0, 0, 0, {300, 40}};  // 授权按钮偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.authButtonRect = authButtonRect;
    viewModel.authButtonCornerRadius = 0; // 授权按钮圆角，默认为0
    viewModel.clickAuthButtonBlock = ^(void) {  // 点击授权页面登录按钮回调
        NSLog(@"clickAuthButtonBlock");
    };
    
    // -------------- slogan设置 -------------------
    viewModel.sloganTextColor = UIColor.cyanColor; // slogan颜色
    viewModel.sloganTextFont = [UIFont systemFontOfSize:14]; // slogan字体
    OLRect sloganRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // slogan偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.sloganRect = sloganRect;
    
    // -------------- 服务条款设置 -------------------
    viewModel.defaultCheckBoxState = YES; // 是否默认选择同意服务条款，默认同意
    //    viewModel.checkedImage = [UIImage imageNamed:@""]; // 复选框选中状态图片
    //    viewModel.uncheckedImage = [UIImage imageNamed:@""]; // 复选框未选中状态图片
    viewModel.checkBoxSize = CGSizeMake(12, 12); // 复选框尺寸，默认为12*12
    // 隐私条款文字属性
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1.33;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.paragraphSpacing = 0.0;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.firstLineHeadIndent = 0.0;
    viewModel.privacyTermsAttributes = @{
                                         NSForegroundColorAttributeName : UIColor.orangeColor,
                                         NSParagraphStyleAttributeName : paragraphStyle,
                                         NSFontAttributeName : [UIFont systemFontOfSize:12]
                                         };
    // 额外自定义服务条款，注意index属性，默认的index为0，SDK会根据index对多条服务条款升序排列，假如想设置服务条款顺序为 自定义服务条款1 默认服务条款 自定义服务条款2，则，只需将自定义服务条款1的index设为-1，自定义服务条款2的index设为1即可
    OLPrivacyTermItem *item1 = [[OLPrivacyTermItem alloc] initWithTitle:@"自定义服务条款1"
                                                                linkURL:[NSURL URLWithString:@"https://docs.geetest.com/onelogin/overview/start"]
                                                                  index:0
                                                                  block:^(OLPrivacyTermItem * _Nonnull termItem, UIViewController *controller) {
                                                                      NSLog(@"termItem.termLink: %@, controller: %@", termItem.termLink, controller);
                                                                      // 自定义操作，可进入自定义服务条款页面
                                                                  }];
    OLPrivacyTermItem *item2 = [[OLPrivacyTermItem alloc] initWithTitle:@"自定义服务条款2"
                                                                linkURL:[NSURL URLWithString:@"https://docs.geetest.com/"]
                                                                  index:0];
    // 加载本地的html
//    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"index.html" withExtension:nil];
//    NSURLRequest *URLRequest = [NSURLRequest requestWithURL:URL];
//    OLPrivacyTermItem *item3 = [[OLPrivacyTermItem alloc] initWithTitle:@"自定义服务条款3"
//                                                             urlRequest:URLRequest
//                                                                  index:0
//                                                                  block:nil];
    viewModel.additionalPrivacyTerms = @[item1, item2];
    OLRect termsRect = {0, 0, 0, 0, 0, 0, {0, 0}};  // 服务条款偏移、大小设置，偏移量和大小设置值需大于0，否则取默认值，默认可不设置
    viewModel.termsRect = termsRect;
    viewModel.auxiliaryPrivacyWords = @[@"条款前文案", @"&", @"&", @"条款后的文案"];   // 条款之外的文案，默认可不设置
    
    viewModel.clickCheckboxBlock = ^(BOOL isChecked) {      // 点击隐私条款前勾选框回调
        NSLog(@"clickCheckboxBlock isChecked: %@", isChecked ? @"YES" : @"NO");
    };
    
    viewModel.termsAlignment = NSTextAlignmentCenter;
    
    // -------------- 服务条款H5页面导航栏设置 -------------------
    viewModel.webNaviTitle = [[NSAttributedString alloc] initWithString:@"服务条款"
                                                             attributes:@{NSForegroundColorAttributeName : UIColor.whiteColor,
                                                                          NSFontAttributeName : [UIFont boldSystemFontOfSize:18]
                                                                          }];  // 服务条款H5页面导航栏标题
    viewModel.webNaviBgColor = UIColor.purpleColor; // 服务条款导航栏背景色
    viewModel.webNaviHidden = NO;   // 服务条款导航栏是否隐藏
    
    // -------------- 授权页面支持的横竖屏设置 -------------------
    viewModel.supportedInterfaceOrientations = UIInterfaceOrientationMaskAllButUpsideDown; // 默认为UIInterfaceOrientationMaskPortrait
    
    // -------------- 自定义UI设置，如，可以在授权页面添加三方登录入口 -------------------
    viewModel.customUIHandler = ^(UIView * _Nonnull customAreaView) {
        UIButton *customBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [customBtn setTitle:@"我是自定义UI" forState:UIControlStateNormal];
        customBtn.backgroundColor = [UIColor redColor];
        customBtn.layer.cornerRadius = 2.0;
        [customBtn addTarget:self action:@selector(dismissAuthVC) forControlEvents:UIControlEventTouchUpInside];
        [customAreaView addSubview:customBtn];
        customBtn.center = CGPointMake(customAreaView.bounds.size.width/2, customAreaView.bounds.size.height/2 + 150);
    };
    
    // -------------- 授权页面点击登录按钮之后的loading设置 -------------------
    viewModel.loadingViewBlock = ^(UIView * _Nonnull containerView) {
        if ([OneLogin isProtocolCheckboxChecked]) {
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            [containerView addSubview:indicatorView];
            indicatorView.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
            [indicatorView startAnimating];
        }
    };
    
    viewModel.stopLoadingViewBlock = ^(UIView * _Nonnull containerView) {
        for (UIView *subview in containerView.subviews) {
            if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
                [(UIActivityIndicatorView *)subview stopAnimating];
                [subview removeFromSuperview];
                break;
            }
        }
    };
    
    // -------------- 授权页面未勾选服务条款时点击登录按钮的提示 -------------------
    viewModel.notCheckProtocolHint = @"请您先同意服务条款";  // 授权页面未勾选服务条款时点击登录按钮的提示，默认为"请同意服务条款"
    
    // -------------- 弹出授权页面转场动画设置 -------------------
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromRight;
    viewModel.modalPresentationAnimation = animation;
    
    CATransition *dismissAnimation = [CATransition animation];
    dismissAnimation.duration = 0.5;
    dismissAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    dismissAnimation.type = kCATransitionPush;
    dismissAnimation.subtype = kCATransitionFromLeft;
    viewModel.modalDismissAnimation = dismissAnimation;
  
    __weak typeof(self) wself = self;
    if ([self needPreGetToken]) {
        [OneLoginProgressHUD showLoadingHUDWithMessage:nil];
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull preResult) {
            NSLog(@"preGetTokenWithCompletion result: %@", preResult);
            [OneLoginProgressHUD hideAllHUD];
            if (preResult.count > 0 && preResult[@"status"] && 200 == [preResult[@"status"] integerValue]) {
                [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
                    NSLog(@"requestTokenWithViewController result: %@", result);
                    // 自定义授权页面点击登录按钮之后的loading时，调用此方法会触发stopLoadingViewBlock回调，可以在此回调中停止自定义的loading
                    [OneLogin stopLoading];
                    [wself finishRequestingToken:result];
                }];
            } else {    // 预取号失败
//                if (flutterResult) {
//                    flutterResult(@"0");
//                }
            }
        }];
    } else {
        [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
            NSLog(@"requestTokenWithViewController result: %@", result);
            [wself finishRequestingToken:result];
        }];
    }
}

- (void)popupLogin:(UIViewController *)controller {
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    viewModel.isPopup = YES;
    viewModel.switchButtonHidden = YES;
    viewModel.canClosePopupFromTapGesture = YES;
    
    viewModel.tapAuthBackgroundBlock = ^{
        NSLog(@"tapAuthBackgroundBlock");
    };
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
        }
    };
    
    __weak typeof(self) wself = self;
    if ([self needPreGetToken]) {
        [OneLoginProgressHUD showLoadingHUDWithMessage:nil];
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull preResult) {
            [OneLoginProgressHUD hideAllHUD];
            NSLog(@"preGetTokenWithCompletion result: %@", preResult);
            if (preResult.count > 0 && preResult[@"status"] && 200 == [preResult[@"status"] integerValue]) {
                [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
                    NSLog(@"requestTokenWithViewController result: %@", result);
                    [wself finishRequestingToken:result];
                }];
            } else {    // 预取号失败
//                if (flutterResult) {
//                    flutterResult(@"0");
//                }
            }
            
        }];
    } else {
        [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
            NSLog(@"requestTokenWithViewController result: %@", result);
            [wself finishRequestingToken:result];
        }];
    }
}

- (void)floatWindowLogin:(UIViewController *)controller {
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    viewModel.isPopup = YES;
    viewModel.switchButtonHidden = YES;
    
    // --------------点击弹窗背景收起弹窗 -------------------
    viewModel.canClosePopupFromTapGesture = YES;
    
    // --------------授权页面生命周期回调 -------------------
    viewModel.viewLifeCycleBlock = ^(NSString *viewLifeCycle, BOOL animated) {
        NSLog(@"viewLifeCycle: %@, animated: %@", viewLifeCycle, animated ? @"YES" : @"NO");
        if ([viewLifeCycle isEqualToString:@"viewDidDisappear:"]) {
            
        }
    };
    
    // -------------- 弹窗设置 -------------------
    
    // 自定义弹窗动画
    viewModel.popupAnimationStyle = OLAuthPopupAnimationStyleCoverVertical; // 弹窗动画风格，支持CoverVertical、StyleFlipHorizontal、CrossDissolve和自定义模式，默认为CoverVertical
    CATransition *animation = [CATransition animation];
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"rippleEffect";
    animation.subtype = kCATransitionFromLeft;
    viewModel.popupTransitionAnimation = animation; // 只有在popupAnimationStyle为OLAuthPopupAnimationStyleCustom时生效
    
    // 弹窗位置、大小设置，弹窗默认大小为300*340，居于屏幕中间，假如要弹窗居于底部，可做如下设置
    OLRect popupRect = {[self ol_screenHeight] - 340, 0, 0, 0, 0, 0, {[self ol_screenWidth], 340}};  // 弹窗偏移、大小设置
    viewModel.popupRect = popupRect;
    viewModel.popupCornerRadius = 0; // 弹窗圆角，默认为6
    //    viewModel.closePopupImage = [UIImage imageNamed:@"back"]; // 关闭按钮
    viewModel.closePopupTopOffset = @(3);  // 关闭按钮距弹窗顶部偏移
    viewModel.closePopupRightOffset = @(-8); // 关闭按钮距弹窗右边偏移
    
    viewModel.tapAuthBackgroundBlock = ^{
        NSLog(@"tapAuthBackgroundBlock");
    };
    
    __weak typeof(self) wself = self;
    if ([self needPreGetToken]) {
        [OneLoginProgressHUD showLoadingHUDWithMessage:nil];
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull preResult) {
            [OneLoginProgressHUD hideAllHUD];
            NSLog(@"preGetTokenWithCompletion result: %@", preResult);
            if (preResult.count > 0 && preResult[@"status"] && 200 == [preResult[@"status"] integerValue]) {
                [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
                    NSLog(@"requestTokenWithViewController result: %@", result);
                    [wself finishRequestingToken:result];
                }];
            } else {    // 预取号失败
//                if (flutterResult) {
//                    flutterResult(@"0");
//                }
            }
            
        }];
    } else {
        [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
            NSLog(@"requestTokenWithViewController result: %@", result);
            [wself finishRequestingToken:result];
        }];
    }
}

- (void)landscapeLogin:(UIViewController *)controller {
    OLAuthViewModel *viewModel = [OLAuthViewModel new];
    viewModel.supportedInterfaceOrientations = UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
    
    __weak typeof(self) wself = self;
    if ([self needPreGetToken]) {
        [OneLoginProgressHUD showLoadingHUDWithMessage:nil];
        [OneLogin preGetTokenWithCompletion:^(NSDictionary * _Nonnull preResult) {
            [OneLoginProgressHUD hideAllHUD];
            NSLog(@"preGetTokenWithCompletion result: %@", preResult);
            if (preResult.count > 0 && preResult[@"status"] && 200 == [preResult[@"status"] integerValue]) {
                [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
                    NSLog(@"requestTokenWithViewController result: %@", result);
                    // 自定义授权页面点击登录按钮之后的loading时，调用此方法会触发stopLoadingViewBlock回调，可以在此回调中停止自定义的loading
                    [OneLogin stopLoading];
                    [wself finishRequestingToken:result];
                }];
            } else {    // 预取号失败
//                if (flutterResult) {
//                    flutterResult(@"0");
//                }
            }
            
        }];
    } else {
        [OneLogin requestTokenWithViewController:controller viewModel:viewModel completion:^(NSDictionary * _Nullable result) {
            NSLog(@"requestTokenWithViewController result: %@", result);
            [wself finishRequestingToken:result];
        }];
    }
}

- (void)finishRequestingToken:(NSDictionary *)result {
    if (result.count > 0 && result[@"status"] && 200 == [result[@"status"] integerValue]) {
        NSString *token = result[@"token"];
        NSString *appID = result[@"appID"];
        NSString *processID = result[@"processID"];
        NSString *gwAuth = result[@"gwAuth"];
        [self validateTokenAndGetLoginInfo:token appID:appID processID:processID gwAuth:gwAuth];
    } else {
#warning 请处理获取token的错误, 更多错误码请参考错误码文档
        NSString *errCode   = [result objectForKey:@"errorCode"];
        NSString *msg       = [result objectForKey:@"msg"];
        NSString *processID = [result objectForKey:@"processID"];
        NSString *appID     = [result objectForKey:@"appID"];
        NSString *operator  = [result objectForKey:@"operatorType"];
        
        // 获取网关token失败
        if ([@"-20103" isEqualToString:errCode]) {
            // TO-DO
            // 重复调用 requestTokenWithViewController:viewModel:completion:
        }
        else if ([@"-20202" isEqualToString:errCode]) {
            // TO-DO
            // 检测到未开启蜂窝网络
        }
        else if ([@"-20203" isEqualToString:errCode]) {
            // TO-DO
            // 不支持的运营商类型
        }
        else if ([@"-20204" isEqualToString:errCode]) {
            // TO-DO
            // 未获取有效的 `accessCode`, 请确保先调用过 preGetTokenWithCompletion:
        }
        else if ([@"-20302" isEqualToString:errCode]) {
            // TO-DO
            // 用户点击了授权页面上的返回按钮, 授权页面将自动关闭
        }
        else if ([@"-20303" isEqualToString:errCode]) {
            // TO-DO
            // 用户点击了授权页面上的切换账号按钮, 授权页面不会自动给关闭。如需关闭, 需调用 [OneLogin dismissAuthViewController]。
        }
        else {
            // TO-DO
            // 其他错误类型
        }
        
        NSLog(@"[Operator: %@] - [Error Code: %@] - [Message: %@] - [ProccesID: %@] - [APPID: %@]", operator, errCode, msg, processID, appID);
        
        // 一键登录失败手动关闭授权页面
        [OneLogin dismissAuthViewController:nil];
        
//        if (flutterResult) {
//            flutterResult(@"1");
//        }
    }
}

// 使用token获取用户的登录信息
- (void)validateTokenAndGetLoginInfo:(NSString *)token appID:(NSString *)appID processID:(NSString *)processID gwAuth:(NSString *)gwAuth {
    // 根据用户自己接口构造
    // demo仅做演示
    // 请不要在线上使用该接口 `http://onepass.geetest.com/onelogin/result`
    
    NSURL *url = [NSURL URLWithString:@"http://onepass.geetest.com/onelogin/result"];
    
    NSMutableURLRequest *mRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:(NSURLRequestCachePolicy)0 timeoutInterval:10.0];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:processID  forKey:@"process_id"];
    [params setValue:appID      forKey:@"id_2_sign"];
    [params setValue:token      forKey:@"token"];
    if (gwAuth) {
        params[@"authcode"] = gwAuth;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:(NSJSONWritingOptions)0 error:nil];
    
    mRequest.HTTPMethod = @"POST";
    mRequest.HTTPBody = data;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:mRequest
                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                         id result = nil;
                                         if (data && !error) {
                                             result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                         }
                                         NSLog(@"validateToken result: %@, error: %@", result, error);
                                         // 一键登录校验成功, 手动关闭授权页面
                                         if (result && result[@"status"] && 200 == [result[@"status"] integerValue] && result[@"result"]) {
                                             NSLog(@"手机号为: %@", result[@"result"]);
                                             [OneLogin dismissAuthViewController:nil];
                                         } else {
                                             NSLog(@"校验失败: %@", result[@"result"]);
                                             [OneLogin stopLoading];
//                                             if (flutterResult) {
//                                                 flutterResult(@"2");
//                                             }
                                         }
                                     }] resume];
    
}


- (void)doneAction:(UIButton *)button {
    [self dismissAuthVC];
}

- (void)dismissAuthVC {
    NSLog(@"OneLogin isProtocolCheckboxChecked: %@", [OneLogin isProtocolCheckboxChecked] ? @"YES" : @"NO");
    [OneLogin dismissAuthViewController:nil];
}

#pragma mark - OneLoginDelegate

- (void)userDidSwitchAccount {
    [OneLogin dismissAuthViewController:nil];
}

- (void)userDidDismissAuthViewController {
    [OneLogin dismissAuthViewController:nil];
}

@end
