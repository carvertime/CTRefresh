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

@interface CTScrollViewObserver ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSNumber *state;
@property (nonatomic, assign) CGFloat originInsetTop;

@end

@implementation CTScrollViewObserver

- (id)initWithScrollView:(UIScrollView *)scrollView{
    if (self = [super init]) {
        _scrollView = scrollView;
        _originInsetTop = scrollView.contentInset.top;
        [self observerScrollView:scrollView];
    }
    return self;
}

- (void)observerScrollView:(UIScrollView *)scrollView{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"state"]) {
        self.state = change[@"new"];
        NSLog(@"----%@",change[@"new"]);
    }
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint point = [change[@"new"] CGPointValue];
        [self changeHeaderViewStatusWithY:point.y];
    }
    
}

- (void)changeHeaderViewStatusWithY:(CGFloat)y{
    id<CTRefreshHeaderProtocol>refreshHeader = (id<CTRefreshHeaderProtocol>)self.scrollView.ct_refreshHeader;
    CGFloat height = self.scrollView.ct_refreshHeader.frame.size.height;
    if ([self.scrollView.ct_refreshHeader respondsToSelector:@selector(refreshHeaderHeight)]) {
        height = [refreshHeader refreshHeaderHeight];
    }
    if (fabs(y) >= height && self.state.integerValue != 4) {
        if (self.state.integerValue == 2) {
            [refreshHeader refreshHeaderStatus:CTHeaderRefreshStatusShouldRefresh];
        } else if (self.state.integerValue == 3) {
            [refreshHeader refreshHeaderStatus:CTHeaderRefreshStatusRefreshing];
            [UIView animateWithDuration:0.25 animations:^{
                [self.scrollView setContentInset:UIEdgeInsetsMake(height+self.originInsetTop, 0, 0, 0)];
            }];
            if (self.headerRefreshBlock) {
                self.headerRefreshBlock(self.scrollView.ct_refreshHeader);
            }
        }
    } else {
        if (self.state.integerValue != 3) {
            [refreshHeader refreshHeaderStatus:CTHeaderRefreshStatusNormal];
            [refreshHeader refreshHeaderScrollOffsetY:fabs(y)];
        }
    }
    
}

- (void)endHeaderRefresh{
    self.state = @4;
    [UIView animateWithDuration:0.25 animations:^{
       [self.scrollView setContentInset:UIEdgeInsetsMake(self.originInsetTop, 0, 0, 0)];
    }];
    
}


@end
