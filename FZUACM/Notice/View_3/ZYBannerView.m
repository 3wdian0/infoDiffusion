//
//  ZYBannerView.m
//  DuoBao
//


#import "ZYBannerView.h"
#import "ZYBannerCell.h"

// 总共的item数
#define ZY_TOTAL_ITEMS (self.itemCount * 20000)


#define ZY_PAGE_CONTROL_HEIGHT 32.0

@interface ZYBannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;


@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZYBannerView

@synthesize scrollInterval = _scrollInterval;
@synthesize autoScroll = _autoScroll;
@synthesize shouldLoop =_shouldLoop;
@synthesize pageControl = _pageControl;

static NSString *banner_item = @"banner_item";


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _shouldLoop = YES;
        _autoScroll = YES;
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateSubviewsFrame];
}

- (void)updateSubviewsFrame
{
    // collectionView
    self.flowLayout.itemSize = self.bounds.size;
    self.collectionView.frame = self.bounds;
    
    // pageControl
    if (CGRectEqualToRect(self.pageControl.frame, CGRectZero)) {
        // 若未对pageControl设置过frame, 则使用以下默认frame
        CGFloat w = self.frame.size.width;
        CGFloat h = ZY_PAGE_CONTROL_HEIGHT;
        CGFloat x = 0;
        CGFloat y = self.frame.size.height - h;
        self.pageControl.frame = CGRectMake(x, y, w, h);
    }
}

// 配置默认起始位置
- (void)fixDefaultPosition
{
    if (self.itemCount == 0) {
        return;
    }
    
    if (self.shouldLoop) {
        // 总item数的中间
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(ZY_TOTAL_ITEMS / 2) inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            self.pageControl.currentPage = 0;
        });
    } else {
        // 第0个item
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            self.pageControl.currentPage = 0;
        });
    }
}

#pragma mark - Reload

- (void)reloadData
{
    if (!self.dataSource || self.itemCount == 0) {
        return;
    }
    
    // 设置pageControl总页数
    self.pageControl.numberOfPages = self.itemCount;
    
    // 刷新数据
    [self.collectionView reloadData];
    
    // 开启定时器
    [self startTimer];
}

#pragma mark - NSTimer

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startTimer
{
    if (!self.autoScroll) return;
    
    [self stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.scrollInterval target:self selector:@selector(autoScrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 定时器方法
- (void)autoScrollToNextItem
{
    if (self.itemCount == 0 ||
        self.itemCount == 1 ||
        !self.autoScroll)
    {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSUInteger currentItem = currentIndexPath.item;
    NSUInteger nextItem = currentItem + 1;
    
    if(nextItem >= ZY_TOTAL_ITEMS) {
        return;
    }
    
    if (self.shouldLoop)
    {
        // 无限往下翻页
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    } else {
        if ((currentItem % self.itemCount) == self.itemCount - 1) {
            // 当前最后一张, 回到第0张
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        } else {
            // 往下翻页
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.shouldLoop) {
        return ZY_TOTAL_ITEMS;
    } else {
        return self.itemCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZYBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:banner_item forIndexPath:indexPath];
 
    if ([self.dataSource respondsToSelector:@selector(banner:viewForItemAtIndex:)]) {
        UIView *itemView = [self.dataSource banner:self viewForItemAtIndex:indexPath.item % self.itemCount];
        itemView.frame = cell.bounds;
        [cell addSubview:itemView];
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        [self.delegate banner:self didSelectItemAtIndex:(indexPath.item % self.itemCount)];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    self.pageControl.currentPage = currentIndexPath.item % self.itemCount;
}


#pragma mark - UIScrollViewDelegate
#pragma mark timer相关

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 用户滑动的时候停止定时器
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 用户停止滑动的时候开启定时器
    [self startTimer];
}

#pragma mark - setters & getters
#pragma mark 属性

/**
 *  数据源
 */
- (void)setDataSource:(id<ZYBannerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    
    // 刷新数据
    [self reloadData];
    
    // 配置默认起始位置
    [self fixDefaultPosition];
}

- (NSInteger)itemCount
{
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInBanner:)]) {
        return [self.dataSource numberOfItemsInBanner:self];
    }
    return 0;
}

/**
 *  是否需要循环滚动
 */
- (void)setShouldLoop:(BOOL)shouldLoop
{
    _shouldLoop = YES;
    
    [self reloadData];
    
    // 重置默认起始位置
    [self fixDefaultPosition];
}

- (BOOL)shouldLoop
{
    
    if (self.itemCount == 1) {
        // 只有一个item也不应该有循环滚动
        return NO;
    }
    return _shouldLoop;
}

/**
 *  是否自动滑动
 */
- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    if (autoScroll) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (BOOL)autoScroll
{
    if (self.itemCount < 2) {
        // itemCount小于2时, 禁用自动滚动
        return NO;
    }
    return _autoScroll;
}

/**
 *  自动滑动间隔时间
 */
- (void)setScrollInterval:(NSTimeInterval)scrollInterval
{
    _scrollInterval = scrollInterval;
    
    [self startTimer];
}

- (NSTimeInterval)scrollInterval
{
    if (!_scrollInterval) {
        _scrollInterval = 2.5; // default
    }
    return _scrollInterval;
}

#pragma mark 控件

/**
 *  collectionView
 */
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES; // 小于等于一页时, 允许bounce
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // 注册cell
        [_collectionView registerClass:[ZYBannerCell class] forCellWithReuseIdentifier:banner_item];
        
        
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _flowLayout;
}

/**
 *  pageControl
 */
- (void)setPageControl:(UIPageControl *)pageControl
{
    // 移除旧oageControl
    [_pageControl removeFromSuperview];
    
    // 赋值
    _pageControl = pageControl;
    
    // 添加新pageControl
    _pageControl.userInteractionEnabled = NO;
    _pageControl.autoresizingMask = UIViewAutoresizingNone;
    _pageControl.backgroundColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
    [self reloadData];
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.autoresizingMask = UIViewAutoresizingNone;
    }
    return _pageControl;
}

@end
