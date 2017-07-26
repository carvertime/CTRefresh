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


@implementation UIScrollView (CTRefresh)

- (void)ct_addHeaderRefresh:(Class)headerClass handle:(void (^)(UIView *))handle{
    CTScrollViewObserver *observer = [[CTScrollViewObserver alloc] initWithScrollView:self];
    objc_setAssociatedObject(self, &CTObserverKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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



@end
