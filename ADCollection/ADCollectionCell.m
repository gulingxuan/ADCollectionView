//
//  ADCollectionCell.m
//  ADCollectionDemo
//
//  Created by 顾泠轩 on 16/9/26.
//  Copyright © 2016年 cd. All rights reserved.
//

#import "ADCollectionCell.h"

@implementation ADCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imgView.userInteractionEnabled = YES;
        [self addSubview:self.imgView];
    }
    return self;
}

@end
