//
//  CTRefreshLogic.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/27.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "CTRefreshLogic.h"
#import "UIScrollView+CTRefresh.h"


@interface CTRefreshLogic ()

@property (nonatomic, assign) CGFloat scrollViewHeight;
@property (nonatomic, assign) CGFloat contentSizeHeight;

@property (nonatomic, assign) CTHeaderRefreshStatus headerRefreshState;
@property (nonatomic, assign) CGFloat originInsetTop;
@property (nonatomic, assign) CGFloat extraTop;

@property (nonatomic, assign) CTFooterRefreshStatus footerRefreshState;
@property (nonatomic, assign) CGFloat originInsetBottom;
@property (nonatomic, assign) CGFloat extraBottom;
@property (nonatomic, assign) CGFloat relativeOffsetBottom;

@end

@implementation CTRefreshLogic

- (void)changeFooterViewFrame{
    self.contentSizeHeight = self.scrollView.contentSize.height;
    self.scrollViewHeight = self.scrollView.frame.size.height;
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    self.scrollView.ct_refreshFooter.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, heigth);
}

- (BOOL)headerFooterViewShouldResponse{
    if (self.headerRefreshState == CTHeaderRefreshStatusRefreshing || self.headerRefreshState ==CTHeaderRefreshStatusRefreshResultFeedback || self.headerRefreshState == CTHeaderRefreshStatusRefreshEnding || self.footerRefreshState == CTFooterRefreshStatusRefreshing) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)headerViewShouldChangeWithStatus:(CTHeaderRefreshStatus)status{
    if (self.headerRefreshState == status) {
        return NO;
    }
    return YES;
}

- (CTHeaderRefreshStatus)handleHeaderViewStatusWithOffsetY:(CGFloat)OffsetY refreshHeight:(CGFloat)height{
    if (-self.newOffsetY >= self.originInsetTop+height) {
        if (self.panState == CTScrollViewPanStateLoosen) {
            return CTHeaderRefreshStatusRefreshing;
        } else {
            return CTHeaderRefreshStatusShouldRefresh;
        }
    } else {
        return CTHeaderRefreshStatusNormal;
    }
}


- (BOOL)footerViewShouldChangeWithStatus:(CTFooterRefreshStatus)status{
    if (self.footerRefreshState == status) {
        return NO;
    } else {
        return YES;
    }
}

- (CGFloat)calculateFooterViewRelativeOffsetYWithOffsetY:(CGFloat)OffsetY{
    if (self.contentSizeHeight >= self.scrollViewHeight - self.originInsetTop - self.originInsetBottom) {
        return OffsetY + self.scrollViewHeight - self.contentSizeHeight - self.originInsetBottom;
    } else {
        return self.originInsetTop + OffsetY;
    }
}

- (CTFooterRefreshStatus)handleFooterViewStatusWithOffsetY:(CGFloat)OffsetY refreshHeight:(CGFloat)height{
    
    self.relativeOffsetBottom = [self calculateFooterViewRelativeOffsetYWithOffsetY:OffsetY];
    if (self.contentSizeHeight >= self.scrollViewHeight - self.originInsetTop - self.originInsetBottom) {
        if (OffsetY + self.scrollViewHeight >= self.contentSizeHeight + height + self.originInsetBottom) {
            if (self.panState == CTScrollViewPanStateLoosen) {
                return CTFooterRefreshStatusRefreshing;
            } else {
                return CTFooterRefreshStatusShouldRefresh;
            }
        } else {
            return CTFooterRefreshStatusNormal;
        }
    } else {
        if (self.originInsetTop + OffsetY >= height) {
            if (self.panState == CTScrollViewPanStateLoosen) {
                return CTFooterRefreshStatusRefreshing;
            } else {
                return CTFooterRefreshStatusShouldRefresh;
            }
        } else {
            return CTFooterRefreshStatusNormal;
        }
    }
}


- (void)changeHeaderStatusWithOffsetY:(CGFloat)offsetY{
    
    self.newOffsetY = offsetY;
    if (![self headerFooterViewShouldResponse]) return;
    if (self.scrollView.ct_refreshHeader == nil) return;
    self.originInsetTop = self.scrollView.contentInset.top;
    
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    if ([self.scrollView.ct_refreshHeader respondsToSelector:@selector(refreshHeaderScrollOffsetY:)]) {
        [self.scrollView.ct_refreshHeader refreshHeaderScrollOffsetY:-offsetY-self.originInsetTop];
    }
    
    CTHeaderRefreshStatus headerRefreshStatus = [self handleHeaderViewStatusWithOffsetY:offsetY refreshHeight:heigth];
    
    if ([self headerViewShouldChangeWithStatus:headerRefreshStatus]) {
        if (headerRefreshStatus == CTHeaderRefreshStatusRefreshing) {
            if (self.scrollView.window == nil) return;
            self.extraTop = heigth;
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.25 animations:^{
                    [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top+self.extraTop, 0, self.scrollView.contentInset.bottom, 0)];
                } completion:^(BOOL finished) {
                    if ([self.delegate respondsToSelector:@selector(loadData:)]) {
                        [self.delegate loadData:CTRefreshHeaderType];
                    }
                }];
            });
        }
        self.headerRefreshState = headerRefreshStatus;
        [self.scrollView.ct_refreshHeader refreshHeaderStatus:headerRefreshStatus];
    }

}

- (void)beginRefresh{
    
    CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
    self.headerRefreshState = CTHeaderRefreshStatusRefreshing;
    [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.headerRefreshState];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat heigth = [self.scrollView.ct_refreshHeader refreshHeaderHeight];
        self.extraTop = heigth;
        [self.scrollView setContentInset:UIEdgeInsetsMake(self.originInsetTop+self.extraTop, 0, self.scrollView.contentInset.bottom, 0)];
    } completion:^(BOOL finished) {
        self.originInsetTop = self.scrollView.contentInset.top-heigth;
        self.originInsetBottom = self.scrollView.contentInset.bottom;
        if ([self.delegate respondsToSelector:@selector(loadData:)]) {
            [self.delegate loadData:CTRefreshHeaderType];
        }
    }];
}

- (void)endHeaderRefresh{
    
    self.headerRefreshState = CTHeaderRefreshStatusRefreshResultFeedback;
    [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.headerRefreshState];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.headerRefreshState = CTHeaderRefreshStatusRefreshEnding;
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top - self.extraTop, 0, self.scrollView.contentInset.bottom, 0)];
        } completion:^(BOOL finished) {
            self.headerRefreshState = CTHeaderRefreshStatusNormal;
            self.extraTop = 0;
            self.extraBottom = 0;
            [self.scrollView.ct_refreshHeader refreshHeaderStatus:self.headerRefreshState];
        }];
    });

}

- (void)changeFooterStatusWithOffsetY:(CGFloat)offsetY{
    
    if (![self headerFooterViewShouldResponse]) return;
    if (self.scrollView.ct_refreshFooter == nil) return;
    if (!self.scrollView.window) return;
    
    self.originInsetBottom = self.scrollView.contentInset.bottom;
    CGFloat height = [self.scrollView.ct_refreshFooter refreshFooterHeight];
    
    CTFooterRefreshStatus footerRefreshStatus = [self handleFooterViewStatusWithOffsetY:offsetY refreshHeight:height];
    if (self.relativeOffsetBottom < 0) {
        self.scrollView.ct_refreshFooter.hidden = YES;
        return;
    } else  if (self.relativeOffsetBottom == 0){
        if (footerRefreshStatus != CTFooterRefreshStatusNormal) {
            self.scrollView.ct_refreshFooter.hidden = YES;
        }
    } else {
        self.scrollView.ct_refreshFooter.hidden = NO;
        if ([self.scrollView.ct_refreshFooter respondsToSelector:@selector(refreshFooterScrollOffsetY:)]) {
            
            [self.scrollView.ct_refreshFooter refreshFooterScrollOffsetY:self.relativeOffsetBottom];
        }
    }

    
    if ([self footerViewShouldChangeWithStatus:footerRefreshStatus]) {
        self.extraTop = 0;
        
        if (footerRefreshStatus == CTFooterRefreshStatusRefreshing) {
            self.extraBottom = height;
            self.scrollView.ct_refreshFooter.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top, 0, self.originInsetBottom + self.extraBottom, 0)];
            } completion:^(BOOL finished) {
                if ([self.delegate respondsToSelector:@selector(loadData:)]) {
                    [self.delegate loadData:CTRefreshFooterType];
                }
            }];
        }
        self.footerRefreshState = footerRefreshStatus;
        [self.scrollView.ct_refreshFooter refreshFooterStatus:footerRefreshStatus];
    }

}

- (void)endFooterRefresh{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat contentOffsetY = self.scrollView.contentOffset.y;
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setContentInset:UIEdgeInsetsMake(self.scrollView.contentInset.top, 0,  self.scrollView.contentInset.bottom - self.extraBottom, 0)];
            [self.scrollView setContentOffset:CGPointMake(0, contentOffsetY) animated:NO];
        } completion:^(BOOL finished) {
            self.scrollView.ct_refreshFooter.hidden = YES;
            self.extraBottom = 0;
            self.extraTop = 0;
            self.footerRefreshState = CTFooterRefreshStatusNormal;
            [self.scrollView.ct_refreshFooter refreshFooterStatus:self.footerRefreshState];
        }];
    });

}

@end
