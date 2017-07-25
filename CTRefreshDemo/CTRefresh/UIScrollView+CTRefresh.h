//
//  UIScrollView+CTRefresh.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CTRefresh)

- (void)ct_addHeaderRefreshBlock:(void(^)(UIView *headerView))block;

@end
