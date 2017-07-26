//
//  CTScrollViewObserver.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTScrollViewObserver : NSObject

@property (nonatomic, copy) void(^headerRefreshBlock)(UIView *headerView);
@property (nonatomic, copy) void(^footerRefreshBlock)(UIView *footerView);

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (void)beginRefresh;
- (void)endHeaderRefresh;

- (void)endFooterRefresh;

@end
