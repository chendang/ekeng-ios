//
//  aview.m
//  GraphicDemo
//
//  Created by 博实结 on 13-11-19.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "aview.h"
#define kViewWidth [[UIScreen mainScreen] bounds].size.width
#define kViewHeight [[UIScreen mainScreen] bounds].size.height
@implementation aview

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //    //设置画线的颜色
    //    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    //    //设置填充的颜色
    //    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    
    [[UIColor colorWithRed:112/255.0 green:112/255.0 blue:112/255.0 alpha:1] setStroke];
//    [[UIColor greenColor] setFill];
    
    
    //设置绘制线的宽度
    CGContextSetLineWidth(ctx, .2);
    
    //画横线
    for (int i=kViewHeight/(568/200.0); i>0; i-=kViewHeight/(568/20.0)) {
        //让画笔移动到某一点
        CGContextMoveToPoint(ctx, 0, i);
            //添加一条线
            CGContextAddLineToPoint(ctx, kViewWidth/(320/500.0), i);
    }
    //画竖线
//    for (int i=0; i<kViewWidth/(320/500.0); i+=kViewWidth/(320/20.0)) {
//
//        CGContextMoveToPoint(ctx, i, kViewHeight/(568/200.0));
//
//        CGContextAddLineToPoint(ctx, i, 0);
//    }
    //画矩形边框
    CGContextAddRect(ctx, CGRectMake(0, 0, kViewWidth/(320/500.0), kViewHeight/(568/200.0)));
    
    
    //CGContextAddCurveToPoint(ctx, 10, 10, 100, 200, 100, 50);
    
    //绘画
    CGContextDrawPath(ctx, kCGPathStroke);
    //    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
    
}

@end
