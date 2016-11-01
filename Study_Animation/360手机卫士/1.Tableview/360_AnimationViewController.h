//
//  360_AnimationViewController.h
//  Study_Animation
//
//  Created by LYY on 2016/10/8.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _60_AnimationViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *scrollView;//主页视图
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, strong)UIScrollView *secondScrollView;//切换后的视图
@property (nonatomic, strong) UIImageView *imgView;//顶部背景图
@end
