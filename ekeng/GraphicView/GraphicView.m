//
//  GraphicView.m
//  GraphicDemo
//
//  Created by wei.chen on 13-1-8.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "GraphicView.h"
#import <QuartzCore/QuartzCore.h>
#import "aview.h"
#import "DrawView.h"
#define kViewWidth [[UIScreen mainScreen] bounds].size.width
#define kViewHeight [[UIScreen mainScreen] bounds].size.height
@implementation GraphicView{
    DrawView *drawview;
    aview *aa;
    UILabel *mileMulLabel;
    UILabel *fuelMulLabel;
    UIScrollView *myScrollView;
}
@synthesize xTitle;
@synthesize yTitle;
@synthesize xArray;
@synthesize yArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置画线的颜色
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    //设置填充的颜色
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    
    [[UIColor blackColor] setStroke];
//    [[UIColor redColor] setFill];
//    CGContextSetRGBFillColor(ctx, 1.0, 0, 0, 1);
    
    
    //设置绘制线的宽度
    CGContextSetLineWidth(ctx, 2);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
//    CGContextFillRect(ctx, CGRectMake(width/2-kViewWidth/(320/150.0), height/2-kViewHeight/(568/130.0), kViewWidth/(320/30.0), kViewHeight/(568/240.0)));
    for (int i=0; i<2; i++) {
        //让画笔移动到某一点
        CGContextMoveToPoint(ctx, width/2-kViewWidth/(320/120.0), height/2+kViewHeight/(568/100.0));
        if (i==0) {
            //添加一条线
            CGContextAddLineToPoint(ctx, width/2+kViewWidth/(320/90.0), height/2+kViewHeight/(568/100.0));
        }else if (i ==1){
            CGContextAddLineToPoint(ctx, width/2-kViewWidth/(320/120.0), height/2-kViewHeight/(568/110.0));
        }
        
    }
    for (int i=0; i<2; i++) {
        //让画笔移动到某一点
        CGContextMoveToPoint(ctx, width/2+kViewWidth/(320/90.0), height/2+kViewHeight/(568/100.0));
        if (i==0) {
            //添加一条线
//            CGContextAddLineToPoint(ctx, width/2+kViewWidth/(320/85.0), height/2+kViewHeight/(568/105.0));
        }else if (i ==1){
//            CGContextAddLineToPoint(ctx, width/2+kViewWidth/(320/85.0), height/2+kViewHeight/(568/95.0));
        }
        
    }
    for (int i=0; i<2; i++) {
        //让画笔移动到某一点
        CGContextMoveToPoint(ctx, width/2-kViewWidth/(320/120.0), height/2-kViewHeight/(568/110.0));
        if (i==0) {
            //添加一条线
//            CGContextAddLineToPoint(ctx, width/2-kViewWidth/(320/125.0), height/2-kViewHeight/(568/105.0));
        } else if (i ==1){
//            CGContextAddLineToPoint(ctx, width/2-kViewWidth/(320/115.0), height/2-kViewHeight/(568/105.0));
        }
    }
    //绘画
    CGContextDrawPath(ctx, kCGPathStroke);
    //
//    UILabel *mileLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-70, height/2-55, 60, 20)];
//    [mileLabel setBackgroundColor:[UIColor clearColor]];
//    [mileLabel setText:@"里程/公里"];
//    [mileLabel setTextColor:[UIColor blueColor]];
//    [mileLabel setFont:[UIFont systemFontOfSize:12]];
//    [self addSubview:mileLabel];
//    [[UIColor blueColor] setStroke];
//    CGContextMoveToPoint(ctx, width-70, height/2-30);
//    CGContextAddLineToPoint(ctx, width-10, height/2-30);
//    CGContextDrawPath(ctx, kCGPathStroke);
//    UILabel *mmLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-70, height/2-25, 60, 20)];
//    [mmLabel setBackgroundColor:[UIColor clearColor]];
//    [mmLabel setText:@"0 X"];
//    [mmLabel setFont:[UIFont systemFontOfSize:12]];
//    [mmLabel setTextColor:[UIColor blueColor]];
//    mileMulLabel = mmLabel;
//    [self addSubview:mmLabel];
//    [mmLabel setTextAlignment:NSTextAlignmentCenter];
//    //
//    UILabel *fuelLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-70, height/2, 60, 20)];
//    [fuelLabel setBackgroundColor:[UIColor clearColor]];
//    [fuelLabel setText:@"油耗/升"];
//    [fuelLabel setTextColor:[UIColor redColor]];
//    [fuelLabel setFont:[UIFont systemFontOfSize:12]];
//    [self addSubview:fuelLabel];
//    [[UIColor redColor] setStroke];
//    CGContextMoveToPoint(ctx, width-70, height/2+25);
//    CGContextAddLineToPoint(ctx, width-10, height/2+25);
//    CGContextDrawPath(ctx, kCGPathStroke);
//    UILabel *fmLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-70, height/2+30, 60, 20)];
//    [fmLabel setBackgroundColor:[UIColor clearColor]];
//    [fmLabel setText:@"0 X"];
//    [fmLabel setFont:[UIFont systemFontOfSize:12]];
//    [fmLabel setTextColor:[UIColor redColor]];
//    [self addSubview:fmLabel];
//    [fmLabel setTextAlignment:NSTextAlignmentCenter];
//    fuelMulLabel = fmLabel;
    //表格
//    aa = [[aview alloc] initWithFrame:CGRectMake(kViewWidth/(320/21.0), 0, kViewWidth/(320/480.0), kViewHeight/(568/200.0))];
    aa = [[aview alloc] initWithFrame:CGRectMake(kViewWidth/(320/21.0), 0, kViewWidth/(320/480.0), kViewHeight/(568/200.0))];
    aa.backgroundColor = [UIColor clearColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-kViewWidth/(320/140.0), CGRectGetHeight(self.frame)/2-kViewHeight/(568/99.0), kViewWidth/(320/221.0), kViewHeight/(568/226.0))];
    [self addSubview:scrollView];
    [scrollView setBackgroundColor:[UIColor blueColor]];
    [scrollView addSubview:aa];
    scrollView.contentSize = CGSizeMake(kViewWidth/(320/501.0), kViewHeight/(568/221.0));
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.scrollEnabled = NO;
    myScrollView = scrollView;
    [myScrollView setDelegate:self];
    
    //标注值
    UILabel *aalabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2-kViewWidth/(320/151.0), height/2+kViewHeight/(568/90.0), kViewWidth/(320/30.0), kViewHeight/(568/10.0))];
    [aalabel setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:aalabel];
    UILabel *ablabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2-kViewWidth/(320/149.0), height/2+kViewHeight/(568/100.0), kViewWidth/(320/25.0), kViewHeight/(568/20.0))];
    [ablabel setBackgroundColor:[UIColor whiteColor]];
    [ablabel setFont:[UIFont boldSystemFontOfSize:12]];
    [ablabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:ablabel];
    for (int i = 0; i<9; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width/2-kViewWidth/(320/151.0), height/2+kViewHeight/(568/70.0)-i*kViewHeight/(568/20.0), kViewWidth/(320/30.0), kViewHeight/(568/20.0))];
        [label setText:[yArray objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        [self addSubview:label];
        [label setBackgroundColor:[UIColor yellowColor]];
    }
    //x轴
    for (int i = 0; i<10; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kViewWidth/(320/20.0)+i*kViewWidth/(320/20.0), kViewHeight/(568/201.0), kViewWidth/(320/20.0), kViewHeight/(568/20.0))];
        [label setText:[xArray objectAtIndex:i]];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        [label setBackgroundColor:[UIColor redColor]];
        [scrollView addSubview:label];
    }
    //单位
    UILabel *xtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2+kViewWidth/(320/93.0), height/2+kViewHeight/(568/105.0), kViewWidth/(320/30.0), kViewHeight/(568/20.0))];
    [xtitleLabel setText:xTitle];
    [xtitleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [xtitleLabel setTextAlignment:NSTextAlignmentCenter];
    [xtitleLabel setBackgroundColor:[UIColor clearColor]];
    [self addSubview:xtitleLabel];
    
    UILabel *ytitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 80, 20)];
    [ytitleLabel setText:yTitle];
    [ytitleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [ytitleLabel setTextAlignment:NSTextAlignmentCenter];
    [ytitleLabel setBackgroundColor:[UIColor whiteColor]];
    [ytitleLabel setNumberOfLines:0];
    [self addSubview:ytitleLabel];
    
    if ([self.pointArray count]>0) {
        [self rushUpWithArray:self.pointArray];
    }
}

- (void)rushUpWithArray:(NSArray *)array{
    [myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    if (drawview!=nil) {
        [drawview removeFromSuperview];
        drawview = nil;
    }
    drawview = [[DrawView alloc] initWithFrame:aa.bounds];
    drawview.pointArray = array;
    [aa addSubview:drawview];
}

@end
