//
//  UIScrollView+CTRefresh.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (CTRefresh)

@property (nonatomic, strong) UIView *ct_refreshHeader;

- (void)ct_addHeaderRefresh:(Class)headerClass handle:(void(^)(UIView *headerView))handle;
- (void)ct_endHeaderRefresh;

@end
