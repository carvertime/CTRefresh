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
    
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew  context:nil];
    [scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew  context:nil];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
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

#pragma mark - headerView

- (void)changeHeaderStatusWithOffsetY:(CGFloat)offsetY{
    
    if (![self.logic headerFooterViewShouldResponse]) return;
    if (self.scrollView.ct_refreshHeader == nil) return;
    self.logic.originInsetTop = self.scrollView.contentInset.top;
    
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    if ([self.scrollView.ct_refreshHeader respondsToSelector:@selector(refreshHeaderScrollOffsetY:)]) {
        [self.scrollView.ct_refreshHeader refreshHeaderScrollOffsetY:-offsetY-self.logic.originInsetTop];
    }
    
    CTHeaderRefreshStatus headerRefreshStatus = [self.logic handleHeaderViewStatusWithOffsetY:offsetY refreshHeight:heigth];
    
    if ([self.logic headerViewShouldChangeWithStatus:headerRefreshStatus]) {
        if (headerRefreshStatus == CTHeaderRefreshStatusRefreshing) {
            if (self.scrollView.window == nil) return;
            self.logic.extraTop = heigth;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.scrollView.ct_refreshFooter removeFromSuperview];
                [UIView animateWithDuration:0.25 animations:^{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top+self.logic.extraTop, 0, self.scrollView.contentInset.bottom, 0)];
                } completion:^(BOOL finished) {
                    if (self.headerRefreshBlock) {
                        self.headerRefreshBlock(self.scrollView.ct_refreshHeader);
                    }
                }];
            });
        }
        self.logic.headerRefreshState = headerRefreshStatus;
        [self.scrollView.ct_refreshHeader refreshHeaderStatus:headerRefreshStatus];
    }
}



- (void)beginRefresh{
    
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    self.logic.headerRefreshState = CTHeaderRefreshStatusRefreshing;
    [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.logic.headerRefreshState];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
        self.logic.extraTop = heigth;
         [self.scrollView setContentInset:UIEdgeInsetsMake(self.logic.originInsetTop+self.logic.extraTop, 0, self.scrollView.contentInset.bottom, 0)];
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
            [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top - self.logic.extraTop, 0, self.scrollView.contentInset.bottom, 0)];
        } completion:^(BOOL finished) {
            [self p_changeHeaderViewNormalStatus];
        }];
    });
}

- (void)p_changeHeaderViewNormalStatus{
    self.logic.headerRefreshState = CTHeaderRefreshStatusNormal;
    self.logic.extraTop = 0;
    self.logic.extraBottom = 0;
    [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.logic.headerRefreshState];
}




#pragma mark - footerView

- (void)changeFooterStatusWithOffsetY:(CGFloat)offsetY{
    
    if (![self.logic headerFooterViewShouldResponse]) return;
    if (self.scrollView.ct_refreshFooter == nil) return;
    if (!self.scrollView.window) return;
    
    self.logic.originInsetBottom = self.scrollView.contentInset.bottom;
    
    if ([self.scrollView.ct_refreshFooter respondsToSelector:@selector(refreshFooterScrollOffsetY:)]) {
        CGFloat relativeOffsetY = [self.logic calculateFooterViewRelativeOffsetYWithOffsetY:offsetY];
        [self.scrollView.ct_refreshFooter refreshFooterScrollOffsetY:[self.logic calculateFooterViewRelativeOffsetYWithOffsetY:offsetY]];
        if (relativeOffsetY <= 0) {
            return;
        }
    }
    
    
    if (!self.scrollView.ct_refreshFooter.superview) {
        self.logic.footerRefreshState = CTFooterRefreshStatusNormal;
        [self.scrollView.ct_refreshFooter removeFromSuperview];
        
    }
    
    CGFloat height = [self.scrollView.ct_refreshFooter refreshFooterHeight];
    CTFooterRefreshStatus footerRefreshStatus = [self.logic handleFooterViewStatusWithOffsetY:offsetY refreshHeight:height];
    
    if ([self.logic footerViewShouldChangeWithStatus:footerRefreshStatus]) {
        self.logic.extraTop = 0;
        [self.scrollView.ct_refreshFooter refreshFooterStatus:CTFooterRefreshStatusNormal];
        [self.scrollView insertSubview:self.scrollView.ct_refreshFooter atIndex:0];
        if (footerRefreshStatus == CTFooterRefreshStatusRefreshing) {
            self.logic.extraBottom = height;
            
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, self.logic.originInsetBottom + self.logic.extraBottom, 0)];
            } completion:^(BOOL finished) {
                
                if (self.footerRefreshBlock) {
                    self.footerRefreshBlock(self.scrollView.ct_refreshFooter);
                }
            }];
        }
        self.logic.footerRefreshState = footerRefreshStatus;
        [self.scrollView.ct_refreshFooter refreshFooterStatus:footerRefreshStatus];
    }
    
}


- (void)endFooterRefresh{

    self.logic.footerRefreshState = CTFooterRefreshStatusRefreshEnding;
    [self.scrollView.ct_refreshFooter refreshFooterStatus:self.logic.footerRefreshState];
    CGFloat contentOffsetY = self.scrollView.contentOffset.y;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top, 0,  self.scrollView.contentInset.bottom - self.logic.extraBottom, 0)];
        [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY) animated:NO];
    } completion:^(BOOL finished) {
        [self p_changeFooterViewNormalStatus];
    }];
 
}

- (void)p_changeFooterViewNormalStatus{
    self.logic.footerRefreshState = CTFooterRefreshStatusNormal;
    [self.scrollView.ct_refreshFooter removeFromSuperview];
    self.logic.extraBottom = 0;
    self.logic.extraTop = 0;
    [self.scrollView.ct_refreshFooter removeFromSuperview];
    [self.scrollView.ct_refreshFooter refreshFooterStatus:self.logic.footerRefreshState];
}

- (void)removeAllObserver{
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
}




@end
