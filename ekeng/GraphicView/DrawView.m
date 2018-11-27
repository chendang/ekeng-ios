//
//  DrawView.m
//  GraphicDemo
//
//  Created by 博实结 on 13-11-19.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
@synthesize pointArray;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    for (int p=0; p<pointArray.count; p++) {
        CGContextSetRGBFillColor(ctx, 1.0, 0, 0, 1);
        CGFloat value = [pointArray[p] floatValue];
        
        CGFloat x = 20 * (p + 1);
        CGFloat y = self.frame.size.height - 20*value;
        CGContextAddArc(ctx, x, y, 3, 0, 2*M_PI , 0);
        
        //绘画
        CGContextDrawPath(ctx, kCGPathFill);
    }
    
}
@end
