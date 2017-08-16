# CTRefresh
CTRefresh 是一个简单的上拉刷新下拉加载控件
## 预览
![image](https://github.com/carvertime/CTRefresh/blob/master/CTRefreshDemo/Resource/CTRefresh.gif)

## 示例

### 下拉刷新

```objc

#pragma mark - 新建一个下拉刷新CTRefreshHeaderView

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

#pragma mark - ViewController中添加刷新功能
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    [self.tableView ct_addHeaderRefresh:[CTRefreshHeaderView class] handle:^(UIView *headerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView ct_endHeaderRefresh];
            weakSelf.dataSource = @[@"data",@"data"].mutableCopy;
            [weakSelf.tableView reloadData];
        });
    }];
    [self.tableView ct_beginHeaderRefresh];
 }

```
### 上拉加载更多

```objc
#pragma mark - 新建一个上拉加载更多CTRefreshFooterView

@interface CTRefreshFooterView : UIView<CTRefreshFooterProtocol>

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation CTRefreshFooterView

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

- (void)refreshFooterStatus:(CTFooterRefreshStatus)status{
     switch (status) {
            case CTFooterRefreshStatusNormal:
                self.titleLb.text = @"上拉可加载更多";
                break;
            case CTFooterRefreshStatusShouldRefresh:
                self.titleLb.text = @"松开开始刷新";
                break;
            case CTFooterRefreshStatusRefreshing:
                self.titleLb.text = @"加载中...";
                break;
            default:
                break;
    }
}

- (CGFloat)refreshFooterHeight{
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

@end

#pragma mark - ViewController中添加上拉加载更多功能
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
   [self.tableView ct_addFooterRefresh:[CTRefreshFooterView class] handle:^(UIView *footerView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView ct_endFooterRefresh];
            [weakSelf.dataSource addObject:@"data"];
            [weakSelf.dataSource addObject:@"data"];
            [weakSelf.tableView reloadData];
        });
    }];
 }

```
