//
//  OneLoginUtil.h
//  Runner
//
//  Created by noctis on 2019/10/21.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OneLoginUtil : NSObject

- (void)normalLogin:(UIViewController *)controller;

- (void)popupLogin:(UIViewController *)controller;

- (void)floatWindowLogin:(UIViewController *)controller;

- (void)landscapeLogin:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
