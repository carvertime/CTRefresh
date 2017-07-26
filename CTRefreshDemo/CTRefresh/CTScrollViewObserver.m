//
//  CTScrollViewObserver.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "CTScrollViewObserver.h"
#import "UIScrollView+CTRefresh.h"
#import "CTRefreshProtocol.h"
#import "CTRefreshDefine.h"

typedef NS_ENUM(NSInteger, CTScrollViewPanState) {
    CTScrollViewPanStateNormor,
    CTScrollViewPanStateBegin,
    CTScrollViewPanStatePulling,
    CTScrollViewPanStateLoosen,
};


@interface CTScrollViewObserver ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger panState;

@property (nonatomic, assign) CGFloat originInsetTop;
@property (nonatomic, assign) CTHeaderRefreshStatus headerRefreshState;

@property (nonatomic, assign) CGFloat originInsetBottom;
@property (nonatomic, assign) CTFooterRefreshStatus footerRefreshState;

@end

@implementation CTScrollViewObserver

- (id)initWithScrollView:(UIScrollView *)scrollView{
    if (self = [super init]) {
        _scrollView = scrollView;
        _originInsetTop = scrollView.contentInset.top;
        _originInsetBottom = scrollView.contentInset.bottom;
        [self observerScrollView:scrollView];
    }
    return self;
}

- (void)observerScrollView:(UIScrollView *)scrollView{
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    CGFloat offsetY = 0.f;
    if ([keyPath isEqualToString:@"contentOffset"]) {
        offsetY = [change[@"new"] CGPointValue].y;
    } else if ([keyPath isEqualToString:@"state"]) {
        self.panState = [change[@"new"] integerValue];
        offsetY = self.scrollView.contentOffset.y;
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        NSLog(@"contentSize = %@",change[@"new"]);
        if (self.scrollView.contentSize.height == 0) {
            self.scrollView.ct_refreshFooter.hidden = YES;
        } else {
            self.scrollView.ct_refreshFooter.hidden = NO;
            id<CTRefreshFooterProtocol>refreshFooter = (id<CTRefreshFooterProtocol>)self.scrollView.ct_refreshHeader;
            CGFloat height = self.scrollView.ct_refreshFooter.frame.size.height;
            if ([self.scrollView.ct_refreshFooter respondsToSelector:@selector(refreshFooterHeight)]) {
                height = [refreshFooter refreshFooterHeight];
            }
            self.scrollView.ct_refreshFooter.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, height);
        }
    }
    if (offsetY <= -self.originInsetTop) {
        if (self.scrollView.ct_refreshHeader && self.footerRefreshState != CTFooterRefreshStatusRefreshing) {
            [self changeHeaderViewStatusWithOffsetY:offsetY];
        }
    } else {
        if (self.scrollView.ct_refreshFooter && self.headerRefreshState != CTHeaderRefreshStatusRefreshing) {
          [self changeFooterViewStatusWithOffsetY:offsetY];
        }
    }
    
}

- (void)changeHeaderViewStatusWithOffsetY:(CGFloat)offsetY{
    
    id<CTRefreshHeaderProtocol>refreshHeader = (id<CTRefreshHeaderProtocol>)self.scrollView.ct_refreshHeader;
    CGFloat height = self.scrollView.ct_refreshHeader.frame.size.height;
    if ([self.scrollView.ct_refreshHeader respondsToSelector:@selector(refreshHeaderHeight)]) {
        height = [refreshHeader refreshHeaderHeight];
    }
    
    [refreshHeader refreshHeaderScrollOffsetY:fabs(offsetY)];
    if (fabs(offsetY) >= height+self.originInsetTop) {
        if (self.panState == CTScrollViewPanStatePulling && self.headerRefreshState != CTHeaderRefreshStatusShouldRefresh) {
            self.headerRefreshState = CTHeaderRefreshStatusShouldRefresh;
            [refreshHeader refreshHeaderStatus:CTHeaderRefreshStatusShouldRefresh];
        } else if (self.panState == CTScrollViewPanStateLoosen && self.headerRefreshState != CTHeaderRefreshStatusRefreshing) {
            self.headerRefreshState = CTHeaderRefreshStatusRefreshing;
            [refreshHeader refreshHeaderStatus:CTHeaderRefreshStatusRefreshing];
            [UIView animateWithDuration:0.25 animations:^{
               [self.scrollView setContentInset:UIEdgeInsetsMake(height+self.originInsetTop, 0, 0, 0)];
            }];
            if (self.headerRefreshBlock) {
                self.headerRefreshBlock(self.scrollView.ct_refreshHeader);
            }
        }
    } else {
        if (self.headerRefreshState != CTHeaderRefreshStatusNormal) {
            self.headerRefreshState = CTHeaderRefreshStatusNormal;
            [refreshHeader refreshHeaderStatus:CTHeaderRefreshStatusNormal];
        }
    }
    
}

- (void)changeFooterViewStatusWithOffsetY:(CGFloat)offsetY{
    
    id<CTRefreshFooterProtocol>refreshFooter = (id<CTRefreshFooterProtocol>)self.scrollView.ct_refreshFooter;
    CGFloat height = self.scrollView.ct_refreshFooter.frame.size.height;
    if ([self.scrollView.ct_refreshFooter respondsToSelector:@selector(refreshFooterHeight)]) {
        height = [refreshFooter refreshFooterHeight];
    }
    
    NSLog(@"offset ======= %lf",offsetY);
    if (offsetY-height > self.scrollView.contentSize.height - self.scrollView.frame.size.height) {
        NSLog(@"--------------到了临界值");
        if (self.panState == CTScrollViewPanStatePulling && self.footerRefreshState != CTFooterRefreshStatusShouldRefresh) {
            self.footerRefreshState = CTFooterRefreshStatusShouldRefresh;
            [refreshFooter refreshFooterStatus:CTFooterRefreshStatusShouldRefresh];
        } else if (self.panState == CTScrollViewPanStateLoosen && self.footerRefreshState != CTFooterRefreshStatusRefreshing) {
            NSLog(@"footerRefreshState ==== %zd",self.footerRefreshState);
            self.footerRefreshState = CTFooterRefreshStatusRefreshing;
            [refreshFooter refreshFooterStatus:CTFooterRefreshStatusRefreshing];
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.originInsetTop, 0, height+self.originInsetBottom, 0)];
            }];
            if (self.footerRefreshBlock) {
                self.footerRefreshBlock(self.scrollView.ct_refreshFooter);
            }
        }
    } else {
        if (self.footerRefreshState != CTFooterRefreshStatusNormal) {
            self.footerRefreshState = CTFooterRefreshStatusNormal;
            [refreshFooter refreshFooterStatus:CTFooterRefreshStatusNormal];
        }
    }
    
}

- (void)beginRefresh{
    
    id<CTRefreshHeaderProtocol>refreshHeader = (id<CTRefreshHeaderProtocol>)self.scrollView.ct_refreshHeader;
    CGFloat height = self.scrollView.ct_refreshHeader.frame.size.height;
    if ([self.scrollView.ct_refreshHeader respondsToSelector:@selector(refreshHeaderHeight)]) {
        height = [refreshHeader refreshHeaderHeight];
    }
    
    self.panState = CTScrollViewPanStatePulling;
    [self changeHeaderViewStatusWithOffsetY:self.scrollView.contentOffset.y];
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsMake(height+self.originInsetTop, 0, 0, 0)];
    }completion:^(BOOL finished) {
        self.panState = CTScrollViewPanStateLoosen;
        [self changeHeaderViewStatusWithOffsetY:self.scrollView.contentOffset.y];
    }];
    
}

- (void)endHeaderRefresh{
    self.panState = CTScrollViewPanStateLoosen;
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.originInsetTop, 0, self.originInsetBottom, 0)];
    } completion:^(BOOL finished) {
        self.headerRefreshState = CTHeaderRefreshStatusNormal;
    }];
}

- (void)endFooterRefresh{
    self.panState = CTScrollViewPanStateLoosen;
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.originInsetTop, 0, self.originInsetBottom, 0)];
    } completion:^(BOOL finished) {
        self.footerRefreshState = CTFooterRefreshStatusNormal;
    }];
}

- (void)dealloc{
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}



@end
