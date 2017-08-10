#import "CTRefreshFooterView.h"

@interface CTRefreshFooterView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLb;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation CTRefreshFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, 50);
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
    self.iconImageView.frame = CGRectMake(CGRectGetMinX(self.titleLb.frame)-32, 9, 32, 32);
    self.indicatorView.frame = self.iconImageView.frame;
}


- (void)refreshFooterStatus:(CTFooterRefreshStatus)status{
    switch (status) {
        case CTFooterRefreshStatusNormal:
        {
            self.titleLb.text = @"加载更多";
            [self.indicatorView stopAnimating];
            self.iconImageView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.iconImageView.transform = CGAffineTransformMakeRotation(- M_PI);
            }];
        }
            break;
        case CTFooterRefreshStatusShouldRefresh:
        {
            self.titleLb.text = @"松开可加载更多";
            [self.indicatorView stopAnimating];
            self.iconImageView.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.iconImageView.transform = CGAffineTransformIdentity;
            }];
        }
            break;
            
        case CTFooterRefreshStatusRefreshing:
        {
            self.titleLb.text = @"加载中...";
            [self.indicatorView startAnimating];
            self.iconImageView.hidden = YES;
        }
            break;
        case CTFooterRefreshStatusRefreshEnding:
        {
            self.titleLb.text = @"结束刷新";
            [self.indicatorView stopAnimating];
            self.iconImageView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)refreshFooterHeight{
    return 44;
}

- (void)refreshFooterScrollOffsetY:(CGFloat)offsetY{
    if (offsetY >0) {
       self.alpha = (offsetY)/ self.frame.size.height;
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
