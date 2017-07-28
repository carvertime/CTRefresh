//
//  UIScrollView+CTRefresh.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "UIScrollView+CTRefresh.h"
#import <objc/runtime.h>
#import "CTScrollViewObserver.h"

static const char CTObserverKey;
static const char CTRefreshHeaderKey;
static const char CTRefreshFooterKey;


@implementation UIScrollView (CTRefresh)


#pragma mark - header refresh
- (void)ct_addHeaderRefresh:(Class)headerClass handle:(void (^)(UIView *))handle{
    
    CTScrollViewObserver *observer = objc_getAssociatedObject(self, &CTObserverKey);
    if (!observer) {
        observer = [[CTScrollViewObserver alloc] initWithScrollView:self];
        objc_setAssociatedObject(self, &CTObserverKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    observer.headerRefreshBlock = handle;
    id headerView = [[headerClass alloc] initWithFrame:CGRectZero];
    self.ct_refreshHeader = headerView;
    [self addSubview:self.ct_refreshHeader];
    
}

- (void)ct_beginRefresh{
    CTScrollViewObserver *observer = objc_getAssociatedObject(self, &CTObserverKey);
    [observer beginRefresh];
}

- (void)ct_endHeaderRefresh{
    CTScrollViewObserver *observer = objc_getAssociatedObject(self, &CTObserverKey);
    [observer endHeaderRefresh];
}

- (UIView *)ct_refreshHeader{
    return objc_getAssociatedObject(self, &CTRefreshHeaderKey);
}

- (void)setCt_refreshHeader:(UIView *)ct_refreshHeader{
    objc_setAssociatedObject(self, &CTRefreshHeaderKey, ct_refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - footer refresh
- (void)ct_addFooterRefresh:(Class)footerClass handle:(void(^)(UIView *footerView))handle{
    CTScrollViewObserver *observer = objc_getAssociatedObject(self, &CTObserverKey);
    if (!observer) {
        observer = [[CTScrollViewObserver alloc] initWithScrollView:self];
        objc_setAssociatedObject(self, &CTObserverKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    observer.footerRefreshBlock = handle;
    id footerView = [[footerClass alloc] initWithFrame:CGRectZero];
    self.ct_refreshFooter = footerView;
}

- (void)ct_endFooterRefresh{
    CTScrollViewObserver *observer = objc_getAssociatedObject(self, &CTObserverKey);
    [observer endFooterRefresh];
}


- (UIView *)ct_refreshFooter{
    return objc_getAssociatedObject(self, &CTRefreshFooterKey);
}

- (void)setCt_refreshFooter:(UIView *)ct_refreshFooter{
    objc_setAssociatedObject(self, &CTRefreshFooterKey, ct_refreshFooter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
