//
//  CTRefreshFooterView.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "CTRefreshFooterView.h"

@implementation CTRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 50);
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (CGFloat)refreshFooterHeight{
    return 50;
}

- (void)refreshFooterStatus:(CTFooterRefreshStatus)status{
    switch (status) {
        case CTFooterRefreshStatusNormal:
            self.backgroundColor = [UIColor blueColor];
            break;
        case CTFooterRefreshStatusShouldRefresh:
            self.backgroundColor = [UIColor purpleColor];
            break;
        case CTFooterRefreshStatusRefreshing:
            self.backgroundColor = [UIColor redColor];
            break;
        default:
            break;
    }
}

@end
