//
//  CTRefreshLogic.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/27.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "CTRefreshLogic.h"


@interface CTRefreshLogic ()


@property (nonatomic, assign) CGFloat newInsetTop;
@property (nonatomic, assign) CGFloat refreshHeaderHeight;
@property (nonatomic, assign) CGFloat refreshFooterHeight;


@end

@implementation CTRefreshLogic


- (BOOL)headerViewShouldResponse{
    if (self.headerRefreshState == CTHeaderRefreshStatusRefreshing || self.headerRefreshState == CTHeaderRefreshStatusRefreshResultFeedback || self.headerRefreshState == CTHeaderRefreshStatusRefreshEnding) {
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
    self.refreshHeaderHeight = height;
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

- (BOOL)footerViewShouldResponse{
    if (self.footerRefreshState == CTFooterRefreshStatusRefreshing || self.footerRefreshState == CTFooterRefreshStatusRefreshEnding) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)footerViewShouldChangeWithStatus:(CTFooterRefreshStatus)status{
    if (self.footerRefreshState == status) {
        return NO;
    } else {
        return YES;
    }
}

- (CTFooterRefreshStatus)handleFooterViewStatusWithOffsetY:(CGFloat)OffsetY refreshHeight:(CGFloat)height{
    self.refreshFooterHeight = height;
    if (OffsetY + self.scrollViewHeight >= self.contentSizeHeight) {
        if (OffsetY + self.scrollViewHeight >= self.contentSizeHeight + height + self.originInsetBottom) {
            if (self.panState == CTScrollViewPanStateLoosen) {
                return CTFooterRefreshStatusRefreshing;
            } else {
                return CTFooterRefreshStatusShouldRefresh;
            }
        } else {
            return CTFooterRefreshStatusWillAppear;
        }
    } else {
        return CTFooterRefreshStatusNormal;
    }
}


@end
