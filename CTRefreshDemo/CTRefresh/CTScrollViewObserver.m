//
//  CTScrollViewObserver.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "CTScrollViewObserver.h"
#import "CTRefreshProtocol.h"
#import "CTRefreshDefine.h"
#import "CTRefreshLogic.h"
#import "UIScrollView+CTRefresh.h"


@interface CTScrollViewObserver ()<CTRefreshLogicDelegateProtocol>

@property (nonatomic, strong) CTRefreshLogic *logic;

@end



@implementation CTScrollViewObserver

- (id)initWithScrollView:(UIScrollView *)scrollView{
    if (self = [super init]) {
        self.logic = [CTRefreshLogic new];
        self.logic.scrollView = scrollView;
        self.logic.panState = CTScrollViewPanStateNormal;
        self.logic.delegate = self;
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
        [self.logic changeHeaderStatusWithOffsetY:offsetY];
        [self.logic changeFooterStatusWithOffsetY:offsetY];
    } else if ([keyPath isEqualToString:@"state"]) {
        self.logic.panState = [change[@"new"] integerValue];
        [self.logic changeHeaderStatusWithOffsetY:self.logic.newOffsetY];
        [self.logic changeFooterStatusWithOffsetY:self.logic.newOffsetY];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self.logic changeFooterViewFrame];
    }

}

- (void)initFooterStatus{
    [self.logic.scrollView.ct_refreshFooter refreshFooterStatus:CTFooterRefreshStatusNormal];
}

#pragma mark - CTRefreshLogicDelegateProtocol

- (void)loadData:(CTRefreshType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == CTRefreshHeaderType) {
            if (self.headerRefreshBlock) {
                self.headerRefreshBlock(self.logic.scrollView.ct_refreshHeader);
            }
        } else {
            if (self.footerRefreshBlock) {
                self.footerRefreshBlock(self.logic.scrollView.ct_refreshHeader);
            }
        }
    });
}

- (void)beginRefresh{
    [self.logic beginRefresh];
}

- (void)endHeaderRefresh{
    [self.logic endHeaderRefresh];
}

- (void)endFooterRefresh{
    [self.logic endFooterRefresh];
}

- (void)removeAllObserver{
    [self.logic.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    [self.logic.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.logic.scrollView removeObserver:self forKeyPath:@"contentSize"];
}




@end
