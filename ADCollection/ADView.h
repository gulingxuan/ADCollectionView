//
//  ADView.h
//  ADCollectionDemo
//
//  Created by 顾泠轩 on 16/9/26.
//  Copyright © 2016年 cd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADView : UIView

@property (nonatomic,copy)void(^clickBlock)(NSInteger index);

//创建滚动视图
/*
 imgArr : 图片数组（数组保存图片名字或图片链接）
 time   : 轮播时长（几秒一换）
 block  : 点击图片执行block内的代码，index的值为：点击的是第index张图片
 isUrl  : 是否为网络图片（YES 为网络图片，NO 为本地图片）
 */
+(instancetype)createADCollectionwithFrame:(CGRect)frame WithImageArr:(NSArray *)imgArr isImageUrl:(BOOL)isUrl  withTimer:(CGFloat)time ClickImage:(void(^)(NSInteger index))block;

/*
 设置小白点的颜色
 第一个参数为选中时的颜色
 第二个为未选中时的颜色
*/
-(void)setPageControlCurrentColor:(UIColor *)color IndicatorTintColor:(UIColor *)tintColor;

/*
 开启定时器
 1.必须确保对象已经创建（最好使用懒加载或是在viewDidLoad方法内创建）
 2.确保对象存在后，在viewWillAppear方法里开启定时器（不开启则不会自动轮播）
 3.必须在页面消失的时候关闭定时器，与之对应，在页面将要显示时必须打开定时器
 */
-(void)startTimer;
/*
 关闭定时器
 必须在创建轮播图的控制器的viewWillDisappear方法里，调用该方法关闭定时器
 */
-(void)closeNSTimer;

@end
