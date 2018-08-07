//
//  HeaderViewController.m
//  DTTopViewZoomIn
//
//  Copyright © 2016年 dtlr. All rights reserved.
//

#import "HeaderViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UIColor+Extension.h"
#import "UIView+Extension.h"
#import "UIImageView+AFNetworking.h"

NSString *const cellId = @"cell_id";
#define kHeaderViewHeight 200  // 顶部视图高度

@interface HeaderViewController () <UITableViewDataSource,UITableViewDelegate>

@end

@implementation HeaderViewController{
    UIView *_headerView;
    UIImageView *_imageView;
    UIView *_lineView;
    UIStatusBarStyle _statusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _statusBarStyle = UIStatusBarStyleLightContent;
    [self createTableView];
    [self setupHeaderView];
    [self setupBackBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 取消自动调整滚动视图间距 - ViewController + Nav会自动调整TableView的ContentInset
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return _statusBarStyle;
}

// 初始化头部视图
- (void)setupHeaderView {
    _headerView = [[UIView alloc] init];
    _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, kHeaderViewHeight);
    _headerView.backgroundColor = [UIColor dt_colorWithHex:0xF8F8F8];
    [self.view addSubview:_headerView];
    
    _imageView = [[UIImageView alloc] initWithFrame:_headerView.bounds];
    _imageView.backgroundColor = [UIColor dt_colorWithHex:0x000033];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [_headerView addSubview:_imageView];
    
    NSURL *url = [NSURL URLWithString:@"http://i1.hdslb.com/bfs/archive/b2fec48626f682b5637151e6b66ea92f0e42a433.jpg"];
    // 使用AFN加载网络图片
//     [_imageView setImageWithURL:url];
    
    // 使用SDWebImage加载网络图片
    [_imageView sd_setImageWithURL:url];
    
    // 添加分割线，1个像素点
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    CGFloat lineViewH = 1 - [UIScreen mainScreen].scale;
    _lineView.frame = CGRectMake(0, kHeaderViewHeight - lineViewH, _headerView.frame.size.width, lineViewH);
    [_headerView addSubview:_lineView];
}

- (void)setupBackBtn {
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(5, 20, 50, 30);
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

// 准备表格视图
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.frame = self.view.bounds;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    tableView.contentInset = UIEdgeInsetsMake(kHeaderViewHeight, 0, 0, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
}

- (void)dealloc{
    NSLog(@"Line = %d,dealloc",__LINE__);
}

#pragma mark - Private

- (void)backBtnClicked:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1000;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y + scrollView.contentInset.top;
    // 向下滚动，放大
    if (offset <= 0) {
        _headerView.y = 0;
        _headerView.height = kHeaderViewHeight - offset;
        _imageView.alpha = 1.0;
    } else {  // 向上滚动，整体图像平移
        _headerView.height = kHeaderViewHeight;
        CGFloat min = kHeaderViewHeight - 64;
        _headerView.y = -MIN(min, offset);
        
        // 设置透明度
        _imageView.alpha = 1 - (offset / min);
        // 设置状态栏样式
        _statusBarStyle = (_imageView.alpha < 0.3)? UIStatusBarStyleDefault : UIStatusBarStyleLightContent;
        // 通知系统改变导航栏样式
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    _imageView.height = _headerView.height;
    _lineView.y = _headerView.height;
}

@end
