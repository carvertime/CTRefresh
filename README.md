# CTRefresh
CTRefresh 是一个简单的上拉刷新下拉加载控件
## 预览
![image](https://github.com/carvertime/CTRefresh/blob/master/CTRefreshDemo/Resource/CTRefresh.gif)

## 示例

### 下拉刷新

```objc

#pragma mark - 新建一个下拉刷新View

@interface CTRefreshHeaderView : UIView<CTRefreshHeaderProtocol>

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation CTRefreshHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self addSubview:self.titleLb];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = self.bounds;
}

- (void)refreshHeaderStatus:(CTHeaderRefreshStatus)status{
     switch (status) {
            case CTHeaderRefreshStatusNormal:
                self.titleLb.text = @"下拉可刷新";
                break;
            case CTHeaderRefreshStatusShouldRefresh:
                self.titleLb.text = @"松开可以刷新";
                break;
            case CTHeaderRefreshStatusRefreshing:
                self.titleLb.text = @"刷新中...";
                break;
            case CTHeaderRefreshStatusRefreshResultFeedback:
                self.titleLb.text = @"刷新成功";
                break;
            case CTHeaderRefreshStatusRefreshEnding:
                self.titleLb.text = @"结束刷新";
                break;
            default:
                break;
    }
}

- (CGFloat)refreshHeaderHeight{
    return 44;
}

- (UILabel *)titleLb{
    if (_titleLb == nil) {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor colorWithRed:117/255.0 green:117/255.0 blue:117/255.0 alpha:1];
        _titleLb.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    }
    return _titleLb;
}

```
