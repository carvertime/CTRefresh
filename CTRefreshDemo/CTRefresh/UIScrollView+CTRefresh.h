//
//  UIScrollView+CTRefresh.h
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTRefreshProtocol.h"

@interface UIScrollView (CTRefresh)


/** refresh header */
@property (nonatomic, strong) UIView <CTRefreshHeaderProtocol>*ct_refreshHeader;

/** create refresh header */
- (void)ct_addHeaderRefresh:(Class)headerClass handle:(void(^)(UIView *headerView))handle;

/** begin header refresh */
- (void)ct_beginHeaderRefresh;

/** end header refresh */
- (void)ct_endHeaderRefresh;

/** refresh footer */
@property (nonatomic, strong) UIView <CTRefreshFooterProtocol>*ct_refreshFooter;

/** create refresh footer */
- (void)ct_addFooterRefresh:(Class)footerClass handle:(void(^)(UIView *footerView))handle;

/** end footer refresh */
- (void)ct_endFooterRefresh;

@end
