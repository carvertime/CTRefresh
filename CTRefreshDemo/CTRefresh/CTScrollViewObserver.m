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
#import "CTRefreshLogic.h"



@interface CTScrollViewObserver ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) CTRefreshLogic *logic;

@end

@implementation CTScrollViewObserver

- (id)initWithScrollView:(UIScrollView *)scrollView{
    if (self = [super init]) {
        _scrollView = scrollView;
        _scrollView.ct_refreshFooter.frame = CGRectMake(0, _scrollView.contentInset.top, _scrollView.ct_refreshFooter.frame.size.width, 0);
        self.logic = [[CTRefreshLogic alloc] init];
        self.logic.panState = CTScrollViewPanStateNormal;
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

    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat offsetY = [change[@"new"] CGPointValue].y;
        self.logic.newOffsetY = offsetY;
        [self changeHeaderStatusWithOffsetY:offsetY];
        [self changeFooterStatusWithOffsetY:offsetY];
    } else if ([keyPath isEqualToString:@"state"]) {
        self.logic.panState = [change[@"new"] integerValue];
        [self changeHeaderStatusWithOffsetY:self.logic.newOffsetY];
        [self changeFooterStatusWithOffsetY:self.logic.newOffsetY];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        self.logic.contentSizeHeight = self.scrollView.contentSize.height;
        self.logic.scrollViewHeight = self.scrollView.frame.size.height;
        CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
        if (self.logic.footerRefreshState != CTFooterRefreshStatusRefreshing && self.logic.footerRefreshState != CTFooterRefreshStatusRefreshResultFeedback) {
          self.scrollView.ct_refreshFooter.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, heigth);
        }
    }

}


- (void)changeHeaderStatusWithOffsetY:(CGFloat)offsetY{
    
    if (![self.logic headerViewShouldResponse]) return;
    if (![self.logic footerViewShouldResponse]) return;
    
    if ([self.scrollView.ct_refreshHeader respondsToSelector:@selector(refreshHeaderScrollOffsetY:)]) {
         [self.scrollView.ct_refreshHeader refreshHeaderScrollOffsetY:-offsetY-self.logic.originInsetTop];
    }
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    CTHeaderRefreshStatus headerRefreshStatus = [self.logic handleHeaderViewStatusWithOffsetY:offsetY refreshHeight:heigth];
    if ([self.logic headerViewShouldChangeWithStatus:headerRefreshStatus]) {
        self.logic.headerRefreshState = headerRefreshStatus;
        [self.scrollView.ct_refreshHeader refreshHeaderStatus:headerRefreshStatus];
        if (headerRefreshStatus == CTHeaderRefreshStatusRefreshing) {
            self.logic.originInsetTop = self.scrollView.contentInset.top;
            self.logic.originInsetBottom = self.scrollView.contentInset.bottom;
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top+heigth, 0, 0, 0)];
            } completion:^(BOOL finished) {
                if (self.headerRefreshBlock) {
                    self.headerRefreshBlock(self.scrollView.ct_refreshHeader);
                }
            }];
        }
    }
}

- (void)changeFooterStatusWithOffsetY:(CGFloat)offsetY{
    
    if (![self.logic footerViewShouldResponse]) return;
    if (![self.logic headerViewShouldResponse]) return;
    
    if ([self.scrollView.ct_refreshFooter respondsToSelector:@selector(refreshFooterScrollOffsetY:)]) {
         [self.scrollView.ct_refreshFooter refreshFooterScrollOffsetY:offsetY];
    }
    CGFloat heigth = [self.scrollView.ct_refreshFooter refreshFooterHeight];
    CTFooterRefreshStatus footerRefreshStatus = [self.logic handleFooterViewStatusWithOffsetY:offsetY refreshHeight:heigth];
    if ([self.logic footerViewShouldChangeWithStatus:footerRefreshStatus]) {
        self.logic.footerRefreshState = footerRefreshStatus;
        [self.scrollView.ct_refreshFooter refreshFooterStatus:footerRefreshStatus];
        if (footerRefreshStatus == CTFooterRefreshStatusWillAppear) {
            self.logic.originInsetBottom = self.scrollView.contentInset.bottom;
            [self.scrollView addSubview:self.scrollView.ct_refreshFooter];
            self.scrollView.ct_refreshFooter.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, heigth);
        } else if (footerRefreshStatus == CTFooterRefreshStatusRefreshing) {
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.logic.originInsetTop, 0, self.logic.originInsetBottom+heigth, 0)];
            } completion:^(BOOL finished) {
                if (self.footerRefreshBlock) {
                    self.footerRefreshBlock(self.scrollView.ct_refreshFooter);
                }
            }];
        }
    }
    
}

- (void)beginRefresh{
    
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    self.logic.headerRefreshState = CTHeaderRefreshStatusRefreshing;
    [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.logic.headerRefreshState];
    [UIView animateWithDuration:0.25 animations:^{
         [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top+heigth, 0, 0, 0)];
    } completion:^(BOOL finished) {
        self.logic.originInsetTop = self.scrollView.contentInset.top-heigth;
        self.logic.originInsetBottom = self.scrollView.contentInset.bottom;
        if (self.headerRefreshBlock) {
            self.headerRefreshBlock(self.scrollView.ct_refreshHeader);
        }
    }];
    
}

- (void)endHeaderRefresh{
    self.logic.headerRefreshState = CTHeaderRefreshStatusRefreshResultFeedback;
    [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.logic.headerRefreshState];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.logic.headerRefreshState = CTHeaderRefreshStatusRefreshEnding;
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentInset:UIEdgeInsetsMake(self.logic.originInsetTop, 0, 0, 0)];
        } completion:^(BOOL finished) {
            self.logic.headerRefreshState = CTHeaderRefreshStatusNormal;
            [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.logic.headerRefreshState];
        }];
    });
}

- (void)endFooterRefresh{
    self.logic.footerRefreshState = CTFooterRefreshStatusRefreshResultFeedback;
    [self.scrollView.ct_refreshFooter refreshFooterStatus:self.logic.footerRefreshState];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.logic.footerRefreshState = CTFooterRefreshStatusRefreshEnding;
        [self.scrollView.ct_refreshFooter refreshFooterStatus:self.logic.footerRefreshState];
        CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
        [UIView animateWithDuration:0.25 animations:^{
            self.scrollView.ct_refreshFooter.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, heigth);
            [self.scrollView setContentInset:UIEdgeInsetsMake(self.logic.originInsetTop, 0, 0, self.logic.originInsetBottom)];
        } completion:^(BOOL finished) {
            self.logic.footerRefreshState = CTFooterRefreshStatusNormal;
            [self.scrollView.ct_refreshFooter refreshFooterStatus:self.logic.footerRefreshState];
        }];
    });
}

- (void)dealloc{
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}



@end
