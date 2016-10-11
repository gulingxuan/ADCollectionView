//
//  ViewController.m
//  ADCollectionDemo
//
//  Created by 顾泠轩 on 16/9/26.
//  Copyright © 2016年 cd. All rights reserved.
//

//屏幕宽高
#define SCW [[UIScreen mainScreen]bounds].size.width
#define SCH [[[UIScreen mainScreen]bounds].size.height


#import "ViewController.h"
#import "ADView.h"

@interface ViewController ()

@property (nonatomic, strong)ADView *adView;
@property (nonatomic, strong)ADView *netView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNetWorkView];
    [self createADView];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.adView)
    {
        [self.adView startTimer];
    }
    if (self.netView)
    {
        [self.netView startTimer];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.adView)
    {
        [self.adView closeNSTimer];
        [self.netView closeNSTimer];
    }
}


-(void)createADView
{
    
    //本地图片轮播
    
    NSArray *arr = @[@"多肉1.jpg",@"多肉2.jpg",@"多肉3.jpg",@"多肉4.jpg",@"多肉5.jpg"];
    self.adView = [ADView createADCollectionwithFrame:CGRectMake(0, 100, SCW, 200) WithImageArr:arr isImageUrl:NO withTimer:3  ClickImage:^(NSInteger index) {
        NSLog(@"点击第 %ld 个Cell！",index);
    }];
    [self.adView setPageControlCurrentColor:[UIColor yellowColor] IndicatorTintColor:[UIColor grayColor]];
    [self.view addSubview:self.adView];
    self.adView.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
}

-(void)createNetWorkView
{
    //网络图片轮播
    NSArray *urlArr = @[@"http://img.kaiyanapp.com/7a5a0825ece32bfea57fcfead5ad20df.jpeg",@"http://img.kaiyanapp.com/421d407f96c7f491b2777bf6f78cbc88.jpeg",@"http://img.kaiyanapp.com/b683e0f9c2f6622cca0eca6b4423bc6a.jpeg",@"http://img.kaiyanapp.com/c614b7fa2a719707155e5c9f36df519f.jpeg",@"http://img.kaiyanapp.com/ddbeae9a9f51675bbd420a38b3eb4fc0.jpeg"];
    self.netView = [ADView createADCollectionwithFrame:CGRectMake(0, 350, SCW, 200) WithImageArr:urlArr isImageUrl:YES withTimer:3 ClickImage:^(NSInteger index) {
        NSLog(@"点击第%ld张图片",index);
    }];
    [self.view addSubview:self.netView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    TestViewController *tvc = [[TestViewController alloc]init];
//    [self.navigationController pushViewController:tvc animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
