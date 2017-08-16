//
//  CTRefreshHeaderView.m
//  CTRefreshDemo
//
//  Created by wenjie on 2017/7/25.
//  Copyright © 2017年 Demo. All rights reserved.
//

#import "CTRefreshHeaderView.h"

@interface CTRefreshHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation CTRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self addSubview:self.titleLb];
        [self addSubview:self.iconImageView];
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
 
    self.titleLb.frame = CGRectMake((self.frame.size.width-100)*0.5+32, 0, 100, 50);
    self.titleLb.textAlignment = NSTextAlignmentLeft;
    self.iconImageView.frame = CGRectMake(CGRectGetMinX(self.titleLb.frame)-32, 9, 32, 32);
    self.indicatorView.frame = self.iconImageView.frame;

}

- (void)refreshHeaderStatus:(CTHeaderRefreshStatus)status{
    if (status == CTHeaderRefreshStatusNormal) {
        self.titleLb.text = @"下拉可刷新";
        [self.indicatorView stopAnimating];
        self.iconImageView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.iconImageView.transform = CGAffineTransformIdentity;
        }];
    } else if (status == CTHeaderRefreshStatusShouldRefresh) {
        self.titleLb.text = @"松开可以刷新";
        [self.indicatorView stopAnimating];
        self.iconImageView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.iconImageView.transform = CGAffineTransformMakeRotation(- M_PI);
        }];
    } else if (status == CTHeaderRefreshStatusRefreshing) {
        self.titleLb.text = @"刷新中...";
        [self.indicatorView startAnimating];
        self.iconImageView.hidden = YES;
    } else if (status == CTHeaderRefreshStatusRefreshResultFeedback) {
        self.titleLb.text = @"刷新成功";
        [self.indicatorView stopAnimating];
        self.iconImageView.hidden = YES;
        self.titleLb.frame = CGRectMake((self.frame.size.width-100)*0.5, 0, 100, 50);
        _titleLb.textAlignment = NSTextAlignmentCenter;
    } else if (status == CTHeaderRefreshStatusRefreshEnding) {
        self.titleLb.text = @"结束刷新";
        [self.indicatorView stopAnimating];
        self.iconImageView.hidden = YES;
    }
}

- (CGFloat)refreshHeaderHeight{
    return 50;
}

- (void)refreshHeaderScrollOffsetY:(CGFloat)offsetY{
    if (offsetY < 0 ) {
        self.alpha = 0;
    } else {
       self.alpha = offsetY/ self.frame.size.height;
    }
    
}

- (UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
        _titleLb.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _titleLb;
}

- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"ct_arrow"];
        _iconImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _iconImageView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _iconImageView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    }
    return _indicatorView;
}


@end
