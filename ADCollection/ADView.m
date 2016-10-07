//
//  ADView.m
//  ADCollectionDemo
//
//  Created by 顾泠轩 on 16/9/26.
//  Copyright © 2016年 cd. All rights reserved.
//

#import "ADView.h"
#import "ADCollectionCell.h"
#import <UIImageView+WebCache.h>

//屏幕宽高
#define SCW [[UIScreen mainScreen]bounds].size.width
#define SCH [[[UIScreen mainScreen]bounds].size.height

//view自身宽高
#define Width self.frame.size.width
#define Height self.frame.size.height

@interface ADView()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UIPageControl *page;//小白点
@property (nonatomic, strong)NSArray *imgArr;//滚动图片数组
@property (nonatomic, strong)NSTimer *timer;//定时器
@property (nonatomic, assign)CGFloat time;//轮播时长
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)BOOL isImageUrl;

@end

@implementation ADView

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    if (self.imgArr && _currentPage <= self.page.numberOfPages && _currentPage)
    {
        self.page.currentPage = _currentPage - 1;
    }
}

-(UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(Width, Height);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        [_collectionView registerClass:[ADCollectionCell class] forCellWithReuseIdentifier:@"ADCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.contentOffset = CGPointMake(Width, 0);
        _collectionView.showsHorizontalScrollIndicator = NO;
        
    }
    return _collectionView;
}

-(UIPageControl *)page
{
    if (!_page)
    {
        _page = [[UIPageControl alloc]initWithFrame:CGRectMake(50, Height - 20, Width - 100, 20)];
        _page.userInteractionEnabled = NO;
        _page.currentPage = 0;
    }
    return _page;
}

//创建滚动视图
+(instancetype)createADCollectionwithFrame:(CGRect)frame WithImageArr:(NSArray *)imgArr isImageUrl:(BOOL)isUrl  withTimer:(CGFloat)time ClickImage:(void(^)(NSInteger index))block
{
    ADView *adView = [[ADView alloc]initWithFrame:frame];
    [adView addSubview:adView.collectionView];
    [adView addSubview:adView.page];
    adView.clickBlock = block;
    adView.time = time;
    adView.isImageUrl = isUrl;
    if (1 < imgArr.count)
    {
         NSMutableArray *mArr = [imgArr mutableCopy];
        [mArr addObject:[imgArr firstObject]];
        [mArr insertObject:[imgArr lastObject] atIndex:0];
        adView.imgArr = mArr;
    }
    else
    {
        adView.imgArr = imgArr;
    }
    if (imgArr)
    {
        adView.page.numberOfPages = imgArr.count;
        adView.page.currentPage = 0;
    }
    
    adView.currentPage = 1;

    return adView;
}

-(void)startTimer
{
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    self.timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
    //开启定时器
//    [self.timer fire];
//    [mainLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//视图滚动（NSTimer）方法
-(void)scrollImage
{
    CGPoint offset = self.collectionView.contentOffset;
    offset.x += Width;
    [self.collectionView setContentOffset:offset animated:YES];
    NSLog(@"NSTimer 正在运行：%ld",self.page.currentPage + 1);
}

-(void)setPageControlCurrentColor:(UIColor *)color IndicatorTintColor:(UIColor *)tintColor
{
    self.page.currentPageIndicatorTintColor = color;
    self.page.pageIndicatorTintColor = tintColor;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.imgArr ? self.imgArr.count : 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ADCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ADCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    if (self.imgArr && indexPath.row < self.imgArr.count)
    {
        if (self.isImageUrl)
        {
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgArr[indexPath.row]]];
        }
        else
        {
            cell.imgView.image = [UIImage imageNamed:self.imgArr[indexPath.row]];
        }
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.clickBlock)
    {
        if (1 < self.imgArr.count)
        {
            if (!indexPath.row)
            {
                self.clickBlock(self.imgArr.count - 2);
                
            }
            else if(indexPath.row == self.imgArr.count - 1)
            {
                self.clickBlock(1);
            }
            else
            {
                self.clickBlock(indexPath.row - 1);
            }
        }
        else
        {
            self.clickBlock(indexPath.row);
        }
        
    }
}

//手指碰到collectionView时，关闭定时器（开始拖动方法）
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate];
    self.timer = nil;
}

//手指离开collectionView时，开启定时器（结束拖动方法）
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    [self startTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(scrollImage) userInfo:nil repeats:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger page =scrollView.contentOffset.x / Width;
//    NSLog(@"偏移量：%f,当前page ： %ld",scrollView.contentOffset.x,page);
    if (scrollView.contentOffset.x == (self.imgArr.count - 1) * Width)
    {
        scrollView.contentOffset = CGPointMake(Width, 0);
    }
    else if (!scrollView.contentOffset.x)
    {
        scrollView.contentOffset = CGPointMake(Width * (self.imgArr.count - 2), 0);
    }
    
    self.currentPage = page;
}

-(void)closeNSTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSLog(@"定时器：%@",self.timer);
}





@end






