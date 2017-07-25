//
//  CTRefreshHeaderView.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "CTRefreshHeaderView.h"

@implementation CTRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, 50);
    }
    return self;
}

- (void)refreshHeaderStatus:(CTHeaderRefreshStatus)status{
    if (status == CTHeaderRefreshStatusNormal) {
        self.backgroundColor = [UIColor greenColor];
    } else if (status == CTHeaderRefreshStatusShouldRefresh) {
        self.backgroundColor = [UIColor yellowColor];
    } else if (status == CTHeaderRefreshStatusRefreshing) {
        self.backgroundColor = [UIColor purpleColor];
    }
}

@end
