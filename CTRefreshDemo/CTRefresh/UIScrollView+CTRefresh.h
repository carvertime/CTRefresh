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



@property (nonatomic, strong) UIView <CTRefreshHeaderProtocol>*ct_refreshHeader;
- (void)ct_addHeaderRefresh:(Class)headerClass handle:(void(^)(UIView *headerView))handle;
- (void)ct_beginRefresh;
- (void)ct_endHeaderRefresh;


@property (nonatomic, strong) UIView <CTRefreshFooterProtocol>*ct_refreshFooter;
- (void)ct_addFooterRefresh:(Class)footerClass handle:(void(^)(UIView *footerView))handle;
- (void)ct_endFooterRefresh;

@end
