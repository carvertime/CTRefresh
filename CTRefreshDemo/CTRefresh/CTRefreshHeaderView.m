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
@property (nonatomic, strong) UILabel *timeLb;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation CTRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, 50);
        [self addSubview:self.titleLb];
        [self addSubview:self.iconImageView];
        [self addSubview:self.indicatorView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake((self.frame.size.width-100)*0.5, 5, 100, 20);
    self.iconImageView.frame = CGRectMake(CGRectGetMinX(self.titleLb.frame)-32, CGRectGetMinY(self.titleLb.frame), 32, 32);
    self.indicatorView.frame = self.iconImageView.frame;
}


- (void)refreshHeaderStatus:(CTHeaderRefreshStatus)status{
    if (status == CTHeaderRefreshStatusNormal) {
        self.backgroundColor = [UIColor greenColor];
        self.titleLb.text = @"下拉可刷新";
        [self.indicatorView stopAnimating];
        self.iconImageView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.iconImageView.transform = CGAffineTransformMakeRotation(0.000001);
        }];
    } else if (status == CTHeaderRefreshStatusShouldRefresh) {
        self.backgroundColor = [UIColor yellowColor];
        self.titleLb.text = @"松开可以刷新";
        [self.indicatorView stopAnimating];
        self.iconImageView.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.iconImageView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (status == CTHeaderRefreshStatusRefreshing) {
        self.backgroundColor = [UIColor purpleColor];
        self.titleLb.text = @"刷新中...";
        [self.indicatorView startAnimating];
        self.iconImageView.hidden = YES;
        
    }
}

- (CGFloat)refreshHeaderHeight{
    return self.frame.size.height;
}

- (void)refreshHeaderScrollOffsetY:(CGFloat)offsetY{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = offsetY / self.frame.size.height;
    }];
}

- (UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLb;
}

- (UIImageView *)iconImageView{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"ct_arrow"];
    }
    return _iconImageView;
}

- (UIActivityIndicatorView *)indicatorView{
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    }
    return _indicatorView;
}


@end
