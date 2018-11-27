//
//  GraphicView.h
//  GraphicDemo
//
//  Created by wei.chen on 13-1-8.
//  Copyright (c) 2013年 www.iphonetrain.com 无限互联3G学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphicView : UIView<UIScrollViewDelegate>

@property (nonatomic, copy) NSString *xTitle;
@property (nonatomic, copy) NSString *yTitle;

@property (nonatomic, strong) NSArray *xArray;
@property (nonatomic, strong) NSArray *yArray;

@property (nonatomic, strong) NSArray *pointArray;

- (void)rushUpWithArray:(NSArray *)array;

@end
