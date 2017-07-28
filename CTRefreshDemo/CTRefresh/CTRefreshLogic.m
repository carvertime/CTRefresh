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
@property (nonatomic, assign) CGFloat refreshHeight;


@end

@implementation CTRefreshLogic

- (id)initWithInsetTop:(CGFloat)top insetBottom:(CGFloat)bottom{
    if (self = [super init]) {
        _originInsetTop = top;
        _panState = CTScrollViewPanStateNormal;
    }
    return self;
}

- (BOOL)headerViewShouldResponse{
    if (self.headerRefreshState == CTHeaderRefreshStatusRefreshing || self.headerRefreshState == CTHeaderRefreshStatusRefreshResultFeedback || self.headerRefreshState == CTHeaderRefreshStatusRefreshEnding) {
        return NO;
    } else {
        return YES;
    }
}

- (CTHeaderRefreshStatus)handleHeaderViewStatusWithOffsetY:(CGFloat)OffsetY refreshHeight:(CGFloat)height{
    self.newOffsetY = OffsetY;
    self.refreshHeight = height;
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

- (BOOL)headerViewShouldChangeWithStatus:(CTHeaderRefreshStatus)status{
    if (self.headerRefreshState == status) {
        return NO;
    }
    return YES;
}

- (void)handlePanStatus:(CTScrollViewPanState)status{
    self.panState = status;
}


@end
