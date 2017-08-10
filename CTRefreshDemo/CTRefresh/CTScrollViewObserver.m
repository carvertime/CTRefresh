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
        self.logic = [CTRefreshLogic new];
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
        self.scrollView.ct_refreshFooter.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, heigth);

    }

}


- (void)changeHeaderStatusWithOffsetY:(CGFloat)offsetY{
    
    if (![self.logic headerViewShouldResponse]) return;
    if (![self.logic footerViewShouldResponse]) return;
    
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    CTHeaderRefreshStatus headerRefreshStatus = [self.logic handleHeaderViewStatusWithOffsetY:offsetY refreshHeight:heigth];
    self.logic.originInsetTop = self.scrollView.contentInset.top;
    self.logic.originInsetBottom = self.scrollView.contentInset.bottom;
    
    if ([self.scrollView.ct_refreshHeader respondsToSelector:@selector(refreshHeaderScrollOffsetY:)]) {
         [self.scrollView.ct_refreshHeader refreshHeaderScrollOffsetY:-offsetY-self.logic.originInsetTop];
    }
   
    if (self.scrollView.ct_refreshHeader == nil) {
        return;
    }
    
    if ([self.logic headerViewShouldChangeWithStatus:headerRefreshStatus]) {
        self.logic.headerRefreshState = headerRefreshStatus;
        [self.scrollView.ct_refreshHeader refreshHeaderStatus:headerRefreshStatus];
        if (headerRefreshStatus == CTHeaderRefreshStatusRefreshing) {
            [self.scrollView.ct_refreshFooter removeFromSuperview];
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top+heigth, 0, self.scrollView.contentInset.bottom, 0)];
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
    
    if (self.scrollView.ct_refreshFooter == nil) {
        return;
    }
    
    if ([self.scrollView.ct_refreshFooter respondsToSelector:@selector(refreshFooterScrollOffsetY:)]) {
        CGFloat relativeOffsetY = [self.logic calculateFooterViewRelativeOffsetYWithOffsetY:offsetY];
        [self.scrollView.ct_refreshFooter refreshFooterScrollOffsetY:[self.logic calculateFooterViewRelativeOffsetYWithOffsetY:offsetY]];
        if (relativeOffsetY <= 0) {
            [self.scrollView.ct_refreshFooter removeFromSuperview];
            return;
        }
    }
    
    
    if (!self.scrollView.ct_refreshFooter.superview) {
        self.logic.footerRefreshState = CTFooterRefreshStatusNormal;
        [self.scrollView.ct_refreshFooter refreshFooterStatus:CTFooterRefreshStatusNormal];
        [self.scrollView addSubview:self.scrollView.ct_refreshFooter];
    }
    
    CGFloat heigth = [self.scrollView.ct_refreshFooter refreshFooterHeight];
    CTFooterRefreshStatus footerRefreshStatus = [self.logic handleFooterViewStatusWithOffsetY:offsetY refreshHeight:heigth];
    
    if ([self.logic footerViewShouldChangeWithStatus:footerRefreshStatus]) {
        self.logic.footerRefreshState = footerRefreshStatus;
        [self.scrollView.ct_refreshFooter refreshFooterStatus:footerRefreshStatus];
        if (footerRefreshStatus == CTFooterRefreshStatusRefreshing) {
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
         [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top+heigth, 0, self.scrollView.contentInset.bottom, 0)];
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
            [self.scrollView setContentInset:UIEdgeInsetsMake(self.logic.originInsetTop, 0, self.scrollView.contentInset.bottom, 0)];
        } completion:^(BOOL finished) {
            self.logic.headerRefreshState = CTHeaderRefreshStatusNormal;
            [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.logic.headerRefreshState];
        }];
    });
}

- (void)endFooterRefresh{

    self.logic.footerRefreshState = CTFooterRefreshStatusRefreshEnding;
    [self.scrollView.ct_refreshFooter refreshFooterStatus:self.logic.footerRefreshState];
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    [UIView animateWithDuration:0.01 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY) animated:YES];
    } completion:^(BOOL finished) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.logic.originInsetTop, 0,  self.logic.originInsetBottom, 0)];
        self.logic.footerRefreshState = CTFooterRefreshStatusNormal;
        [self.scrollView.ct_refreshFooter removeFromSuperview];
        [self.scrollView.ct_refreshFooter refreshFooterStatus:self.logic.footerRefreshState];
    }];
 
}

- (void)dealloc{
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}



@end
