//
//  CTRefreshProtocol.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CTRefreshProtocol <NSObject>

- (UIScrollView *)observerScrollView;
- (UIView *)refreshHeaderView;

@end


